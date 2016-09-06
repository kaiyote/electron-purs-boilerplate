module View.Counter where

import Prelude (type (~>), pure)

import Data.Eq (class Eq)
import Data.Generic
import Data.Ord (class Ord)
import Halogen (ComponentDSL, ComponentHTML, Component, component)
import Halogen.HTML.Indexed as H

type State = { counter :: Int }

init :: State
init = { counter: 0 }

data Input a = Noop a

data Slot = Slot

derive instance slotGeneric :: Generic Slot

instance eqSlot :: Eq Slot where
  eq = gEq

instance ordGeneric :: Ord Slot where
  compare = gCompare

ui :: forall g. Component State Input g
ui = component { render, eval }
  where
    render :: State -> ComponentHTML Input
    render st =
      H.div_ [ H.text "Counter" ]

    eval :: Input ~> ComponentDSL State Input g
    eval (Noop n) = do
      pure n
