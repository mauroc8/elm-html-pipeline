# elm-html-pipeline

Build HTML nodes using the pipeline [`(|>)`](http://package.elm-lang.org/packages/elm-lang/core/3.0.0/Basics#|>)
operator.

## Example

```elm
import Html.Element as Element exposing (Element)
import Html.Element.Attribute as Attribute
import Html.Element.Event as Event

view : Int -> Element a Msg
view count =
    Element.div
        |> Attribute.style "font-family" "sans-serif"
        |> Element.children
            [ Element.button
                |> Event.onClick Decrement
                |> Element.text "-"
            , Element.div
                |> Element.text (String.fromInt count)
            , Element.button
                |> Event.onClick Increment
                |> Element.text "+"
            ]
```

## Motivation

I wanted to try a pipeline-based API to generate HTML.
This package offers the type [Element a msg](Html.Element#Element) to create HTML
nodes using pipelines.

_This is experimental, but I'm publishing it because, even if it turns out to be a bad idea,
hopefully the next person that wants to scratch the same itch won't waste a lot of time with it._


## Usage

You start a pipeline with some function from [Html.Element](Html.Element):

```elm
import Html.Element as Element exposing (Element)

button : Element a msg
button =
    Element.button
```

This creates an empty `<button></button>` element.

Then you can add attributes, event handlers and children:

```elm
import Html.Element as Element exposing (Element)
import Html.Element.Attribute as Attribute
import Html.Element.Event as Event

button : msg -> String -> Element a msg
button msg label =
    Element.button
        |> Attribute.class "button"
        |> Event.onClick msg
        |> Element.child icon
        |> Element.text label
```

`Html` values are constructed once and then untouchable.
Instead, `Element`s can be modified after being created:

```elm
primaryButton msg label =
    button msg label
        |> Attribute.class "primary-button"

primaryButtonWithOutline msg label =
    primaryButton msg label
        |> Attribute.class "button-outline"
```

You can convert an `Element` into an `Html` using [toHtml](Html.Element#toHtml).

You can't convert an `Html` into an `Element`, but you can append `Html` nodes as children of an
`Element` using [htmlChildren](Html.Element#htmlChildren).


## Attributes

This library doesn't have an `Attribute` type, it uses
[Html.Attribute](https://package.elm-lang.org/packages/elm/html/latest/Html#Attribute)
under the hood.
