module Main
    ( main
    ) where

import Control.Monad
import Options.Applicative
import System.Environment
import Text.Show.Pretty

import Data.Aviation.WX.Fetcher

data Request = Request
    { rqFetchMetar                      :: Bool
    , rqFetchTaf                        :: Bool
    , rqStation                         :: String }

main :: IO ()
main = execParser opts >>= doit
    where
        opts = info (helper <*> request)
            ( fullDesc
           <> progDesc "Fetch and display METAR/TAF messages"
           <> header "Welcome to avwx" )

doit :: Request -> IO ()
doit args = do
    when (rqFetchMetar args) $ do
        wx <- fetchMetar $ rqStation args
        putStrLn $ case wx of
            Right weather ->
                ppShow weather
            Left error ->
                "No information available for " ++ rqStation args ++ ": " ++ show error
    when (rqFetchTaf args) $ do
        wx <- fetchTaf $ rqStation args
        putStrLn $ ppShow wx

request :: Parser Request
request = Request
    <$> switch
        ( long "metar"
       <> help "Fetch and display the METAR message" )
    <*> switch
        ( long "taf"
       <> help "Fetch and display the TAF message" )
    <*> argument str (metavar "ICAO_STATION_DESIGNATOR")