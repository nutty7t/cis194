module Homework2.LogAnalysis where

import Prelude
import Control.Monad.State (State, get, modify, put, runState)
import Data.Array (drop, head, intercalate)
import Data.Int (fromString)
import Data.Maybe (Maybe(..))
import Data.String.Utils (lines, words)
import Data.Tuple (Tuple(..))
import Homework2.Log (LogMessage(..), MessageType(..))

--
-- Exercise 1
--

type Tokens
  = Array String

lex :: String -> Tokens
lex = words

unlex :: Tokens -> String
unlex = intercalate " "

consume :: Int -> Tokens -> Tokens
consume = drop

parseInt :: State Tokens (Maybe Int)
parseInt = do
  tokens <- get
  case fromString =<< head tokens of
    Just i -> do
      _ <- modify $ consume 1
      pure $ Just i
    Nothing -> pure Nothing

parseMessageType :: State Tokens (Maybe MessageType)
parseMessageType = do
  tokens <- get
  case head tokens of
    Just "I" -> do
      _ <- modify $ consume 1
      pure $ Just Info
    Just "W" -> do
      _ <- modify $ consume 1
      pure $ Just Warning
    Just "E" -> do
      _ <- modify $ consume 1
      ms <- parseInt
      case ms of
        Just s -> pure $ Just (Error s)
        Nothing -> do
          put tokens
          pure $ Nothing
    _ -> pure Nothing

parseMessage :: String -> LogMessage
parseMessage m = case runState parseMessageType $ lex m of
  Tuple (Just mt) s -> case runState parseInt s of
    Tuple (Just ts) s' -> LogMessage mt ts $ unlex s'
    Tuple Nothing s' -> Unknown $ unlex s'
  Tuple Nothing s -> Unknown $ unlex s

parse :: String -> Array LogMessage
parse = map parseMessage <<< lines
