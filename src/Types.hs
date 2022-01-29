module Types
  ( BuildOrder (BuildOrder)
  , BuildOrderEntry (Comment, BuildStep)
  , Unit (Unit)
  , Second
  ) where

newtype BuildOrder = BuildOrder [BuildOrderEntry]
  deriving (Show)

data BuildOrderEntry = Comment String
                     | BuildStep { vTotal :: Int
                                 , vFood :: Int
                                 , vWood :: Int
                                 , vGold :: Int
                                 , vStone :: Int
                                 , timestamp :: Int
                                 , units :: [Unit]
                                 }
  deriving (Show)

newtype Unit = Unit String
  deriving (Show)

type Second = Int
