module Main where

import Prelude (bind, pure, unit, map, (<<<), ($), (==), otherwise)

import Control.Monad.Eff (Eff)
import DOM (DOM)
import Signal ((~>))
import Signal.Channel (channel, send, subscribe)

import Pux (App, CoreEffects, renderToDOM, fromSimple, start)
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

update :: Action -> State -> State
update (PageView route) state = state { currentRoute = route }
update (HAction _) state = state
update (CAction action) state = state { counter = Counter.update action state.counter }

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
    , update: fromSimple update
    , view: view
    , inputs: [ routeSignal ]
    }

  renderToDOM "#container" app.html
  pure app
