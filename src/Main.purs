module Main where

import Prelude
import Data.Maybe (Maybe)
import Routes (Locations(..), routing)
import Routing
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import View.Home as VH
import Halogen
import Halogen.Util
import Control.Monad.Eff.Exception (throwException)
import Control.Monad.Aff (runAff)
import DOM.HTML.Types

main :: forall e. Eff (console :: CONSOLE | e) Unit
main = void $ runAff throwException (const (pure unit)) $ do
  body <- awaitBody
  matches routing (\old new -> (render body) old new)
  where
    render :: forall f. HTMLElement -> Maybe Locations -> Locations -> Eff (console :: CONSOLE | f) Unit
    render body _ Home = runUI VH.view VH.initialState body
    render body _ Counter = log "Counter"
