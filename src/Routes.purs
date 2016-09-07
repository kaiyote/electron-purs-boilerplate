module Routes where

import Prelude (class Show, ($))

import Control.Alt ((<|>))
import Control.Apply ((<*))

import Data.Functor ((<$))
import Data.Generic (class Generic, gShow)
import Data.Maybe (fromMaybe)

import Pux.Router (end, router)

data Route
  = Home
  | Counter
  | NotFound

derive instance genericRoute :: Generic Route

instance showRoute :: Show Route where
  show = gShow

match :: String -> Route
match url = fromMaybe NotFound $ router url $
  Home <$ end
  <|>
  Counter <$> lit "counter" <* end
