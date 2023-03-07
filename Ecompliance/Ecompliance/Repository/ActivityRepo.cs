using Ecompliance.Areas.Master.Models;
using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Hosting;
using System.ComponentModel.DataAnnotations;
using System.IO;
using System.Web.Mvc;



namespace Ecompliance.Repository
{
    public class ActivityRepo
    {
        public DataTable GetActivityList(Activity model)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@ActivityID",model.ActivityID ),
                    new SqlParameter("@ActID",model.Act ),
                    new SqlParameter("@IsAct",model.IsAct ),
                    new SqlParameter("@Name",model.Name )
                };
                return DataLib.ExecuteDataTable("[GetActivityList]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }

        public DataTable GetActivityHistory(Activity model)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]{new SqlParameter("@ActivityID",model.ActivityID )};
                return DataLib.ExecuteDataTable("[GetActivityHistory]", CommandType.StoredProcedure, parameters);
            }

            catch
            {
                throw;
            }
        }
        public DataSet GetActivitySnapShot()
        {
            try
            {
                SqlParameter[] parameters = null;
                return DataLib.ExecuteDataSet("GetActivitySnapShot", CommandType.StoredProcedure, parameters);
            }

            catch
            {
                throw;
            }
        }

        public int CreateUpdateActivity(Activity model)
        {
            try
            {
               // string[] strdate = model.StartDate.Split('/');
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@ActivityID", model.ActivityID ),
                    new SqlParameter("@Act", model.Act ),
                    new SqlParameter("@Ext_Exp_Date",model.Extendable_Exp_Date),
                    new SqlParameter("@Name", model.Name),
                    new SqlParameter("@Description",model.Activity_Desc),
                    new SqlParameter("@Frequency", model.Frequency),
                    new SqlParameter("@Date_Of_Month", model.Date_Of_Month),
                    new SqlParameter("@Month", model.Month),
                    new SqlParameter("@Year", model.Year),
                    new SqlParameter("@RemindDays", model.RemindDays),
                    new SqlParameter("@IsAct", model.IsAct ),
                    new SqlParameter("@UID", model.CreatedBy),
                    new SqlParameter("@Compliance_Nature", model.Compliance_Nature),
                     new SqlParameter("@StartDate", model.StartDate.Day.ToString() +"/"+ model.StartDate.Month.ToString()+"/"+ model.StartDate.Year.ToString())
                };
                return Convert.ToInt32(DataLib.ExecuteScaler("CreateUpdateActivity", CommandType.StoredProcedure, parameters));
            }
            catch
            {
                throw;
            }
        }

        public DataTable GetFrequencyList( int FrequencyID=0, int IsAct =0, string Frequency ="")
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@FrequencyID",FrequencyID ),
                    new SqlParameter("@IsAct",IsAct ),
                    new SqlParameter("@Frequency",Frequency )
                };
                return DataLib.ExecuteDataTable("[GetFrequencyList]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }
        public string DownLoadActivity(Activity model)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                   new SqlParameter("@ActivityID",model.ActivityID ),
                    new SqlParameter("@ActID",model.Act ),
                    new SqlParameter("@IsAct",model.IsAct )
                };

                dt = DataLib.ExecuteDataTable("[GetActivityList]", CommandType.StoredProcedure, parameters);
                return CSVUtills.DataTableToCSV(dt, ",");
            }
            catch { throw; }
        }

        public bool CheckColumnFormatActivity(string FilePath, string SampleFilePath)
        {
            bool ret = true;
            DataTable dt = CSVUtills.CSVToDataTable(SampleFilePath, ',');
            DataTable dt2 = CSVUtills.CSVHeaderToDataTable(FilePath, ',');
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                if ( ! (dt2.Columns.Contains(dt.Columns[i].ColumnName)))
                {
                    ret = false;
                    return ret;
                }
            }
             return ret;
        }
        
        public int GetMonthfromMonthNm(string MonthNm)
        {
            int month = 0;
            switch (MonthNm.ToUpper())
            {
                case "JANUARY" :
                    month = 1;
                    break;
                case "FEBRUARY":
                    month = 2;
                    break;
                case "MARCH":
                    month = 3;
                    break;
                case "APRIL":
                    month = 4;
                    break;
                case "MAY":
                    month = 5;
                    break;
                case "JUNE":
                    month = 6;
                    break;
                case "JULY":
                    month = 7;
                    break;
                case "AUGUST":
                    month = 8;
                    break;
                case "SEPTEMBER":
                    month = 9;
                    break;
                case "OCTOBER":
                    month = 10;
                    break;
                case "NOVEMBER":
                    month = 11;
                    break;
                case "DECEMBER":
                    month = 12;
                    break;
                default  : month =0;
                    break;
            }
            return month;
        }

        public string UploadActivity(string FilePath,string SampleFilePath, int CreatedBy,  ref int SuccessCount, ref int FailCount)
        {
            try
            {
                DataTable dt = null;
                try
                {
                    dt = CSVUtills.CSVToDataTable(FilePath, ',');
                }
                catch (Exception Ex)
                {
                    return Ex.Message;
                }
                if (!CheckColumnFormatActivity(FilePath, SampleFilePath))
                {
                    return "Invalid File Format";
                }
                dt.Columns.Add("Response");
                dt.Columns.Add("Message");

                Activity Model;

                ActivityVM VM;

                ActRepo objActRep = new ActRepo();
                Act MdlAct;
                string strerr="";
            

                ActivityRepo objActivityRep = new ActivityRepo();
              //  Activity MdlActivity;

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    //Only checking Required validation using View Model
                    try
                    {
                        VM = new ActivityVM();
                        VM.ActivityID = Convert.ToInt32((dt.Rows[i]["ActivityID"]).ToString().Replace("\"", ""));
                        //VM.Month = GetMonthfromMonthNm( Convert.ToString(dt.Rows[i]["Month"]).Replace("\"", ""));
                        VM.Activity_Desc = Convert.ToString(dt.Rows[i]["Activity_Desc"]).Replace("\"", "");
                        VM.Compliance_Nature = Convert.ToString(dt.Rows[i]["Compliance_Nature"]).Replace("\"", "");
                        VM.Act = Convert.ToString(dt.Rows[i]["Act"]).Replace("\"", "");
                        VM.Frequency = Convert.ToString(dt.Rows[i]["Frequency"]).Replace("\"", "");
                        VM.Name = Convert.ToString(dt.Rows[i]["Name"]).Replace("\"", "");
                        VM.StartDate = DateUtils.GetFDate(dt.Rows[i]["StartDate"].ToString().Replace("\"", ""));
                       // VM.Year =Convert.ToInt32(  dt.Rows[i]["Year"].ToString().Replace("\"", ""));
                        VM.RemindDays = Convert.ToInt32((dt.Rows[i]["RemindDays"]).ToString().Replace("\"", ""));
                        VM.IsAct = Convert.ToBoolean( dt.Rows[i]["Status"].ToString().Replace("\"", "")== "1"? true:false);
                        VM.Extendable_Exp_Date = Convert.ToBoolean(dt.Rows[i]["Extendable_Exp_Date"].ToString().Replace("\"", "") == "1" ? true : false);
                        VM.CreatedBy = CreatedBy;
                        var results = new List<ValidationResult>();
                        var vc = new ValidationContext(VM, null, null);
                        var isValid = Validator.TryValidateObject(VM, vc, results, true);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                        strerr=string.Join(" ",errors);
                        if (isValid)
                        {
                            Model = new Activity();
                            Model.ActivityID = Convert.ToInt32((dt.Rows[i]["ActivityID"]).ToString().Replace("\"", ""));

                                //Getting ActId from DataBase
                            MdlAct = new Act();                        
                            MdlAct.Short_Name = VM.Act;
                            MdlAct.IsAct = true;
                            MdlAct.ActID = 0;
                            DataTable dtAct = objActRep.GetActList(MdlAct);
                            if (dtAct.Rows.Count > 0)
                            {
                                Model.Act = Convert.ToInt32(dtAct.Rows[0]["ActID"].ToString().Replace("\"", ""));
                            }
                            else
                            {
                                Model.Act = -1;
                            }
                            //Now Getting FrequencyID From DataBase
                            string Frequency = (dt.Rows[i]["Frequency"]).ToString().Replace("\"", "");
                            DataTable dtfrequency = objActivityRep.GetFrequencyList(0,1, Frequency);
                             if (dtfrequency.Rows.Count > 0)
                            {
                                Model.Frequency = Convert.ToInt32(dtfrequency.Rows[0]["FrequencyID"].ToString().Replace("\"", ""));
                            }
                            else
                            {
                                Model.Frequency = -1;
                            }
                            Model.Name = VM.Name;
                            Model.Activity_Desc = VM.Activity_Desc;
                            Model.Compliance_Nature = VM.Compliance_Nature;
                            Model.Date_Of_Month = VM.Date_Of_Month;
                            Model.Year =  VM.Year;
                            Model.Month = VM.Month;
                            Model.RemindDays = VM.RemindDays;
                            Model.IsAct = VM.IsAct;
                            Model.Extendable_Exp_Date = VM.Extendable_Exp_Date;
                            Model.CreatedBy = VM.CreatedBy;
                            Model.StartDate = VM.StartDate;

                            results = new List<ValidationResult>();
                            vc = new ValidationContext(Model, null, null);
                            isValid = Validator.TryValidateObject(Model, vc, results,true);
                            errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                            strerr = string.Join(" ", errors);
                            if (isValid)
                            {
                                int Result = Convert.ToInt32(CreateUpdateActivity(Model));
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
                FilePath = CSVUtills.DataTableToCSV(dt, ",");
                return FilePath;
            }
            catch
            {
                throw;
            }
        }
        public DataTable GetScheduledDates(int frequencyID , int RemindDays, DateTime  StartDate)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ScheduledDates", typeof(string));
            dt.Columns.Add("Day", typeof(string));
            StartDate = StartDate.AddYears(DateTime.Now.Year - StartDate.Year);
            switch (frequencyID)
            {
                case 1:
                    if(StartDate >= DateTime.Now.Date && StartDate <= DateTime.Now.AddYears(1).Date)
                    dt.Rows.Add(StartDate.ToString("dd/MM/yyyy"), StartDate.DayOfWeek.ToString());
                    if (StartDate.AddMonths(6).Date >= DateTime.Now.Date && StartDate.AddMonths(6).Date <= DateTime.Now.AddYears(1).Date)
                    {
                        dt.Rows.Add(StartDate.AddMonths(6).ToString("dd/MM/yyyy"),StartDate.AddMonths(6).DayOfWeek.ToString());
                    }
                    break;
                case 3:
                    if (StartDate >= DateTime.Now.Date && StartDate <= DateTime.Now.AddYears(1).Date)
                    dt.Rows.Add(StartDate.ToString("dd/MM/yyyy"), StartDate.DayOfWeek.ToString());
                    break;
                case 5:

                    for (int i = 0; i <= (DateTime.IsLeapYear(StartDate.Year) == true ? 366 : 365) && (StartDate.AddDays(i).Date >= DateTime.Now.Date && StartDate.AddDays(i).Date <= DateTime.Now.AddYears(1).Date); i = i + 7)
                    {
                        dt.Rows.Add(StartDate.AddDays(i).ToString("dd/MM/yyyy"), StartDate.AddDays(i).DayOfWeek.ToString());

                    }
                    break;
                case 6:

                    for (int i = 0; (i <= 9 && StartDate.AddDays(i).Date >= DateTime.Now.Date && StartDate.AddDays(i).Date <= DateTime.Now.AddYears(1).Date); i = i + 3)
                    {
                        dt.Rows.Add(StartDate.AddMonths(i).ToString("dd/MM/yyyy"), StartDate.AddMonths(i).DayOfWeek.ToString());
                    }
                    break;
               
                case 7:
                    if (StartDate >= DateTime.Now.Date && StartDate <= DateTime.Now.AddYears(1).Date)
                    dt.Rows.Add(StartDate.ToString("dd/MM/yyyy"), StartDate.DayOfWeek.ToString());
                    break;
                case 8:
                    if (StartDate >= DateTime.Now.Date && StartDate <= DateTime.Now.AddYears(1).Date)
                    dt.Rows.Add(StartDate.ToString("dd/MM/yyyy"), StartDate.DayOfWeek.ToString());
                    for (int i = 1; (i <= 12 && StartDate.AddMonths(i).Date >= DateTime.Now.Date && StartDate.AddMonths(i).Date <= DateTime.Now.AddYears(1).Date); i++)
                    {
                        dt.Rows.Add(StartDate.AddMonths(i).ToString("dd/MM/yyyy"), StartDate.AddMonths(i).DayOfWeek.ToString());
                    }
                    break;
            }
           

            return dt;
        }

    }
}