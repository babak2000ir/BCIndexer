table 50104 "TPE BCI Table Setup"
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Table No."; Integer)
        {
            DataClassification = SystemMetadata;
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = const(Table));
        }
        field(2; "Table Caption"; Text[249])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup (AllObjWithCaption."Object Caption" WHERE("Object Type" = const(Table), "Object ID" = field("Table No.")));
        }
    }

    keys
    {
        key(PK; "Table No.")
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