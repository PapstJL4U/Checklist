module Models exposing (Checklist, ChecklistItem, Step(..), Tabs, change, csharp, oracle)


type Step
    = Csharp
    | Oracle
    | Change


type alias ChecklistItem =
    { text : String
    , id : Int
    , checked : Bool
    }


type alias Checklist =
    { display : String
    , context : Step
    , items : List ChecklistItem
    }


type alias Tabs =
    { csharp : Checklist
    , oracle : Checklist
    , change : Checklist
    , uid : Int
    }


transform_list : List String -> List ChecklistItem
transform_list list =
    case ( List.head list, List.tail list ) of
        ( Just hd, Just tail ) ->
            { text = hd
            , id = -1
            , checked = False
            }
                :: transform_list tail

        ( Just hd, _ ) ->
            [ { text = hd
              , id = -1
              , checked = False
              }
            ]

        ( _, _ ) ->
            []


csharp : Checklist
csharp =
    { display = "C#"
    , context = Csharp
    , items =
        transform_list do_csharp
    }


oracle : Checklist
oracle =
    { display = "Oracle"
    , context = Oracle
    , items =
        transform_list do_oracle
    }


change : Checklist
change =
    { display = "Change-Scripts"
    , context = Change
    , items =
        transform_list do_change
    }


do_csharp : List String
do_csharp =
    [ "Merged Production"
    , ".csproj kontrolliert"
    , "Abhängige Tickets notiert"
    ]


do_oracle : List String
do_oracle =
    [ "Reference mit Select gesucht"
    , "Codesuit Änderungen"
    , "Types"
    , "Collections"
    , "Kommentare"
    ]


do_change : List String
do_change =
    [ "ANSI Codierung"
    , "Line Ending"
    ]
