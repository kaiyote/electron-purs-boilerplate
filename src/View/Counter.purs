module View.Counter where

{-import Prelude (mod, show, const, pure, (+), (-), (==), ($))
import Control.Monad.Aff (later')
import Pux (EffModel, noEffects, onlyEffects)
import Pux.DOM.Events (onClick)
import Pux.DOM.HTML (HTML)
import Text.Smolder.HTML (div, a, i, button)
import Text.Smolder.Attributes (className, href)
import Text.Smolder.Markup (text, (!), (#!))

type State = Int

data Event
  = Increment
  | Decrement
  | IncrementIfOdd
  | IncrementAsync

init :: State
init = 0

foldp :: ∀ fx. Event -> State -> EffModel State Event fx
foldp Increment n = noEffects $ n + 1
foldp Decrement n = noEffects $ n - 1
foldp IncrementIfOdd n = noEffects $ if n `mod` 2 == 0 then n else n + 1
foldp IncrementAsync n = onlyEffects n [ do later' 1000 $ pure Increment ]

view :: State -> Html Event
view count =
  div do
    div ! className "backButton" $ a ! href "#/" $ i ! className "fa fa-arrow-left fa-3x"
    div ! className "counter" $ text $ show count
    div ! className "buttonGroup" do
      button ! className "button" #! onClick (const Increment) $ i ! className "fa fa-plus"
      button ! className "button" #! onClick (const Decrement) $ i ! className "fa fa-minus"
      button ! className "button" #! onClick (const IncrementIfOdd) $ text "odd"
      button ! className "button" #! onClick (const IncrementAsync) $ text "async"-}
