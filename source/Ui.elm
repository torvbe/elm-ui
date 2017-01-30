module Ui exposing
  ( stylesheetLink, tabIndex, enabledActions, attributeList )

{-| UI Library for Elm!

@docs stylesheetLink, tabIndex, enabledActions, attributeList
-}

import Html.Attributes exposing (attribute, rel, href, class, tabindex, target)
import Html.Events.Extra exposing (onLoad)
import Html.Events exposing (onClick)
import Html exposing (node, text)

{-| Renders a link tag for a CSS Stylesheet which triggers the given message
after it's loaded.

    Ui.stylesheetLink "http://some-css-file.css" Loaded
-}
stylesheetLink : String -> msg -> Html.Html msg
stylesheetLink path msg =
  node
    "link"
    [ rel "stylesheet"
    , href path
    , onLoad msg
    ]
    []


{-| Returns tabindex attribute for a generic model or an empty list if
disabled.

    Ui.tabIndex { disabled: False } -- [ tabindex 0 ]
    Ui.tabIndex { disabled: True } -- []
-}
tabIndex : { a | disabled : Bool } -> List (Html.Attribute msg)
tabIndex model =
  -- # TODO: Use Html.Attributes.tabindex when the issue is fixed
  if model.disabled then
    []
  else
    [ attribute "tabindex" "0" ]


{-| Retruns the given attributes unless the model is disabled or readonly, in
that case it returs an empty list. This is usefull when you only want to add
for example some event listeners when the component is not disabled or readonly.

    -- [ onClick Open ]
    Ui.enabledActions
      { disabeld: False, readonly: False }
      [ onClick Open ]

    -- []
    Ui.enabledActions
      { disabeld: False, readonly: True }
      [ onClick Open ]

    -- []
    Ui.enabledActions
      { disabeld: True, readonly: False }
      [ onClick Open ]
-}
enabledActions : { a | disabled : Bool, readonly : Bool } -> List b -> List b
enabledActions model attributes =
  if model.disabled || model.readonly then
    []
  else
    attributes


{-| Renders a floating action button.

    Ui.fab "[ onClick Open ]
-}
fab : String -> List (Html.Attribute msg) -> Html.Html msg
fab glyph attributes =
  node
    "ui-fab"
    attributes
    [ ]


{-| Renders breadcrumbs.

    Ui.breadcrumbs
      (text "|")
      [ ("Home", Just Home)
      , ("Posts", Just Posts)
      , ("Post", Just (Post 1))
      ]
-}
breadcrumbs : Html.Html msg -> List ( String, Maybe msg ) -> Html.Html msg
breadcrumbs separator items =
  let
    renderItem ( label, action_ ) =
      let
        attributes =
          case action_ of
            Just action ->
              [ onClick action
              , class "clickable"
              ]

            Nothing ->
              []
      in
        node
          "ui-breadcrumb"
          attributes
          [ node "span" [] [ text label ] ]
  in
    node
      "ui-breadcrumbs"
      []
      (List.map renderItem items
        |> List.intersperse separator
      )


{-|-}
attributeList : List ( String, Bool ) -> List (Html.Attribute msg)
attributeList items =
  let
    attr ( name, active ) =
      if active then
        [ attribute name "" ]
      else
        []
  in
    List.map attr items
      |> List.foldr (++) []
