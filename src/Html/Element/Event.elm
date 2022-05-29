module Html.Element.Event exposing
    ( onClick, onDoubleClick
    , onMouseDown, onMouseUp
    , onMouseEnter, onMouseLeave
    , onMouseOver, onMouseOut
    , onInput, onCheck, onSubmit
    , onBlur, onFocus
    , on, stopPropagationOn, preventDefaultOn, custom
    )

{-| This module has wrappers around the functions in
[Html.Events](https://package.elm-lang.org/packages/elm/html/latest/Html-Events).


# Mouse

@docs onClick, onDoubleClick
@docs onMouseDown, onMouseUp
@docs onMouseEnter, onMouseLeave
@docs onMouseOver, onMouseOut


# Forms

@docs onInput, onCheck, onSubmit


# Focus

@docs onBlur, onFocus


# Custom

@docs on, stopPropagationOn, preventDefaultOn, custom

-}

import Html.Events
import Html.Shared as Shared exposing (Element)
import Json.Decode as Json



-- MOUSE EVENTS


{-| -}
onClick : msg -> Element msg -> Element msg
onClick msg =
    Html.Events.onClick msg
        |> Shared.addAttribute


{-| -}
onDoubleClick : msg -> Element msg -> Element msg
onDoubleClick msg =
    Html.Events.onDoubleClick msg
        |> Shared.addAttribute


{-| -}
onMouseDown : msg -> Element msg -> Element msg
onMouseDown msg =
    Html.Events.onMouseDown msg
        |> Shared.addAttribute


{-| -}
onMouseUp : msg -> Element msg -> Element msg
onMouseUp msg =
    Html.Events.onMouseUp msg
        |> Shared.addAttribute


{-| -}
onMouseEnter : msg -> Element msg -> Element msg
onMouseEnter msg =
    Html.Events.onMouseEnter msg
        |> Shared.addAttribute


{-| -}
onMouseLeave : msg -> Element msg -> Element msg
onMouseLeave msg =
    Html.Events.onMouseLeave msg
        |> Shared.addAttribute


{-| -}
onMouseOver : msg -> Element msg -> Element msg
onMouseOver msg =
    Html.Events.onMouseOver msg
        |> Shared.addAttribute


{-| -}
onMouseOut : msg -> Element msg -> Element msg
onMouseOut msg =
    Html.Events.onMouseOut msg
        |> Shared.addAttribute



-- FORM EVENTS


{-| Detect [input](https://developer.mozilla.org/en-US/docs/Web/Events/input)
events for things like text fields or text areas.

For more details on how `onInput` works, check out [`targetValue`](#targetValue).

**Note 1:** It grabs the **string** value at `event.target.value`, so it will
not work if you need some other information. For example, if you want to track
inputs on a range slider, make a custom handler with [`on`](#on).

**Note 2:** It uses `stopPropagationOn` internally to always stop propagation
of the event. This is important for complicated reasons explained [here][1] and
[here][2].

[1]: /packages/elm/virtual-dom/latest/VirtualDom#Handler
[2]: https://github.com/elm/virtual-dom/issues/125

-}
onInput : (String -> msg) -> Element msg -> Element msg
onInput tagger =
    Html.Events.onInput tagger
        |> Shared.addAttribute


{-| Detect [change](https://developer.mozilla.org/en-US/docs/Web/Events/change)
events on checkboxes. It will grab the boolean value from `event.target.checked`
on any input event.

Check out [`targetChecked`](#targetChecked) for more details on how this works.

-}
onCheck : (Bool -> msg) -> Element msg -> Element msg
onCheck tagger =
    Html.Events.onCheck tagger
        |> Shared.addAttribute


{-| Detect a [submit](https://developer.mozilla.org/en-US/docs/Web/Events/submit)
event with [`preventDefault`](https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault)
in order to prevent the form from changing the page’s location. If you need
different behavior, create a custom event handler.
-}
onSubmit : msg -> Element msg -> Element msg
onSubmit msg =
    Html.Events.onSubmit msg
        |> Shared.addAttribute



-- FOCUS EVENTS


{-| -}
onBlur : msg -> Element msg -> Element msg
onBlur msg =
    Html.Events.onBlur msg
        |> Shared.addAttribute


{-| -}
onFocus : msg -> Element msg -> Element msg
onFocus msg =
    Html.Events.onFocus msg
        |> Shared.addAttribute



-- CUSTOM EVENTS


{-| Create a custom event listener. Normally this will not be necessary, but
you have the power! Here is how `onClick` can be defined for example:

    import Json.Decode as Decode

    onClick : msg -> Element msg -> Element msg
    onClick message =
        Events.on "click" (Decode.succeed message)

The first argument is the event name in the same format as with JavaScript's
[`addEventListener`][aEL] function.

The second argument is a JSON decoder. Read more about these [here][decoder].
When an event occurs, the decoder tries to turn the event object into an Elm
value. If successful, the value is routed to your `update` function. In the
case of `onClick` we always just succeed with the given `message`.

If this is confusing, work through the [Elm Architecture Tutorial][tutorial].
It really helps!

[aEL]: https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener
[decoder]: /packages/elm/json/latest/Json-Decode
[tutorial]: https://github.com/evancz/elm-architecture-tutorial/

**Note:** This creates a [passive] event listener, enabling optimizations for
touch, scroll, and wheel events in some browsers.

[passive]: https://github.com/WICG/EventListenerOptions/blob/gh-pages/explainer.md

-}
on : String -> Json.Decoder msg -> Element msg -> Element msg
on event decoder =
    Html.Events.on event decoder
        |> Shared.addAttribute


{-| Create an event listener that may [`stopPropagation`][stop]. Your decoder
must produce a message and a `Bool` that decides if `stopPropagation` should
be called.

[stop]: https://developer.mozilla.org/en-US/docs/Web/API/Event/stopPropagation

**Note:** This creates a [passive] event listener, enabling optimizations for
touch, scroll, and wheel events in some browsers.

[passive]: https://github.com/WICG/EventListenerOptions/blob/gh-pages/explainer.md

-}
stopPropagationOn : String -> Json.Decoder ( msg, Bool ) -> Element msg -> Element msg
stopPropagationOn event decoder =
    Html.Events.stopPropagationOn event decoder
        |> Shared.addAttribute


{-| Create an event listener that may [`preventDefault`][prevent]. Your decoder
must produce a message and a `Bool` that decides if `preventDefault` should
be called.

For example, the `onSubmit` function in this library _always_ prevents the
default behavior:

[prevent]: https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault

    onSubmit : msg -> Element msg -> Element msg
    onSubmit msg =
        Events.preventDefaultOn "submit"
            (Json.map alwaysPreventDefault (Json.succeed msg))

    alwaysPreventDefault : msg -> ( msg, Bool )
    alwaysPreventDefault msg =
        Html.Events.alwaysPreventDefault msg
            |> Shared.addAttribute
                ( msg, True )

-}
preventDefaultOn : String -> Json.Decoder ( msg, Bool ) -> Element msg -> Element msg
preventDefaultOn event decoder =
    Html.Events.preventDefaultOn event decoder
        |> Shared.addAttribute


{-| Create an event listener that may [`stopPropagation`][stop] or
[`preventDefault`][prevent].

[stop]: https://developer.mozilla.org/en-US/docs/Web/API/Event/stopPropagation
[prevent]: https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault
[handler]: https://package.elm-lang.org/packages/elm/virtual-dom/latest/VirtualDom#Handler

**Note:** Check out the lower-level event API in `elm/virtual-dom` for more
information on exactly how events work, especially the [`Handler`][handler]
docs.

-}
custom : String -> Json.Decoder { message : msg, stopPropagation : Bool, preventDefault : Bool } -> Element msg -> Element msg
custom event decoder =
    Html.Events.custom event decoder
        |> Shared.addAttribute
