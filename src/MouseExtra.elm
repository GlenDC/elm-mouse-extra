module MouseExtra 
  ( ButtonCode
  , buttonsDown
  )
  where

import Set
import Native.MouseExtra


{-| Type alias to make it clearer what integers are supposed to represent in this library. -}
type alias ButtonCode = Int

-- MANAGE RAW STREAMS

type alias Model =
    { buttonCodes : Set.Set ButtonCode
    }


empty : Model
empty =
    { buttonCodes = Set.empty
    }


type Event = Up EventInfo | Down EventInfo

type alias EventInfo =
    { buttonCode : ButtonCode
    }


update : Event -> Model -> Model
update event model =
  case event of
    Down info ->
        { buttonCodes = Set.insert info.buttonCode model.buttonCodes
        }

    Up info ->
        { buttonCodes = Set.remove info.buttonCode model.buttonCodes
        }


model : Signal Model
model =
  Signal.foldp update empty rawEvents


rawEvents : Signal Event
rawEvents =
  Signal.mergeMany
    [ Signal.map Up Native.MouseExtra.ups
    , Signal.map Down Native.MouseExtra.downs
    ]


dropMap : (a -> b) -> Signal a -> Signal b
dropMap f signal =
  Signal.dropRepeats (Signal.map f signal)


{-| Set of keys that are currently down. -}
buttonsDown : Signal (Set.Set ButtonCode)
buttonsDown =
  dropMap .buttonCodes model