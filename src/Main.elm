module Main exposing (..)

import Browser
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class, style)
import Service
import Mine
import Type exposing (Model, Msg(..))
import Service exposing (..)


exampleGenerateRandomMines : Cmd Msg
exampleGenerateRandomMines =
    Mine.generateRandomMines
        { width = 9
        , height = 9
        , minMines = 10
        , maxMines = 10
        , initialX = 0
        , initialY = 0
        }
        MinesGenerated


init : ( Model, Cmd Msg )
init =
    ( {listPosMine = [], uncovereds = [], bombClicked = False }, exampleGenerateRandomMines )





update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    MinesGenerated v -> ({model | listPosMine = v}, Cmd.none)

    EmptyCase pos -> ({model | uncovereds = model.uncovereds ++ (uncoveredList model.listPosMine [] pos)}, Cmd.none)

    BombCase -> ({model | bombClicked = True}, Cmd.none)

    FlagCase -> ({model |bombClicked = True}, Cmd.none)


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
