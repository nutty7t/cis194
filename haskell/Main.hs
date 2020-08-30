module Main where

import Test.Hspec

import Homework1.Spec
import Homework2.Spec

testSuite :: Spec
testSuite = do
  homework1Spec
  homework2Spec

main :: IO ()
main = hspec testSuite
