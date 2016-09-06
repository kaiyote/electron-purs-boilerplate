module Main where

import Prelude (Unit, bind, unit, pure, const, void, ($), (<<<))

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (throwException)
import Control.Monad.Aff (runAff, forkAff)
import Halogen (runUI, parentState)
import Halogen.Util (awaitBody)
import View.Router

main :: forall ef. Eff (Effects ef) Unit
main = void $ runAff throwException (const (pure unit)) $ do
  body <- awaitBody
  driver <- runUI ui (parentState init) body
  forkAff $ routeSignal driver
