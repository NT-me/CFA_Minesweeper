module Service exposing (..)

import Html exposing (Html, text, button)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick)
import Type exposing (Model)
import Type exposing (Msg(..))
import Type exposing (UncoveredValueCase)
import String exposing (String)


proximityBomb : List (Int, Int) ->(Int, Int) -> Int -> Int
proximityBomb bombPosList posClick retValue =
    case bombPosList of
       [] -> retValue
       h :: t -> if (abs((Tuple.first h) - (Tuple.first posClick)) <= 1 &&
                        abs((Tuple.second h) - (Tuple.second posClick)) <= 1) then
                            proximityBomb t posClick (retValue + 1)
                 else proximityBomb t posClick retValue

--(abs((Tuple.first h) - (Tuple.first posClick)) <= 1) && (abs((Tuple.second h) - (Tuple.second posClick)) <= 1))


uncoveredList : List (Int, Int) -> List (UncoveredValueCase) -> (Int, Int) -> List (UncoveredValueCase)
uncoveredList bombPosList uncovereds posClick =
    let ucase = {value = (proximityBomb bombPosList posClick 0), position = posClick} in
        ucase :: uncovereds

determineCaseMsg : List (Int, Int) -> Int -> Int -> Msg
determineCaseMsg bombPosList i j =
    case bombPosList of
      [] -> EmptyCase (i,j)
      h :: t -> if (h == (i, j)) then
          BombCase
          else
              determineCaseMsg t i j
renderGrid : List (Html Msg) -> Int -> Int -> Int -> Int -> Model ->List (Html Msg)
renderGrid msgList col row maxCol maxRow model =
  if col >= maxCol then
      if row == (maxRow - 1)  then
          msgList -- Retour de la grille de bouton
      else
          renderGrid msgList 0 (row + 1) maxCol maxRow model -- On change de ligne
  else
      renderGrid (List.append msgList ((displayButtons model col row) :: [])) (col + 1) row maxCol maxRow model

getValue : List (UncoveredValueCase) -> Int -> Int -> String
getValue uncoveredcases col row =
    case uncoveredcases of
        [] -> " "
        h :: t -> if (col,row) == h.position then
           (String.fromInt h.value)
                else
                    getValue t col row

displayButtons : Model -> Int -> Int -> Html Msg
displayButtons model col row =
    if model.bombClicked then
        if List.member (col,row) model.listPosMine then
            button [class "grid-item case", id "bomb" ] [ text "💣"]
        else
            let value = getValue model.uncovereds col row in
            button [class "grid-item case", id ("nb"++value) ] [ text value ]
    else
        let value = getValue model.uncovereds col row in
        button [class "grid-item case", id ("nb"++value), onClick (determineCaseMsg model.listPosMine col row) ] [ text value ]

