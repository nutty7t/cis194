module Homework03.Golf where

import Data.List (replicate)

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
    nth (i, xs) = (i, filter (\(j, x) -> j `mod` i == 0) xs)
    unenum = (fmap . fmap) snd . fmap snd
