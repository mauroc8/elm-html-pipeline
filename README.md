# elm-html-pipeline

Build HTML nodes using the pipeline [`(|>)`](http://package.elm-lang.org/packages/elm-lang/core/3.0.0/Basics#|>)
operator.

## Example

```elm
import Html.Pipeline as Html
import Html.Pipeline.Attribute as Attribute
import Html.Pipeline.Event as Event

view : Int -> Html.Element Msg
view count =
  Html.div
    |> Html.children
        [ Html.button
            |> Event.onClick Decrement
            |> Html.text "-"
        , Html.div
            |> Html.text (String.fromInt count)
        , Html.button
            |> Event.onClick Increment
            |> Html.text "+"
        ]
```

## Motivation

Feeling a little frustrated with all the list juggling involved in writing HTML in elm,
I've been recently obsessed with trying a pipeline-based API instead.

This is experimental, but I'm publishing it because, even if it turns out to be a bad idea,
at least the next person that wants to scratch the same itch will realize sooner.

This package offers the type `Html.Pipeline.Element msg` to generate HTML.

## Usage

You start a pipeling with a function from `Html.Pipeline`:

> The same functions available in `Html` for creating `Html` nodes are available
> in `Html.Pipeline` to create empty `Element`s.

```elm
button : Element msg
button =
    Element.button
```


Then you can add attributes, properties, event handlers and children:

```elm
button : msg -> String -> Element msg
button msg label =
    Element.button
        |> Event.onClick msg
        |> Element.text label
```

`Html` values are constructed once and then untouchable.
Instead, `Element`s can be modified after being created:

```elm
primaryButton msg label =
    button msg label
        |> Attribute.class "primary-button"

secondaryButton msg label =
    button msg label
        |> Attribute.class "secondary-buton"
```

You can convert an `Element msg` to `Html msg` using `Html.Pipeline.toHtml`.

Unlike an `Html msg`, an `Element msg` cannot be a text node, but
you can append text nodes to any element using `Html.Pipeline.text`.

You can also append `Html msg` nodes in an `Element` using `Html.Pipeline.htmlChildren`.

## Attributes and events

Most functions in the `Html.Pipeline.Attribute` and `Html.Pipeline.Event` call the
homonymous function in `Html.Attributes` and `Html.Events`

## Keyed and lazy

There are no plans to support keyed and lazy nodes.

You can just use the regular `Html.Keyed` and `Html.Lazy` functions.
