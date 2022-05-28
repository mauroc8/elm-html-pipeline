module Html.Shared exposing
    ( Element
    , Modifier
    , addAttribute
    , addChildren
    , addHtmlChildren
    , addTextNode
    , element
    , map
    , toHtml
    )

import Html
import Html.Attributes
import Html.Keyed


{-| -}
type Element msg
    = Element String (List (Modifier msg))


{-| -}
element : String -> Element msg
element tagName =
    Element tagName []


type Modifier msg
    = AddAttribute (Html.Attribute msg)
    | AddChildren (List (Element msg))
    | AddHtmlChildren (List (Html.Html msg))


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

        AddHtmlChildren children ->
            AddHtmlChildren <| List.map (Html.map f) children


addAttribute : Html.Attribute msg -> Element msg -> Element msg
addAttribute attr el =
    addModifier (AddAttribute attr) el


addChildren : List (Element msg) -> Element msg -> Element msg
addChildren children el =
    addModifier (AddChildren children) el


addHtmlChildren : List (Html.Html msg) -> Element msg -> Element msg
addHtmlChildren children el =
    addModifier (AddHtmlChildren children) el


addTextNode : String -> Element msg -> Element msg
addTextNode content el =
    addHtmlChildren [ Html.text content ] el


toHtml : Element msg -> Html.Html msg
toHtml (Element tagName modifiers) =
    let
        ( attrs, children ) =
            collectAttributesAndChildren modifiers
    in
    Html.node tagName
        (List.reverse attrs)
        (List.reverse children)


collectAttributesAndChildren : List (Modifier msg) -> ( List (Html.Attribute msg), List (Html.Html msg) )
collectAttributesAndChildren =
    List.foldr
        (\modifier ( attrs, children ) ->
            case modifier of
                AddAttribute attr ->
                    ( attr :: attrs, children )

                AddChildren otherChildren ->
                    ( attrs, List.map toHtml otherChildren ++ children )

                AddHtmlChildren otherChildren ->
                    ( attrs, otherChildren ++ children )
        )
        ( [], [] )
