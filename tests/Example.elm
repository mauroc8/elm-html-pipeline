module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Html
import Html.Attributes
import Html.Pipeline
import Test exposing (..)


suite : Test
suite =
    describe "The Html.Pipeline module"
        [ test "preserves attributes order" preservesAttributesOrder
        , test "preserves children order" preservesChildrenOrder
        ]


preservesAttributesOrder _ =
    let
        attr0 =
            Html.Attributes.class "class-0"

        attr1 =
            Html.Attributes.class "class-1"

        attr2 =
            Html.Attributes.class "class-2"

        attr3 =
            Html.Attributes.class "class-3"
    in
    Html.Pipeline.node "div"
        |> Html.Pipeline.addAttributes
            [ attr0
            , attr1
            ]
        |> Html.Pipeline.addAttributes
            [ attr2
            , attr3
            ]
        |> Html.Pipeline.fold (\_ attrs _ -> attrs)
        |> Expect.equal
            [ attr0
            , attr1
            , attr2
            , attr3
            ]


preservesChildrenOrder _ =
    let
        child0 =
            Html.text "child-0"

        child1 =
            Html.text "child-1"

        child2 =
            Html.text "child-2"

        child3 =
            Html.text "child-3"
    in
    Html.Pipeline.node "div"
        |> Html.Pipeline.addChildren
            [ child0
            , child1
            ]
        |> Html.Pipeline.addChildren
            [ child2
            , child3
            ]
        |> Html.Pipeline.fold (\_ _ children -> children)
        |> Expect.equal
            [ child0
            , child1
            , child2
            , child3
            ]
