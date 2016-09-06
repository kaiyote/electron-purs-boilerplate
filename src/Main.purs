module Main where

import Prelude (Unit, bind, unit, pure, const, void, ($), (<<<), (=<<))

import Control.Monad.Aff (runAff, forkAff)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (throwException, error)
import Control.Monad.Error.Class (throwError)

import Data.Maybe (maybe)

import Halogen (runUI, parentState)
import Halogen.Util (awaitLoad, selectElement)

import View.Router

main :: forall ef. Eff (Effects ef) Unit
main = void $ runAff throwException (const (pure unit)) $ do
  awaitLoad
  container <- maybe (throwError (error "Could not find '#container'")) pure =<< selectElement "#container"
  driver <- runUI ui (parentState init) container
  forkAff $ routeSignal driver
