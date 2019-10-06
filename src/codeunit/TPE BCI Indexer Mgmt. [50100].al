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
        lrecCustomer: record Customer;
        lrecVendor: record Customer;
        lrecSalesInvoice: Record "Sales Invoice Header";
        lrecPurchaseInvoice: Record "Purch. Inv. Header";
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
        if lrecTableSetup.FindSet(false, false) then
            repeat
                lrecTableFieldsSetup.reset;
                lrecTableFieldsSetup.setrange("Table No.", lrecTableSetup."Table No.");
                lrecTableFieldsSetup.setfilter("Field No.", '<>%1', 0);
                if lrecTableFieldsSetup.findset then begin
                    lRecRef.open(lrecTableSetup."Table No.");
                    repeat
                        if lRecRef.FindSet(false, false) then begin
                            lFieldRef := lRecRef.Field(lrecTableFieldsSetup."Field No.");
                            fctIndexRecord(lRecRef.RecordId, lFieldRef.Value);
                            Commit;
                        end;
                    until lrecTableFieldsSetup.next = 0;
                end;
            until lrecTableSetup.next = 0;

        /* if lrecCustomer.FindSet(false, false) then
            repeat
                fctIndexRecord(lrecCustomer.RecordId, lrecCustomer."No.");
                fctIndexRecord(lrecCustomer.RecordId, lrecCustomer.Name);
                fctIndexRecord(lrecCustomer.RecordId, lrecCustomer."Name 2");
                fctIndexRecord(lrecCustomer.RecordId, lrecCustomer.City);
                fctIndexRecord(lrecCustomer.RecordId, lrecCustomer."Country/Region Code");
            until lrecCustomer.next = 0;

        if lrecVendor.FindSet(false, false) then
            repeat
                fctIndexRecord(lrecVendor.RecordId, lrecVendor."No.");
                fctIndexRecord(lrecVendor.RecordId, lrecVendor.Name);
                fctIndexRecord(lrecVendor.RecordId, lrecVendor."Name 2");
                fctIndexRecord(lrecVendor.RecordId, lrecVendor.City);
                fctIndexRecord(lrecVendor.RecordId, lrecVendor."Country/Region Code");
            until lrecVendor.next = 0;

        if lrecSalesInvoice.FindSet(false, false) then
            repeat
                fctIndexRecord(lrecSalesInvoice.RecordId, lrecSalesInvoice."Bill-to Customer No.");
                fctIndexRecord(lrecSalesInvoice.RecordId, lrecSalesInvoice."Sell-to Customer Name");
                fctIndexRecord(lrecSalesInvoice.RecordId, lrecSalesInvoice."No.");
                fctIndexRecord(lrecSalesInvoice.RecordId, lrecSalesInvoice."External Document No.");
                fctIndexRecord(lrecSalesInvoice.RecordId, lrecSalesInvoice."Bill-to Country/Region Code");
                fctIndexRecord(lrecSalesInvoice.RecordId, lrecSalesInvoice."Bill-to City");
            until lrecSalesInvoice.next = 0;

        if lrecPurchaseInvoice.FindSet(false, false) then
            repeat
                fctIndexRecord(lrecPurchaseInvoice.RecordId, lrecPurchaseInvoice."Pay-to Vendor No.");
                fctIndexRecord(lrecPurchaseInvoice.RecordId, lrecPurchaseInvoice."Buy-from Vendor Name");
                fctIndexRecord(lrecPurchaseInvoice.RecordId, lrecPurchaseInvoice."No.");
                fctIndexRecord(lrecPurchaseInvoice.RecordId, lrecPurchaseInvoice."Your Reference");
                fctIndexRecord(lrecPurchaseInvoice.RecordId, lrecPurchaseInvoice."Pay-to Country/Region Code");
                fctIndexRecord(lrecPurchaseInvoice.RecordId, lrecPurchaseInvoice."Pay-to City");
            until lrecPurchaseInvoice.next = 0; */
    end;

    local procedure fctIndexRecord(precId: RecordId; ptxtContent: text)
    var
        lrecIndex: record "TPE BCI Index250";
    begin
        if ptxtContent <> '' then begin
            lrecIndex.SetCurrentKey("Record Id", "Searchable Content");
            lrecIndex.SetRange("Record Id", precId);
            lrecIndex.SetRange("Searchable Content", ptxtContent);
            if lrecIndex.IsEmpty then begin
                lrecIndex.init;
                lrecIndex."Record Id" := precId;
                lrecIndex."Table Id" := precId.TableNo;
                lrecIndex."Searchable Content" := UpperCase(ptxtContent);
                lrecIndex.Insert;
            end;
        end;
    end;

    var
        intCounter: Integer;
        intDeepSearchControlTableId: Integer;
}