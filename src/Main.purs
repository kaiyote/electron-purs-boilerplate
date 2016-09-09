module Main (main, debug, init) where

import Prelude (bind, pure, ($))

import Control.Bind ((=<<))
import Control.Monad.Eff (Eff)
import Signal (Signal, (~>))
import Signal.Channel (CHANNEL, channel, send, subscribe)

import Pux (App, CoreEffects, Config, renderToDOM, start)
import Pux.Devtool (Action, start) as PD
import Routing (matches)

import App (AppEffects, State, Action(..), view, update)
import App.Route (Location(..), routing)
import View.Counter (init) as Counter

init :: State
init = { currentRoute: Home, counter: Counter.init }

routes :: forall eff. Eff (channel :: CHANNEL | eff) (Signal Action)
routes = do
  chan <- channel Home
  matches routing (\_ -> send chan)
  pure $ (subscribe chan) ~> PageView

config :: forall eff. State -> Eff (channel :: CHANNEL | eff) (Config State Action AppEffects)
config state = do
  routeSignal <- routes
  pure
    { initialState: state
    , update: update
    , view: view
    , inputs: [ routeSignal ]
    }

main :: State -> Eff (CoreEffects AppEffects) (App State Action)
main state = do
  conf <- config state
  app <- start conf
  renderToDOM "#container" app.html
  --| for hot-reload
  pure app

debug :: State -> Eff (CoreEffects AppEffects) (App State (PD.Action Action))
debug state = do
  conf <- config state
  app <- PD.start conf
  renderToDOM "#container" app.html
  --| for hot-reload
  pure app
