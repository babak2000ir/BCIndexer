page 50100 "TPE BCI Indexer Seach"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "TPE BCI Search Result";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(SearchGroup)
            {
                field(Search; txtSearch)
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        clear(rec);
                        rec.DeleteAll();

                        cduIndexerMgmt.fctSearch(txtSearch, 0, rec);
                    end;
                }
            }
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

                field("Result Content"; "Result Content")
                {
                    ApplicationArea = All;
                }
                field("Search Level"; "Search Level")
                {
                    ApplicationArea = All;
                    Visible = false;
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
            action(IndexAll)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                image = CalculateLines;

                trigger OnAction();
                begin
                    cduIndexerMgmt.fctIndexFullTable();
                end;
            }
        }
    }

    var
        txtSearch: Text;
        cduIndexerMgmt: Codeunit "TPE BCI Indexer Mgmt.";
}