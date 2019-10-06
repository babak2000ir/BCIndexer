page 50106 "TPE BCI Table Setup List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "TPE BCI Table Setup";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Table No."; "Table No.")
                {
                    ApplicationArea = All;
                }
                field("Table Caption"; "Table Caption")
                {
                    ApplicationArea = All;
                }
            }
            group(FieldsGroup)
            {
                part("FieldsPart"; "TPE BCI Fields Setup Listpart")
                {
                    ApplicationArea = all;
                    SubPageLink = "Table No." = field("Table No.");
                }
            }
        }
    }
}