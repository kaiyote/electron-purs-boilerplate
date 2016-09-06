module View.Home (Query(..), view, initialState) where

import Prelude
import Halogen
import Halogen.HTML.Indexed as H
import Halogen.HTML.Events.Indexed as E
import Halogen.HTML.Properties.Indexed as P
import Routes (Locations(..))
import Data.String (toLower)

type State = { currentPage :: String }

initialState :: State
initialState = { currentPage: "" }

data Query a = Goto Locations a

view :: forall g. Component State Query g
view = component { render, eval }
  where
    render :: State -> ComponentHTML Query
    render st =
      H.div_
        [ H.h1_ [ H.text (st.currentPage) ]
        , H.p_ [ H.text "Routing!!" ]
        , H.ul_ (map link ["", "Counter"])
        ]

    eval :: Query ~> ComponentDSL State Query g
    eval (Goto Home next) = do
      modify (_{ currentPage = "Home" })
      pure next
    eval (Goto Counter next) = do
      modify (_{ currentPage = "Counter" })
      pure next

    link s = H.li_ [ H.a [ P.href ("#/" <> toLower s) ] [ H.text s ]]
