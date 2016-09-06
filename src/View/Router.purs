module View.Router where

import Prelude (Unit, type (~>), unit, bind, pure, (<$), (<*), (<<<))

import Control.Alt ((<|>))
import Control.Plus (class Plus, (<|>))
import Control.Monad.Aff (Aff())
import Control.Monad.Aff.AVar (AVAR)
import Control.Monad.Eff.Exception (EXCEPTION)
import Data.Either (Either)
import Data.Functor.Coproduct (Coproduct(), left)
import Data.Maybe (Maybe(Nothing))
import Data.Tuple (Tuple(..))
import DOM (DOM)
import Halogen (ChildF, ParentState, Driver, ParentDSL, SlotConstructor, HTML, ParentHTML, Component, action, parentComponent, modify)
import Halogen.Component.ChildPath (ChildPath(), cpR, cpL)
import Halogen.HTML.Indexed as H
import Routing (matchesAff)
import Routing.Match (Match)
import Routing.Match.Class (lit)
import View.Counter as Counter
import View.Home as Home

data Input a
  = Goto Routes a

data Routes
  = Home
  | Counter

type State = { currentPage :: String }

type Effects e = (dom :: DOM, avar :: AVAR, err :: EXCEPTION | e)

type ChildState = Either Home.State Counter.State

type ChildQuery = Coproduct Home.Input Counter.Input

type ChildSlot = Either Home.Slot Counter.Slot

type StateP g = ParentState State ChildState Input ChildQuery g ChildSlot

type QueryP = Coproduct Input (ChildF ChildSlot ChildQuery)

routing :: Match Routes
routing = Counter <$ lit "" <* lit "counter"
      <|> Home <$ lit ""

init :: State
init = { currentPage: "Home" }

ui :: forall g. (Plus g) => Component (StateP g) QueryP g
ui = parentComponent {render, eval, peek: Nothing}
  where
    render :: State -> ParentHTML ChildState Input ChildQuery g ChildSlot
    render state = viewPage state.currentPage

    viewPage :: String -> HTML (SlotConstructor ChildState ChildQuery g ChildSlot) Input
    viewPage "Home" = H.slot' pathToHome Home.Slot \_ -> { component: Home.ui, initialState: unit }
    viewPage "Counter" = H.slot' pathToCounter Counter.Slot \_ -> { component: Counter.ui, initialState: Counter.init }
    viewPage _ = H.div_ []

    eval :: Input ~> ParentDSL State ChildState Input ChildQuery g ChildSlot
    eval (Goto Counter next) = do
      modify (_ { currentPage = "Counter" })
      pure next
    eval (Goto Home next) = do
      modify (_ { currentPage = "Home" })
      pure next

routeSignal :: forall eff. Driver QueryP eff -> Aff (Effects eff) Unit
routeSignal driver = do
  Tuple old new <- matchesAff routing
  redirects driver old new

redirects :: forall eff. Driver QueryP eff -> Maybe Routes -> Routes -> Aff (Effects eff) Unit
redirects driver _ = driver <<< left <<< action <<< Goto

pathToHome :: ChildPath Home.State ChildState Home.Input ChildQuery Home.Slot ChildSlot
pathToHome = cpL

pathToCounter :: ChildPath Counter.State ChildState Counter.Input ChildQuery Counter.Slot ChildSlot
pathToCounter = cpR
