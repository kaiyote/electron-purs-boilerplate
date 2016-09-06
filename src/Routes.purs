module Routes where

import Prelude ((<$), (*>))
import Control.Alt ((<|>))
import Routing.Match (Match)
import Routing.Match.Class (lit)

data Locations
  = Home
  | Counter

home :: Match Locations
home = Home <$ lit ""

counter :: Match Locations
counter = Counter <$ (lit "" *> lit "counter")

routing :: Match Locations
routing = counter <|> home
