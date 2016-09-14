module View.Counter where

import Prelude (mod, show, const, pure, (+), (-), (==), ($))

import Control.Monad.Aff (later')

import Pux (EffModel, noEffects, onlyEffects)
import Pux.Html (Html, text, div, a, i, button)
import Pux.Html.Attributes (className, href)
import Pux.Html.Events (onClick)

type State = Int
data Action
  = Increment
  | Decrement
  | IncrementIfOdd
  | IncrementAsync

init :: State
init = 0

view :: State -> Html Action
view count =
  div []
    [ div [ className "backButton" ] [ a [ href "#/" ] [ i [ className "fa fa-arrow-left fa-3x" ] [] ] ]
    , div [ className "counter" ] [ text $ show count ]
    , div [ className "buttonGroup" ]
        [ button [ className "button", onClick (const Increment) ] [ i [ className "fa fa-plus" ] [] ]
        , button [ className "button", onClick (const Decrement) ] [ i [ className "fa fa-minus" ] [] ]
        , button [ className "button", onClick (const IncrementIfOdd) ] [ text "odd" ]
        , button [ className "button", onClick (const IncrementAsync) ] [ text "async" ]
        ]
    ]

update :: forall eff. Action -> State -> EffModel State Action (eff)
update Increment counter = noEffects $ counter + 1
update Decrement counter = noEffects $ counter - 1
update IncrementIfOdd counter = noEffects $ if counter `mod` 2 == 0 then counter else counter + 1
update IncrementAsync counter = onlyEffects counter [ do later' 1000 $ pure Increment ]
