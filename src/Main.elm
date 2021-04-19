module Main exposing (..)

import Browser
import Html exposing (Html, div, h1, text, button)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Service
import Mine
import Type exposing (Model, Msg(..))
import Service exposing (..)


exampleGenerateRandomMines : Cmd Msg
exampleGenerateRandomMines =
    Mine.generateRandomMines
        { width = 9
        , height = 9
        , minMines = 5
        , maxMines = 5
        , initialX = 0
        , initialY = 0
        }
        MinesGenerated


init : ( Model, Cmd Msg )
init =
    ( {listPosMine = [], uncovereds = [], bombClicked = False, flagedList = [] }, exampleGenerateRandomMines )





update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    MinesGenerated v -> ({model | listPosMine = v}, Cmd.none)

    EmptyCase pos -> ({model | uncovereds = (uncoveredList model.listPosMine model.flagedList model.uncovereds pos)}, Cmd.none)

    BombCase -> ({model | bombClicked = True}, Cmd.none)

    FlagCase pos -> ({model | flagedList = pos :: model.flagedList}, Cmd.none)

    UnFlagCase pos -> ({model | flagedList = List.filter (\x -> x /= pos) model.flagedList}, Cmd.none)

    Reset -> init
--🚩--
--OnAnimationFrame



--tabGrid : List (Int Int) -> List (Int Int)-> Int -> Int -> Int -> Int -> List (Int Int)
--tabGrid posMine retList col row maxCol maxRow =
  --  case posMine of
    --    [] -> retList
      --  h :: t ->

-- Valeur de retour, 0, 0, maximum colonne, maximum ligne


view : Model -> Html Msg
view model =
    div []
        [
        div [] [h1 [] [text "Démineur"]],
        if model.bombClicked then
            div [] [button [class "reset-button", onClick Reset] [ text "(ಠ_ಠ)" ]]
        else
          div [] [button [class "reset-button", onClick Reset] [ text "(｡◕‿◕｡)" ]],
        if ((List.length model.listPosMine) + (List.length model.uncovereds)) == 100 then
          div [class "victory"] [ text "Bravo vous avez gagné !" ]
        else
          div [class "wrapper", style "grid-template-columns" "repeat(10, 1fr)"]
            (Service.renderGrid [] 0 0 10 10 model)
        ]


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = always init
        , update = update
        , subscriptions = always Sub.none
        }
