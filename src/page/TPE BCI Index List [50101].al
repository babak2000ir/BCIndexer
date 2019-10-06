page 50101 "TPE BCI Index List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "TPE BCI Index250";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Record Id"; format("Record Id"))
                {
                    ApplicationArea = All;
                }
                field("Searchable Content"; "Searchable Content")
                {
                    ApplicationArea = All;
                }
                field("Table Id"; "Table Id")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}