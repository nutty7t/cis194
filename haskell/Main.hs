module Main where

import Homework01.Spec (homework01Spec)
import Homework02.Spec (homework02Spec)
import Homework03.Spec (homework03Spec)
import Test.Hspec (Spec, hspec)

testSuite :: Spec
testSuite = do
  homework01Spec
  homework02Spec
  homework03Spec

main :: IO ()
main = hspec testSuite
