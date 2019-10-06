table 50103 "TPE BCI Search Result"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(10; "Record Id"; RecordId)
        {
            DataClassification = SystemMetadata;
        }
        field(20; "Result Content"; text[250])
        {
            DataClassification = CustomerContent;
        }
        field(21; "Search Level"; Integer)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

}