{-# LANGUAGE LambdaCase #-}

module Machine.Irrational
  ( MConfig(..)
  , machine
  ) where

import           Entscheidungsproblem           ( Machine(..) )
import qualified Entscheidungsproblem          as M

data MConfig = B | O | Q | P | F
  deriving (Eq, Show)

-- Run: take 10 $ compute machine (B, Tape.empty)
machine :: Machine MConfig Char
machine = Machine $ \case
  (B, _) -> Just (O, [M.P '_', M.R, M.P '_', M.R, M.P '0', M.R, M.R, M.P '0', M.L, M.L])
  (O, Just '1')               -> Just (O, [M.R, M.P 'x', M.L, M.L, M.L])
  (O, Just '0')               -> Just (Q, [])
  (Q, Just s) | s `elem` "01" -> Just (Q, [M.R, M.R])
  (Q, Nothing )               -> Just (P, [M.P '1', M.L])
  (P, Just 'x')               -> Just (Q, [M.E, M.R])
  (P, Just '_')               -> Just (F, [M.R])
  (P, Nothing )               -> Just (P, [M.L, M.L])
  (F, Just _  )               -> Just (F, [M.R, M.R])
  (F, Nothing )               -> Just (O, [M.P '0', M.L, M.L])
  _                           -> Nothing
