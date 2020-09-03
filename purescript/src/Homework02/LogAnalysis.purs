module Homework02.LogAnalysis where

import Prelude
import Control.Monad.State (State, get, modify, put, runState)
import Data.Array (drop, filter, foldr, head, intercalate)
import Data.Int (fromString)
import Data.Maybe (Maybe(..))
import Data.String.Utils (lines, words)
import Data.Tuple (Tuple(..))
import Homework02.Log (LogMessage(..), MessageTree(..), MessageType(..))

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

--
-- Exercise 2
--

insert :: LogMessage -> MessageTree -> MessageTree
insert (Unknown _) t = t
insert m@(LogMessage _ _ _) Leaf = Node Leaf m Leaf
insert m@(LogMessage _ ts _) t@(Node left m' right) = case m' of
  Unknown _ -> t
  (LogMessage _ ts' _) ->
    if ts <= ts' then
      (Node (insert m left) m' right)
    else
      (Node left m' (insert m right))

--
-- Exercise 3
--

build :: Array LogMessage -> MessageTree
build messages = foldr insert Leaf messages

--
-- Exercise 4
--

inOrder :: MessageTree -> Array LogMessage
inOrder Leaf = []
inOrder (Node l m r) = inOrder l <> [ m ] <> inOrder r

--
-- Exercise 5
--

sortMessages :: Array LogMessage -> Array LogMessage
sortMessages = inOrder <<< build

getMessage :: LogMessage -> String
getMessage (Unknown m) = m
getMessage (LogMessage _ _ m) = m

whatWentWrong :: Array LogMessage -> Array String
whatWentWrong = map getMessage <<< sortMessages <<< filter isSevere
  where
  isSevere :: LogMessage -> Boolean
  isSevere (LogMessage (Error s) _ _) = s >= 50
  isSevere _ = false
