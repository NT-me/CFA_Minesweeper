module Main exposing (..)

import Browser
import Time
import Html exposing (Html, div, h1, text, button)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Service
import Mine
import Type exposing (Model, Msg(..))
import Service exposing (..)

--Settings of the game
exampleGenerateRandomMines : Cmd Msg
exampleGenerateRandomMines =
    Mine.generateRandomMines
        { width = 9
        , height = 9
        , minMines = 10
        , maxMines = 35
        , initialX = 0
        , initialY = 0
        }
        MinesGenerated

--Initialization, all lists are empty, no bomb is clicked, no case is uncovered,
--timer setted to 0 and game parameters are given trought exampleGenerateRandomMines
init : ( Model, Cmd Msg )
init =
    ( {listPosMine = [], uncovereds = [], bombClicked = False, flagedList = [], numberCaseClicked = 0, time = 0 }, exampleGenerateRandomMines )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    -- Fill mines list with random position
    MinesGenerated v -> ({model | listPosMine = v}, Cmd.none)

    -- For every cases who's not a bomb add case position into list
    EmptyCase pos -> ({model | uncovereds = (uncoveredList model.listPosMine model.flagedList model.uncovereds pos), numberCaseClicked = (model.numberCaseClicked + 1)}, Cmd.none)

    -- If user clicked on bomb switch BombCase boolean on True
    BombCase -> ({model | bombClicked = True}, Cmd.none)

    -- Add flag position into list
    FlagCase pos -> ({model | flagedList = pos :: model.flagedList}, Cmd.none)

    -- Remove flag position from list
    UnFlagCase pos -> ({model | flagedList = List.filter (\x -> x /= pos) model.flagedList}, Cmd.none)

    -- Reset grid/timer/counter
    Reset -> init

    -- Increment value every second
    Tick posix -> ({model | time = (if (model.bombClicked || ((List.length model.listPosMine) + (List.length model.uncovereds)) == 100) then model.time else (model.time + 1))}, Cmd.none)
--🚩--

--The actual web page displayed by the program
view : Model -> Html Msg
view model =
    div []
        [
        div [] [h1 [] [text "Démineur"]],

        div [class "headers"] [
          div [] [h1 [] [text ("Cases cliquées: " ++ (String.fromInt model.numberCaseClicked))]],
          if model.bombClicked then
            --Losing condition, a bombcase is uncovered
            div [] [button [class "reset-button", onClick Reset] [ text "(ಠ_ಠ)" ]]
          else
            div [] [button [class "reset-button", onClick Reset] [ text "(｡◕‿◕｡)" ]],
          div [] [h1 [] [text ("Secondes écoulées: " ++ (String.fromInt model.time))]]
        ],
        --Winning condition -> all unbombed case are uncovered
        if ((List.length model.listPosMine) + (List.length model.uncovereds)) == 100 then
          div [class "victory"] [ text "Bravo vous avez gagné !" ]
        else
          div [class "wrapper"]
            (Service.renderGrid [] 0 0 10 10 model)
        ]


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = always init
        , update = update
        , subscriptions = subscriptions
        }

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every 1000 Tick
