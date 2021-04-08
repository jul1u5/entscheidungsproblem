{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE RecordWildCards   #-}

module Tape
  ( Tape(..)
  , empty
  , moveLeft
  , moveRight
  ) where

import           Data.Maybe (fromMaybe)

data Tape a = Tape
  { tapeLeft  :: [Maybe a]
  , tapeHead  :: Maybe a
  , tapeRight :: [Maybe a]
  }
  deriving Eq

instance Show a => Show (Tape a) where
  show Tape {..} = concat [left', head', right']
   where
    left'     = foldMap maybeShow $ reverse tapeLeft
    head'     = maybeShow tapeHead
    right'    = foldMap maybeShow tapeRight

    maybeShow = maybe " " show

-- TODO: Get rid of overlapping pragma
instance {-# OVERLAPPING #-} Show (Tape Char) where
  show Tape {..} =
    unlines . map mconcat $ [[left', head', right'], [' ' <$ left', '^' <$ head', ' ' <$ right']]
   where
    left'     = foldMap maybeShow $ reverse tapeLeft
    head'     = maybeShow tapeHead
    right'    = foldMap maybeShow tapeRight

    maybeShow = pure . fromMaybe ' '

instance Functor Tape where
  fmap f Tape {..} = Tape { tapeLeft  = map (f <$>) tapeLeft
                          , tapeHead  = f <$> tapeHead
                          , tapeRight = map (f <$>) tapeRight
                          }

empty :: Tape a
empty = Tape [] Nothing []

moveLeft :: Tape a -> Tape a
moveLeft tape@Tape {..} = case tapeLeft of
  []     -> tape { tapeHead = Nothing, tapeRight = tapeRight' }
  x : xs -> Tape { tapeLeft = xs, tapeHead = x, tapeRight = tapeRight' }
  where tapeRight' = tapeHead : tapeRight

moveRight :: Tape a -> Tape a
moveRight tape@Tape {..} = case tapeRight of
  []     -> tape { tapeLeft = tapeLeft', tapeHead = Nothing }
  x : xs -> Tape { tapeLeft = tapeLeft', tapeHead = x, tapeRight = xs }
  where tapeLeft' = tapeHead : tapeLeft
