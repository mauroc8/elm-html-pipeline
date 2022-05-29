module Html.Element exposing
    ( Element, element
    , toHtml
    , text, children, child, htmlChildren, htmlChild, map
    , style
    , h1, h2, h3, h4, h5, h6
    , div, p, hr, pre, blockquote
    , span, a, code, em, strong, i, b, u, sub, sup, br
    , ol, ul, li, dl, dt, dd
    , img, iframe, canvas, math
    , form, input, textarea, button, select, option
    , section, nav, article, aside, header, footer, address, main_
    , figure, figcaption
    , table, caption, colgroup, col, tbody, thead, tfoot, tr, td, th
    , fieldset, legend, label, datalist, optgroup, output, progress, meter
    , audio, video, source, track
    , embed, object, param
    , ins, del
    , small, cite, dfn, abbr, time, var, samp, kbd, s, q
    , mark, ruby, rt, rp, bdi, bdo, wbr
    , details, summary, menuitem, menu
    )

{-| Some [Html](https://package.elm-lang.org/packages/elm/html/latest/Html#Html) nodes
are [text nodes](https://developer.mozilla.org/en-US/docs/Web/API/Text) and others are
[element nodes](https://developer.mozilla.org/en-US/docs/Web/API/Element).

The type [Element](Element) represents only **element nodes**.
Unlike `Html`, all `Element` values have a list of attributes and a list of children.

This module has functions to create and modify `Element` nodes.

**Note:** The code examples will assume the following imports:

    import Html.Element as Element exposing (Element)
    import Html.Element.Attribute as Attribute
    import Html.Element.Event as Event


# Element

@docs Element, element


## Convert to HTML

@docs toHtml


## Add attributes and children

@docs text, children, child, htmlChildren, htmlChild, map


# Tags


## Stylesheets

@docs style


## Headers

@docs h1, h2, h3, h4, h5, h6


## Grouping Content

@docs div, p, hr, pre, blockquote


## Text

@docs span, a, code, em, strong, i, b, u, sub, sup, br


## Lists

@docs ol, ul, li, dl, dt, dd


## Embedded Content

@docs img, iframe, canvas, math


## Inputs

@docs form, input, textarea, button, select, option


## Sections

@docs section, nav, article, aside, header, footer, address, main_


## Figures

@docs figure, figcaption


## Tables

@docs table, caption, colgroup, col, tbody, thead, tfoot, tr, td, th


## Less Common Elements


### Less Common Inputs

@docs fieldset, legend, label, datalist, optgroup, output, progress, meter


### Audio and Video

@docs audio, video, source, track


### Embedded Objects

@docs embed, object, param


### Text Edits

@docs ins, del


### Semantic Text

@docs small, cite, dfn, abbr, time, var, samp, kbd, s, q


### Less Common Text Tags

@docs mark, ruby, rt, rp, bdi, bdo, wbr


## Interactive Elements

@docs details, summary, menuitem, menu

-}

import Html
import Html.Attributes
import Html.Shared as Shared



-- ELEMENT


{-| An [HTML element node](https://developer.mozilla.org/en-US/docs/Web/HTML/Element).

It has a tag name, a list of attributes and a list of children.

`Element` nodes can be converted to [Html](https://package.elm-lang.org/packages/elm/html/latest/Html#Html)
nodes using [toHtml](#toHtml).

-}
type alias Element msg =
    Shared.Element msg


type alias Modifier msg =
    Shared.Modifier msg


{-| Creates an empty `Element` from an HTML tag name.


    button : Element msg
    button =
        element "button"

    -- <button></button>

-}
element : String -> Element msg
element tagName =
    Shared.element tagName



-- BASIC MODIFIERS


{-| Appends a text node to an element.

    Element.div
        |> Element.text "Hello"
        |> Element.text " world"

    -- <div>Hello world</div>

-}
text : String -> Element msg -> Element msg
text content =
    Shared.addTextNode content


{-| Appends a list of elements to an element.

    Element.div
        |> Element.children
            [ Element.input
            , Element.button
                |> Element.text "Ok"
            ]

    -- <div><input /><button>Ok</button></div>

You can keep calling this function to add more children.

-}
children : List (Element msg) -> Element msg -> Element msg
children =
    Shared.addChildren


{-| Like [children](#children) but appends only one child element.

The example above can be written like:

    Element.div
        |> Element.child Element.input
        |> Element.child
            (Element.button |> Element.text "Ok")

-}
child : Element msg -> Element msg -> Element msg
child el =
    children [ el ]


{-| Appends `Html` children to an element.
-}
htmlChildren : List (Html.Html msg) -> Element msg -> Element msg
htmlChildren =
    Shared.addHtmlChildren


{-| Appends an `Html` child to an element.
-}
htmlChild : Html.Html msg -> Element msg -> Element msg
htmlChild child_ =
    htmlChildren [ child_ ]


{-| Transform the messages produced by some `Element`. In the following example,
we have `viewButton` that produces `()` messages, and we transform those values
into `Msg` values in `view`.

    type Msg
        = Left
        | Right

    view : model -> Element Msg
    view model =
        Element.div
            |> Element.children
                [ Element.map (\_ -> Left) (viewButton "Left")
                , Element.map (\_ -> Right) (viewButton "Right")
                ]

    viewButton : String -> Element ()
    viewButton name =
        Element.button
            |> Event.onClick ()
            |> Element.text name

-}
map : (a -> msg) -> Element a -> Element msg
map =
    Shared.map



-- TO HTML


{-| Converts an [Element](#Element) into an `Html`.
-}
toHtml : Element msg -> Html.Html msg
toHtml =
    Shared.toHtml



-- SECTIONS


{-| Creates a CSS style node.
-}
style : Element msg
style =
    element "style"


{-| Defines a section in a document.
-}
section : Element msg
section =
    element "section"


{-| Defines a section that contains only navigation links.
-}
nav : Element msg
nav =
    element "nav"


{-| Defines self-contained content that could exist independently of the rest
of the content.
-}
article : Element msg
article =
    element "article"


{-| Defines some content loosely related to the page content. If it is removed,
the remaining content still makes sense.
-}
aside : Element msg
aside =
    element "aside"


{-| -}
h1 : Element msg
h1 =
    element "h1"


{-| -}
h2 : Element msg
h2 =
    element "h2"


{-| -}
h3 : Element msg
h3 =
    element "h3"


{-| -}
h4 : Element msg
h4 =
    element "h4"


{-| -}
h5 : Element msg
h5 =
    element "h5"


{-| -}
h6 : Element msg
h6 =
    element "h6"


{-| Defines the header of a page or section. It often contains a logo, the
title of the web site, and a navigational table of content.
-}
header : Element msg
header =
    element "header"


{-| Defines the footer for a page or section. It often contains a copyright
notice, some links to legal information, or addresses to give feedback.
-}
footer : Element msg
footer =
    element "footer"


{-| Defines a section containing contact information.
-}
address : Element msg
address =
    element "address"


{-| Defines the main or important content in the document. There is only one
`main` element in the document.
-}
main_ : Element msg
main_ =
    element "main"



-- GROUPING CONTENT


{-| Defines a portion that should be displayed as a paragraph.
-}
p : Element msg
p =
    element "p"


{-| Represents a thematic break between paragraphs of a section or article or
any longer content.
-}
hr : Element msg
hr =
    element "hr"


{-| Indicates that its content is preformatted and that this format must be
preserved.
-}
pre : Element msg
pre =
    element "pre"


{-| Represents a content that is quoted from another source.
-}
blockquote : Element msg
blockquote =
    element "blockquote"


{-| Defines an ordered list of items.
-}
ol : Element msg
ol =
    element "ol"


{-| Defines an unordered list of items.
-}
ul : Element msg
ul =
    element "ul"


{-| Defines a item of an enumeration list.
-}
li : Element msg
li =
    element "li"


{-| Defines a definition list, that is, a list of terms and their associated
definitions.
-}
dl : Element msg
dl =
    element "dl"


{-| Represents a term defined by the next `dd`.
-}
dt : Element msg
dt =
    element "dt"


{-| Represents the definition of the terms immediately listed before it.
-}
dd : Element msg
dd =
    element "dd"


{-| Represents a figure illustrated as part of the document.
-}
figure : Element msg
figure =
    element "figure"


{-| Represents the legend of a figure.
-}
figcaption : Element msg
figcaption =
    element "figcaption"


{-| Represents a generic container with no special meaning.
-}
div : Element msg
div =
    element "div"



-- TEXT LEVEL SEMANTIC


{-| Represents a hyperlink, linking to another resource.
-}
a : Element msg
a =
    element "a"


{-| Represents emphasized text, like a stress accent.
-}
em : Element msg
em =
    element "em"


{-| Represents especially important text.
-}
strong : Element msg
strong =
    element "strong"


{-| Represents a side comment, that is, text like a disclaimer or a
copyright, which is not essential to the comprehension of the document.
-}
small : Element msg
small =
    element "small"


{-| Represents content that is no longer accurate or relevant.
-}
s : Element msg
s =
    element "s"


{-| Represents the title of a work.
-}
cite : Element msg
cite =
    element "cite"


{-| Represents an inline quotation.
-}
q : Element msg
q =
    element "q"


{-| Represents a term whose definition is contained in its nearest ancestor
content.
-}
dfn : Element msg
dfn =
    element "dfn"


{-| Represents an abbreviation or an acronym; the expansion of the
abbreviation can be represented in the title attribute.
-}
abbr : Element msg
abbr =
    element "abbr"


{-| Represents a date and time value; the machine-readable equivalent can be
represented in the datetime attribute.
-}
time : Element msg
time =
    element "time"


{-| Represents computer code.
-}
code : Element msg
code =
    element "code"


{-| Represents a variable. Specific cases where it should be used include an
actual mathematical expression or programming context, an identifier
representing a constant, a symbol identifying a physical quantity, a function
parameter, or a mere placeholder in prose.
-}
var : Element msg
var =
    element "var"


{-| Represents the output of a program or a computer.
-}
samp : Element msg
samp =
    element "samp"


{-| Represents user input, often from the keyboard, but not necessarily; it
may represent other input, like transcribed voice commands.
-}
kbd : Element msg
kbd =
    element "kbd"


{-| Represent a subscript.
-}
sub : Element msg
sub =
    element "sub"


{-| Represent a superscript.
-}
sup : Element msg
sup =
    element "sup"


{-| Represents some text in an alternate voice or mood, or at least of
different quality, such as a taxonomic designation, a technical term, an
idiomatic phrase, a thought, or a ship name.
-}
i : Element msg
i =
    element "i"


{-| Represents a text which to which attention is drawn for utilitarian
purposes. It doesn't convey extra importance and doesn't imply an alternate
voice.
-}
b : Element msg
b =
    element "b"


{-| Represents a non-textual annotation for which the conventional
presentation is underlining, such labeling the text as being misspelt or
labeling a proper name in Chinese text.
-}
u : Element msg
u =
    element "u"


{-| Represents text highlighted for reference purposes, that is for its
relevance in another context.
-}
mark : Element msg
mark =
    element "mark"


{-| Represents content to be marked with ruby annotations, short runs of text
presented alongside the text. This is often used in conjunction with East Asian
language where the annotations act as a guide for pronunciation, like the
Japanese furigana.
-}
ruby : Element msg
ruby =
    element "ruby"


{-| Represents the text of a ruby annotation.
-}
rt : Element msg
rt =
    element "rt"


{-| Represents parenthesis around a ruby annotation, used to display the
annotation in an alternate way by browsers not supporting the standard display
for annotations.
-}
rp : Element msg
rp =
    element "rp"


{-| Represents text that must be isolated from its surrounding for
bidirectional text formatting. It allows embedding a span of text with a
different, or unknown, directionality.
-}
bdi : Element msg
bdi =
    element "bdi"


{-| Represents the directionality of its children, in order to explicitly
override the Unicode bidirectional algorithm.
-}
bdo : Element msg
bdo =
    element "bdo"


{-| Represents text with no specific meaning. This has to be used when no other
text-semantic element conveys an adequate meaning, which, in this case, is
often brought by global attributes like `class`, `lang`, or `dir`.
-}
span : Element msg
span =
    element "span"


{-| Represents a line break.
-}
br : Element msg
br =
    element "br"


{-| Represents a line break opportunity, that is a suggested point for
wrapping text in order to improve readability of text split on several lines.
-}
wbr : Element msg
wbr =
    element "wbr"



-- EDITS


{-| Defines an addition to the document.
-}
ins : Element msg
ins =
    element "ins"


{-| Defines a removal from the document.
-}
del : Element msg
del =
    element "del"



-- EMBEDDED CONTENT


{-| Represents an image.
-}
img : Element msg
img =
    element "img"


{-| Embedded an HTML document.
-}
iframe : Element msg
iframe =
    element "iframe"


{-| Represents a integration point for an external, often non-HTML,
application or interactive content.
-}
embed : Element msg
embed =
    element "embed"


{-| Represents an external resource, which is treated as an image, an HTML
sub-document, or an external resource to be processed by a plug-in.
-}
object : Element msg
object =
    element "object"


{-| Defines parameters for use by plug-ins invoked by `object` elements.
-}
param : Element msg
param =
    element "param"


{-| Represents a video, the associated audio and captions, and controls.
-}
video : Element msg
video =
    element "video"


{-| Represents a sound or audio stream.
-}
audio : Element msg
audio =
    element "audio"


{-| Allows authors to specify alternative media resources for media elements
like `video` or `audio`.
-}
source : Element msg
source =
    element "source"


{-| Allows authors to specify timed text track for media elements like `video`
or `audio`.
-}
track : Element msg
track =
    element "track"


{-| Represents a bitmap area for graphics rendering.
-}
canvas : Element msg
canvas =
    element "canvas"


{-| Defines a mathematical formula.
-}
math : Element msg
math =
    element "math"



-- TABULAR DATA


{-| Represents data with more than one dimension.
-}
table : Element msg
table =
    element "table"


{-| Represents the title of a table.
-}
caption : Element msg
caption =
    element "caption"


{-| Represents a set of one or more columns of a table.
-}
colgroup : Element msg
colgroup =
    element "colgroup"


{-| Represents a column of a table.
-}
col : Element msg
col =
    element "col"


{-| Represents the block of rows that describes the concrete data of a table.
-}
tbody : Element msg
tbody =
    element "tbody"


{-| Represents the block of rows that describes the column labels of a table.
-}
thead : Element msg
thead =
    element "thead"


{-| Represents the block of rows that describes the column summaries of a table.
-}
tfoot : Element msg
tfoot =
    element "tfoot"


{-| Represents a row of cells in a table.
-}
tr : Element msg
tr =
    element "tr"


{-| Represents a data cell in a table.
-}
td : Element msg
td =
    element "td"


{-| Represents a header cell in a table.
-}
th : Element msg
th =
    element "th"



-- FORMS


{-| Represents a form, consisting of controls, that can be submitted to a
server for processing.
-}
form : Element msg
form =
    element "form"


{-| Represents a set of controls.
-}
fieldset : Element msg
fieldset =
    element "fieldset"


{-| Represents the caption for a `fieldset`.
-}
legend : Element msg
legend =
    element "legend"


{-| Represents the caption of a form control.
-}
label : Element msg
label =
    element "label"


{-| Represents a typed data field allowing the user to edit the data.
-}
input : Element msg
input =
    element "input"


{-| Represents a button.
-}
button : Element msg
button =
    element "button"


{-| Represents a control allowing selection among a set of options.
-}
select : Element msg
select =
    element "select"


{-| Represents a set of predefined options for other controls.
-}
datalist : Element msg
datalist =
    element "datalist"


{-| Represents a set of options, logically grouped.
-}
optgroup : Element msg
optgroup =
    element "optgroup"


{-| Represents an option in a `select` element or a suggestion of a `datalist`
element.
-}
option : Element msg
option =
    element "option"


{-| Represents a multiline text edit control.
-}
textarea : Element msg
textarea =
    element "textarea"


{-| Represents the result of a calculation.
-}
output : Element msg
output =
    element "output"


{-| Represents the completion progress of a task.
-}
progress : Element msg
progress =
    element "progress"


{-| Represents a scalar measurement (or a fractional value), within a known
range.
-}
meter : Element msg
meter =
    element "meter"



-- INTERACTIVE ELEMENTS


{-| Represents a widget from which the user can obtain additional information
or controls.
-}
details : Element msg
details =
    element "details"


{-| Represents a summary, caption, or legend for a given `details`.
-}
summary : Element msg
summary =
    element "summary"


{-| Represents a command that the user can invoke.
-}
menuitem : Element msg
menuitem =
    element "menuitem"


{-| Represents a list of commands.
-}
menu : Element msg
menu =
    element "menu"
