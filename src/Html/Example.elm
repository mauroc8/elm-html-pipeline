module Html.Example exposing (..)

import Html
import Html.Attributes
import Html.Events
import Html.Pipeline


associatedLabelAndInput :
    { id : String }
    ->
        ( Html.Pipeline.Element msg
        , Html.Pipeline.Element msg
        )
associatedLabelAndInput { id } =
    ( Html.Pipeline.node "label"
        |> Html.Pipeline.addAttributes
            [ Html.Attributes.for id
            ]
    , Html.Pipeline.node "input"
        |> Html.Pipeline.addAttributes
            [ Html.Attributes.id id
            ]
    )


inputWithLabel { id, value, type_, onChange } =
    let
        ( label, input ) =
            associatedLabelAndInput { id = id }
    in
    Html.div []
        [ label
            |> Html.Pipeline.addChildren
                [ Html.text "Password"
                ]
            |> Html.Pipeline.toHtml
        , input
            |> Html.Pipeline.addAttributes
                [ Html.Attributes.type_ type_
                , Html.Attributes.value value
                , Html.Events.onInput onChange
                ]
            |> Html.Pipeline.toHtml
        ]
