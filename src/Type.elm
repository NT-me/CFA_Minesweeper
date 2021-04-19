module Type exposing (..)

type Msg
    = MinesGenerated (List ( Int, Int ))
    | EmptyCase (Int, Int)
    | BombCase
    | FlagCase

type alias Model =
    {listPosMine : List ( Int, Int ),
    uncovereds : List UncoveredValueCase,
    bombClicked : Bool}

type alias UncoveredValueCase =
    {
    value : Int
    , position : (Int, Int)
    }
