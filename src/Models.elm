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


csharp : Checklist
csharp =
    { display = "C#"
    , context = Csharp
    , items =
        [ { text = "first"
          , id = -1
          , checked = False
          }
        , { text = "second"
          , id = -2
          , checked = True
          }
        ]
    }


oracle : Checklist
oracle =
    { display = "Oracle"
    , context = Oracle
    , items =
        [ { text = "first"
          , id = 3
          , checked = True
          }
        , { text = "second"
          , id = 4
          , checked = True
          }
        ]
    }


change : Checklist
change =
    { display = "Change-Script"
    , context = Change
    , items =
        [ { text = "first"
          , id = 5
          , checked = False
          }
        , { text = "second"
          , id = 6
          , checked = True
          }
        ]
    }


type alias Tabs =
    { csharp : Checklist
    , oracle : Checklist
    , change : Checklist
    , uid : Int
    }



-- tabs : { csharp : Checklist, oracle : Checklist, change : Checklist }
