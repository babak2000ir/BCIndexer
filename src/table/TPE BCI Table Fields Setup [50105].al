table 50105 "TPE BCI Table Fields Setup"
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Table No."; Integer)
        {
            DataClassification = SystemMetadata;
            //TableRelation = "TPE BCI Table Setup"."Table No.";
        }
        field(10; "Field No."; Integer)
        {
            DataClassification = SystemMetadata;
            TableRelation = Field."No." WHERE(TableNo = field("Table No."));
        }
        field(11; "Field Caption"; text[80])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup (Field."Field Caption" WHERE(TableNo = field("Table No."), "No." = field("Field No.")));
        }
    }

    keys
    {
        key(PK; "Table No.", "Field No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}