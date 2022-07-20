enum 90000 "Standing Order Frequency"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Successful)
    {
        Caption = 'Successful';
    }
    value(2; Unsuccessful)
    {
        Caption = 'Unsuccessful';
    }
}

enum 90001 "Member Status"
{
    Extensible = true;

    value(0; Active)
    {
    }
    value(1; Defaulter)
    {
    }
    value(2; "Withdrawal-Pending")
    {
    }
    value(3; Withdrawn)
    {
    }
    value(4; Desceased)
    {
    }
    value(5; Dormant) { }
    value(6; "Re-Instated") { }
    value(7; "Non-Active") { }
}
