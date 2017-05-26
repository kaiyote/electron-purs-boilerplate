module View.Counter where
import Control.Monad.Aff (Aff, delay)
import Data.Maybe (Maybe(..))
import Data.Time.Duration (Milliseconds(..))
import Halogen (Component, component, liftAff)
import Halogen.Component (ComponentDSL, ComponentHTML)
import Halogen.HTML (ClassName(..), HTML, a, button, div, div_, i, text)
import Halogen.HTML.Events (input_, onClick)
import Halogen.HTML.Properties (class_, classes, href)
import Halogen.Query (modify)
import Prelude (class Eq, class Ord, type (~>), Unit, Void, const, discard, map, mod, negate, pure, show, ($), (+), (==))

data Query a
  = Increment a
  | Decrement a
  | IncrementIfOdd a
  | IncrementAsync a

type State = Int

data Slot = Slot
derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

init :: State
init = 0

ui :: ∀ eff. Component HTML Query Unit Void (Aff eff)
ui = component
  { initialState: const init
  , render
  , eval
  , receiver: const Nothing
  }

eval :: ∀ eff. Query ~> ComponentDSL State Query Void (Aff eff)
eval (Increment next) = do
  modify ((+) 1)
  pure next
eval (Decrement next) = do
  modify ((+) (-1))
  pure next
eval (IncrementIfOdd next) = do
  modify \x -> if x `mod` 2 == 1 then x + 1 else x
  pure next
eval (IncrementAsync next) = do
  liftAff $ delay (Milliseconds 1000.0)
  modify ((+) 1)
  pure next

render :: State -> ComponentHTML Query
render count =
  div_
    [ div [ class_ (ClassName "backButton") ]
        [ a [ href "#/" ]
            [ i [ classes $ map ClassName ["fa", "fa-arrow-left", "fa-3x"] ] [] ]
        ]
    , div [ class_ (ClassName "counter") ] [ text $ show count ]
    , div [ class_ (ClassName "buttonGroup") ]
        [ button [ class_ (ClassName "button"), onClick (input_ Increment) ]
            [ i [ classes $ map ClassName ["fa", "fa-plus"] ] [] ]
        , button [ class_ (ClassName "button"), onClick (input_ Decrement) ]
            [ i [ classes $ map ClassName ["fa", "fa-minus"] ] [] ]
        , button [ class_ (ClassName "button"), onClick (input_ IncrementIfOdd) ]
            [ text "odd" ]
        , button [ class_ (ClassName "button"), onClick (input_ IncrementAsync) ]
            [ text "async!" ]
        ]
    ]
