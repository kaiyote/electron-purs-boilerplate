module Test.Main where

import Prelude (Unit, bind)
import Control.Monad.Aff.AVar (AVAR)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Data.Either (Either(Right))

import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert (assert, equal, equal')
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
    equal (matchHash routing "/counter") (Right Counter)
  test "home" do
    equal (matchHash routing "") (Right Home)
    equal (matchHash routing "/") (Right Home)
    equal (matchHash routing "/gibberish") (Right Home)
