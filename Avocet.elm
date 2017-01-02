module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import Material
import Material.Scheme
import Material.Button as Button
import Material.Options as Options exposing (css)
import Material.Card as Card
import Material.Typography as Typography
import Material.Options as Options
import Material.Color as Color
import Material.Icon as Icon


white : Options.Property c m
white =
    Color.text Color.white



-- MODEL


type alias Card =
    { title : String
    , text : String
    }


type alias Model =
    { mdl : Material.Model {- Boilerplate: model store for any and all Mdl components you use. -}
    , cards : List Card
    , count : Int
    }


model : Model
model =
    { mdl = Material.model {- Boilerplate: always use this initial Mdl model store. -}
    , cards =
        [ { title = "Title1", text = "Text1" }
        , { title = "Title2", text = "Text2" }
        , { title = "Title3", text = "Text3" }
        , { title = "Title4", text = "Text4" }
        , { title = "Title5", text = "Text5" }
        , { title = "Title6", text = "Text6" }
        , { title = "Title7", text = "Text7" }
        , { title = "Title8", text = "Text8" }
        , { title = "Title9", text = "Text9" }
        ]
    , count = 0
    }



-- ACTION, UPDATE


type Msg
    = Mdl (Material.Msg Msg) {- Boilerplate: Msg clause for internal Mdl messages. -}
    | Increase
    | Reset


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        {- Boilerplate: Mdl action handler. -}
        Mdl msg_ ->
            Material.update Mdl msg_ model

        Increase ->
            ( { model | count = model.count + 1 }
            , Cmd.none
            )

        Reset ->
            ( { model | count = 0 }
            , Cmd.none
            )



-- VIEW


type alias Mdl =
    Material.Model


viewCard : Card -> Html Msg
viewCard card =
    Card.view
        [ css "width" "192px"
        , css "height" "192px"
        , css "margin" "16px 16px 16px 16px"
        , Color.background (Color.color Color.LightBlue Color.S400)
        ]
        [ Card.title [] [ Card.head [ white ] [ text card.title ] ]
        , Card.text [ Card.expand ] [ text card.text ]
          -- Filler
        , Card.actions
            [ Card.border
              -- Modify flexbox to accomodate small text in action block
            , css "display" "flex"
            , css "justify-content" "space-between"
            , css "align-items" "center"
            , css "padding" "8px 16px 8px 16px"
            , white
            ]
            [ Options.span [ Typography.caption, Typography.contrast 0.87 ] [ text "August 3, 2016" ]
            , Button.render Mdl
                [ 1 ]
                model.mdl
                [ Button.icon, Button.ripple ]
                [ Icon.i "phone" ]
            ]
        ]


view : Model -> Html Msg
view model =
    div
        [ style [ ( "padding", "2rem" ) ] ]
        ([ text ("Current count: " ++ toString model.count)
           {- We construct the instances of the Button component that we need, one
              for the increase button, one for the reset button. First, the increase
              button. The first three arguments are:

                - A Msg constructor (`Mdl`), lifting Mdl messages to the Msg type.
                - An instance id (the `[0]`). Every component that uses the same model
                  collection (model.mdl in this file) must have a distinct instance id.
                - A reference to the elm-mdl model collection (`model.mdl`).

              Notice that we do not have to add fields for the increase and reset buttons
              separately to our model; and we did not have to add to our update messages
              to handle their internal events.

              Mdl components are configured with `Options`, similar to `Html.Attributes`.
              The `Options.onClick Increase` option instructs the button to send the `Increase`
              message when clicked. The `css ...` option adds CSS styling to the button.
              See `Material.Options` for details on options.
           -}
         , Button.render Mdl
            [ 0 ]
            model.mdl
            [ Options.onClick Increase
            , css "margin" "0 24px"
            ]
            [ text "Increase" ]
         , Button.render Mdl
            [ 1 ]
            model.mdl
            [ Options.onClick Reset ]
            [ text "Reset" ]
         , Options.div
            [ css "display" "flex"
            , css "flex-flow" "row wrap"
            , css "justify-content" "flex-start"
            , css "align-items" "flex-start"
            , css "width" "100%"
            , css "margin-top" "4rem"
            ]
            (List.map viewCard model.cards)
         ]
        )
        |> Material.Scheme.top



-- Load Google Mdl CSS. You'll likely want to do that not in code as we
-- do here, but rather in your master .html file. See the documentation
-- for the `Material` module for details.


main : Program Never Model Msg
main =
    Html.program
        { init = ( model, Cmd.none )
        , update = update
        , subscriptions = always Sub.none
        , view = view
        }
