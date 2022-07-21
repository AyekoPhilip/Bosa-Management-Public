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

enum 90002 "Repayment Frequency"
{
    Extensible = false;

    value(0; "Monthly")
    {
    }
    value(1; "Quarterly")
    {
    }
    value(2; "Semi-Annualy")
    {
    }
    value(3; "Annualy")
    {
    }
}

enum 90003 "Approval Status Custom"
{
    Extensible = false;

    value(0; "New")
    {
    }
    value(1; "Approval Pending")
    {
    }
    value(2; "Approved")
    {
    }
}

enum 90004 "Prouct Source"
{
    Extensible = false;

    value(0; BOSA)
    {
    }
    value(1; FOSA)
    {
    }
    value(2; MICROFINANCE)
    {
    }
}