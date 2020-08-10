module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)

import Test.Homework1.Exercises (homework1Spec)
import Test.Spec.Reporter (specReporter)
import Test.Spec.Runner (runSpec)

main :: Effect Unit
main = launchAff_ $ runSpec [ specReporter ] do
  homework1Spec
