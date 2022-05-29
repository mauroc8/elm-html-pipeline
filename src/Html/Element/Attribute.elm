module Html.Element.Attribute exposing
    ( htmlAttribute, htmlAttributes, batch, none
    , style, property, attribute
    , class, classList, id, title, hidden
    , type_, value, checked, placeholder, selected
    , accept, acceptCharset, action, autocomplete, autofocus
    , disabled, enctype, list, maxlength, minlength, method, multiple
    , name, novalidate, pattern, readonly, required, size, for, form
    , max, min, step
    , cols, rows, wrap
    , href, target, download, downloadAs, hreflang, media, ping, rel
    , ismap, usemap, shape, coords
    , src, height, width, alt
    , autoplay, controls, loop, preload, poster, default, kind, srclang
    , sandbox, srcdoc
    , reversed, start
    , align, colspan, rowspan, headers, scope
    , accesskey, contenteditable, contextmenu, dir, draggable, dropzone
    , itemprop, lang, spellcheck, tabindex
    , cite, datetime, pubdate, manifest
    )

{-| This module exposes functions to add attributes to an `Element`.

**Note:** The code examples will assume the following imports:

    import Html.Element as Element exposing (Element)
    import Html.Element.Attribute as Attribute
    import Html.Element.Event as Event


# Helpers

@docs htmlAttribute, htmlAttributes, batch, none

The rest of the functions in this module are wrappers around the homonymous functions
in [Html.Attributes](https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes).


# Primitives

@docs style, property, attribute


# Super Common Attributes

@docs class, classList, id, title, hidden


# Inputs

@docs type_, value, checked, placeholder, selected


## Input Helpers

@docs accept, acceptCharset, action, autocomplete, autofocus
@docs disabled, enctype, list, maxlength, minlength, method, multiple
@docs name, novalidate, pattern, readonly, required, size, for, form


## Input Ranges

@docs max, min, step


## Input Text Areas

@docs cols, rows, wrap


# Links and Areas

@docs href, target, download, downloadAs, hreflang, media, ping, rel


## Maps

@docs ismap, usemap, shape, coords


# Embedded Content

@docs src, height, width, alt


## Audio and Video

@docs autoplay, controls, loop, preload, poster, default, kind, srclang


## iframes

@docs sandbox, srcdoc


# Ordered Lists

@docs reversed, start


# Tables

@docs align, colspan, rowspan, headers, scope


# Less Common Global Attributes

Attributes that can be attached to any HTML tag but are less commonly used.

@docs accesskey, contenteditable, contextmenu, dir, draggable, dropzone
@docs itemprop, lang, spellcheck, tabindex


# Miscellaneous

@docs cite, datetime, pubdate, manifest

-}

import Html
import Html.Attributes
import Html.Shared as Shared exposing (Element)
import Json.Encode as Json exposing (Value)


{-| Adds an `Html.Attribute` to an [Element](Html.Element#Element).

This is the base function used to implement all other functions in this module.

-}
htmlAttribute : Html.Attribute msg -> Element msg -> Element msg
htmlAttribute =
    Shared.addAttribute


{-| -}
htmlAttributes : List (Html.Attribute msg) -> Element msg -> Element msg
htmlAttributes attrs =
    batch (List.map htmlAttribute attrs)


{-| Flattens a list of functions into a single function.

    textStyles =
        Attribute.batch
            [ Attribute.style "font-family" "Monaco, sans-serif"
            , Attribute.style "font-size" "1rem"
            , Attribute.style "line-height" "1.4rem"
            ]

    paragraph =
        Element.p
            |> textStyles

Note that adding child nodes is also done with functions of type `Element msg -> Element msg`,
so there is no way _(yet?)_ to prevent someone from doing:

    textStyles =
        Attribute.batch
            [ Element.text "Hello"
            , Debug.log "attribute"
            ]

-}
batch : List (Element msg -> Element msg) -> (Element msg -> Element msg)
batch attributes el =
    List.foldl (<|) el attributes


{-| An empty attribute.

It adds the attribute `Html.Attributes.class ""`.

> _You can also use the [identity]() function as a empty attribute, but this implementation
> might work better with the virtual DOM diffing algorithm (unverified)._

-}
none : Element msg -> Element msg
none el =
    class "" el


{-| Specify a style.

    greeting : Element msg
    greeting =
        Element.div
            |> Element.style "background-color" "red"
            |> Element.style "height" "90px"
            |> Element.style "width" "100%"
            |> Element.text "Hello!"

-}
style : String -> String -> Element msg -> Element msg
style p v =
    Html.Attributes.style p v
        |> Shared.addAttribute


{-| This function makes it easier to build a space-separated class attribute.
Each class can easily be added and removed depending on the boolean value it
is paired with. For example, maybe we want a way to view notices:

    viewNotice : Notice -> Html msg
    viewNotice notice =
        Element.div
            |> Element.classList
                [ ( "notice", True )
                , ( "notice-important", notice.isImportant )
                , ( "notice-seen", notice.isSeen )
                ]
            |> Element.text notice.content

**Note:** You can have as many `class` and `classList` attributes as you want.
They all get applied, so if you say `[ class "notice", class "notice-seen" ]`
you will get both classes!

-}
classList : List ( String, Bool ) -> Element msg -> Element msg
classList classes =
    Html.Attributes.classList classes
        |> Shared.addAttribute



-- CUSTOM ATTRIBUTES


{-| Create _properties_, like saying `domNode.className = 'greeting'` in
JavaScript.

    import Json.Encode as Encode

    class : String -> Element msg -> Element msg
    class name =
        property "className" (Encode.string name)

Read more about the difference between properties and attributes [here].

[here]: https://github.com/elm/html/blob/master/properties-vs-attributes.md

-}
property : String -> Value -> Element msg -> Element msg
property n v =
    Html.Attributes.property n v
        |> Shared.addAttribute


{-| Create _attributes_, like saying `domNode.setAttribute('class', 'greeting')`
in JavaScript.

    class : String -> Element msg -> Element msg
    class name =
        attribute "class" name

Read more about the difference between properties and attributes [here].

[here]: https://github.com/elm/html/blob/master/properties-vs-attributes.md

-}
attribute : String -> String -> Element msg -> Element msg
attribute n v =
    Html.Attributes.attribute n v
        |> Shared.addAttribute



-- GLOBAL ATTRIBUTES


{-| Often used with CSS to style elements with common properties.

**Note:** You can have as many `class` and `classList` attributes as you want.
They all get applied, so if you say `[ class "notice", class "notice-seen" ]`
you will get both classes!

-}
class : String -> Element msg -> Element msg
class n =
    Html.Attributes.class n
        |> Shared.addAttribute


{-| Indicates the relevance of an element.
-}
hidden : Bool -> Element msg -> Element msg
hidden bool =
    Html.Attributes.hidden bool
        |> Shared.addAttribute


{-| Often used with CSS to style a specific element. The value of this
attribute must be unique.
-}
id : String -> Element msg -> Element msg
id str =
    Html.Attributes.id str
        |> Shared.addAttribute


{-| Text to be displayed in a tooltip when hovering over the element.
-}
title : String -> Element msg -> Element msg
title str =
    Html.Attributes.title str
        |> Shared.addAttribute



-- LESS COMMON GLOBAL ATTRIBUTES


{-| Defines a keyboard shortcut to activate or add focus to the element.
-}
accesskey : Char -> Element msg -> Element msg
accesskey char =
    Html.Attributes.accesskey char
        |> Shared.addAttribute


{-| Indicates whether the element's content is editable.
-}
contenteditable : Bool -> Element msg -> Element msg
contenteditable bool =
    Html.Attributes.contenteditable bool
        |> Shared.addAttribute


{-| Defines the ID of a `menu` element which will serve as the element's
context menu.
-}
contextmenu : String -> Element msg -> Element msg
contextmenu str =
    Html.Attributes.contextmenu str
        |> Shared.addAttribute


{-| Defines the text direction. Allowed values are ltr (Left-To-Right) or rtl
(Right-To-Left).
-}
dir : String -> Element msg -> Element msg
dir str =
    Html.Attributes.dir str
        |> Shared.addAttribute


{-| Defines whether the element can be dragged.
-}
draggable : String -> Element msg -> Element msg
draggable str =
    Html.Attributes.draggable str
        |> Shared.addAttribute


{-| Indicates that the element accept the dropping of content on it.
-}
dropzone : String -> Element msg -> Element msg
dropzone str =
    Html.Attributes.dropzone str
        |> Shared.addAttribute


{-| -}
itemprop : String -> Element msg -> Element msg
itemprop str =
    Html.Attributes.itemprop str
        |> Shared.addAttribute


{-| Defines the language used in the element.
-}
lang : String -> Element msg -> Element msg
lang str =
    Html.Attributes.lang str
        |> Shared.addAttribute


{-| Indicates whether spell checking is allowed for the element.
-}
spellcheck : Bool -> Element msg -> Element msg
spellcheck bool =
    Html.Attributes.spellcheck bool
        |> Shared.addAttribute


{-| Overrides the browser's default tab order and follows the one specified
instead.
-}
tabindex : Int -> Element msg -> Element msg
tabindex int =
    Html.Attributes.tabindex int
        |> Shared.addAttribute



-- EMBEDDED CONTENT


{-| The URL of the embeddable content. For `audio`, `embed`, `iframe`, `img`,
`input`, `script`, `source`, `track`, and `video`.
-}
src : String -> Element msg -> Element msg
src str =
    Html.Attributes.src str
        |> Shared.addAttribute


{-| Declare the height of a `canvas`, `embed`, `iframe`, `img`, `input`,
`object`, or `video`.
-}
height : Int -> Element msg -> Element msg
height int =
    Html.Attributes.height int
        |> Shared.addAttribute


{-| Declare the width of a `canvas`, `embed`, `iframe`, `img`, `input`,
`object`, or `video`.
-}
width : Int -> Element msg -> Element msg
width n =
    Html.Attributes.width n
        |> Shared.addAttribute


{-| Alternative text in case an image can't be displayed. Works with `img`,
`area`, and `input`.
-}
alt : String -> Element msg -> Element msg
alt str =
    Html.Attributes.alt str
        |> Shared.addAttribute



-- AUDIO and VIDEO


{-| The `audio` or `video` should play as soon as possible.
-}
autoplay : Bool -> Element msg -> Element msg
autoplay bool =
    Html.Attributes.autoplay bool
        |> Shared.addAttribute


{-| Indicates whether the browser should show playback controls for the `audio`
or `video`.
-}
controls : Bool -> Element msg -> Element msg
controls bool =
    Html.Attributes.controls bool
        |> Shared.addAttribute


{-| Indicates whether the `audio` or `video` should start playing from the
start when it's finished.
-}
loop : Bool -> Element msg -> Element msg
loop bool =
    Html.Attributes.loop bool
        |> Shared.addAttribute


{-| Control how much of an `audio` or `video` resource should be preloaded.
-}
preload : String -> Element msg -> Element msg
preload str =
    Html.Attributes.preload str
        |> Shared.addAttribute


{-| A URL indicating a poster frame to show until the user plays or seeks the
`video`.
-}
poster : String -> Element msg -> Element msg
poster str =
    Html.Attributes.poster str
        |> Shared.addAttribute


{-| Indicates that the `track` should be enabled unless the user's preferences
indicate something different.
-}
default : Bool -> Element msg -> Element msg
default bool =
    Html.Attributes.default bool
        |> Shared.addAttribute


{-| Specifies the kind of text `track`.
-}
kind : String -> Element msg -> Element msg
kind str =
    Html.Attributes.kind str
        |> Shared.addAttribute


{-| Specifies a user-readable title of the text `track`.
-}
label : String -> Element msg -> Element msg
label str =
    Html.Attributes.attribute "label" str
        |> Shared.addAttribute


{-| A two letter language code indicating the language of the `track` text data.
-}
srclang : String -> Element msg -> Element msg
srclang str =
    Html.Attributes.srclang str
        |> Shared.addAttribute



-- IFRAMES


{-| A space separated list of security restrictions you'd like to lift for an
`iframe`.
-}
sandbox : String -> Element msg -> Element msg
sandbox str =
    Html.Attributes.sandbox str
        |> Shared.addAttribute


{-| An HTML document that will be displayed as the body of an `iframe`. It will
override the content of the `src` attribute if it has been specified.
-}
srcdoc : String -> Element msg -> Element msg
srcdoc str =
    Html.Attributes.srcdoc str
        |> Shared.addAttribute



-- INPUT


{-| Defines the type of a `button`, `checkbox`, `input`, `embed`, `menu`,
`object`, `script`, `source`, or `style`.
-}
type_ : String -> Element msg -> Element msg
type_ str =
    Html.Attributes.type_ str
        |> Shared.addAttribute


{-| Defines a default value which will be displayed in a `button`, `option`,
`input`, `li`, `meter`, `progress`, or `param`.
-}
value : String -> Element msg -> Element msg
value str =
    Html.Attributes.value str
        |> Shared.addAttribute


{-| Indicates whether an `input` of type checkbox is checked.
-}
checked : Bool -> Element msg -> Element msg
checked bool =
    Html.Attributes.checked bool
        |> Shared.addAttribute


{-| Provides a hint to the user of what can be entered into an `input` or
`textarea`.
-}
placeholder : String -> Element msg -> Element msg
placeholder str =
    Html.Attributes.placeholder str
        |> Shared.addAttribute


{-| Defines which `option` will be selected on page load.
-}
selected : Bool -> Element msg -> Element msg
selected bool =
    Html.Attributes.selected bool
        |> Shared.addAttribute



-- INPUT HELPERS


{-| List of types the server accepts, typically a file type.
For `form` and `input`.
-}
accept : String -> Element msg -> Element msg
accept str =
    Html.Attributes.accept str
        |> Shared.addAttribute


{-| List of supported charsets in a `form`.
-}
acceptCharset : String -> Element msg -> Element msg
acceptCharset str =
    Html.Attributes.acceptCharset str
        |> Shared.addAttribute


{-| The URI of a program that processes the information submitted via a `form`.
-}
action : String -> Element msg -> Element msg
action str =
    Html.Attributes.action str
        |> Shared.addAttribute


{-| Indicates whether a `form` or an `input` can have their values automatically
completed by the browser.
-}
autocomplete : Bool -> Element msg -> Element msg
autocomplete bool =
    Html.Attributes.autocomplete bool
        |> Shared.addAttribute


{-| The element should be automatically focused after the page loaded.
For `button`, `input`, `select`, and `textarea`.
-}
autofocus : Bool -> Element msg -> Element msg
autofocus bool =
    Html.Attributes.autofocus bool
        |> Shared.addAttribute


{-| Indicates whether the user can interact with a `button`, `fieldset`,
`input`, `optgroup`, `option`, `select` or `textarea`.
-}
disabled : Bool -> Element msg -> Element msg
disabled bool =
    Html.Attributes.disabled bool
        |> Shared.addAttribute


{-| How `form` data should be encoded when submitted with the POST method.
Options include: application/x-www-form-urlencoded, multipart/form-data, and
text/plain.
-}
enctype : String -> Element msg -> Element msg
enctype str =
    Html.Attributes.enctype str
        |> Shared.addAttribute


{-| Associates an `input` with a `datalist` tag. The datalist gives some
pre-defined options to suggest to the user as they interact with an input.
The value of the list attribute must match the id of a `datalist` node.
For `input`.
-}
list : String -> Element msg -> Element msg
list str =
    Html.Attributes.list str
        |> Shared.addAttribute


{-| Defines the minimum number of characters allowed in an `input` or
`textarea`.
-}
minlength : Int -> Element msg -> Element msg
minlength n =
    Html.Attributes.minlength n
        |> Shared.addAttribute


{-| Defines the maximum number of characters allowed in an `input` or
`textarea`.
-}
maxlength : Int -> Element msg -> Element msg
maxlength n =
    Html.Attributes.maxlength n
        |> Shared.addAttribute


{-| Defines which HTTP method to use when submitting a `form`. Can be GET
(default) or POST.
-}
method : String -> Element msg -> Element msg
method n =
    Html.Attributes.method n
        |> Shared.addAttribute


{-| Indicates whether multiple values can be entered in an `input` of type
email or file. Can also indicate that you can `select` many options.
-}
multiple : Bool -> Element msg -> Element msg
multiple bool =
    Html.Attributes.multiple bool
        |> Shared.addAttribute


{-| Name of the element. For example used by the server to identify the fields
in form submits. For `button`, `form`, `fieldset`, `iframe`, `input`,
`object`, `output`, `select`, `textarea`, `map`, `meta`, and `param`.
-}
name : String -> Element msg -> Element msg
name str =
    Html.Attributes.name str
        |> Shared.addAttribute


{-| This attribute indicates that a `form` shouldn't be validated when
submitted.
-}
novalidate : Bool -> Element msg -> Element msg
novalidate bool =
    Html.Attributes.novalidate bool
        |> Shared.addAttribute


{-| Defines a regular expression which an `input`'s value will be validated
against.
-}
pattern : String -> Element msg -> Element msg
pattern str =
    Html.Attributes.pattern str
        |> Shared.addAttribute


{-| Indicates whether an `input` or `textarea` can be edited.
-}
readonly : Bool -> Element msg -> Element msg
readonly bool =
    Html.Attributes.readonly bool
        |> Shared.addAttribute


{-| Indicates whether this element is required to fill out or not.
For `input`, `select`, and `textarea`.
-}
required : Bool -> Element msg -> Element msg
required bool =
    Html.Attributes.required bool
        |> Shared.addAttribute


{-| For `input` specifies the width of an input in characters.

For `select` specifies the number of visible options in a drop-down list.

-}
size : Int -> Element msg -> Element msg
size n =
    Html.Attributes.size n
        |> Shared.addAttribute


{-| The element ID described by this `label` or the element IDs that are used
for an `output`.
-}
for : String -> Element msg -> Element msg
for str =
    Html.Attributes.for str
        |> Shared.addAttribute


{-| Indicates the element ID of the `form` that owns this particular `button`,
`fieldset`, `input`, `label`, `meter`, `object`, `output`, `progress`,
`select`, or `textarea`.
-}
form : String -> Element msg -> Element msg
form str =
    Html.Attributes.form str
        |> Shared.addAttribute



-- RANGES


{-| Indicates the maximum value allowed. When using an input of type number or
date, the max value must be a number or date. For `input`, `meter`, and `progress`.
-}
max : String -> Element msg -> Element msg
max str =
    Html.Attributes.max str
        |> Shared.addAttribute


{-| Indicates the minimum value allowed. When using an input of type number or
date, the min value must be a number or date. For `input` and `meter`.
-}
min : String -> Element msg -> Element msg
min str =
    Html.Attributes.min str
        |> Shared.addAttribute


{-| Add a step size to an `input`. Use `step "any"` to allow any floating-point
number to be used in the input.
-}
step : String -> Element msg -> Element msg
step n =
    Html.Attributes.step n
        |> Shared.addAttribute



--------------------------


{-| Defines the number of columns in a `textarea`.
-}
cols : Int -> Element msg -> Element msg
cols n =
    Html.Attributes.cols n
        |> Shared.addAttribute


{-| Defines the number of rows in a `textarea`.
-}
rows : Int -> Element msg -> Element msg
rows n =
    Html.Attributes.rows n
        |> Shared.addAttribute


{-| Indicates whether the text should be wrapped in a `textarea`. Possible
values are "hard" and "soft".
-}
wrap : String -> Element msg -> Element msg
wrap str =
    Html.Attributes.wrap str
        |> Shared.addAttribute



-- MAPS


{-| When an `img` is a descendant of an `a` tag, the `ismap` attribute
indicates that the click location should be added to the parent `a`'s href as
a query string.
-}
ismap : Bool -> Element msg -> Element msg
ismap bool =
    Html.Attributes.ismap bool
        |> Shared.addAttribute


{-| Specify the hash name reference of a `map` that should be used for an `img`
or `object`. A hash name reference is a hash symbol followed by the element's name or id.
E.g. `"#planet-map"`.
-}
usemap : String -> Element msg -> Element msg
usemap str =
    Html.Attributes.usemap str
        |> Shared.addAttribute


{-| Declare the shape of the clickable area in an `a` or `area`. Valid values
include: default, rect, circle, poly. This attribute can be paired with
`coords` to create more particular shapes.
-}
shape : String -> Element msg -> Element msg
shape str =
    Html.Attributes.shape str
        |> Shared.addAttribute


{-| A set of values specifying the coordinates of the hot-spot region in an
`area`. Needs to be paired with a `shape` attribute to be meaningful.
-}
coords : String -> Element msg -> Element msg
coords str =
    Html.Attributes.coords str
        |> Shared.addAttribute



-- REAL STUFF


{-| Specifies the horizontal alignment of a `caption`, `col`, `colgroup`,
`hr`, `iframe`, `img`, `table`, `tbody`, `td`, `tfoot`, `th`, `thead`, or
`tr`.
-}
align : String -> Element msg -> Element msg
align str =
    Html.Attributes.align str
        |> Shared.addAttribute


{-| Contains a URI which points to the source of the quote or change in a
`blockquote`, `del`, `ins`, or `q`.
-}
cite : String -> Element msg -> Element msg
cite str =
    Html.Attributes.cite str
        |> Shared.addAttribute



-- LINKS AND AREAS


{-| The URL of a linked resource, such as `a`, `area`, `base`, or `link`.
-}
href : String -> Element msg -> Element msg
href url =
    Html.Attributes.href url
        |> Shared.addAttribute


{-| Specify where the results of clicking an `a`, `area`, `base`, or `form`
should appear. Possible special values include:

  - \_blank &mdash; a new window or tab
  - \_self &mdash; the same frame (this is default)
  - \_parent &mdash; the parent frame
  - \_top &mdash; the full body of the window

You can also give the name of any `frame` you have created.

-}
target : String -> Element msg -> Element msg
target str =
    Html.Attributes.target str
        |> Shared.addAttribute


{-| Indicates that clicking an `a` and `area` will download the resource
directly. The `String` argument determins the name of the downloaded file.
Say the file you are serving is named `hats.json`.

    download "" -- hats.json

    download "my-hats.json" -- my-hats.json

    download "snakes.json" -- snakes.json

The empty `String` says to just name it whatever it was called on the server.

-}
download : String -> Element msg -> Element msg
download fileName =
    Html.Attributes.download fileName
        |> Shared.addAttribute


{-| Indicates that clicking an `a` and `area` will download the resource
directly, and that the downloaded resource with have the given filename.
So `downloadAs "hats.json"` means the person gets a file named `hats.json`.
-}
downloadAs : String -> Element msg -> Element msg
downloadAs str =
    Html.Attributes.attribute "downloadAs" str
        |> Shared.addAttribute


{-| Two-letter language code of the linked resource of an `a`, `area`, or `link`.
-}
hreflang : String -> Element msg -> Element msg
hreflang str =
    Html.Attributes.hreflang str
        |> Shared.addAttribute


{-| Specifies a hint of the target media of a `a`, `area`, `link`, `source`,
or `style`.
-}
media : String -> Element msg -> Element msg
media str =
    Html.Attributes.media str
        |> Shared.addAttribute


{-| Specify a URL to send a short POST request to when the user clicks on an
`a` or `area`. Useful for monitoring and tracking.
-}
ping : String -> Element msg -> Element msg
ping str =
    Html.Attributes.ping str
        |> Shared.addAttribute


{-| Specifies the relationship of the target object to the link object.
For `a`, `area`, `link`.
-}
rel : String -> Element msg -> Element msg
rel str =
    Html.Attributes.rel str
        |> Shared.addAttribute



-- CRAZY STUFF


{-| Indicates the date and time associated with the element.
For `del`, `ins`, `time`.
-}
datetime : String -> Element msg -> Element msg
datetime str =
    Html.Attributes.datetime str
        |> Shared.addAttribute


{-| Indicates whether this date and time is the date of the nearest `article`
ancestor element. For `time`.
-}
pubdate : String -> Element msg -> Element msg
pubdate str =
    Html.Attributes.pubdate str
        |> Shared.addAttribute



-- ORDERED LISTS


{-| Indicates whether an ordered list `ol` should be displayed in a descending
order instead of a ascending.
-}
reversed : Bool -> Element msg -> Element msg
reversed bool =
    Html.Attributes.reversed bool
        |> Shared.addAttribute


{-| Defines the first number of an ordered list if you want it to be something
besides 1.
-}
start : Int -> Element msg -> Element msg
start n =
    Html.Attributes.start n
        |> Shared.addAttribute



-- TABLES


{-| The colspan attribute defines the number of columns a cell should span.
For `td` and `th`.
-}
colspan : Int -> Element msg -> Element msg
colspan n =
    Html.Attributes.colspan n
        |> Shared.addAttribute


{-| A space separated list of element IDs indicating which `th` elements are
headers for this cell. For `td` and `th`.
-}
headers : String -> Element msg -> Element msg
headers str =
    Html.Attributes.headers str
        |> Shared.addAttribute


{-| Defines the number of rows a table cell should span over.
For `td` and `th`.
-}
rowspan : Int -> Element msg -> Element msg
rowspan n =
    Html.Attributes.rowspan n
        |> Shared.addAttribute


{-| Specifies the scope of a header cell `th`. Possible values are: col, row,
colgroup, rowgroup.
-}
scope : String -> Element msg -> Element msg
scope str =
    Html.Attributes.scope str
        |> Shared.addAttribute


{-| Specifies the URL of the cache manifest for an `html` tag.
-}
manifest : String -> Element msg -> Element msg
manifest str =
    Html.Attributes.manifest str
        |> Shared.addAttribute


{-| The number of columns a `col` or `colgroup` should span.
-}
span : Int -> Element msg -> Element msg
span n =
    Html.Attributes.attribute "span" (String.fromInt n)
        |> Shared.addAttribute
