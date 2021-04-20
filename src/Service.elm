module Service exposing (..)
import Html exposing (Html, text, button)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick, custom)
import Type exposing (Model, UncoveredValueCase, Msg(..))
import String exposing (String)
import Json.Decode as Json

-- Determine the value to put into a case according to the bomb proximity
proximityBomb : List (Int, Int) ->(Int, Int) -> Int -> Int
proximityBomb bombPosList posClick retValue =
    case bombPosList of
       [] -> retValue
       h :: t -> if (abs((Tuple.first h) - (Tuple.first posClick)) <= 1 &&
                        abs((Tuple.second h) - (Tuple.second posClick)) <= 1) then
                            proximityBomb t posClick (retValue + 1)
                 else proximityBomb t posClick retValue

--This function add cases next to clicked case into uncovered list (list who's show into model) recursively
recCase bombPosList flagsList uncovereds posClick =
   let ucase = {value = (proximityBomb bombPosList posClick 0), position = posClick} in
    --Test to ensure that position is included on the grid & the case has no been already uncovered/flagged
    if (((Tuple.first posClick) >= 0)
      && ((Tuple.first posClick) < 10)
      && ((Tuple.second posClick) >= 0)
      && ((Tuple.second posClick) < 10)
      && (not (List.member ucase uncovereds))
      && (not(List.member posClick flagsList)))  then
      if ucase.value == 0 then
        let
          down =
            (recCase bombPosList flagsList (ucase :: uncovereds) (Tuple.first posClick, (Tuple.second posClick + 1)))
          up =
            (recCase bombPosList flagsList (down) (Tuple.first posClick, (Tuple.second posClick - 1)))
          right =
            (recCase bombPosList flagsList (up) ((Tuple.first posClick + 1), Tuple.second posClick))
          left =
            (recCase bombPosList flagsList (right) ((Tuple.first posClick - 1), Tuple.second posClick))
          upleft =
            (recCase bombPosList flagsList (left) ((Tuple.first posClick - 1), (Tuple.second posClick - 1)))
          upright =
            (recCase bombPosList flagsList (upleft) ((Tuple.first posClick + 1), (Tuple.second posClick - 1)))
          downleft =
            (recCase bombPosList flagsList (upright) ((Tuple.first posClick - 1), (Tuple.second posClick + 1)))
          downright =
            (recCase bombPosList flagsList (downleft) ((Tuple.first posClick + 1), (Tuple.second posClick + 1)))
        in
         downright
      else
        ucase :: uncovereds
    else
      uncovereds

-- This function add cases into uncovered list
uncoveredList : List (Int, Int) -> List (Int, Int) -> List (UncoveredValueCase) -> (Int, Int) -> List (UncoveredValueCase)
uncoveredList bombPosList flagsList uncovereds posClick =
     let ucase = {value = (proximityBomb bombPosList posClick 0), position = posClick} in
        if ucase.value == 0 && (not(List.member posClick flagsList))  then
          recCase bombPosList flagsList uncovereds posClick
        else
            ucase :: uncovereds

-- Determine which message must be send when user clicked on case
determineCaseMsg : List (Int, Int) -> Int -> Int -> Msg
determineCaseMsg bombPosList i j =
    case bombPosList of
      [] -> EmptyCase (i,j) --should never happend
      h :: t -> if (h == (i, j)) then
          BombCase
          else
              determineCaseMsg t i j

-- Show grid of cases
renderGrid : List (Html Msg) -> Int -> Int -> Int -> Int -> Model ->List (Html Msg)
renderGrid msgList col row maxCol maxRow model =
  if col >= maxCol then
      if row == (maxRow - 1)  then
          msgList --Return a grid of cases (sawable on the Html)
      else
          renderGrid msgList 0 (row + 1) maxCol maxRow model -- On change de ligne
  else
      renderGrid (List.append msgList ((displayButtons model col row) :: [])) (col + 1) row maxCol maxRow model

-- Return the value of a case if there is one, empty string otherwise
getValue : List (UncoveredValueCase) -> Int -> Int -> String
getValue uncoveredcases col row =
    case uncoveredcases of
        [] -> " "
        h :: t -> if (col,row) == h.position then
           (String.fromInt h.value)
                else
                    getValue t col row

-- Manage the flags, return true if case is a flag, false otherwise
caseIsFlag : List (Int , Int) -> (Int , Int) -> Bool
caseIsFlag listFlags pos =
    case listFlags of
        [] -> False
        h :: t -> if pos == h then
            True
          else
            caseIsFlag t pos

-- Manage the display on the cases of the grid
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
        else if value == " " then -- Cas vide
          if caseIsFlag model.flagedList (col , row) then
            button [class "grid-item case", id ("nb"++value), onRightClick (UnFlagCase (col,row)) ] [ text "🚩" ]
          else
            button [class "grid-item case", id ("nb"++value), onClick (determineCaseMsg model.listPosMine col row), onRightClick (FlagCase (col,row)) ] []
        else
            button [class "grid-item case", id ("nb"++value)] [ text value ]

-- Create the right click
onRightClick : msg -> Html.Attribute msg
onRightClick msg =
    custom "contextmenu"
        (Json.succeed
            { message = msg
            , stopPropagation = True
            , preventDefault = True
            }
        )
