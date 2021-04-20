module Type exposing (..)
import Time

type Msg
    = MinesGenerated (List ( Int, Int ))
    | EmptyCase (Int, Int)
    | BombCase
    | FlagCase (Int, Int)
    | UnFlagCase (Int, Int)
    | Reset
    | Tick Time.Posix

type alias Model =
    {listPosMine : List ( Int, Int ),
    uncovereds : List UncoveredValueCase,
    bombClicked : Bool,
    flagedList: List ( Int, Int ),
    numberCaseClicked: Int,
    time : Int}

type alias UncoveredValueCase =
    {
    value : Int
    , position : (Int, Int)
    }
