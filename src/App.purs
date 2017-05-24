module App where

import App.Route (Location(..))
import Control.Monad.Aff (Aff)
import Data.Either (Either)
import Data.Functor.Coproduct (Coproduct)
import Data.Maybe (Maybe(..))
import Halogen (Component, get, parentComponent, put)
import Halogen.Component (ParentHTML, ParentDSL)
import Halogen.Component.ChildPath (ChildPath, cpL, cpR)
import Halogen.HTML (HTML, slot')
import Prelude (type (~>), Unit, Void, absurd, bind, const, discard, pure, unit)
import View.Counter (Query, Slot(..), ui) as Counter
import View.Home (Query, Slot(..), ui) as Home

data Query a = Goto Location a

type State = Location

type ChildQuery = Coproduct Home.Query Counter.Query

type ChildSlot = Either Home.Slot Counter.Slot

pathToHome :: ChildPath Home.Query ChildQuery Home.Slot ChildSlot
pathToHome = cpL

pathToCounter :: ChildPath Counter.Query ChildQuery Counter.Slot ChildSlot
pathToCounter = cpR

type QueryP = Coproduct Query ChildQuery

init :: State
init = Home

ui :: ∀ eff. Component HTML Query Unit Void (Aff eff)
ui = parentComponent
  { initialState: const init
  , render
  , eval
  , receiver: const Nothing
  }

render :: ∀ eff. State -> ParentHTML Query ChildQuery ChildSlot (Aff eff)
render Home = slot' pathToHome Home.Slot Home.ui unit absurd
render Counter = slot' pathToCounter Counter.Slot Counter.ui unit absurd

eval :: ∀ m. Query ~> ParentDSL State Query ChildQuery ChildSlot Void m
eval (Goto loc next) = do
  state <- get
  let nextState = loc
  put nextState
  pure next
