module Main where

import Prelude (Unit)
import Data.Maybe (Maybe)
import Routes (Locations(..), routing)
import Routing
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)

main :: forall e. Eff (console :: CONSOLE | e) Unit
main = matches routing (\old new -> someAction old new)
  where
    someAction :: forall e. Maybe Locations -> Locations -> Eff (console :: CONSOLE | e) Unit
    someAction _ Home = log "Home"
    someAction _ Counter = log "Counter"
