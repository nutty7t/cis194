{-# OPTIONS_GHC -Wall #-}

module Homework2.LogAnalysis where

import Prelude

import Safe
import Text.Read

import Homework2.Log

--
-- Exercise 1
--

consume :: Int -> [String] -> String
consume n = unwords . drop n

parseInt :: String -> (String, Maybe Int)
parseInt m =
  let
    tokens = words m
    severity = readMaybe =<< headMay tokens
  in
    case severity of
      Just s  -> (consume 1 tokens, Just s)
      Nothing -> (consume 0 tokens, Nothing)

parseMessageType :: String -> (String, Maybe MessageType)
parseMessageType m =
  let
    tokens = words m
    messageType = headMay tokens
  in
    case messageType of
      Just "I" -> (consume 1 tokens, Just Info)
      Just "W" -> (consume 1 tokens, Just Warning)
      Just "E" -> case parseInt (consume 1 tokens) of
                    (m', Just s)  -> (m', Just $ Error s)
                    (m', Nothing) -> (m', Nothing)
      _        -> (m, Nothing)

parseMessage :: String -> LogMessage
parseMessage m =
  case parseMessageType m of
    (m', Just messageType) -> case parseInt m' of
                                (m'', Just timestamp) -> LogMessage messageType timestamp m''
                                (m'', Nothing)        -> Unknown m''
    (m', Nothing)          -> Unknown m'

