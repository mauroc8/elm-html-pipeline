module Html.Pipeline exposing
    ( Element, node
    , addAttributes, addChildren
    , toHtml, fold
    )

{-|

@docs Element, node

@docs addAttributes, addChildren

@docs toHtml, fold

-}

import Html
import Html.Attributes as Attributes
import Html.Events as Events


{-| Represents an HTML element node.

In particular, an element node is a node that has a tag name, a list of attributes and a list of children.

Other types of [HTML nodes](https://developer.mozilla.org/en-US/docs/Web/API/Node/nodeType) (for example
text nodes) don't have any of those.

-}
type Element msg
    = Pipeline
        { tagName : String
        , attributes : List (List (Html.Attribute msg))
        , children : List (List (Html.Html msg))
        }


html :
    String
    -> List (List (Html.Attribute msg))
    -> List (List (Html.Html msg))
    -> Element msg
html tagName attributes children =
    Pipeline { tagName = tagName, attributes = attributes, children = children }


{-| Creates an empty [Element](Html.Pipeline#Element) from a [HTML tag name](https://developer.mozilla.org/en-US/docs/Web/HTML/Element).
-}
node : String -> Element msg
node tagName =
    html tagName [] []


{-| Appends attributes to an existing [Element](Html.Pipeline#Element).

    node "div"
        |> addAttributes
            [ Html.Attributes.class "container"
            ]

-}
addAttributes :
    List (Html.Attribute msg)
    -> Element msg
    -> Element msg
addAttributes newAttributes (Pipeline { tagName, attributes, children }) =
    html tagName (newAttributes :: attributes) children


{-| Appends children to an existing [Element](Html.Pipeline#Element).

    node "div"
        |> addChildren
            [ Html.text "Hello,"
            , Html.text " world"
            ]

-}
addChildren : List (Html.Html msg) -> Element msg -> Element msg
addChildren newChildren (Pipeline { tagName, attributes, children }) =
    html tagName attributes (newChildren :: children)


{-| Converts an [Element](Html.Pipeline#Element) into an elm
[Html](https://package.elm-lang.org/packages/elm/html/latest/Html#Html) value,
closing the pipeline.
-}
toHtml : Element msg -> Html.Html msg
toHtml =
    fold Html.node


{-| This function allows you to do whatever you want with the accumulated
attributes and children.

_It is exported for testing purposes, you shouldn't need it._

-}
fold :
    (String -> List (Html.Attribute msg) -> List (Html.Html msg) -> b)
    -> Element msg
    -> b
fold f (Pipeline { tagName, attributes, children }) =
    let
        reverseConcat =
            List.reverse >> List.concat
    in
    f tagName
        (reverseConcat attributes)
        (reverseConcat children)
