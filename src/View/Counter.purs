module View.Counter where

import Prelude (class Ord, class Eq, type (~>), pure, bind, mod, (+), ($), (-), (==), (<>), map, show)

import Data.String (toLower)
import Data.Generic (class Generic, gCompare, gEq)
import Halogen (ComponentDSL, ComponentHTML, Component, component, modify)
import Halogen.HTML.Core (className)
import Halogen.HTML.Events.Indexed as E
import Halogen.HTML.Indexed as H
import Halogen.HTML.Properties.Indexed as P

type State = Int

data Input a
  = Increment a
  | Decrement a
  | IncrementIfOdd a

data Slot = Slot

derive instance slotGeneric :: Generic Slot

instance eqSlot :: Eq Slot where
  eq = gEq

instance ordGeneric :: Ord Slot where
  compare = gCompare

init :: State
init = 0

ui :: forall g. Component State Input g
ui = component { render, eval }
  where
    render :: State -> ComponentHTML Input
    render st =
      H.div_
        [ H.div [ P.class_ (className "backButton") ] [ link "home" ]
        , H.div [ P.class_ (className "counter") ] [ H.text (show st) ]
        , H.div [ P.class_ (className "buttonGroup") ]
            [ H.button [ P.class_ (className "button"), E.onClick (E.input_ Increment) ]
                [ H.i [ P.classes (map className [ "fa", "fa-plus" ]) ] [] ]
            , H.button [ P.class_ (className "button"), E.onClick (E.input_ Decrement) ]
                [ H.i [ P.classes (map className [ "fa", "fa-minus" ]) ] [] ]
            , H.button [ P.class_ (className "button"), E.onClick (E.input_ IncrementIfOdd) ]
                [ H.text "odd" ]
            ]
        ]

    eval :: Input ~> ComponentDSL State Input g
    eval (Increment n) = do
      modify (_ + 1)
      pure n
    eval (Decrement n) = do
      modify (_ - 1)
      pure n
    eval (IncrementIfOdd n) = do
      modify (\s -> if s `mod` 2 == 0 then s else s + 1)
      pure n

    link s = H.a [ P.href ("#/" <> toLower s) ] [ H.i [ P.classes (map className ["fa", "fa-arrow-left", "fa-3x"]) ] [] ]
