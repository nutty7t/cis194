module Homework2.Log where

import Prelude
import Data.Array (take)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Eq (genericEq)
import Data.Generic.Rep.Show (genericShow)
import Effect (Effect)
import Node.Encoding (Encoding(..))
import Node.FS.Sync (readTextFile)
import Node.Path (FilePath)

data MessageType
  = Info
  | Warning
  | Error Int

derive instance genericMessageType :: Generic MessageType _

instance showMessageType :: Show MessageType where
  show = genericShow

instance eqMessageType :: Eq MessageType where
  eq = genericEq

type TimeStamp
  = Int

data LogMessage
  = LogMessage MessageType TimeStamp String
  | Unknown String

derive instance genericLogMessage :: Generic LogMessage _

instance showLogMessage :: Show LogMessage where
  show = genericShow

instance eqLogMessage :: Eq LogMessage where
  eq = genericEq

data MessageTree
  = Leaf
  | Node MessageTree LogMessage MessageTree

derive instance genericMessageTree :: Generic MessageTree _

instance showMessageTree :: Show MessageTree where
  -- I think I need to use an η-expansion here because MessageTree is a
  -- recursive type. Otherwise, we get a `CycleInDeclaration` error. The docs
  -- also mention that the error can occur when defining a typeclass member
  -- using another, so maybe that could be the reason why as well.
  show t = genericShow t

instance eqMessageTree :: Eq MessageTree where
  eq t = genericEq t

testParse ::
  (String -> Array LogMessage) ->
  Int ->
  FilePath ->
  Effect (Array LogMessage)
testParse parse n file = take n <<< parse <$> readTextFile UTF8 file

testWhatWentWrong ::
  (String -> Array LogMessage) ->
  (Array LogMessage -> Array String) ->
  FilePath ->
  Effect (Array String)
testWhatWentWrong parse whatWentWrong file = whatWentWrong <<< parse <$> readTextFile UTF8 file
