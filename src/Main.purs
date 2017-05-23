module Main where

import Prelude
import App (Query(..), ui)
import App.Route (Location, routing)
import Control.Monad.Aff (Aff, forkAff)
import Control.Monad.Eff (Eff)
import Data.Maybe (Maybe)
import Data.Tuple (Tuple(..))
import Halogen (HalogenIO, action, liftEff)
import Halogen.Aff (HalogenEffects, runHalogenAff, awaitBody)
import Halogen.VDom.Driver (runUI)
import Routing (matchesAff)

foreign import log :: ∀ eff a. a -> Eff eff Unit

routeSignal :: ∀ eff. HalogenIO Query Void (Aff (HalogenEffects eff))
            -> Aff (HalogenEffects eff) Unit
routeSignal driver = do
  Tuple old new <- matchesAff routing
  redirects driver old new

redirects :: ∀ eff. HalogenIO Query Void (Aff (HalogenEffects eff)) -> Maybe Location -> Location
          -> Aff (HalogenEffects eff) Unit
redirects driver _ = driver.query <<< action <<< Goto

main :: ∀ eff. Eff (HalogenEffects eff) Unit
main = runHalogenAff do
  body <- awaitBody
  driver <- runUI ui unit body
  _ <- forkAff $ routeSignal driver
  liftEff $ log driver
