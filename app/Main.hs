module Main where

import Options.Applicative
import Data.Semigroup ((<>))

import qualified Data.Text.IO as TIO

import BuildOrderParser (parseBuildOrder)

data CommandArgs = CommandArgs
  { infile :: FilePath
  , outdir :: FilePath
  } deriving (Show)

argparser :: Parser CommandArgs
argparser = CommandArgs
  <$> strOption ( long "input"
                  <> metavar "INFILE"
                  <> help "Input file containing build order in a text format."
                )
  <*> strOption ( long "outdir"
                  <> metavar "OUTDIR"
                  <> help "Output directory to which the csv files are written."
                )

mainWithArgs :: CommandArgs -> IO ()
mainWithArgs (CommandArgs infile outdir) = do
  buildOrder <- parseBuildOrder <$> TIO.readFile infile
  putStrLn $ "Parsed Build Order: " ++ (show buildOrder)

main :: IO ()
main = mainWithArgs =<< execParser opts
  where
    opts = info (argparser <**> helper )
      ( fullDesc
      <> progDesc "Converts build order in the text format to a csv."
      <> header "Age of Empires 4 Build Order Text Converter"
      )
