{-# LANGUAGE LambdaCase #-}

module Machine.Alternator
  ( MConfig(..)
  , machine
  ) where

import           Entscheidungsproblem           ( Machine(..) )
import qualified Entscheidungsproblem          as M

data MConfig = B | C | E | K
    deriving (Eq, Show)

-- Run: take 10 $ compute machine (B, Tape.empty)
machine :: Machine MConfig Char
machine = Machine $ Just . \case
  (B, _) -> (C, [M.P '0', M.R])
  (C, _) -> (E, [M.R])
  (E, _) -> (K, [M.P '1', M.R])
  (K, _) -> (B, [M.R])
