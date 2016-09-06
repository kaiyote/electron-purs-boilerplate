module View.Home where

import Prelude (type (~>), Unit, pure, (<>))

import Data.Eq (class Eq)
import Data.Generic
import Data.Ord (class Ord)
import Data.String (toLower)

import Halogen (ComponentDSL, ComponentHTML, Component, component)
import Halogen.HTML.Core (className)
import Halogen.HTML.Indexed as H
import Halogen.HTML.Properties.Indexed as P

type State = Unit

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
      H.div_
        [ H.div [ P.class_ (className "container") ]
            [ H.h2_ [ H.text "Home" ]
            , link "Counter"
            ]
        ]

    eval :: Input ~> ComponentDSL State Input g
    eval (Noop n) = do
      pure n

    link s = H.a [ P.href ("#/" <> toLower s) ] [ H.text s ]
