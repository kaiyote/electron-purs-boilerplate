module Main where

import Prelude (bind, pure, unit, map, (<<<), ($), (==), otherwise)

import Control.Monad.Eff (Eff)
import DOM (DOM)
import Signal ((~>))
import Signal.Channel (channel, send, subscribe)

import Pux (App, CoreEffects, EffModel, noEffects, mapState, mapEffects, renderToDOM, start)
import Pux.Html (Html, div)
import Routing (matches)

import App.Route
import View.Home as Home
import View.Counter as Counter

data Action
  = PageView Location
  | HAction Home.Action
  | CAction Counter.Action

type State =
  { currentRoute :: Location
  , counter :: Counter.State
  }
type AppEffects = (dom :: DOM)

init :: State
init = { currentRoute: Home, counter: Counter.init }

update :: forall eff. Action -> State -> EffModel State Action (eff)
update (PageView route) state = noEffects $ state { currentRoute = route }
update (HAction _) state = noEffects $ state
update (CAction action) state = mapChildEffModel (\ps cs -> ps { counter = cs }) CAction state $ Counter.update action state.counter

mapChildEffModel :: forall sc ac eff.
                  (State -> sc -> State)
                  -> (ac -> Action)
                  -> State
                  -> EffModel sc ac (eff)
                  -> EffModel State Action (eff)
mapChildEffModel childToParentState parentAction parentState childEffModel =
  mapState (childToParentState parentState) $ mapEffects parentAction childEffModel

view :: State -> Html Action
view state =
  div [] [ pageView state ]

pageView :: State -> Html Action
pageView ({currentRoute, counter}) | currentRoute == Counter = map CAction $ Counter.view counter
                                   | otherwise = map HAction $ Home.view unit

main :: State -> Eff (CoreEffects AppEffects) (App State Action)
main state = do
  routeChannel <- channel Home
  matches routing (\_ -> send routeChannel)
  let routeSignal = (subscribe routeChannel) ~> PageView

  app <- start
    { initialState: state
    , update: update
    , view: view
    , inputs: [ routeSignal ]
    }

  renderToDOM "#container" app.html
  pure app
