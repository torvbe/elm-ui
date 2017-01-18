import Spec exposing (describe, it, Node, context, before, after)
import Spec.Steps exposing (click, dispatchEvent)
import Spec.Assertions exposing (Outcome, assert)
import Spec.Runner

import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Html exposing (div, text)

import Json.Encode as Json

import Ui.Container
import Ui.Button
import Ui.Styles

import Task exposing (Task)

type alias Model
  = String

type Msg
  = Set

init : () -> Model
init _ =
  "Initial"

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Set ->
      ( "Clicked", Cmd.none )

view : Model -> Html.Html Msg
view model =
  div
    [ ]
    [ Ui.Styles.embed
    , Ui.Container.column []
      [ Ui.Container.row []
        [ Ui.Button.primary "Primary" Set
        , Ui.Button.secondary "Secondary" Set
        , Ui.Button.warning "Warning" Set
        , Ui.Button.success "Success" Set
        , Ui.Button.danger "Danger" Set
        ]
      , Ui.Container.row []
        [ Ui.Button.primaryBig "Primary" Set
        , Ui.Button.secondaryBig "Secondary" Set
        , Ui.Button.warningBig "Warning" Set
        , Ui.Button.successBig "Success" Set
        , Ui.Button.dangerBig "Danger" Set
        ]
      , Ui.Container.row []
        [ Ui.Button.primarySmall "Primary" Set
        , Ui.Button.secondarySmall "Secondary" Set
        , Ui.Button.warningSmall "Warning" Set
        , Ui.Button.successSmall "Success" Set
        , Ui.Button.dangerSmall "Danger" Set
        ]
      , Ui.Container.row []
        [ Ui.Button.render
          Set
          { disabled = True
          , readonly = False
          , kind = "primary"
          , size = "medium"
          , text = "Hello"
          }
        , Ui.Button.render
          Set
          { disabled = False
          , readonly = True
          , kind = "primary"
          , size = "medium"
          , text = "Hello"
          }
        ]
      ]
    , div [ class "result" ] [ text model ]
    ]

keyDown : Int -> String -> Task Never Outcome
keyDown keyCode selector =
  dispatchEvent
    "keydown"
    (Json.object [("keyCode", Json.int keyCode)])
    selector

specs : Node
specs =
  describe "Ui.Button"
    [ it "has tabindex"
      [ assert.elementPresent "ui-button[tabindex]"
      , assert.elementPresent "ui-button[readonly][tabindex]"
      ]
    , context "Disabled"
      [ it "does not have tabindex"
        [ assert.not.elementPresent "ui-button[disabled][tabindex]"
        ]
      ]
    , context "Actions"
      [ before
        [ assert.containsText { text = "Initial", selector = "div.result" }
        ]
      , after
        [ assert.containsText { text = "Clicked", selector = "div.result" }
        ]
      , it "triggers on click"
        [ click "ui-button"
        ]
      , it "triggers on enter"
        [ keyDown 13 "ui-button"
        ]
      , it "triggers on space"
        [ keyDown 32 "ui-button"
        ]
      ]
    , context "No actions"
      [ before
        [ assert.containsText { text = "Initial", selector = "div.result" }
        ]
      , after
        [ assert.not.containsText { text = "Clicked", selector = "div.result" }
        ]
      , context "Disabled"
        [ it "not triggers on click"
          [ click "ui-button[disabled]"
          ]
        , it "not triggers on enter"
          [ keyDown 13 "ui-button[disabled]"
          ]
        , it "not triggers on enter"
          [ keyDown 32 "ui-button[disabled]"
          ]
        ]
      , context "Readonly"
        [ it "should not trigger action on click"
          [ click "ui-button[readonly]"
          ]
        , it "not triggers on enter"
          [ keyDown 13 "ui-button[readonly]"
          ]
        , it "not triggers on enter"
          [ keyDown 32 "ui-button[readonly]"
          ]
        ]
      ]
    ]

main =
  Spec.Runner.runWithProgram
    { subscriptions = \_ -> Sub.none
    , update = update
    , view = view
    , init = init
    } specs
