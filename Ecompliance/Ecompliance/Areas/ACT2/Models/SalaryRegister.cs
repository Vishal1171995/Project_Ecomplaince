using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace Ecompliance.Areas.ACT2.Models
{
    public class SalaryRegister
    {
        public int UID { set; get; }
        [Required(ErrorMessage ="Paydate is required.")]
        public DateTime? Paydate { set; get; }
        [Required(ErrorMessage = "Company_code is required.")]
        public string Company_code { set; get; }
        [Required(ErrorMessage = "Site_Code is required.")]
        public string Site_Code { set; get; }
        [Required(ErrorMessage = "Employee_code is required.")]
        public string Employee_code { set; get; }
        public string Employee_Name { set; get; }
        public string F_H_Name { set; get; }
        public string Designation { set; get; }
        public string Gender { set; get; }
        public DateTime? DOB { set; get; }
        public DateTime? DOJ { set; get; }
        public DateTime? DOL { set; get; }
        public string EPF_No { set; get; }
        public string UAN { set; get; }
        public string Adhaar { set; get; }
        public string ESIC { set; get; }
        public string Bank_Account_No { set; get; }
        public string Bank_Name { set; get; }
        public string Present_Address { set; get; }
        public string Permanent_address { set; get; }
        public string Wage_Month { set; get; }
        public int Month_days { set; get; }
        public decimal Worked_Days { set; get; }
        public decimal Total_attendance_unit_of_workdone { set; get; }
        public decimal Pay_days { set; get; }
        public decimal Minimum_rate_of_wages { set; get; }
        public int Total_Hour_of_Overtime_During_Month { set; get; }
        public int Amount_of_Overtime { set; get; }
        public decimal Basic { set; get; }
        public decimal DA { set; get; }
        public decimal HRA { set; get; }
        public decimal Conv { set; get; }
        public decimal Special_Allow { set; get; }
        public decimal Medical_Allowance { set; get; }
        public decimal NFH_allowance { set; get; }
        public decimal Other_Allow { set; get; }
        public decimal Gratuity { set; get; }
        public decimal Total_Bonus { set; get; }
        public decimal Gross_Wages_Payable { set; get; }
        public decimal PF { set; get; }
        public decimal VPF { set; get; }
        public decimal ESI { set; get; }
        public decimal PTAX { set; get; }
        public decimal LWF { set; get; }
        public decimal INCOME_TAX { set; get; }
        public decimal House_Rent { set; get; }
        public string Deductions_if_any_and_reasons_thereof { set; get; }
        public decimal Loan { set; get; }
        public decimal Other_deduction { set; get; }
        public decimal Total_deduction { set; get; }
        public decimal NET_Wages_Payable { set; get; }
        public DateTime? Date_of_Payment { set; get; }
        public string Mode_of_Payment_Cash_Cheque_No { set; get; }
        public string Employee_signature_or_thumb_impression { set; get; }
        public string Remarks_Salary { set; get; }
        public decimal Cash_value_of_concessional_supply_of_essential_commodities { set; get; }
        public decimal Advance { set; get; }
        public string Date_and_Amount_of_Advance_Made { set; get; }
        public string Date_on_which_total_amount_is_recovered { set; get; }
        public string Purpose_for_which_advance_made { set; get; }
        public string Number_of_instalments_by_which_advance_tobe_repaid { set; get; }
        public string Postponements_granted { set; get; }
        public string Date_on_which_total_amount_repaid { set; get; }
        public decimal Damages_Loss { set; get; }
        public string Absence_from_duty_with_date { set; get; }
        public decimal Amount_of_deduction_imposed { set; get; }
        public string Damage_or_loss_caused_with_date { set; get; }
        public string Showed_cause_against_deduction_with_date { set; get; }
        public string Showed_cause_against_Deduction_with_date_and_person_in_presence { set; get; }
        public string Date_amount_of_deduction_imposed { set; get; }
        public string Number_of_instalment_if_any { set; get; }
        public string Date_on_which_total_amount_realised { set; get; }
        public decimal Fine { set; get; }
        public string Nature_and_date_of_the_offence_for_which_fine_imposed { set; get; }
        public string Showed_cause_against_fine_or_not_with_date { set; get; }
        public decimal Rate_of_Wages { set; get; }
        public string Date_and_amount_of_fine_imposed { set; get; }
        public string Date_which_fine_realised { set; get; }
        public decimal Overtime { set; get; }
        public string Dates_on_which_overtime_worked { set; get; }
        public string Extent_of_overtime_on_each_occasion { set; get; }
        public decimal Total_overtime_worked_or_production_in_case_of_piece_rated { set; get; }
        public decimal Overtime_rate_of_wages { set; get; }
        public decimal Normal_hours { set; get; }
        public decimal Normal_Rate { set; get; }
        public decimal Normal_earnings { set; get; }
        public decimal Overtime_earnings_total_Earning { set; get; }
        public string Date_on_which_overtime_wages_paid { set; get; }
        public string Date_on_which_overtime_payment_made { set; get; }
        public string Remarks_Other { set; get; }
        public decimal Leave_Encahsment { set; get; }


    }
}