report 91000 "Loan Checkoff Analysis"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = '.\Loan Management\Credit Reports\LoanCheckoffAnalysis.rdl';
    DefaultLayout = rdlc;



    dataset
    {
        dataitem("CheckoffAdvice"; "Checkoff Advice")
        {
            RequestFilterFields = "Advice Type", "Employer Code", "Member No";

            column(PayrollNo; PayrollNo) { }
            column(MemberName; MemberName) { }
            column(Member_Name; "Member Name") { }
            column(Amount_Off; "Amount Off") { }
            column(Amount_On; "Amount On") { }
            column("CompanyLogo"; CompanyInfo.Picture) { }
            column("CompanyName"; CompanyInfo.Name) { }
            column("CompanyAddress1"; CompanyInfo.Address) { }
            column("CompanyAddress2"; CompanyInfo."Address 2") { }
            column("CompanyPhone"; CompanyInfo."Phone No.") { }
            column("CompanyEmail"; CompanyInfo."E-Mail") { }
            column(Product_Name; "Product Name") { }
            column(Product_Type; "Product Type") { }


            trigger OnPreDataItem()
            begin
                CompanyInfo.get();
                CompanyInfo.CalcFields(Picture);
                //CheckoffAdvice.CalcFields("Member Name");
            end;

            trigger OnAfterGetRecord()
            begin
                Member.reset;
                Member.SetRange(Member."Member No.", CheckoffAdvice."Member No");
                if Member.findset then begin
                    PayrollNo := Member."Payroll No";
                    MemberName := Member."Full Name";
                    //Message('Member Number is %1', MemberName);
                end;
            end;


            trigger OnPostDataItem()
            begin

            end;

        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }



    var
        CompanyInfo: record "Company Information";
        Member: record Members;
        PayrollNo: Text[50];
        MemberName: Text[250];


}

report 91002 "Loan Pro-rata Interest"
{
    ApplicationArea = All;
    Caption = 'Loan Pro-rata Interest';
    UsageCategory = ReportsAndAnalysis;
    PreviewMode = Normal;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\Loan Pro_rata Interest.rdl';
    dataset
    {
        dataitem(LoanApplication; "Loan Application")
        {
            DataItemTableView = where(posted = filter(true));
            RequestFilterFields = "Posting Date", "Member No.", "Employer Code", "Date Filter";
            column(LoanAccount; "Loan Account")
            {
            }
            column(ProductDescription; "Product Description")
            {
            }
            column(MemberName; "Member Name")
            {
            }
            column(ApprovedAmount; "Approved Amount")
            {
            }
            // column(Interest){}
            column(PostingDate; FORMAT("Posting Date"))
            {
            }
            column(ProratedDays; "Prorated Days")
            {
            }
            column(ProratedInterest; "Prorated Interest")
            {
            }
            column("CompanyLogo"; CompanyInfo.Picture) { }
            column("CompanyName"; CompanyInfo.Name) { }
            column("CompanyAddress1"; CompanyInfo.Address) { }
            column("CompanyAddress2"; CompanyInfo."Address 2") { }
            column("CompanyPhone"; CompanyInfo."Phone No.") { }
            column("CompanyEmail"; CompanyInfo."E-Mail") { }
            column(Interest; Interest) { }

            trigger OnPreDataItem()
            begin
                CompanyInfo.get();
                CompanyInfo.CalcFields(Picture);
            end;

            trigger OnAfterGetRecord()
            begin
                Interest := 0;
                if LoanApplication.Get(LoanApplication."Application No") then begin
                    Interest := LoanApplication."Approved Amount" * LoanApplication."Interest Rate" * 0.01 * (1 / 12) * (1 / 30) * LoanApplication."Prorated Days";
                    Interest := Round(Interest, 1, '=');
                end;


            end;

            trigger OnPostDataItem()
            begin

            end;
        }

    }


    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var
        CompanyInfo: Record "Company Information";
        Interest: Decimal;
}

report 91003 "OverPaid Principle"
{
    PreviewMode = Normal;
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\OverPaidPrinciple.rdl';
    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            DataItemTableView = where("Principle Balance" = filter(< 0));
            RequestFilterFields = "Date Filter", "Member No.", "Application No", "Application Date", "Employer Code";
            column(Application_No; "Application No") { }
            column(Installments; Installments) { }
            column(Loan_Classification; "Loan Classification") { }
            column(Deposits; Deposits) { }
            column(Member_No_; "Member No.") { }
            column(Member_Name; "Member Name") { }
            column(EmployerName; EmployerName) { }
            column(Posting_Date; "Posting Date") { }
            column(Last_Pay_Date; "Last Pay Date") { }
            column(Repayment_End_Date; "Repayment End Date") { }
            column(Approved_Amount; "Approved Amount") { }
            column(Loan_Balance; "Loan Balance") { }
            column(GroupSortingOrder; GroupSortingOrder) { }
            column(Product_Code; "Product Code") { }
            column(Product_Description; "Product Description") { }
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(RemainingPeriod; RemainingPeriod) { }
            column(Principle_Balance; "Principle Balance - At Date") { }
            column(LoanAge; LoanAge) { }
            column(Principle_Paid; "Principle Paid") { }
            column(Interest_Arrears; "Interest Arrears") { }
            column(Employer_Code; "Employer Code") { }
            column(Monthly_Principle; "Monthly Principle") { }
            column(AgeingGroup; AgeingGroup) { }
            column(Staff_No; "Staff No") { }
            column(Filters; Filters) { }
            column(Interest_Rate; "Interest Rate") { }
            column(Rate_Type; "Interest Repayment Method") { }
            column(PrincipleDue; PrincipleDue) { }
            trigger OnPreDataItem()
            begin
                Filters := "Loan Application".GetFilters;
                CompanyInformation.get();
                CompanyInformation.CalcFields(Picture);
            end;

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                "Loan Application".CalcFields("Employer Code");
                EmployerCode := '';
                EmployerName := '';
                if Employers.get("Employer Code") then
                    EmployerName := Employers.Name;
                AgeingGroup := '';
                if "Loan Application"."Repayment End Date" = 0D then
                    CurrReport.Skip();
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        Deposits, DefPrinciple, PrinciplePaid, MonthlyPrinciple, PrincipleDue : Decimal;
        MemberMgt: Codeunit "Member Management";
        LoansMgt: Codeunit "Loans Management";
        EmployerCode, EmployerName : Code[100];
        Members: Record Members;
        Employers: Record "Employer Codes";
        Filters: Text;
        AgeingGroup: Text[100];
        RemainingPeriod, GroupSortingOrder : Integer;
        AsAtDate: Date;
        LoanAge: Integer;

}

report 91004 "Non_Guaranteed Loans"
{
    PreviewMode = Normal;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Loans Without Guarantors';
    RDLCLayout = '.\Loan Management\Credit Reports\Non_GuaranteedLoans.rdl';
    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            DataItemTableView = where("Total Securities" = filter(= 0), Posted = filter(true));
            RequestFilterFields = "Date Filter", "Member No.", "Application No", "Application Date", "Employer Code";
            column(Application_No; "Application No") { }
            column(Installments; Installments) { }
            column(Loan_Classification; "Loan Classification") { }
            column(Deposits; Deposits) { }
            column(Member_No_; "Member No.") { }
            column(Member_Name; "Member Name") { }
            column(EmployerName; EmployerName) { }
            column(Posting_Date; FORMAT("Posting Date")) { }
            column(Last_Pay_Date; FORMAT("Last Pay Date")) { }
            column(Repayment_End_Date; FORMAT("Repayment End Date")) { }
            column(Approved_Amount; "Approved Amount") { }
            column(Loan_Balance; "Loan Balance") { }
            column(GroupSortingOrder; GroupSortingOrder) { }
            column(Product_Code; "Product Code") { }
            column(Product_Description; "Product Description") { }
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(RemainingPeriod; RemainingPeriod) { }
            column(Principle_Balance; "Principle Balance - At Date") { }
            column(LoanAge; LoanAge) { }
            column(Principle_Paid; "Principle Paid") { }
            column(Interest_Arrears; "Interest Arrears") { }
            column(Employer_Code; "Employer Code") { }
            column(Monthly_Principle; "Monthly Principle") { }
            column(AgeingGroup; AgeingGroup) { }
            column(Staff_No; "Staff No") { }
            column(Filters; Filters) { }
            column(Interest_Rate; "Interest Rate") { }
            column(Rate_Type; "Interest Repayment Method") { }
            column(PrincipleDue; PrincipleDue) { }
            trigger OnPreDataItem()
            begin
                Filters := "Loan Application".GetFilters;
                CompanyInformation.get();
                CompanyInformation.CalcFields(Picture);
            end;

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                "Loan Application".CalcFields("Employer Code");
                EmployerCode := '';
                EmployerName := '';
                if Employers.get("Employer Code") then
                    EmployerName := Employers.Name;
                AgeingGroup := '';
                //if "Loan Application"."Repayment End Date" = 0D then
                // CurrReport.Skip();
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        Deposits, DefPrinciple, PrinciplePaid, MonthlyPrinciple, PrincipleDue : Decimal;
        MemberMgt: Codeunit "Member Management";
        LoansMgt: Codeunit "Loans Management";
        EmployerCode, EmployerName : Code[100];
        Members: Record Members;
        Employers: Record "Employer Codes";
        Filters: Text;
        AgeingGroup: Text[100];
        RemainingPeriod, GroupSortingOrder : Integer;
        AsAtDate: Date;
        LoanAge: Integer;

}

report 91005 "Membership Statistics"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Member Management\Report Layouts\MembershipStatistics.rdl';



    dataset
    {
        dataitem(Employer_Codes; "Employer Codes")
        {
            RequestFilterFields = Code;
            //DataItemTableView = where(Blocked = const(false));

            column(Code; "Code") { }

            column(Name; Name) { }

            //column(NoOfActiveMembers; "No. Of Active Members") { }

            //column(NoOfDormantMembers; "No. Of Dormant Members") { }

            //column(NoOfWithdrawnMembers; "No. Of Withdrawn Members") { }

            //column(NoOfDeceasedMembers; "No. Of Deceased Members") { }

            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            trigger OnPreDataItem()
            begin
                CompanyInformation.get();
                CompanyInformation.CalcFields(Picture);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }



    var
        CompanyInformation: Record "Company Information";
}

report 91006 "Loan Statistics"
{
    PreviewMode = Normal;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Loans Without Guarantors';
    RDLCLayout = '.\Loan Management\Credit Reports\LoanStatistics.rdl';
    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            DataItemTableView = where("Loan Balance" = filter(<> 0), Posted = filter(true));
            RequestFilterFields = "Date Filter", "Member No.", "Application No", "Application Date", "Employer Code";
            column(Application_No; "Application No") { }
            column(Installments; Installments) { }
            column(Loan_Classification; "Loan Classification") { }
            column(Deposits; Deposits) { }
            column(Member_No_; "Member No.") { }
            column(Member_Name; "Member Name") { }
            column(EmployerName; EmployerName) { }
            column(Posting_Date; FORMAT("Posting Date")) { }
            column(Last_Pay_Date; FORMAT("Last Pay Date")) { }
            column(Repayment_End_Date; FORMAT("Repayment End Date")) { }
            column(Approved_Amount; "Approved Amount") { }
            column(Loan_Balance; "Loan Balance") { }

            column(Product_Code; "Product Code") { }
            column(Product_Description; "Product Description") { }
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }

            column(Principle_Balance; "Principle Balance - At Date") { }

            column(EmployerCode; EmployerCode) { }
            column(Principle_Paid; "Principle Paid") { }
            column(Interest_Arrears; "Interest Arrears") { }
            column(Employer_Code; "Employer Code") { }
            column(Monthly_Principle; "Monthly Principle") { }
            column(AgeingGroup; AgeingGroup) { }
            column(Staff_No; "Staff No") { }
            column(Filters; Filters) { }
            column(Interest_Rate; "Interest Rate") { }
            column(Rate_Type; "Interest Repayment Method") { }
            column(PrincipleDue; PrincipleDue) { }
            column(Sector_Code; "Sector Code") { }
            trigger OnPreDataItem()
            begin
                Filters := "Loan Application".GetFilters;
                CompanyInformation.get();
                CompanyInformation.CalcFields(Picture);
            end;

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                "Loan Application".CalcFields("Employer Code");
                EmployerCode := '';
                EmployerName := '';
                if Employers.get("Employer Code") then
                    EmployerName := Employers.Name;
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        Deposits, DefPrinciple, PrinciplePaid, MonthlyPrinciple, PrincipleDue : Decimal;
        MemberMgt: Codeunit "Member Management";
        LoansMgt: Codeunit "Loans Management";
        EmployerCode, EmployerName : Code[100];
        Members: Record Members;
        Employers: Record "Employer Codes";
        Filters: Text;
        AgeingGroup: Text[100];
        RemainingPeriod, GroupSortingOrder : Integer;
        AsAtDate: Date;
        LoanAge: Integer;

}

report 91007 "Collateral Register"
{
    PreviewMode = Normal;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'List of Collaterals';
    RDLCLayout = '.\Loan Management\Credit Reports\CollateralRegister.rdl';
    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            DataItemTableView = where("Loan Balance" = filter(<> 0), Posted = filter(true));
            RequestFilterFields = "Date Filter", "Member No.", "Application No", "Application Date", "Employer Code";
            column(Application_No; "Application No") { }
            column(Installments; Installments) { }
            column(Loan_Classification; "Loan Classification") { }
            column(Deposits; Deposits) { }
            //column(Member_No_; "Member No.") { }
            //column(Member_Name; "Member Name") { }
            column(EmployerName; EmployerName) { }
            column(Posting_Date; FORMAT("Posting Date")) { }
            column(Last_Pay_Date; FORMAT("Last Pay Date")) { }
            column(Repayment_End_Date; FORMAT("Repayment End Date")) { }
            column(Approved_Amount; "Approved Amount") { }
            column(Loan_Balance; "Loan Balance") { }

            column(Product_Code; "Product Code") { }
            column(Product_Description; "Product Description") { }
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }

            column(Principle_Balance; "Principle Balance - At Date") { }

            column(EmployerCode; EmployerCode) { }
            column(Principle_Paid; "Principle Paid") { }
            column(Interest_Arrears; "Interest Arrears") { }
            column(Employer_Code; "Employer Code") { }
            column(Monthly_Principle; "Monthly Principle") { }
            column(AgeingGroup; AgeingGroup) { }
            column(Staff_No; "Staff No") { }
            column(Filters; Filters) { }
            column(Interest_Rate; "Interest Rate") { }
            column(Rate_Type; "Interest Repayment Method") { }
            column(PrincipleDue; PrincipleDue) { }
            column(Sector_Code; "Sector Code") { }
            dataitem("Collateral Register"; "Collateral Register")
            {
                DataItemLink = "Member No" = field("Member No.");
                column(Document_No; "Document No") { }
                column(Member_No; "Member No") { }
                column(Member_Name; "Member Name") { }
                column(Collateral_Type; "Collateral Type") { }
                column(Collateral_Description; "Collateral Description") { }
                column(Loan_No_; "Loan No.") { }
                column(Caollateral_Value; "Caollateral Value") { }
                column(Registration_No; "Registration No") { }
                column(RemainingPeriod; RemainingPeriod) { }
                column(Linking_Date; "Linking Date") { }
                column(Insurance_Expiry_Date; "Insurance Expiry Date") { }
                column(Owner_Phone_No_; "Owner Phone No.") { }


            }
            trigger OnPreDataItem()
            begin
                Filters := "Loan Application".GetFilters;
                CompanyInformation.get();
                CompanyInformation.CalcFields(Picture);
            end;

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                "Loan Application".CalcFields("Employer Code");
                EmployerCode := '';
                EmployerName := '';
                if Employers.get("Employer Code") then
                    EmployerName := Employers.Name;
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        Deposits, DefPrinciple, PrinciplePaid, MonthlyPrinciple, PrincipleDue : Decimal;
        MemberMgt: Codeunit "Member Management";
        LoansMgt: Codeunit "Loans Management";
        EmployerCode, EmployerName : Code[100];
        Members: Record Members;
        Employers: Record "Employer Codes";
        Filters: Text;
        AgeingGroup: Text[100];
        RemainingPeriod, GroupSortingOrder : Integer;
        AsAtDate: Date;
        LoanAge: Integer;

}
//Fred
report 91008 "Cash With_Deposit Receipt "
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\Cash Receipt.rdl';
    dataset
    {
        dataitem("Teller Transactions"; "Teller Transactions")
        {
            column(Document_No; "Document No") { }

            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(Transaction_Type; "Transaction Type") { }
            column(Member_No; "Member No") { }
            column(Member_Name; "Member Name") { }
            column(Account_No; "Account No") { }
            column(Account_Name; "Account Name") { }
            column(Amount; Amount) { }
            column(Teller; Teller) { }
            column(Till; Till) { }
            column(Created_On; "Created On") { }
            column(Posting_Date; "Posting Date") { }
            column(Created_By; "Created By") { }
            column(AmountInWords; AmountInWords[1]) { }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                ObjCheck.FormatNoText(AmountInWords, Amount, 1033, 'KES');


            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        DateFilter: Text;
        AmountInWords: array[2] of Text[80];
        ObjCheck: Report "Check Translation Management";

}

report 91009 "Cash Withdrawal "
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\Cash Withdrawal Slip.rdl';
    dataset
    {
        dataitem("Teller Transactions"; "Teller Transactions")
        {
            column(Document_No; "Document No") { }

            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(Transaction_Type; "Transaction Type") { }
            column(Member_No; "Member No") { }
            column(Member_Name; "Member Name") { }
            column(Account_No; "Account No") { }
            column(Account_Name; "Account Name") { }
            column(Amount; Amount) { }
            column(Teller; Teller) { }
            column(Till; Till) { }
            column(Created_On; "Created On") { }
            column(Posting_Date; "Posting Date") { }
            column(Created_By; "Created By") { }
            column(AmountInWords; AmountInWords[1]) { }
            column(Charge_Code; "Charge Code") { }
            column(ChargeAount; ChargeAount) { }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                ObjCheck.FormatNoText(AmountInWords, Amount, 1033, 'KES');

                ChargeAount := 0;
                ObjCalcSchemes.reset;
                //ObjCalcSchemes.SetRange("Transaction Code","Charge Code");
                ObjCalcSchemes.SetRange("Charge Code", "Charge Code");
                if ObjCalcSchemes.FindSet() then begin
                    if ((Amount >= ObjCalcSchemes."Lower Limit") and (Amount <= ObjCalcSchemes."Upper Limit")) then
                        repeat
                            ChargeAount += ObjCalcSchemes.Rate;
                        until ObjCalcSchemes.next = 0;

                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        DateFilter: Text;
        AmountInWords: array[2] of Text[80];
        ObjCheck: Report "Check Translation Management";
        ChargeAount: Decimal;
        ObjCharges: Record "Transaction Charges";
        ObjCalcSchemes: Record "Transaction Calc. Scheme";


}
//O4FPahuip1dm8SDKxVLv