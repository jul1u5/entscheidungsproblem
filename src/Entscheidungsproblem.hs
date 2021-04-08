{-# LANGUAGE LambdaCase #-}

module Entscheidungsproblem
  ( Operation(..)
  , Machine(..)
  , step
  , compute
  ) where

import           Data.List                      ( foldl' )
import           Data.List.NonEmpty
import           Tape                           ( Tape(..) )
import qualified Tape

data Operation a
    = L
    | R
    | E
    | P a
    deriving (Eq, Show)

type Config m s = (m, Maybe s)

type CompleteConfig m s = (m, Tape s)

type Behaviour m s = (m, [Operation s])

newtype Machine m s = Machine {runMachine :: Config m s -> Maybe (Behaviour m s)}

operate :: Tape s -> Operation s -> Tape s
operate tape = \case
  L   -> Tape.moveLeft tape
  R   -> Tape.moveRight tape
  E   -> tape { tapeHead = Nothing }
  P x -> tape { tapeHead = Just x }

step :: Machine m s -> CompleteConfig m s -> Maybe (CompleteConfig m s)
step machine (m, tape) = do
  (m', ops) <- runMachine machine (m, tapeHead tape)
  let tape' = foldl' operate tape ops
  pure (m', tape')

compute :: Machine m s -> CompleteConfig m s -> NonEmpty (CompleteConfig m s)
compute machine = iterateM (step machine)
 where
  iterateM :: (a -> Maybe a) -> a -> NonEmpty a
  iterateM f a = unfoldr (\x -> (x, f x)) a
