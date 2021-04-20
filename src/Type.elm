module Type exposing (..)

type Msg
    = MinesGenerated (List ( Int, Int ))
    | EmptyCase (Int, Int)
    | BombCase
    | FlagCase (Int, Int)
    | UnFlagCase (Int, Int)
    | Reset

type alias Model =
    {listPosMine : List ( Int, Int ),
    uncovereds : List UncoveredValueCase,
    bombClicked : Bool,
    flagedList: List ( Int, Int ),
    numberCaseClicked: Int}

type alias UncoveredValueCase =
    {
    value : Int
    , position : (Int, Int)
    }
