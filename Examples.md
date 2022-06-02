
# Examples

## Password input

We'll write a password input.

We'll start with a function will receive a label, an input
and a caption and returns a simple layout adding accessibility attributes.

```elm
module Input exposing (..)

container :
    { id : String
    , label : Element a msg
    , input : Element a msg
    , caption : Element a msg
    }
    -> Element b msg
container { id, label, input, caption } =
    let
        inputId =
            id

        captionId =
            id ++ "-caption"
    in
    Element.div
        |> Element.children
            [ label
                |> Attribute.for inputId
            , input
                |> Attribute.id inputId
                |> Attribute.attribute "aria-describedby" captionId
            , caption
                |> Attribute.id captionId
            ]
```

Here's an example of how we might consume this function:

```elm
passwordInput { id, value, onInput } =
    Input.container
        { id = id
        , label =
            viewLabel
                |> Element.text "Password"
        , input =
            viewPasswordInput
                |> Attribute.value value
                |> Event.onInput onInput
        , caption =
            viewCaption
                |> Element.text "Must have 8 characters"
        }
        |> column 8


viewLabel =
    Element.label
        |> Attribute.style "font-size" "0.8rem"
        |> Attribute.style "font-weight" "600"


viewPasswordInput =
    Element.input
        |> Attribute.type_ "password"
        |> Attribute.placeholder "Enter your password…"


viewCaption = -- ...


column spacing =
    Attribute.style "display" "flex"
        >> Attribute.style "flex-direction" "column"
        >> Attribute.style "gap" (String.fromInt spacing ++ "px")
```

Notice how clean the separation is between:

1. and the code that assigns the accessibility props.
2. the code that assigns styles,
3. the code that fills the styled elements with text nodes, and event handlers.

For example, changing the layout from a column to a row doesn't require changing
the implementation of `container`, and we didn't need any boilerplate
code to accumulate attributes or children.

However, note that `container` has the implicit assumption that its parameters
must be `<label>` and `<input>` elements, not wrapped in `<div>`s or anything.

To address that issue, we can use the _phantom type_ ✨

The module `Input` will now expose these types and functions:

```elm
module Input exposing (container, input, label, Input, Label)

container :
    { id : String
    , label : Element Label msg
    , input : Element Input msg
    , caption : Element a msg
    }
    -> Element b msg
container config = -- ... same implementation

type Label = Label


label : Element Label msg
label =
    Element.element Label "label"

type Input = Input

input : Element Input msg
input =
    Element.element Input "input"
```

Now, calling `Input.container` requires using `Input.label`
and `Input.input`.

```elm
viewLabel =
    Input.label
        |> Attribute.style "font-size" "0.8rem"
        |> Attribute.style "font-weight" "600"


viewPasswordInput =
    Input.input
        |> Attribute.type_ "password"
        |> Attribute.placeholder "Enter your password…"
```
