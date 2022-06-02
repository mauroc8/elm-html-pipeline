module Html.Example exposing (..)

import Html
import Html.Attributes
import Html.Builder
import Html.Events


sandbox =
    { init = ""
    , update = \newValue _ -> newValue
    , view = view
    }


view password =
    let
        ( label, input ) =
            associatedLabelAndInput { id = "password-input" }
    in
    Html.div
        [ Html.Attributes.class "container" ]
        [ label
            |> Html.Builder.addChildren
                [ Html.text "Password"
                ]
            |> Html.Builder.addAttributes
                [ Html.Attributes.class "label"
                ]
            |> Html.Builder.toHtml
        , input
            |> Html.Builder.addAttributes
                [ -- Input
                  Html.Attributes.type_ "password"
                , Html.Attributes.value password
                , Html.Events.onInput identity

                -- Styles
                , Html.Attributes.class "input"
                ]
            |> Html.Builder.toHtml
        , styles
        ]


associatedLabelAndInput :
    { id : String }
    ->
        ( Html.Builder.Html msg
        , Html.Builder.Html msg
        )
associatedLabelAndInput { id } =
    ( Html.Builder.from Html.label
        |> Html.Builder.addAttributes
            [ Html.Attributes.for id
            ]
    , Html.Builder.from Html.input
        |> Html.Builder.addAttributes
            [ Html.Attributes.id id
            ]
    )


styles =
    Html.node "style"
        []
        [ Html.text """

.container {
    display: flex;
    flex-direction: column;
    gap: 16px;
    padding: 16px;
    font-family: sans-serif;
}

.label {
    font-weight: bold;
    font-size: 0.7rem;
}

.input {
    border: 1px solid #ddd;
    background-color: #eee;
    font-size: 1rem;
    line-height: 1rem;
    padding: 8px;
}

"""
        ]
