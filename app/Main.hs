{-# LANGUAGE OverloadedStrings #-}
module Main
    ( main
    ) where

import Control.Monad
import Options.Applicative
import System.Environment
import Text.Show.Pretty

import qualified Data.Text as T
import qualified Data.Text.IO as TIO

import Data.Aviation.WX.Fetcher

data Request = Request
    { rqFetchMetar                      :: Bool
    , rqFetchTaf                        :: Bool
    , rqReadFromFile                    :: Bool
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
    if rqReadFromFile args
    then do
        wxraw <- T.intercalate " " . drop 1 . T.splitOn "\n"
            <$> TIO.readFile (rqStation args)
        let wx = case (rqFetchMetar args, rqFetchTaf args) of
                (True, False) -> parseWeather $ T.concat ["METAR ", wxraw, "="] -- hack
                (False, True) -> parseWeather $ T.concat [wxraw, "="] -- hack
                _             -> error "Either specify --taf or --metar"
        putStrLn $ ppShow wx

    else do
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
    <*> switch
        ( long "file"
       <> help "Fetch and display from the specified file" )
    <*> argument str (metavar "IDENTIFIER")

