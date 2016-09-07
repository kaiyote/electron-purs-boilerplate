module Main where

import Prelude (bind, pure)

import Control.Bind ((=<<))
import Control.Monad.Eff (Eff)

import DOM (DOM)

import Pux (App, Config, CoreEffects, fromSimple, renderToDOM, start)
import Pux.Devtool (Action, start) as PD
import Pux.Router (sampleUrl)

import Signal ((~>))

import Routes (match)
import Layout (Action(PageView), State, view, update)

type AppEffects = (dom :: DOM)

config :: forall eff. State -> Eff (dom :: DOM | eff) (Config State Action AppEffects)
config state = do
  urlSignal <- sampleUrl
  let routeSignal = urlSignal ~> \r -> PageView (match r)
  pure
    { initialState : state
    , update: fromSimple update
    , view: view
    , inputs: [ routeSignal ]
    }

main :: State -> Eff (CoreEffects AppEffects) (App State Action)
main state = do
  app <- start =<< config state
  renderToDOM "#container" app.html
  --| For hot-reloading
  pure app

debug :: State -> Eff (CoreEffects AppEffects) (App State (PD.Action Action))
debug state = do
  app <- PD.start =<< config state
  renderToDOM "#container" app.html
  --| For hot-reloading
  pure app
