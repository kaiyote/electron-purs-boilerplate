module App.Route where

import Prelude (class Eq, Unit)
import Control.Alt ((<|>))
import Control.Apply ((*>))
import Data.Functor ((<$))
import Data.Generic (class Generic)
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

derive instance eqLocation :: Eq Location
derive instance genericLocation :: Generic Location
