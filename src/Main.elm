module Main exposing (main, subscriptions)

import Browser
import Html exposing (..)
import Html.Attributes exposing (checked, disabled, type_)
import Html.Events exposing (..)
import Models exposing (..)



-- main


type Msg
    = CheckBox Int Bool
    | NoOp


mytabs : Tabs
mytabs =
    init_ids
        { csharp = csharp
        , oracle = oracle
        , change = change
        , uid = 0
        }


main : Program () Tabs Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



--  init


init : () -> ( Tabs, Cmd Msg )
init _ =
    ( mytabs
    , Cmd.none
    )


init2 : Int -> List ChecklistItem -> List ChecklistItem
init2 start list =
    case ( List.head list, List.tail list ) of
        ( Just hd, Just tlist ) ->
            { hd | id = start } :: init2 (start + 1) tlist

        ( Just hd, _ ) ->
            [ { hd | id = start } ]

        ( _, _ ) ->
            list


init_ids : Tabs -> Tabs
init_ids model =
    let
        cs =
            List.length model.csharp.items

        orc =
            List.length model.oracle.items
    in
    { model
        | csharp = { csharp | items = init2 0 csharp.items }
        , oracle = { oracle | items = init2 cs oracle.items }
        , change = { change | items = init2 (cs + orc) change.items }
    }



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
                | csharp = { csharp | items = List.map updateEntry csharp.items }
                , oracle = { oracle | items = List.map updateEntry oracle.items }
                , change = { change | items = List.map updateEntry change.items }
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
    ul []
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
                        (List.map
                            itemToTD
                            model.csharp.items
                        )
                    , td []
                        (List.map
                            itemToTD
                            model.oracle.items
                        )
                    , td []
                        (List.map
                            itemToTD
                            model.change.items
                        )
                    ]
                ]
            , tfoot []
                [ tr []
                    [ td [] [ input [ type_ "checkbox", disabled True, checked (itemsAllChecked model.csharp.items) ] [], span [] [ text "Alles" ] ]
                    , td [] [ input [ type_ "checkbox", disabled True, checked (itemsAllChecked model.oracle.items) ] [], span [] [ text "Alles" ] ]
                    , td [] [ input [ type_ "checkbox", disabled True, checked (itemsAllChecked model.change.items) ] [], span [] [ text "Alles" ] ]
                    ]
                ]
            ]
        ]
