# elm-html-pipeline

Build HTML nodes using the pipeline [`(|>)`](http://package.elm-lang.org/packages/elm-lang/core/3.0.0/Basics#|>)
operator.

## Example

```elm
import Html exposing (Html)
import Html.Element as Element exposing (Element)
import Html.Element.Attribute as Attribute
import Html.Element.Event as Event

view : Int -> Html Msg
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
        |> Element.toHtml
```

## Motivation

I wanted to try a pipeline-based API to generate HTML.
This package offers the type [Element msg](Html.Element#Element) to create HTML
nodes using pipelines.

_This is experimental, but I'm publishing it because, even if it turns out to be a bad idea,
hopefully the next person that wants to scratch the same itch won't waste a lot of time with it._


## Usage

You start a pipeline with some function from [Html.Element](Html.Element):

```elm
import Html.Element as Element exposing (Element)

button : Element msg
button =
    Element.button
```

This creates an empty `<button></button>` element.

Then you can add attributes, event handlers and children:

```elm
import Html.Element as Element exposing (Element)
import Html.Element.Attribute as Attribute
import Html.Element.Event as Event

button : msg -> String -> Element msg
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

## Elements vs nodes

There are several types of [HTML nodes](https://developer.mozilla.org/en-US/docs/Web/API/Node/nodeType):

- text nodes
- element nodes (e.g. `<p>`, `<div>`)
- comments
- whitespace
- others…

The [Html](https://package.elm-lang.org/packages/elm/html/latest/Html#Html)
type represents a text or element node. The [Element](Html.Element#Element) type represents
only element nodes (that's why it's called like that).

You can't create text nodes using this package, but you can append them to any `Element`
using [text](Html.Element#text).

## Attributes and events

I copy-pasted the [Html.Html](https://package.elm-lang.org/packages/elm/html/latest/Html),
[Html.Attributes](https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes)
and [Html.Events](https://package.elm-lang.org/packages/elm/html/latest/Html-Events) modules and
added a thin wrapper around the exposed functions. You can expect to encounter all the functions
you're used to from `elm/html`.

This library doesn't have an `Attribute` type, it uses
[Html.Attribute](https://package.elm-lang.org/packages/elm/html/latest/Html#Attribute) under
the hood.

## Attributes

Attributes in [Html.Element.Attribute](Html.Element.Attribute) are defined as functions
that take an element and return a new element with the added attribute(s).

```
Attribute.style "color" "red"
-- <function> : Element msg -> Element msg
```

At the type level, there's no distintion between attributes, event handlers and other
functions like [children](Html.Element.children).

### Batch attributes

A list of attributes is just a list of functions `Element msg -> Element msg`, and can be
flattened into a single `Element msg -> Element msg` function:

```
textStyles =
    Attribute.batch
        [ Attribute.style "font-family" "Monaco, sans-serif"
        , Attribute.style "font-size" "1rem"
        , Attribute.style "line-height" "1.4rem"
        ]

paragraph =
    Element.p
        |> textStyles

```

Note that adding child nodes is also done with a function of type `Element msg -> Element msg`,
so there is no way (yet?) to prevent someone from doing things like:

```
textStyles =
    Attribute.batch
        [ Attribute.style "font-family" "Monaco, sans-serif"
        , Attribute.style "font-size" "1rem"
        , Attribute.style "line-height" "1.4rem"
        , Element.text "Hello"
        , Debug.log "attribute"
        ]
```


## Keyed and lazy

There are no plans to support keyed and lazy nodes.

You can just use the regular `Html.Keyed` and `Html.Lazy` functions.
