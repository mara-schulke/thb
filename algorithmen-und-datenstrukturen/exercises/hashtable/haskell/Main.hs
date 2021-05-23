module Main where

import Data.Char (ord)


class Hash a where
    (#) :: a -> Int

instance Hash Char where
    (#) = ord

instance (Hash a) => Hash [a] where
    (#) a = sum $ map (#) a


newtype LinearHashTable a = LinearHashTable [a]
    deriving (Show)

insert :: a -> LinearHashTable a -> LinearHashTable a
-- insert x (LinearHashTable ys) =
--    case ys !! ((#) x) of
--        a -> 

main = do
    putStrLn $ show $ LinearHashTable [1]


