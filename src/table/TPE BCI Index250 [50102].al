table 50102 "TPE BCI Index250"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(10; "Searchable Content"; text[250])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Record Id"; RecordId)
        {
            DataClassification = SystemMetadata;
        }
        field(21; "Table Id"; Integer)
        {
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(SK1; "Searchable Content")
        {
            MaintainSQLIndex = true;
            SQLIndex = "Searchable Content", "Record Id";
        }
        key(SK2; "Record Id", "Searchable Content")
        {
            MaintainSQLIndex = true;
            SQLIndex = "Record Id", "Searchable Content";
        }

        key(SK3; "Table Id")
        {
            MaintainSQLIndex = true;
        }
    }

}