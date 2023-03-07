using Ecompliance.Areas.ACT2.Models;
using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Ecompliance.Areas.ACT2.Repository
{
    public class UploadReportRepo
    {

        public int AddUpdateSalaryRegister(SalaryRegister model)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                  new SqlParameter("@UID", model.UID),
new SqlParameter("@Paydate", model.Paydate),
new SqlParameter("@Company_code", model.Company_code),
new SqlParameter("@Site_Code", model.Site_Code),
new SqlParameter("@Employee_code", model.Employee_code),
new SqlParameter("@Employee_Name", model.Employee_Name),
new SqlParameter("@F_H_Name", model.F_H_Name),
new SqlParameter("@Designation", model.Designation),
new SqlParameter("@Gender", model.Gender),
new SqlParameter("@DOB", model.DOB),
new SqlParameter("@DOJ", model.DOJ),
new SqlParameter("@DOL", model.DOL),
new SqlParameter("@EPF_No", model.EPF_No),
new SqlParameter("@UAN", model.UAN),
new SqlParameter("@Adhaar", model.Adhaar),
new SqlParameter("@ESIC", model.ESIC),
new SqlParameter("@Bank_Account_No", model.Bank_Account_No),
new SqlParameter("@Bank_Name", model.Bank_Name),
new SqlParameter("@Present_Address", model.Present_Address),
new SqlParameter("@Permanent_address", model.Permanent_address),
new SqlParameter("@Wage_Month", model.Wage_Month),
new SqlParameter("@Month_days", model.Month_days),
new SqlParameter("@Worked_Days", model.Worked_Days),
new SqlParameter("@Total_attendance_unit_of_workdone", model.Total_attendance_unit_of_workdone),
new SqlParameter("@Pay_days", model.Pay_days),
new SqlParameter("@Minimum_rate_of_wages", model.Minimum_rate_of_wages),
new SqlParameter("@Total_Hour_of_Overtime_During_Month", model.Total_Hour_of_Overtime_During_Month),
new SqlParameter("@Amount_of_Overtime", model.Amount_of_Overtime),
new SqlParameter("@Basic", model.Basic),
new SqlParameter("@DA", model.DA),
new SqlParameter("@HRA", model.HRA),
new SqlParameter("@Conv", model.Conv),
new SqlParameter("@Special_Allow", model.Special_Allow),
new SqlParameter("@Medical_Allowance", model.Medical_Allowance),
new SqlParameter("@NFH_allowance", model.NFH_allowance),
new SqlParameter("@Other_Allow", model.Other_Allow),
new SqlParameter("@Gratuity", model.Gratuity),
new SqlParameter("@Total_Bonus", model.Total_Bonus),
new SqlParameter("@Gross_Wages_Payable", model.Gross_Wages_Payable),
new SqlParameter("@PF", model.PF),
new SqlParameter("@VPF", model.VPF),
new SqlParameter("@ESI", model.ESI),
new SqlParameter("@PTAX", model.PTAX),
new SqlParameter("@LWF", model.LWF),
new SqlParameter("@INCOME_TAX", model.INCOME_TAX),
new SqlParameter("@House_Rent", model.House_Rent),
new SqlParameter("@Deductions_if_any_and_reasons_thereof", model.Deductions_if_any_and_reasons_thereof),
new SqlParameter("@Loan", model.Loan),
new SqlParameter("@Other_deduction", model.Other_deduction),
new SqlParameter("@Total_deduction", model.Total_deduction),
new SqlParameter("@NET_Wages_Payable", model.NET_Wages_Payable),
new SqlParameter("@Date_of_Payment", model.Date_of_Payment),
new SqlParameter("@Mode_of_Payment_Cash_Cheque_No", model.Mode_of_Payment_Cash_Cheque_No),
new SqlParameter("@Employee_signature_or_thumb_impression", model.Employee_signature_or_thumb_impression),
new SqlParameter("@Remarks_Salary", model.Remarks_Salary),
new SqlParameter("@Cash_value_of_concessional_supply_of_essential_commodities", model.Cash_value_of_concessional_supply_of_essential_commodities),
new SqlParameter("@Advance", model.Advance),
new SqlParameter("@Date_and_Amount_of_Advance_Made", model.Date_and_Amount_of_Advance_Made),
new SqlParameter("@Date_on_which_total_amount_is_recovered", model.Date_on_which_total_amount_is_recovered),
new SqlParameter("@Purpose_for_which_advance_made", model.Purpose_for_which_advance_made),
new SqlParameter("@Number_of_instalments_by_which_advance_tobe_repaid", model.Number_of_instalments_by_which_advance_tobe_repaid),
new SqlParameter("@Postponements_granted", model.Postponements_granted),
new SqlParameter("@Date_on_which_total_amount_repaid", model.Date_on_which_total_amount_repaid),
new SqlParameter("@Damages_Loss", model.Damages_Loss),
new SqlParameter("@Absence_from_duty_with_date", model.Absence_from_duty_with_date),
new SqlParameter("@Amount_of_deduction_imposed", model.Amount_of_deduction_imposed),
new SqlParameter("@Damage_or_loss_caused_with_date", model.Damage_or_loss_caused_with_date),
new SqlParameter("@Showed_cause_against_deduction_with_date", model.Showed_cause_against_deduction_with_date),
new SqlParameter("@Showed_cause_against_Deduction_with_date_and_person_in_presence", model.Showed_cause_against_Deduction_with_date_and_person_in_presence),
new SqlParameter("@Date_amount_of_deduction_imposed", model.Date_amount_of_deduction_imposed),
new SqlParameter("@Number_of_instalment_if_any", model.Number_of_instalment_if_any),
new SqlParameter("@Date_on_which_total_amount_realised", model.Date_on_which_total_amount_realised),
new SqlParameter("@Fine", model.Fine),
new SqlParameter("@Nature_and_date_of_the_offence_for_which_fine_imposed", model.Nature_and_date_of_the_offence_for_which_fine_imposed),
new SqlParameter("@Showed_cause_against_fine_or_not_with_date", model.Showed_cause_against_fine_or_not_with_date),
new SqlParameter("@Rate_of_Wages", model.Rate_of_Wages),
new SqlParameter("@Date_and_amount_of_fine_imposed", model.Date_and_amount_of_fine_imposed),
new SqlParameter("@Date_which_fine_realised", model.Date_which_fine_realised),
new SqlParameter("@Overtime", model.Overtime),
new SqlParameter("@Dates_on_which_overtime_worked", model.Dates_on_which_overtime_worked),
new SqlParameter("@Extent_of_overtime_on_each_occasion", model.Extent_of_overtime_on_each_occasion),
new SqlParameter("@Total_overtime_worked_or_production_in_case_of_piece_rated", model.Total_overtime_worked_or_production_in_case_of_piece_rated),
new SqlParameter("@Overtime_rate_of_wages", model.Overtime_rate_of_wages),
new SqlParameter("@Normal_hours", model.Normal_hours),
new SqlParameter("@Normal_Rate", model.Normal_Rate),
new SqlParameter("@Normal_earnings", model.Normal_earnings),
new SqlParameter("@Overtime_earnings_total_Earning", model.Overtime_earnings_total_Earning),
new SqlParameter("@Date_on_which_overtime_wages_paid", model.Date_on_which_overtime_wages_paid),
new SqlParameter("@Date_on_which_overtime_payment_made", model.Date_on_which_overtime_payment_made),
new SqlParameter("@Remarks_Other", model.Remarks_Other),
new SqlParameter("@Leave_Encahsment", model.Leave_Encahsment)

                };
                return Convert.ToInt32(DataLib.ExecuteScaler("AddUpdateSalaryRegisterNew", CommandType.StoredProcedure, parameters));
            }
            catch
            {
                throw;
            }
        }
        public int AddUpdateMusterRolldata(MusterRolldata model)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@UID",model.UID),
new SqlParameter("@Paydate ", model.Paydate),
new SqlParameter("@Company_Code ", model.Company_Code),
new SqlParameter("@Site_Code ", model.Site_Code),
new SqlParameter("@Employee_code ", model.Employee_code),
new SqlParameter("@Opening_Time ", model.Opening_Time),
new SqlParameter("@Lunch_Time ", model.Lunch_Time),
new SqlParameter("@Closing_Time ", model.Closing_Time),
new SqlParameter("@d1 ", model.d1),
new SqlParameter("@d2 ", model.d2),
new SqlParameter("@d3 ", model.d3),
new SqlParameter("@d4 ", model.d4),
new SqlParameter("@d5 ", model.d5),
new SqlParameter("@d6 ", model.d6),
new SqlParameter("@d7 ", model.d7),
new SqlParameter("@d8 ", model.d8),
new SqlParameter("@d9 ", model.d9),
new SqlParameter("@d10 ", model.d10),
new SqlParameter("@d11 ", model.d11),
new SqlParameter("@d12 ", model.d12),
new SqlParameter("@d13 ", model.d13),
new SqlParameter("@d14 ", model.d14),
new SqlParameter("@d15 ", model.d15),
new SqlParameter("@d16 ", model.d16),
new SqlParameter("@d17 ", model.d17),
new SqlParameter("@d18 ", model.d18),
new SqlParameter("@d19 ", model.d19),
new SqlParameter("@d20 ", model.d20),
new SqlParameter("@d21 ", model.d21),
new SqlParameter("@d22 ", model.d22),
new SqlParameter("@d23 ", model.d23),
new SqlParameter("@d24 ", model.d24),
new SqlParameter("@d25 ", model.d25),
new SqlParameter("@d26 ", model.d26),
new SqlParameter("@d27 ", model.d27),
new SqlParameter("@d28 ", model.d28),
new SqlParameter("@d29 ", model.d29),
new SqlParameter("@d30 ", model.d30),
new SqlParameter("@d31 ", model.d31),
new SqlParameter("@Total_Attendance ", model.Total_Attendance),
new SqlParameter("@Remarks ", model.Remarks),
new SqlParameter("@Date_overtime_extent_of_overtime_each_day ", model.Date_overtime_extent_of_overtime_each_day),
new SqlParameter("@Opening_Blance_PL ", model.Opening_Blance_PL),
new SqlParameter("@Earned_during_month_PL ", model.Earned_during_month_PL),
new SqlParameter("@Availed_during_month_PL ", model.Availed_during_month_PL),
new SqlParameter("@Closing_Blance_PL ", model.Closing_Blance_PL),
new SqlParameter("@Leave_Availed_Date_PL ", model.Leave_Availed_Date_PL),
new SqlParameter("@Date_of_Application_of_Leave_PL ", model.Date_of_Application_of_Leave_PL),
new SqlParameter("@Opening_Blance_CL ", model.Opening_Blance_CL),
new SqlParameter("@Earned_during_month_CL ", model.Earned_during_month_CL),
new SqlParameter("@Availed_during_month_CL ", model.Availed_during_month_CL),
new SqlParameter("@Closing_Blance_CL ", model.Closing_Blance_CL),
new SqlParameter("@Leave_Availed_Date_CL ", model.Leave_Availed_Date_CL),
new SqlParameter("@Date_of_Application_of_Leave_CL ", model.Date_of_Application_of_Leave_CL),
new SqlParameter("@Opening_Blance_SL ", model.Opening_Blance_SL),
new SqlParameter("@Earned_during_month_SL ", model.Earned_during_month_SL),
new SqlParameter("@Availed_during_month_SL ", model.Availed_during_month_SL),
new SqlParameter("@Closing_Blance_SL ", model.Closing_Blance_SL),
new SqlParameter("@Leave_Availed_Date_SL ", model.Leave_Availed_Date_SL),
new SqlParameter("@Date_of_Application_of_Leave_SL ", model.Date_of_Application_of_Leave_SL),
new SqlParameter("@Opening_Blance_ML ", model.Opening_Blance_ML),
new SqlParameter("@Availed_during_month_ML ", model.Availed_during_month_ML),
new SqlParameter("@Closing_Blance_ML ", model.Closing_Blance_ML),
new SqlParameter("@Leave_Availed_Date_ML ", model.Leave_Availed_Date_ML),
new SqlParameter("@Date_of_Application_of_Leave_ML ", model.Date_of_Application_of_Leave_ML),
new SqlParameter("@Weekly_Company_Holidays ", model.Weekly_Company_Holidays),
new SqlParameter("@Date_Of_Leaving ", model.Date_Of_Leaving),
new SqlParameter("@Worked_Hours ", model.Worked_Hours),
new SqlParameter("@Yearly_Company_Holidays ", model.Yearly_Company_Holidays),
                };
                return Convert.ToInt32(DataLib.ExecuteScaler("AddUpdateMusterRollDataNew", CommandType.StoredProcedure, parameters));
            }
            catch
            {
                throw;
            }
        }

       
        public bool CheckColumnFormatSalary(string FilePath, string SampleFilePath)
        {
            bool ret = true;
            DataTable dt = CSVUtills.CSVToDataTable(SampleFilePath, '|');
            DataTable dt2 = CSVUtills.CSVHeaderToDataTable(FilePath, '|');

            for (int i = 0; i < dt.Columns.Count; i++)
            {
                if (!(dt2.Columns.Contains(dt.Columns[i].ColumnName)))
                {
                    ret = false;
                    return ret;
                }
            }
            return ret;
        }

        public string UploadSalaryRegister(string FilePath, string SampleFilePath, int CreatedBy, ref int SuccessCount, ref int FailCount)
        {
            try
            {
                //Convert csv file into DataTable
                DataTable dt = null;
                try
                {
                    dt = CSVUtills.CSVToDataTable(FilePath, '|');
                }
                catch (Exception Ex)
                {
                    return Ex.Message;
                }

                if (!CheckColumnFormatSalary(FilePath, SampleFilePath))
                {
                    return "Invalid File Format";
                }
                dt.Columns.Add("Response");
                dt.Columns.Add("Message");

                SalaryRegister Model;
                GenerateReportRepo objSalaryRep = new GenerateReportRepo();


                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    //Only checking Required validation using View Model
                    try
                    {
                        string strerr = "";
                        Model = new SalaryRegister();
                        //Model.TID = Convert.ToInt32((dt.Rows[i]["TID"]).ToString().Replace("\"", ""));
                        Model.UID = CreatedBy;
                        if (Convert.ToString(dt.Rows[i]["Paydate"]) == "" || dt.Rows[i]["Paydate"] == null)
                        {
                            Model.Paydate = null;
                        }
                        else {
                            Model.Paydate = Convert.ToDateTime((dt.Rows[i]["Paydate"]).ToString().Replace("\"", "").Trim());
                        }

                        Model.Company_code = Convert.ToString((dt.Rows[i]["Company_code"]).ToString().Replace("\"", "").Trim());
                        Model.Site_Code = Convert.ToString((dt.Rows[i]["Site_Code"]).ToString().Replace("\"", "").Trim());
                        Model.Employee_code = Convert.ToString((dt.Rows[i]["Employee_code"]).ToString().Replace("\"", "").Trim());
                        Model.Employee_Name = Convert.ToString((dt.Rows[i]["Employee_Name"]).ToString().Replace("\"", "").Trim());
                        Model.F_H_Name = Convert.ToString((dt.Rows[i]["F_H_Name"]).ToString().Replace("\"", ""));
                        Model.Designation = Convert.ToString((dt.Rows[i]["Designation"]).ToString().Replace("\"", ""));
                        Model.Gender = Convert.ToString((dt.Rows[i]["Gender"]).ToString().Replace("\"", ""));
                        if (Convert.ToString(dt.Rows[i]["DOB"]) == "" || dt.Rows[i]["DOB"] == null)
                        {
                            Model.DOB = null;
                        }
                        else { Model.DOB = Convert.ToDateTime((dt.Rows[i]["DOB"]).ToString().Replace("\"", "")); }

                        if (Convert.ToString(dt.Rows[i]["DOJ"]) == "" || dt.Rows[i]["DOJ"] == null)
                        {
                            Model.DOJ = null;
                        }
                        else { Model.DOJ = Convert.ToDateTime((dt.Rows[i]["DOJ"]).ToString().Replace("\"", "")); }
                        if (Convert.ToString(dt.Rows[i]["DOL"]) == "" || dt.Rows[i]["DOL"] == null)
                        {
                            Model.DOL = null;
                        }
                        else { Model.DOL = Convert.ToDateTime((dt.Rows[i]["DOL"]).ToString().Replace("\"", "")); }
                        Model.EPF_No = Convert.ToString((dt.Rows[i]["EPF_No"]).ToString().Replace("\"", ""));
                        Model.UAN = Convert.ToString((dt.Rows[i]["UAN"]).ToString().Replace("\"", ""));
                        Model.Adhaar = Convert.ToString((dt.Rows[i]["Adhaar"]).ToString().Replace("\"", ""));
                        Model.ESIC = Convert.ToString((dt.Rows[i]["ESIC"]).ToString().Replace("\"", ""));
                        Model.Bank_Account_No = Convert.ToString((dt.Rows[i]["Bank_Account_No"]).ToString().Replace("\"", ""));
                        Model.Bank_Name = Convert.ToString((dt.Rows[i]["Bank_Name"]).ToString().Replace("\"", ""));
                        Model.Present_Address = Convert.ToString((dt.Rows[i]["Present_Address"]).ToString().Replace("\"", ""));
                        Model.Permanent_address = Convert.ToString((dt.Rows[i]["Permanent_address"]).ToString().Replace("\"", ""));
                        Model.Wage_Month = Convert.ToString((dt.Rows[i]["Wage_Month"]).ToString().Replace("\"", ""));
                        Model.Month_days = Convert.ToInt32((dt.Rows[i]["Month_days"]).ToString().Replace("\"", ""));
                        Model.Worked_Days = Convert.ToDecimal((dt.Rows[i]["Worked_Days"]).ToString().Replace("\"", ""));
                        Model.Total_attendance_unit_of_workdone = Convert.ToDecimal((dt.Rows[i]["Total_attendance_unit_of_workdone"]).ToString().Replace("\"", ""));
                        Model.Pay_days = Convert.ToDecimal((dt.Rows[i]["Pay_days"]).ToString().Replace("\"", ""));
                        Model.Minimum_rate_of_wages = Convert.ToDecimal((dt.Rows[i]["Minimum_rate_of_wages"]).ToString().Replace("\"", ""));
                        Model.Total_Hour_of_Overtime_During_Month = Convert.ToInt32((dt.Rows[i]["Total_Hour_of_Overtime_During_Month"]).ToString().Replace("\"", ""));
                        Model.Amount_of_Overtime = Convert.ToInt32((dt.Rows[i]["Amount_of_Overtime"]).ToString().Replace("\"", ""));
                        Model.Basic = Convert.ToDecimal((dt.Rows[i]["Basic"]).ToString().Replace("\"", ""));
                        Model.DA = Convert.ToDecimal((dt.Rows[i]["DA"]).ToString().Replace("\"", ""));
                        Model.HRA = Convert.ToDecimal((dt.Rows[i]["HRA"]).ToString().Replace("\"", ""));
                        Model.Conv = Convert.ToDecimal((dt.Rows[i]["Conv"]).ToString().Replace("\"", ""));
                        Model.Special_Allow = Convert.ToDecimal((dt.Rows[i]["Special_Allow"]).ToString().Replace("\"", ""));
                        Model.Medical_Allowance = Convert.ToDecimal((dt.Rows[i]["Medical_Allowance"]).ToString().Replace("\"", ""));
                        Model.NFH_allowance = Convert.ToDecimal((dt.Rows[i]["NFH_allowance"]).ToString().Replace("\"", ""));
                        Model.Other_Allow = Convert.ToDecimal((dt.Rows[i]["Other_Allow"]).ToString().Replace("\"", ""));
                        Model.Gratuity = Convert.ToDecimal((dt.Rows[i]["Gratuity"]).ToString().Replace("\"", ""));
                        Model.Total_Bonus = Convert.ToDecimal((dt.Rows[i]["Total_Bonus"]).ToString().Replace("\"", ""));
                        Model.Gross_Wages_Payable = Convert.ToDecimal((dt.Rows[i]["Gross_Wages_Payable"]).ToString().Replace("\"", ""));
                        Model.PF = Convert.ToDecimal((dt.Rows[i]["PF"]).ToString().Replace("\"", ""));
                        Model.VPF = Convert.ToDecimal((dt.Rows[i]["VPF"]).ToString().Replace("\"", ""));
                        Model.ESI = Convert.ToDecimal((dt.Rows[i]["ESI"]).ToString().Replace("\"", ""));
                        Model.PTAX = Convert.ToDecimal((dt.Rows[i]["PTAX"]).ToString().Replace("\"", ""));
                        Model.LWF = Convert.ToDecimal((dt.Rows[i]["LWF"]).ToString().Replace("\"", ""));
                        Model.INCOME_TAX = Convert.ToDecimal((dt.Rows[i]["INCOME_TAX"]).ToString().Replace("\"", ""));
                        Model.House_Rent = Convert.ToDecimal((dt.Rows[i]["House_Rent"]).ToString().Replace("\"", ""));
                        Model.Deductions_if_any_and_reasons_thereof = Convert.ToString((dt.Rows[i]["Deductions_if_any_and_reasons_thereof"]).ToString().Replace("\"", ""));
                        Model.Loan = Convert.ToDecimal((dt.Rows[i]["Loan"]).ToString().Replace("\"", ""));
                        Model.Other_deduction = Convert.ToDecimal((dt.Rows[i]["Other_deduction"]).ToString().Replace("\"", ""));
                        Model.Total_deduction = Convert.ToDecimal((dt.Rows[i]["Total_deduction"]).ToString().Replace("\"", ""));
                        Model.NET_Wages_Payable = Convert.ToDecimal((dt.Rows[i]["NET_Wages_Payable"]).ToString().Replace("\"", ""));

                        if (Convert.ToString(dt.Rows[i]["Date_of_Payment"]) == "" || dt.Rows[i]["Date_of_Payment"] == null)
                        {
                            Model.Date_of_Payment = null;
                        }
                        else { Model.Date_of_Payment = Convert.ToDateTime((dt.Rows[i]["Date_of_Payment"]).ToString().Replace("\"", "")); }

                        Model.Mode_of_Payment_Cash_Cheque_No = Convert.ToString((dt.Rows[i]["Mode_of_Payment_Cash_Cheque_No"]).ToString().Replace("\"", ""));
                        Model.Employee_signature_or_thumb_impression = Convert.ToString((dt.Rows[i]["Employee_signature_or_thumb_impression"]).ToString().Replace("\"", ""));
                        Model.Remarks_Salary = Convert.ToString((dt.Rows[i]["Remarks_Salary"]).ToString().Replace("\"", ""));
                        Model.Cash_value_of_concessional_supply_of_essential_commodities = Convert.ToDecimal((dt.Rows[i]["Cash_value_of_concessional_supply_of_essential_commodities"]).ToString().Replace("\"", ""));
                        Model.Advance = Convert.ToDecimal((dt.Rows[i]["Advance"]).ToString().Replace("\"", ""));
                        Model.Date_and_Amount_of_Advance_Made = Convert.ToString((dt.Rows[i]["Date_and_Amount_of_Advance_Made"]).ToString().Replace("\"", ""));
                        Model.Date_on_which_total_amount_is_recovered = Convert.ToString((dt.Rows[i]["Date_on_which_total_amount_is_recovered"]).ToString().Replace("\"", ""));
                        Model.Purpose_for_which_advance_made = Convert.ToString((dt.Rows[i]["Purpose_for_which_advance_made"]).ToString().Replace("\"", ""));
                        Model.Number_of_instalments_by_which_advance_tobe_repaid = Convert.ToString((dt.Rows[i]["Number_of_instalments_by_which_advance_tobe_repaid"]).ToString().Replace("\"", ""));
                        Model.Postponements_granted = Convert.ToString((dt.Rows[i]["Postponements_granted"]).ToString().Replace("\"", ""));
                        Model.Date_on_which_total_amount_repaid = Convert.ToString((dt.Rows[i]["Date_on_which_total_amount_repaid"]).ToString().Replace("\"", ""));
                        Model.Damages_Loss = Convert.ToDecimal((dt.Rows[i]["Damages_Loss"]).ToString().Replace("\"", ""));
                        Model.Absence_from_duty_with_date = Convert.ToString((dt.Rows[i]["Absence_from_duty_with_date"]).ToString().Replace("\"", ""));
                        Model.Amount_of_deduction_imposed = Convert.ToDecimal((dt.Rows[i]["Amount_of_deduction_imposed"]).ToString().Replace("\"", ""));
                        Model.Damage_or_loss_caused_with_date = Convert.ToString((dt.Rows[i]["Damage_or_loss_caused_with_date"]).ToString().Replace("\"", ""));
                        Model.Showed_cause_against_deduction_with_date = Convert.ToString((dt.Rows[i]["Showed_cause_against_deduction_with_date"]).ToString().Replace("\"", ""));
                        Model.Showed_cause_against_Deduction_with_date_and_person_in_presence = Convert.ToString((dt.Rows[i]["Showed_cause_against_Deduction_with_date_and_person_in_presence"]).ToString().Replace("\"", ""));
                        Model.Date_amount_of_deduction_imposed = Convert.ToString((dt.Rows[i]["Date_amount_of_deduction_imposed"]).ToString().Replace("\"", ""));
                        Model.Number_of_instalment_if_any = Convert.ToString((dt.Rows[i]["Number_of_instalment_if_any"]).ToString().Replace("\"", ""));
                        Model.Date_on_which_total_amount_realised = Convert.ToString((dt.Rows[i]["Date_on_which_total_amount_realised"]).ToString().Replace("\"", ""));
                        Model.Fine = Convert.ToDecimal((dt.Rows[i]["Fine"]).ToString().Replace("\"", ""));
                        Model.Nature_and_date_of_the_offence_for_which_fine_imposed = Convert.ToString((dt.Rows[i]["Nature_and_date_of_the_offence_for_which_fine_imposed"]).ToString().Replace("\"", ""));
                        Model.Showed_cause_against_fine_or_not_with_date = Convert.ToString((dt.Rows[i]["Showed_cause_against_fine_or_not_with_date"]).ToString().Replace("\"", ""));
                        Model.Rate_of_Wages = Convert.ToDecimal((dt.Rows[i]["Rate_of_Wages"]).ToString().Replace("\"", ""));
                        Model.Date_and_amount_of_fine_imposed = Convert.ToString((dt.Rows[i]["Date_and_amount_of_fine_imposed"]).ToString().Replace("\"", ""));
                        Model.Date_which_fine_realised = Convert.ToString((dt.Rows[i]["Date_which_fine_realised"]).ToString().Replace("\"", ""));
                        Model.Overtime = Convert.ToDecimal((dt.Rows[i]["Overtime"]).ToString().Replace("\"", ""));
                        Model.Dates_on_which_overtime_worked = Convert.ToString((dt.Rows[i]["Dates_on_which_overtime_worked"]).ToString().Replace("\"", ""));
                        Model.Extent_of_overtime_on_each_occasion = Convert.ToString((dt.Rows[i]["Extent_of_overtime_on_each_occasion"]).ToString().Replace("\"", ""));
                        Model.Total_overtime_worked_or_production_in_case_of_piece_rated = Convert.ToDecimal((dt.Rows[i]["Total_overtime_worked_or_production_in_case_of_piece_rated"]).ToString().Replace("\"", ""));
                        Model.Overtime_rate_of_wages = Convert.ToDecimal((dt.Rows[i]["Overtime_rate_of_wages"]).ToString().Replace("\"", ""));
                        Model.Normal_hours = Convert.ToDecimal((dt.Rows[i]["Normal_hours"]).ToString().Replace("\"", ""));
                        Model.Normal_Rate = Convert.ToDecimal((dt.Rows[i]["Normal_Rate"]).ToString().Replace("\"", ""));
                        Model.Normal_earnings = Convert.ToDecimal((dt.Rows[i]["Normal_earnings"]).ToString().Replace("\"", ""));
                        Model.Overtime_earnings_total_Earning = Convert.ToDecimal((dt.Rows[i]["Overtime_earnings_total_Earning"]).ToString().Replace("\"", ""));
                        Model.Date_on_which_overtime_wages_paid = Convert.ToString((dt.Rows[i]["Date_on_which_overtime_wages_paid"]).ToString().Replace("\"", ""));
                        Model.Date_on_which_overtime_payment_made = Convert.ToString((dt.Rows[i]["Date_on_which_overtime_payment_made"]).ToString().Replace("\"", ""));
                        Model.Remarks_Other = Convert.ToString((dt.Rows[i]["Remarks_Other"]).ToString().Replace("\"", ""));
                        Model.Leave_Encahsment = Convert.ToDecimal((dt.Rows[i]["Leave_Encahsment"]).ToString().Replace("\"", ""));

                        var results = new List<ValidationResult>();
                        var vc = new ValidationContext(Model, null, null);
                        var isValid = Validator.TryValidateObject(Model, vc, results, true);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                        strerr = string.Join(" ", errors);
                        if (isValid)
                        {
                            results = new List<ValidationResult>();
                            vc = new ValidationContext(Model, null, null);
                            isValid = Validator.TryValidateObject(Model, vc, results, true);
                            errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                            strerr = string.Join(" ", errors);
                            if (isValid)
                            {
                                int Result = Convert.ToInt32(AddUpdateSalaryRegister(Model));
                                if (Result >= 0)
                                {
                                    SuccessCount += 1;
                                    dt.Rows[i]["Response"] = "Success";
                                }
                                else
                                {
                                    FailCount += 1;
                                  
                                    if (Result == -1)
                                    {
                                        dt.Rows[i]["Message"] = "Duplicate";
                                    }
                                    if (Result == -4)
                                    {
                                        dt.Rows[i]["Message"] = "You have not right to insert this Site_Code.";
                                    }
                                    if (Result == -5)
                                    {
                                        dt.Rows[i]["Message"] = "You have not right to insert this Company_Code.";
                                    }
                                    if (Result == -6)
                                    {
                                        dt.Rows[i]["Message"] = "Please check Site_Code and Company_Code Combination.";
                                    }
                                    dt.Rows[i]["Response"] = "Failed";
                                }
                            }
                            else
                            {
                                FailCount += 1;
                                dt.Rows[i]["Response"] = strerr;
                            }
                        }
                        else
                        {
                            FailCount += 1;
                            dt.Rows[i]["Response"] = "Failed";
                            dt.Rows[i]["Message"] = strerr;
                            //Message
                        }
                    }
                    catch
                    {
                        FailCount += 1;
                        dt.Rows[i]["Response"] = "Failed";
                        dt.Rows[i]["Message"] = "Invalid Data Format";
                        continue;
                    }
                }
                //Converting dt into csv FIle
                FilePath = CSVUtills.DataTableToCSV(dt, "|");
                return FilePath;
            }
            catch
            {
                throw;
            }
        }

        public string UploadMusterRolldata(string FilePath, string SampleFilePath, int CreatedBy, ref int SuccessCount, ref int FailCount)
        {
            try
            {
                //Convert csv file into DataTable
                DataTable dt = null;
                try
                {
                    dt = CSVUtills.CSVToDataTable(FilePath, '|');
                }
                catch (Exception Ex)
                {
                    return Ex.Message;
                }

                if (!CheckColumnFormatSalary(FilePath, SampleFilePath))
                {
                    return "Invalid File Format";
                }
                dt.Columns.Add("Response");
                dt.Columns.Add("Message");

                MusterRolldata Model;
                GenerateReportRepo objSalaryRep = new GenerateReportRepo();


                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    try
                    {
                        string strerr = "";
                        Model = new MusterRolldata();
                        if (Convert.ToString(dt.Rows[i]["Paydate"]) == "" || dt.Rows[i]["Paydate"] == null)
                        {
                            Model.Paydate = null;
                        }
                        else { Model.Paydate = Convert.ToDateTime((dt.Rows[i]["Paydate"]).ToString().Replace("\"", "").Trim()); }
                        Model.UID = CreatedBy;
                        Model.Company_Code = Convert.ToString((dt.Rows[i]["Company_Code"]).ToString().Replace("\"", "").Trim());
                        Model.Site_Code = Convert.ToString((dt.Rows[i]["Site_Code"]).ToString().Replace("\"", "").Trim());
                        Model.Employee_code = Convert.ToString((dt.Rows[i]["Employee_code"]).ToString().Replace("\"", "").Trim());
                        Model.Opening_Time = Convert.ToString((dt.Rows[i]["Opening_Time"]).ToString().Replace("\"", ""));
                        Model.Lunch_Time = Convert.ToString((dt.Rows[i]["Lunch_Time"]).ToString().Replace("\"", ""));
                        Model.Closing_Time = Convert.ToString((dt.Rows[i]["Closing_Time"]).ToString().Replace("\"", ""));
                        Model.d1 = Convert.ToString((dt.Rows[i]["d1"]).ToString().Replace("\"", ""));
                        Model.d2 = Convert.ToString((dt.Rows[i]["d2"]).ToString().Replace("\"", ""));
                        Model.d3 = Convert.ToString((dt.Rows[i]["d3"]).ToString().Replace("\"", ""));
                        Model.d4 = Convert.ToString((dt.Rows[i]["d4"]).ToString().Replace("\"", ""));
                        Model.d5 = Convert.ToString((dt.Rows[i]["d5"]).ToString().Replace("\"", ""));
                        Model.d6 = Convert.ToString((dt.Rows[i]["d6"]).ToString().Replace("\"", ""));
                        Model.d7 = Convert.ToString((dt.Rows[i]["d7"]).ToString().Replace("\"", ""));
                        Model.d8 = Convert.ToString((dt.Rows[i]["d8"]).ToString().Replace("\"", ""));
                        Model.d9 = Convert.ToString((dt.Rows[i]["d9"]).ToString().Replace("\"", ""));
                        Model.d10 = Convert.ToString((dt.Rows[i]["d10"]).ToString().Replace("\"", ""));
                        Model.d11 = Convert.ToString((dt.Rows[i]["d11"]).ToString().Replace("\"", ""));
                        Model.d12 = Convert.ToString((dt.Rows[i]["d12"]).ToString().Replace("\"", ""));
                        Model.d13 = Convert.ToString((dt.Rows[i]["d13"]).ToString().Replace("\"", ""));
                        Model.d14 = Convert.ToString((dt.Rows[i]["d14"]).ToString().Replace("\"", ""));
                        Model.d15 = Convert.ToString((dt.Rows[i]["d15"]).ToString().Replace("\"", ""));
                        Model.d16 = Convert.ToString((dt.Rows[i]["d16"]).ToString().Replace("\"", ""));
                        Model.d17 = Convert.ToString((dt.Rows[i]["d17"]).ToString().Replace("\"", ""));
                        Model.d18 = Convert.ToString((dt.Rows[i]["d18"]).ToString().Replace("\"", ""));
                        Model.d19 = Convert.ToString((dt.Rows[i]["d19"]).ToString().Replace("\"", ""));
                        Model.d20 = Convert.ToString((dt.Rows[i]["d20"]).ToString().Replace("\"", ""));
                        Model.d21 = Convert.ToString((dt.Rows[i]["d21"]).ToString().Replace("\"", ""));
                        Model.d22 = Convert.ToString((dt.Rows[i]["d22"]).ToString().Replace("\"", ""));
                        Model.d23 = Convert.ToString((dt.Rows[i]["d23"]).ToString().Replace("\"", ""));
                        Model.d24 = Convert.ToString((dt.Rows[i]["d24"]).ToString().Replace("\"", ""));
                        Model.d25 = Convert.ToString((dt.Rows[i]["d25"]).ToString().Replace("\"", ""));
                        Model.d26 = Convert.ToString((dt.Rows[i]["d26"]).ToString().Replace("\"", ""));
                        Model.d27 = Convert.ToString((dt.Rows[i]["d27"]).ToString().Replace("\"", ""));
                        Model.d28 = Convert.ToString((dt.Rows[i]["d28"]).ToString().Replace("\"", ""));
                        Model.d29 = Convert.ToString((dt.Rows[i]["d29"]).ToString().Replace("\"", ""));
                        Model.d30 = Convert.ToString((dt.Rows[i]["d30"]).ToString().Replace("\"", ""));
                        Model.d31 = Convert.ToString((dt.Rows[i]["d31"]).ToString().Replace("\"", ""));
                        Model.Total_Attendance = Convert.ToDecimal((dt.Rows[i]["Total_Attendance"]).ToString().Replace("\"", ""));
                        Model.Remarks = Convert.ToString((dt.Rows[i]["Remarks"]).ToString().Replace("\"", ""));
                        Model.Date_overtime_extent_of_overtime_each_day = Convert.ToString((dt.Rows[i]["Date_overtime_extent_of_overtime_each_day"]).ToString().Replace("\"", ""));
                        Model.Opening_Blance_PL = Convert.ToDecimal((dt.Rows[i]["Opening_Blance_PL"]).ToString().Replace("\"", ""));
                        Model.Earned_during_month_PL = Convert.ToDecimal((dt.Rows[i]["Earned_during_month_PL"]).ToString().Replace("\"", ""));
                        Model.Availed_during_month_PL = Convert.ToDecimal((dt.Rows[i]["Availed_during_month_PL"]).ToString().Replace("\"", ""));
                        Model.Closing_Blance_PL = Convert.ToDecimal((dt.Rows[i]["Closing_Blance_PL"]).ToString().Replace("\"", ""));
                        Model.Leave_Availed_Date_PL = Convert.ToString((dt.Rows[i]["Leave_Availed_Date_PL"]).ToString().Replace("\"", ""));
                        Model.Date_of_Application_of_Leave_PL = Convert.ToString((dt.Rows[i]["Date_of_Application_of_Leave_PL"]).ToString().Replace("\"", ""));
                        Model.Opening_Blance_CL = Convert.ToDecimal((dt.Rows[i]["Opening_Blance_CL"]).ToString().Replace("\"", ""));
                        Model.Earned_during_month_CL = Convert.ToDecimal((dt.Rows[i]["Earned_during_month_CL"]).ToString().Replace("\"", ""));
                        Model.Availed_during_month_CL = Convert.ToDecimal((dt.Rows[i]["Availed_during_month_CL"]).ToString().Replace("\"", ""));
                        Model.Closing_Blance_CL = Convert.ToDecimal((dt.Rows[i]["Closing_Blance_CL"]).ToString().Replace("\"", ""));
                        Model.Leave_Availed_Date_CL = Convert.ToString((dt.Rows[i]["Leave_Availed_Date_CL"]).ToString().Replace("\"", ""));
                        Model.Date_of_Application_of_Leave_CL = Convert.ToString((dt.Rows[i]["Date_of_Application_of_Leave_CL"]).ToString().Replace("\"", ""));
                        Model.Opening_Blance_SL = Convert.ToDecimal((dt.Rows[i]["Opening_Blance_SL"]).ToString().Replace("\"", ""));
                        Model.Earned_during_month_SL = Convert.ToDecimal((dt.Rows[i]["Earned_during_month_SL"]).ToString().Replace("\"", ""));
                        Model.Availed_during_month_SL = Convert.ToDecimal((dt.Rows[i]["Availed_during_month_SL"]).ToString().Replace("\"", ""));
                        Model.Closing_Blance_SL = Convert.ToDecimal((dt.Rows[i]["Closing_Blance_SL"]).ToString().Replace("\"", ""));
                        Model.Leave_Availed_Date_SL = Convert.ToString((dt.Rows[i]["Leave_Availed_Date_SL"]).ToString().Replace("\"", ""));
                        Model.Date_of_Application_of_Leave_SL = Convert.ToString((dt.Rows[i]["Date_of_Application_of_Leave_SL"]).ToString().Replace("\"", ""));
                        Model.Opening_Blance_ML = Convert.ToDecimal((dt.Rows[i]["Opening_Blance_ML"]).ToString().Replace("\"", ""));
                        Model.Availed_during_month_ML = Convert.ToDecimal((dt.Rows[i]["Availed_during_month_ML"]).ToString().Replace("\"", ""));
                        Model.Closing_Blance_ML = Convert.ToDecimal((dt.Rows[i]["Closing_Blance_ML"]).ToString().Replace("\"", ""));
                        Model.Leave_Availed_Date_ML = Convert.ToString((dt.Rows[i]["Leave_Availed_Date_ML"]).ToString().Replace("\"", ""));
                        Model.Date_of_Application_of_Leave_ML = Convert.ToString((dt.Rows[i]["Date_of_Application_of_Leave_ML"]).ToString().Replace("\"", ""));
                        Model.Weekly_Company_Holidays = Convert.ToString((dt.Rows[i]["Weekly_Company_Holidays"]).ToString().Replace("\"", ""));
                        Model.Date_Of_Leaving = Convert.ToString((dt.Rows[i]["Date_Of_Leaving"]).ToString().Replace("\"", ""));
                        Model.Worked_Hours = Convert.ToDecimal((dt.Rows[i]["Worked_Hours"]).ToString().Replace("\"", ""));
                        Model.Yearly_Company_Holidays = Convert.ToString((dt.Rows[i]["Yearly_Company_Holidays"]).ToString().Replace("\"", ""));

                        var results = new List<ValidationResult>();
                        var vc = new ValidationContext(Model, null, null);
                        var isValid = Validator.TryValidateObject(Model, vc, results, true);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                        strerr = string.Join(" ", errors);
                        if (isValid)
                        {
                            results = new List<ValidationResult>();
                            vc = new ValidationContext(Model, null, null);
                            isValid = Validator.TryValidateObject(Model, vc, results, true);
                            errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                            strerr = string.Join(" ", errors);
                            if (isValid)
                            {
                                int Result = Convert.ToInt32(AddUpdateMusterRolldata(Model));
                                if (Result >= 0)
                                {
                                    SuccessCount += 1;
                                    dt.Rows[i]["Response"] = "Success";
                                }
                                else
                                {
                                    FailCount += 1;
                                    if (Result == -1)
                                    {
                                        dt.Rows[i]["Message"] = "Duplicate";
                                    }
                                    if (Result == -4)
                                    {
                                        dt.Rows[i]["Message"] = "You have not right to insert this Site_Code.";
                                    }
                                    if (Result == -5)
                                    {
                                        dt.Rows[i]["Message"] = "You have not right to insert this Company_Code.";
                                    }
                                    if (Result == -6)
                                    {
                                        dt.Rows[i]["Message"] = "Please check Site_Code and Company_Code Combination.";
                                    }
                                    dt.Rows[i]["Response"] = "Failed";
                                }
                            }
                            else
                            {
                                FailCount += 1;
                                dt.Rows[i]["Response"] = strerr;
                            }
                        }
                        else
                        {
                            FailCount += 1;
                            dt.Rows[i]["Response"] = "Failed";
                            dt.Rows[i]["Message"] = strerr;
                            //Message
                        }
                    }
                    catch
                    {
                        FailCount += 1;
                        dt.Rows[i]["Response"] = "Failed";
                        dt.Rows[i]["Message"] = "Invalid Data Format";
                        continue;
                    }
                }
                //Converting dt into csv FIle
                FilePath = CSVUtills.DataTableToCSV(dt, "|");
                return FilePath;
            }
            catch
            {
                throw;
            }
        }
    }
}