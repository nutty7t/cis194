module Homework03.Golf where

import Data.List (tails, transpose)

--
-- Exercise 1
--

-- TIL that you can compose fmap repeatedly to drill down into a structure and
-- modify it at a certain depth. Pretty neat. It reminds me of the little bit
-- that I know of optics from my experience with monocle-ts. The following
-- solution is sort of like composing an Iso (enum, unenum) with an Indexed
-- Traversal.

skips :: [a] -> [[a]]
skips as = unenum . fmap nth . enum . replicate (length as) $ as
  where
    enum = zip [1 ..] . fmap (zip [1 ..])
    nth (i, xs) = (i, filter (\(j, _) -> j `mod` i == 0) xs)
    unenum = (fmap . fmap) snd . fmap snd

--
-- Exercise 2
--

windows :: Int -> [a] -> [[a]]
windows n = transpose . take n . tails

localMaxima :: [Integer] -> [Integer]
localMaxima xs = windows 3 xs >>= filterPeak
  where
    filterPeak ws@([_, b, _]) =
      if maximum ws == b
        then [b]
        else []
    filterPeak _ = []

--
-- Exercise 3
--

count :: Eq a => [a] -> a -> Int
count xs x = length . filter (x ==) $ xs

bar :: Int -> Int -> String
bar n w = mconcat $ replicate n "*" <> replicate (w - n) " "

row :: Int -> Int -> Int -> String
row i n w = show i <> "=" <> bar n w

rows :: [Int] -> Int -> [String]
rows cs m = uncurry row <$> zip [0 .. 9] cs <*> pure m

rotate :: [[a]] -> [[a]]
rotate = transpose . fmap reverse

histogram :: [Integer] -> String
histogram xs = unlines $ rotate $ rows cs m
  where
    cs = count xs <$> [0 .. 9]
    m = maximum cs
