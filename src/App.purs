module App where

import App.Route (Location(..))
import Data.Maybe (Maybe(..))
import Halogen (Component, component, get, put)
import Halogen.Component (ComponentHTML, ComponentDSL)
import Halogen.HTML (HTML, a, div, text)
import Halogen.HTML.Properties (href)
import Prelude (type (~>), Unit, Void, bind, const, discard, pure, ($), (<>))

data Query a = Goto Location a

type State = Location

init :: State
init = Home

ui :: ∀ m. Component HTML Query Unit Void m
ui = component
  { initialState: const init
  , render
  , eval
  , receiver: const Nothing
  }

render :: State -> ComponentHTML Query
render state =
  div []
    [ a [ href "#/" ] [ text "Home" ]
    , a [ href "#/counter" ] [ text "Counter" ]
    , a [ href "#/nop" ] [ text "Not a Valid Route" ]
    , text $ "Routed to: " <> label state
    ]
  where
    label Counter = "Counter"
    label Home = "Home"

eval :: ∀ m. Query ~> ComponentDSL State Query Void m
eval (Goto loc next) = do
  state <- get
  let nextState = loc
  put nextState
  pure next

{-
import Prelude (map, unit, ($))
import DOM (DOM)
import Pux (EffModel, noEffects, mapState, mapEffects)
import Pux.Html (Html, div)

import App.Route
import View.Home as Home
import View.Counter as Counter

data Event
  = PageView Location
  | HAction Home.Action
  | CAction Counter.Action

type AppEffects = (dom :: DOM)

type State =
  { currentRoute :: Location
  , counter :: Counter.State
  }

update :: Action -> State -> EffModel State Action AppEffects
update (PageView route) state = noEffects $ state { currentRoute = route }
update (HAction _) state = noEffects $ state
update (CAction action) state = mapChildEffModel (\ps cs -> ps { counter = cs }) CAction state $ Counter.update action state.counter

mapChildEffModel :: forall childState childAction.
                  (State -> childState -> State)
                  -> (childAction -> Action)
                  -> State
                  -> EffModel childState childAction AppEffects
                  -> EffModel State Action AppEffects
mapChildEffModel childToParentState parentAction parentState childEffModel =
  mapState (childToParentState parentState) $ mapEffects parentAction childEffModel

view :: State -> Html Action
view state = div [] [ pageView state ]

pageView :: State -> Html Action
pageView {currentRoute: Counter, counter} = map CAction $ Counter.view counter
pageView _ = map HAction $ Home.view unit
-}
