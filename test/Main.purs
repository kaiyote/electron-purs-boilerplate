module Test.Main where

import Prelude (Unit, bind)
import Control.Monad.Aff.AVar (AVAR)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Data.Either (Either(Right))
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (equal')
import Test.Unit.Main (runTest)
import Test.Unit.Console (TESTOUTPUT)

import Routing (matchHash)
import App.Route (Location(..), routing)

main :: forall e. Eff (avar :: AVAR, testOutput :: TESTOUTPUT, console :: CONSOLE | e) Unit
main = runTest do
  routeSuite

routeSuite :: forall e. TestSuite e
routeSuite = suite "route matching" do
  test "counter" do
    equal' "/counter should route to Counter" (Right Counter) (matchHash routing "/counter")
  test "home" do
    equal' "'' should route to Home" (Right Home) (matchHash routing "")
    equal' "/ should route to Home" (Right Home) (matchHash routing "/")
    equal' "anything that's not /counter should route to Home" (Right Home) (matchHash routing "/gibberish")
