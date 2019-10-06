table 50100 "TPE BCI Index20"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(10; "Searchable Content"; code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Record Id"; RecordId)
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
    }

}