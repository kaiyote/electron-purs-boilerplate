module App.Route where

import Prelude (class Show, class Eq, Unit, show, ($), (<$>), (==))

import Control.Alt ((<|>))
import Control.Apply ((*>))

import Data.Functor ((<$))

import Routing.Match (Match)
import Routing.Match.Class (lit)

data Location
  = Home
  | Counter

homeSlash :: Match Unit
homeSlash = lit ""

routing :: Match Location
routing =
  Counter <$ (homeSlash *> lit "counter") <|>
  Home <$ homeSlash

instance showLocation :: Show Location where
  show Home = "Home"
  show Counter = "Counter"

instance eqLocation :: Eq Location where
  eq a b = show a == show b
