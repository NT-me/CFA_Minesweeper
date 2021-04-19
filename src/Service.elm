module Service exposing (..)

import Html exposing (Html, text, button)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick)
import Type exposing (Model)
import Type exposing (Msg(..))
import Type exposing (UncoveredValueCase)
import String exposing (String)
import Html.Events exposing (custom)
import Json.Decode as Json


proximityBomb : List (Int, Int) ->(Int, Int) -> Int -> Int
proximityBomb bombPosList posClick retValue =
    case bombPosList of
       [] -> retValue
       h :: t -> if (abs((Tuple.first h) - (Tuple.first posClick)) <= 1 &&
                        abs((Tuple.second h) - (Tuple.second posClick)) <= 1) then
                            proximityBomb t posClick (retValue + 1)
                 else proximityBomb t posClick retValue


recCase bombPosList uncovereds posClick =
   let ucase = {value = (proximityBomb bombPosList posClick 0), position = posClick} in
    if (((Tuple.first posClick) >= 0) && ((Tuple.first posClick) < 10) && ((Tuple.second posClick) >= 0) && ((Tuple.second posClick) < 10) && (not (List.member ucase uncovereds)))  then
      if ucase.value == 0 then
        let
          down =
            (recCase bombPosList (ucase :: uncovereds) (Tuple.first posClick, (Tuple.second posClick + 1)))
          up =
            (recCase bombPosList (down) (Tuple.first posClick, (Tuple.second posClick - 1)))
          right =
            (recCase bombPosList (up) ((Tuple.first posClick + 1), Tuple.second posClick))
          left =
            (recCase bombPosList (right) ((Tuple.first posClick - 1), Tuple.second posClick))
          upleft =
            (recCase bombPosList (left) ((Tuple.first posClick - 1), (Tuple.second posClick - 1)))
          upright =
            (recCase bombPosList (upleft) ((Tuple.first posClick + 1), (Tuple.second posClick - 1)))
          downleft =
            (recCase bombPosList (upright) ((Tuple.first posClick - 1), (Tuple.second posClick + 1))) 
          downright =
            (recCase bombPosList (downleft) ((Tuple.first posClick + 1), (Tuple.second posClick + 1)))
        in
         downright
      else
        ucase :: uncovereds
    else
      uncovereds

uncoveredList : List (Int, Int) -> List (UncoveredValueCase) -> (Int, Int) -> List (UncoveredValueCase)
uncoveredList bombPosList uncovereds posClick =
     let ucase = {value = (proximityBomb bombPosList posClick 0), position = posClick} in
        if ucase.value == 0  then
          recCase bombPosList [] posClick 
        else
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

addFlagList flagList pos =
    case [] -> let flag = {value = True, position = pos} in
                flag :: flagList
    h :: t -> if h.position == pos then
                  t
              else
                  addFlagList t pos


displayButtons : Model -> Int -> Int -> Html Msg
displayButtons model col row =
    if model.bombClicked then
        if List.member (col,row) model.listPosMine then
            button [class "grid-item case", id "bomb" ] [ text "💣"]
        else
            let value = getValue model.uncovereds col row in
            if value == "0" then
                button [class "grid-item case", id ("nb"++value) ] []
            else
                button [class "grid-item case", id ("nb"++value) ] [ text value ]
    else
        let value = getValue model.uncovereds col row in
        if value == "0" then
            button [class "grid-item case", id ("nb"++value) ] []
        else if value == " " then
            button [class "grid-item case", id ("nb"++value), onClick (determineCaseMsg model.listPosMine col row), onRightClick (FlagCase (col,row)) ] []
        else
            button [class "grid-item case", id ("nb"++value)] [ text value ]

onRightClick : msg -> Html.Attribute msg
onRightClick msg =
    custom "contextmenu"
        (Json.succeed
            { message = msg
            , stopPropagation = True
            , preventDefault = True
            }
        )