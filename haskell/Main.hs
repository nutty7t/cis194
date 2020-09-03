module Main where

import Test.Hspec

import Homework01.Spec
import Homework02.Spec

testSuite :: Spec
testSuite = do
  homework01Spec
  homework02Spec

main :: IO ()
main = hspec testSuite
