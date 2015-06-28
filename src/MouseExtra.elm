module MouseExtra 
  ( ButtonCode
  , buttonsDown
  , mouseWheel
  )
  where

import Set
import Native.MouseExtra


{-| Type alias to make it clearer what integers are supposed to represent in this library. -}
type alias ButtonCode = Int

-- MANAGE RAW STREAMS

type alias ButtonModel =
  { buttonCodes : Set.Set ButtonCode
  }


emptyButtonModel : ButtonModel
emptyButtonModel =
  { buttonCodes = Set.empty
  }


type ButtonEvent = Up ButtonEventInfo | Down ButtonEventInfo

type alias ButtonEventInfo =
  { buttonCode : ButtonCode
  }


buttonUpdate : ButtonEvent -> ButtonModel -> ButtonModel
buttonUpdate event model =
  case event of
    Down info ->
        { buttonCodes = Set.insert info.buttonCode model.buttonCodes
        }

    Up info ->
        { buttonCodes = Set.remove info.buttonCode model.buttonCodes
        }


buttonModel : Signal ButtonModel
buttonModel =
  Signal.foldp buttonUpdate emptyButtonModel rawButtonEvents


rawButtonEvents : Signal ButtonEvent
rawButtonEvents =
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
  dropMap .buttonCodes buttonModel


mouseWheel : Signal (Float, Float)
mouseWheel = Native.MouseExtra.wheel