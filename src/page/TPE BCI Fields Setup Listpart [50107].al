page 50107 "TPE BCI Fields Setup Listpart"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "TPE BCI Table fields Setup";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Field No."; "Field No.")
                {
                    ApplicationArea = All;
                }
                field("Field Caption"; "Field Caption")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}