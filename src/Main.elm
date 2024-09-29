module Main exposing (main, subscriptions)

import Browser
import Html exposing (..)
import Html.Attributes exposing (align, checked, disabled, style, type_)
import Html.Events exposing (..)
import Models exposing (..)



-- main


type Msg
    = CheckBox Int Bool
    | NoOp


mytabs : Tabs
mytabs =
    { csharp = csharp
    , oracle = oracle
    , change = change
    , uid = 0
    }


main : Program () Tabs Msg
main =
    Browser.element
        { init = init_ids
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



--  init
--init : () -> ( Tabs, Cmd Msg )
--init _ =
--    ( mytabs
--  , Cmd.none
--  )


init_enum : Int -> List ChecklistItem -> List ChecklistItem
init_enum start list =
    case ( List.head list, List.tail list ) of
        ( Just hd, Just tlist ) ->
            { hd | id = start } :: init_enum (start + 1) tlist

        ( Just hd, _ ) ->
            [ { hd | id = start } ]

        ( _, _ ) ->
            list


init_ids : () -> ( Tabs, Cmd Msg )
init_ids _ =
    let
        cs =
            List.length mytabs.csharp.items

        orc =
            List.length mytabs.oracle.items
    in
    ( { csharp =
            { display = "Hello"
            , context = Csharp
            , items = init_enum 0 csharp.items
            }
      , oracle =
            { display = "Oracle"
            , context = Oracle
            , items = init_enum cs oracle.items
            }
      , change =
            { display = "Change"
            , context = Change
            , items = init_enum (cs + orc) change.items
            }
      , uid = 1
      }
    , Cmd.none
    )



-- update


update : Msg -> Tabs -> ( Tabs, Cmd Msg )
update msg model =
    case msg of
        CheckBox id isChecked ->
            let
                updateEntry : ChecklistItem -> ChecklistItem
                updateEntry t =
                    if t.id == id then
                        { t | checked = isChecked }

                    else
                        t
            in
            ( { model
                | csharp = { csharp | items = List.map updateEntry model.csharp.items }
                , oracle = { oracle | items = List.map updateEntry model.oracle.items }
                , change = { change | items = List.map updateEntry model.change.items }
              }
            , Cmd.none
            )

        NoOp ->
            ( model, Cmd.none )



-- subcriptions


subscriptions : Tabs -> Sub Msg
subscriptions _ =
    Sub.none



-- view


itemsAllChecked : List { a | checked : Bool } -> Bool
itemsAllChecked checkList =
    List.all (\x -> x.checked == True) checkList


itemToTD : ChecklistItem -> Html Msg
itemToTD checkListItem =
    li []
        [ input [ type_ "checkbox", checked checkListItem.checked, onClick (CheckBox checkListItem.id (not checkListItem.checked)) ] []
        , span [] [ text (String.concat [ checkListItem.text, String.fromInt checkListItem.id ]) ]
        ]


view : Tabs -> Html Msg
view model =
    div []
        [ table []
            [ thead
                []
                [ th [] [ text model.csharp.display ]
                , th [] [ text model.oracle.display ]
                , th [] [ text model.change.display ]
                ]
            , tbody
                []
                [ tr []
                    [ td []
                        [ ul [ style "list-style-type" "none" ]
                            (List.map
                                itemToTD
                                model.csharp.items
                            )
                        ]
                    , td []
                        [ ul
                            [ style "list-style-type" "none" ]
                            (List.map
                                itemToTD
                                model.oracle.items
                            )
                        ]
                    , td []
                        [ ul [ style "list-style-type" "none" ]
                            (List.map
                                itemToTD
                                model.change.items
                            )
                        ]
                    ]
                ]
            , tfoot []
                [ tr []
                    [ td [ align "center" ] [ input [ type_ "checkbox", disabled True, checked (itemsAllChecked model.csharp.items) ] [], span [] [ text "Alles" ] ]
                    , td [ align "center" ] [ input [ type_ "checkbox", disabled True, checked (itemsAllChecked model.oracle.items) ] [], span [] [ text "Alles" ] ]
                    , td [ align "center" ] [ input [ type_ "checkbox", disabled True, checked (itemsAllChecked model.change.items) ] [], span [] [ text "Alles" ] ]
                    ]
                ]
            ]
        ]
