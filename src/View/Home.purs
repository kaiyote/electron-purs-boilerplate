module View.Home where

import Data.Maybe (Maybe(..))
import Halogen (Component, component)
import Halogen.Component (ComponentDSL, ComponentHTML)
import Halogen.HTML (ClassName(..), HTML, a, div, div_, h2_, text)
import Halogen.HTML.Properties (class_, href)
import Prelude (class Eq, class Ord, type (~>), Unit, Void, const, pure, unit)

data Query a = Noop a

type State = Unit

data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

ui :: ∀ m. Component HTML Query Unit Void m
ui = component
  { initialState: const unit
  , render
  , eval
  , receiver: const Nothing
  }

eval :: ∀ m. Query ~> ComponentDSL State Query Void m
eval (Noop next) = pure next

render :: State -> ComponentHTML Query
render _ =
  div_ [ div [ class_ (ClassName "container") ]
    [ h2_ [ text "Home" ]
    , a [ href "#/counter" ] [ text "Counter" ]
    ]
  ]
