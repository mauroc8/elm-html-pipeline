module Html.Shared exposing (..)

import Html
import Html.Attributes


{-| -}
type Element msg
    = Element String (List (Modifier msg))


type Modifier msg
    = AddAttribute (Html.Attribute msg)
    | AddChildren (List (Element msg))
    | AddTextNode String


addModifier : Modifier msg -> Element msg -> Element msg
addModifier modifier (Element tagName modifiers) =
    Element tagName (modifier :: modifiers)


map : (a -> msg) -> Element a -> Element msg
map f (Element tagName modifiers) =
    Element tagName (List.map (mapModifier f) modifiers)


mapModifier : (msg -> a) -> Modifier msg -> Modifier a
mapModifier f modifier =
    case modifier of
        AddAttribute attr ->
            AddAttribute (Html.Attributes.map f attr)

        AddChildren children ->
            AddChildren <| List.map (map f) children

        AddTextNode content ->
            AddTextNode content
