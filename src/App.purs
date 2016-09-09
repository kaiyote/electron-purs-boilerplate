module App where

import Prelude (map, otherwise, unit, ($), (==))

import DOM (DOM)

import Pux (EffModel, noEffects, mapState, mapEffects)
import Pux.Html (Html, div)

import App.Route
import View.Home as Home
import View.Counter as Counter

data Action
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
view state =
  div [] [ pageView state ]

pageView :: State -> Html Action
pageView ({currentRoute, counter}) | currentRoute == Counter = map CAction $ Counter.view counter
                                   | otherwise = map HAction $ Home.view unit
