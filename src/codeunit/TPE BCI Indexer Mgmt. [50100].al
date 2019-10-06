codeunit 50100 "TPE BCI Indexer Mgmt."
{
    trigger OnRun()
    var
    begin

    end;

    //Searching
    procedure fctSearch(ptxtSearchPhrase: Text; pintSearchLevel: Integer; var precSearchResult: Record "TPE BCI Search Result" temporary)
    var
        lrecIndex: record "TPE BCI Index250";
        ltxtDeepSearchPhrase: text;
    begin
        ptxtSearchPhrase := UpperCase(ptxtSearchPhrase);
        if pintSearchLevel = 0 then begin
            intCounter := 0;
            intDeepSearchControlTableId := 0;
        end;

        //Deep Search Control
        if (pintSearchLevel > 0) then begin
            lrecIndex.SetFilter("table Id", '<>%1', intDeepSearchControlTableId);
        end;

        lrecIndex.SetRange("Searchable Content", ptxtSearchPhrase);
        if lrecIndex.findset(false, false) then begin
            repeat
                precSearchResult.reset;
                precSearchResult.SetRange("Record Id", lrecIndex."Record Id");
                if precSearchResult.IsEmpty then begin
                    intCounter += 1;

                    precSearchResult.init;
                    precSearchResult."Entry No." := intCounter;
                    precSearchResult."Record Id" := lrecIndex."Record Id";
                    precSearchResult."Result Content" := lrecIndex."Searchable Content";
                    precSearchResult."Search Level" := pintSearchLevel;
                    precSearchResult.Insert;

                    //Deep Search
                    if pintSearchLevel = 0 then begin
                        ltxtDeepSearchPhrase := fctGetDeepSearchValue(lrecIndex."Record Id");
                        intDeepSearchControlTableId := lrecIndex."Table Id";
                        fctSearch(ltxtDeepSearchPhrase, pintSearchLevel + 1, precSearchResult);
                    end;
                end;

            until lrecIndex.next = 0;
        end;

        clear(precSearchResult);
    end;

    procedure fctGetDeepSearchValue(precId: RecordId): Text;
    var
        lRecRef: RecordRef;
        lFieldRef: FieldRef;
    begin
        lRecRef.get(precId);

        case precId.TableNo of
            database::Customer:
                begin
                    lFieldRef := lRecRef.field(1);
                    exit(lFieldRef.Value);
                end;
            database::Vendor:
                begin
                    lFieldRef := lRecRef.field(1);
                    exit(lFieldRef.Value);
                end;
            database::"Sales Invoice Header":
                begin
                    lFieldRef := lRecRef.field(4);
                    exit(lFieldRef.Value);
                end;
            database::"Purch. Inv. Header":
                begin
                    lFieldRef := lRecRef.field(4);
                    exit(lFieldRef.Value);
                end;
        end;
    end;

    //Indexing
    procedure fctIndexFullTable()
    var
        lrecTableSetup: record "TPE BCI Table Setup";
        lrecTableFieldsSetup: record "TPE BCI Table Fields Setup";
        lRecRef: RecordRef;
        lFieldRef: FieldRef;
    begin
        lrecTableSetup.reset;
        if lrecTableSetup.FindSet(false, false) then
            repeat
                lRecRef.open(lrecTableSetup."Table No.");
                if lRecRef.FindSet(false, false) then
                    repeat
                        lrecTableFieldsSetup.reset;
                        lrecTableFieldsSetup.setrange("Table No.", lrecTableSetup."Table No.");
                        lrecTableFieldsSetup.setfilter("Field No.", '<>%1', 0);
                        if lrecTableFieldsSetup.findset then begin
                            repeat
                                lFieldRef := lRecRef.Field(lrecTableFieldsSetup."Field No.");
                                fctIndexRecord(lRecRef.RecordId, lFieldRef.Value);
                                Commit;
                            until lrecTableFieldsSetup.next = 0;
                        end;
                    until lRecRef.Next = 0;
            until lrecTableSetup.next = 0;
    end;

    local procedure fctIndexRecord(precId: RecordId; ptxtContent: text)
    var
        lRecRef: RecordRef;
    begin
        if ptxtContent <> '' then begin
            case StrLen(ptxtContent) of
                1 .. 20:
                    begin
                        lRecRef.Open(Database::"TPE BCI Index20");
                    end;
                21 .. 100:
                    begin
                        lRecRef.Open(Database::"TPE BCI Index100");
                    end;
                101 .. 250:
                    begin
                        lRecRef.Open(Database::"TPE BCI Index250");
                    end;
            end;

            lRecRef.CurrentKeyIndex(2);

            lRecRef.Field(20).SetRange(precId);
            lRecRef.Field(10).SetRange(ptxtContent);

            if lRecRef.IsEmpty then begin
                lRecRef.init;
                lRecRef.Field(20).Value(precId);
                lRecRef.Field(21).value(precId.TableNo);
                lRecRef.Field(10).Value(UpperCase(ptxtContent));
                lRecRef.Insert;
            end;
        end;
    end;

    //Misc
    procedure fctCompileAllindices(var precIndex: record "TPE BCI Index250" temporary)
    var
        lrecIndex20: Record "TPE BCI Index20";
        lrecIndex100: Record "TPE BCI Index100";
        lrecIndex250: Record "TPE BCI Index250";
        lintCounter: BigInteger;
    begin
        clear(precIndex);
        precIndex.DeleteAll();
        lintCounter := 0;

        lrecIndex20.reset;
        if lrecIndex20.findset then
            repeat
                lintCounter += 1;

                precIndex.Init();
                precIndex.TransferFields(lrecIndex20);
                precIndex."Entry No." := lintCounter;
                precIndex.insert;
            until lrecIndex20.next = 0;

        lrecIndex100.reset;
        if lrecIndex100.findset then
            repeat
                lintCounter += 1;

                precIndex.Init();
                precIndex.TransferFields(lrecIndex100);
                precIndex."Entry No." := lintCounter;
                precIndex.insert;
            until lrecIndex100.next = 0;

        lrecIndex250.reset;
        if lrecIndex250.findset then
            repeat
                lintCounter += 1;

                precIndex.Init();
                precIndex.TransferFields(lrecIndex250);
                precIndex."Entry No." := lintCounter;
                precIndex.insert;
            until lrecIndex250.next = 0;
    end;

    var
        intCounter: Integer;
        intDeepSearchControlTableId: Integer;
}