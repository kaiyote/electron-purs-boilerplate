module Main where

import Prelude (bind, const, show, pure, (-), (+))

import Control.Monad.Eff (Eff)
import DOM (DOM)

import Pux (App, CoreEffects, renderToDOM, fromSimple, start)
import Pux.Html (Html, text, button, span, div)
import Pux.Html.Events (onClick)

data Action = Increment | Decrement

type State = Int
type AppEffects = (dom :: DOM)

init :: State
init = 0

update :: Action -> State -> State
update Increment count = count + 1
update Decrement count = count - 1

view :: State -> Html Action
view count =
  div
    []
    [ button [ onClick (const Increment) ] [ text "Increment" ]
    , span [] [ text (show count) ]
    , button [ onClick (const Decrement) ] [ text "Decrement" ]
    ]

main :: State -> Eff (CoreEffects AppEffects) (App State Action)
main state = do
  app <- start
    { initialState: state
    , update: fromSimple update
    , view: view
    , inputs: []
    }

  renderToDOM "#container" app.html
  pure app
