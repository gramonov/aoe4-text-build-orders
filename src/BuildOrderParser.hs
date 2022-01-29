module BuildOrderParser
  ( parseBuildOrder
  ) where

import Data.Text (Text)

import Text.Parsec
import Text.Parsec.Text

import Types
  ( BuildOrder (..)
  , BuildOrderEntry (..)
  , Unit (..)
  , Second
  )

parseBuildOrder :: Text -> Either ParseError BuildOrder
parseBuildOrder = runP buildOrder () "build-order"

buildOrder :: Parser BuildOrder
buildOrder = BuildOrder <$> sepEndBy orderEntry endOfLine <* eof

orderEntry :: Parser BuildOrderEntry
orderEntry = comment <|> step

comment :: Parser BuildOrderEntry
comment = Comment <$> string "#" <> (many notEol)

step :: Parser BuildOrderEntry
-- step = BuildStep <$> intVal <*> spaces <*> intVal <*> intVal <*> intVal <*> timestampVal <*> units
step = BuildStep
       <$> (intVal <* spaces)
       <*> (intVal <* spaces)
       <*> (intVal <* spaces)
       <*> (intVal <* spaces)
       <*> (intVal <* spaces)
       <*> (timestampVal <* spaces)
       <*> units

intVal :: Parser Int
intVal = read <$> many digit <* spaces

-- parses into seconds
timestampVal :: Parser Second
timestampVal = minSecsToSecs <$> (read <$> count 2 digit <* char ':') <*> (read <$> count 2 digit) <* spaces

minSecsToSecs :: Int -> Int -> Int
minSecsToSecs min sec = 60*min + sec

units :: Parser [Unit]
units = sepBy (Unit <$> (many $ noneOf ",\r\n")) (char ',')

notEol :: Parser Char
notEol = noneOf "\r\n"
