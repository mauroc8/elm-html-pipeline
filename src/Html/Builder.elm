module Html.Builder exposing
    ( Html
    , addAttributes
    , addChildren
    , from
    , toHtml
    )

import Html
import Html.Attributes as Attributes
import Html.Events as Events


type Html msg
    = Pipeline
        { build : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
        , attributes : List (List (Html.Attribute msg))
        , children : List (List (Html.Html msg))
        }


html :
    (List (Html.Attribute msg)
     -> List (Html.Html msg)
     -> Html.Html msg
    )
    -> List (List (Html.Attribute msg))
    -> List (List (Html.Html msg))
    -> Html msg
html build attributes children =
    Pipeline { build = build, attributes = attributes, children = children }


from :
    (List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg)
    -> Html msg
from build =
    html build [] []


addAttributes :
    List (Html.Attribute msg)
    -> Html msg
    -> Html msg
addAttributes newAttributes (Pipeline { build, attributes, children }) =
    html build (newAttributes :: attributes) children


addChildren : List (Html.Html msg) -> Html msg -> Html msg
addChildren newChildren (Pipeline { build, attributes, children }) =
    html build attributes (newChildren :: children)


toHtml : Html msg -> Html.Html msg
toHtml (Pipeline { build, attributes, children }) =
    let
        reverseConcat =
            List.reverse >> List.concat
    in
    build
        (reverseConcat attributes)
        (reverseConcat children)
