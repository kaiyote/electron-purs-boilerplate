module View.Home where

import Prelude (Unit)
import Pux.Html (Html, text, h2, div, a)
import Pux.Html.Attributes (className, href)

type State = Unit
data Action = Noop

view :: State -> Html Action
view s =
  div []
    [ div [ className "container" ]
        [ h2 [] [ text "Home" ]
        , a [ href "#/counter" ] [ text "Counter" ]
        ]
    ]
