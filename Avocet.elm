module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import Material
import Material.Scheme
import Material.Button as Button
import Material.Options as Options exposing (css)
import Material.Card as Card
import Material.Typography as Typography
import Material.Textfield as Textfield
import Material.Options as Options
import Material.Color as Color
import Material.Icon as Icon
import Http
import Json.Decode exposing (string, int, list, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional)


-- MODEL


cardDecoder : Decoder Card
cardDecoder =
    decode Card
        |> required "title" string
        |> required "text" string
        |> optional "footer" string ""
        |> optional "icon" string ""
        |> optional "color" string "Grey"


type alias Card =
    { title : String
    , text : String
    , footer : String
    , icon : String
    , color : String
    }


type alias Model =
    { mdl : Material.Model {- Boilerplate: model store for any and all Mdl components you use. -}
    , cards : List Card
    , address : Maybe String
    , error : Maybe String
    , temp : String
    }


initialModel : Model
initialModel =
    { mdl = Material.model {- Boilerplate: always use this initial Mdl model store. -}
    , cards =
        [ { title = "Title1", text = "Text1", footer = "Footer", icon = "phone", color = "red" }
        , { title = "Title2", text = "Text2", footer = "Footer", icon = "phone", color = "red" }
        ]
    , address = Nothing
    , error = Nothing
    , temp = "Temp"
    }


colorHue : String -> Color.Hue
colorHue name =
    case name of
        "Indigo" ->
            Color.Indigo

        "Blue" ->
            Color.Blue

        "LightBlue" ->
            Color.LightBlue

        "Cyan" ->
            Color.Cyan

        "Teal" ->
            Color.Teal

        "Green" ->
            Color.Green

        "LightGreen" ->
            Color.LightGreen

        "Lime" ->
            Color.Lime

        "Yellow" ->
            Color.Yellow

        "Amber" ->
            Color.Amber

        "Orange" ->
            Color.Orange

        "Brown" ->
            Color.Brown

        "BlueGrey" ->
            Color.BlueGrey

        "Grey" ->
            Color.Grey

        "DeepOrange" ->
            Color.DeepOrange

        "Red" ->
            Color.Red

        "Pink" ->
            Color.Pink

        "Purple" ->
            Color.Purple

        "DeepPurple" ->
            Color.DeepPurple

        _ ->
            Color.Grey



-- ACTION, UPDATE


initialCmd : String -> Cmd Msg
initialCmd address =
    list cardDecoder
        |> Http.get address
        |> Http.send (\result -> LoadData result)


type Msg
    = Mdl (Material.Msg Msg) {- Boilerplate: Msg clause for internal Mdl messages. -}
    | ChangeAddress String
    | FetchData
    | LoadData (Result Http.Error (List Card))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        {- Boilerplate: Mdl action handler. -}
        Mdl msg_ ->
            Material.update Mdl msg_ model

        ChangeAddress str ->
            ( { model | address = Just str }
            , Cmd.none
            )

        FetchData ->
            ( model
            , (case model.address of
                Nothing ->
                    Cmd.none

                Just address ->
                    initialCmd address
              )
            )

        LoadData result ->
            case result of
                Ok responseCards ->
                    ( { model | cards = responseCards }, Cmd.none )

                Err httpError ->
                    ( { model | temp = "ERROR", cards = [] }, Cmd.none )



-- VIEW


type alias Mdl =
    Material.Model


viewCard : Model -> Card -> Html Msg
viewCard model card =
    Card.view
        [ css "width" "200px"
        , css "margin" "16px 16px 16px 16px"
        , Color.background (Color.color (colorHue card.color) Color.S400)
        ]
        [ Card.title [] [ Card.head [ Color.text Color.white ] [ text card.title ] ]
        , Card.text [ Card.expand ] [ text card.text ]
          -- Filler
        , Card.actions
            [ Card.border
            , Color.text Color.white
              -- Modify flexbox to accomodate small text in action block
            , css "display" "flex"
            , css "justify-content" "space-between"
            , css "align-items" "center"
            , css "padding" "8px 16px 8px 16px"
            ]
            [ Options.span
                [ Typography.body1, Typography.contrast 0.87 ]
                [ text card.footer ]
            , Icon.i card.icon
            ]
        ]


view : Model -> Html Msg
view model =
    div
        [ style [ ( "padding", "2rem" ) ] ]
        [ Options.styled p
            [ Typography.subhead, Color.text (Color.color Color.Red Color.S500) ]
            [ text ("Error: " ++ model.temp) ]
        , Options.styled p
            [ Typography.subhead, Color.text Color.primary ]
            [ text "Enter the address to a JSON resource, for example, http://example.com/data.json." ]
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
        , Textfield.render Mdl
            [ 0 ]
            model.mdl
            [ Textfield.label "Address"
            , Textfield.floatingLabel
            , Textfield.text_
            , Textfield.value
                (case model.address of
                    Nothing ->
                        ""

                    Just address ->
                        address
                )
            , Options.onInput ChangeAddress
            ]
            []
        , Button.render Mdl
            [ 1 ]
            model.mdl
            [ Options.onClick FetchData
            , css "margin" "0 24px"
            ]
            [ text "Display Data" ]
        , Options.div
            [ css "display" "flex"
            , css "flex-flow" "row wrap"
            , css "justify-content" "flex-start"
            , css "align-items" "center"
            , css "width" "100%"
            , css "margin-top" "4rem"
            ]
            (List.map (viewCard model) model.cards)
        ]
        |> Material.Scheme.top



-- Load Google Mdl CSS. You'll likely want to do that not in code as we
-- do here, but rather in your master .html file. See the documentation
-- for the `Material` module for details.


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, initialCmd "http://localhost:8000/data.json" )
        , update = update
        , subscriptions = always Sub.none
        , view = view
        }
