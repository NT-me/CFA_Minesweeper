module Main exposing (..)

import Browser
import Html exposing (Html, div, h1, img, text, button)
import Html.Attributes exposing (src, class, style)
import Html.Events exposing (onClick)
import Mine


type alias Model =
    {listPosMine : List ( Int, Int )}


exampleGenerateRandomMines : Cmd Msg
exampleGenerateRandomMines =
    Mine.generateRandomMines
        { width = 5
        , height = 5
        , minMines = 1
        , maxMines = 2
        , initialX = 0
        , initialY = 0
        }
        MinesGenerated


init : ( Model, Cmd Msg )
init =
    ( {listPosMine = []}, exampleGenerateRandomMines )


type Msg
    = MinesGenerated (List ( Int, Int ))
    | EmptyCase
    | BombCase


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    MinesGenerated v -> ({model | listPosMine = v}, Cmd.none)

    EmptyCase -> (model, Cmd.none)

    BombCase -> (model, Cmd.none)



determineCaseMsg : List (Int, Int) -> Int -> Int -> Msg
determineCaseMsg bombPosList i j =
    case bombPosList of
      [] -> EmptyCase
      h :: t -> if (h == (i, j)) then
          BombCase
          else
              determineCaseMsg t i j


-- Valeur de retour, 0, 0, maximum colonne, maximum ligne
renderGrid : List (Html Msg) -> Int -> Int -> Int -> Int -> Model ->List (Html Msg)
renderGrid msgList col row maxCol maxRow model =
  if col >= maxCol then
      if row == (maxRow - 1)  then
          msgList -- Retour de la grille de bouton
      else
          renderGrid msgList 0 (row + 1) maxCol maxRow model -- On change de ligne
  else
      renderGrid (List.append msgList (button [class "grid-item case", onClick (determineCaseMsg model.listPosMine col row) ] [ text "+" ] :: [])) (col + 1) row maxCol maxRow model

view : Model -> Html Msg
view model =
    div []
        [
        div [] [h1 [] [text "Démineur"]],
        div [class "wrapper", style "grid-template-columns" "repeat(5, 1fr)"]
          (renderGrid [] 0 0 5 5 model)
        ]


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = always init
        , update = update
        , subscriptions = always Sub.none
        }
