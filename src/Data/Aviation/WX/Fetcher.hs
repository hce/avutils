{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}

module Data.Aviation.WX.Fetcher(
  parseWeather
, fetchMetar
, fetchTaf
) where

import Data.Attoparsec.Text (parseOnly)
import Data.Aviation.WX (Weather, weatherParser)
import Data.Char (toUpper, isAlpha)
import Data.List (intersperse)
import Data.Text (Text, pack)
import Network.HTTP (simpleHTTP, getRequest, getResponseBody)

type ICAOStationDesignator = String

-- | Parse the given METAR text.
parseWeather :: Text -> Either String Weather
parseWeather = parseOnly weatherParser

data FetchType
    = METAR
    | TAF

noaaurl :: FetchType -> String
noaaurl METAR = "http://tgftp.nws.noaa.gov/data/observations/metar/stations/"
noaaurl TAF = "http://tgftp.nws.noaa.gov/data/forecasts/taf/stations/"

fetchMetar :: ICAOStationDesignator -> IO (Either String Weather)
fetchMetar = fetchWX METAR

fetchTaf :: ICAOStationDesignator -> IO (Either String Weather)
fetchTaf = fetchWX TAF

fetchWX :: FetchType -> ICAOStationDesignator -> IO (Either String Weather)
fetchWX fetchType icao = do
    let icao' = map toUpper . filter isAlpha $ icao
        prefix s = case fetchType of
            METAR -> "METAR " ++ s
            -- NOAA reports non-corrected and non-amended TAFs as
            -- "TAF TAF ...", whereas corrected tafs are reported as
            -- "TAF COR ...". Hence the ugliness here.
            TAF -> case take 8 s of
                "TAF TAF " -> drop 4 s
                _          -> s
    wxString <- simpleHTTP (getRequest $ url icao') >>= getResponseBody
    let wx' = pack $ prefix $ relLine wxString
    putStrLn $ "Parsing " ++ show wx'
    return $ parseWeather wx'
    where
        url designator = noaaurl fetchType ++ designator ++ ".TXT"
        relLine = concat . intersperse " " . drop 1 . Prelude.lines
