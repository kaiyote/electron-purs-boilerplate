module Layout where

import Prelude (($), map)

import Pux.Html (Html, div, h1, p, text)

import Routes (Route(Home, Counter, NotFound))

data Action
  = PageView Route

type State =
  { route :: Route
  }

init :: State
init = { route: NotFound }

update :: Action -> State -> State
update (PageView route) state = state { route = route }

view :: State -> Html Action
view state =
  div []
    [ case state.route of
        Home -> text "Home"
        Counter -> text "Counter"
        NotFound -> text "Not Found"
    ]
