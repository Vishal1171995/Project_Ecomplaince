using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Ecompliance.Utils;
using System.Data;
using Ecompliance.Repository;
using Ecompliance.ViewModel;
using System.Data.SqlClient;
using Ecompliance.Areas.Master.Models;
using System.ComponentModel.DataAnnotations;
using Quartz;
using System.Threading.Tasks;
using System.Threading;
using System.Text;
using System.Net;
using System.Collections.Specialized;
using System.Net.Http;
using System.Web.Mvc;
using Newtonsoft.Json.Linq;
using Ecompliance.Utils;
using Newtonsoft.Json;
using Ecompliance.Models;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.Areas.ACT2.Repository;

namespace Ecompliance.Utils
{
    public class Scheduler : Controller, IJob
    {



        //It will create normal schedule document
        public void StartScheduler()
        {

            SqlTransaction trans = null;
            SqlConnection con = null;
            try
            {
                string datetimestamp = DateTime.Now.Year.ToString() + DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString() + DateTime.Now.Hour.ToString() + DateTime.Now.Second.ToString();
                string date = DateTime.Now.Date.Day.ToString() + "/" + DateTime.Now.Month.ToString() + "/" + DateTime.Now.Year.ToString();
                int LogID = 0;
                Task<int> LogTask = System.Threading.Tasks.Task.Factory.StartNew<int>(() => InsertSchedulerLog(date));

                int SuccessCount = 0;
                int FailedCount = 0;
                int DuplicateCount = 0;


                DataTable dt = DataLib.ExecuteDataTable("[GetScheduledTask_New]", CommandType.StoredProcedure, null); //GetScheduledTask

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    con = new SqlConnection(Ecompliance.Utils.DataLib.GetConnectionString());
                    if (!(con.State == ConnectionState.Open))
                    {
                        con.Open();
                    }
                    trans = con.BeginTransaction();
                    string result = "";
                    try
                    {
                        TaskRepo objTaskrepo = new TaskRepo();
                        TaskVM objVM = new TaskVM();
                        objVM.MappingID = Convert.ToInt32(dt.Rows[i]["MappingID"].ToString());
                        objVM.ActID = Convert.ToInt32(dt.Rows[i]["ActID"].ToString());
                        objVM.ActivityID = Convert.ToInt32(dt.Rows[i]["ActivityID"].ToString());
                        objVM.ActivityType = dt.Rows[i]["ContractorID"].ToString() == "0" ? "PE" : "Contractor";
                        objVM.CompanyID = Convert.ToInt32(dt.Rows[i]["CompanyID"].ToString());
                        objVM.ContractorID = Convert.ToInt32(dt.Rows[i]["ContractorID"].ToString());
                        objVM.CreatedBy = 26;
                        objVM.Creation_Desc = "";
                        objVM.SiteID = Convert.ToInt32(dt.Rows[i]["SiteID"].ToString());
                        objVM.Creation_Remarks = "";
                        objVM.ExpiryDate = Convert.ToDateTime(dt.Rows[i]["ExpDate"].ToString());
                        objVM.TaskCreationDate = date;
                        objVM.Freq = "";
                        objVM.ActionType = dt.Rows[i]["ActionType"].ToString();
                        objVM.Applicable_To_Client = Convert.ToInt32(dt.Rows[i]["Applicable_To_Client"]);
                        var results = new List<ValidationResult>();
                        var vc = new ValidationContext(objVM, null, null);
                        var isValid = Validator.TryValidateObject(objVM, vc, results, true);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                        string strerr = string.Join(" ", errors);
                        if (isValid)
                        {
                            result = objTaskrepo.AddTask(objVM, con, trans);
                            trans.Commit();
                            con.Close();

                            if (Convert.ToInt32(result) > 0)
                            {
                                SuccessCount += 1;
                                int Year = DateTime.Now.Month == 1 ? DateTime.Now.Year - 1 : DateTime.Now.Year;
                                int Month = DateTime.Now.Month == 1 ? 12 : DateTime.Now.Month - 1;
                                DateTime Paydate = new DateTime(Year, Month, DateTime.DaysInMonth(Year, Month));
                                // InsertTaskFile(Convert.ToInt32(result), "2018-04-30", 22,90, 61, 19, 58, DateTime.Now.ToString("yyyy/MM/dd"), "Creation Failed");
                             int FileResponse=   InsertTaskFile(Convert.ToInt32(result), Paydate.ToString("yyyy-MM-dd"), Convert.ToInt32(dt.Rows[i]["State"].ToString()), objVM.CompanyID, objVM.SiteID, objVM.ActID, objVM.ActivityID, DateTime.Now.ToString("yyyy/MM/dd"), "Creation Failed");
                                //Move Task File into checker Bucket
                                //if(FileResponse==1)
                                //{
                                //    SqlParameter[] P = { new SqlParameter("@DOCID", result) };
                                //    string MovementRes = DataLib.ExecuteScaler("MoveToCheckerBucket", CommandType.StoredProcedure, P);
                                //}
                            }
                            else if (result != "-2")
                            {
                                SuccessCount += 1;
                            }
                            else if (result == "-6")
                            { DuplicateCount += 1; }
                            else
                            {
                                FailedCount += 1;
                                CreateFailedTaskLog(dt.Rows[i], result, datetimestamp, "StartScheduler");
                            }
                        }
                        else
                        {
                            FailedCount += 1;
                            CreateFailedTaskLog(dt.Rows[i], strerr, datetimestamp, "StartScheduler");
                        }

                    }
                    catch (Exception Ex)
                    {
                        trans.Rollback();
                        con.Close();
                        FailedCount += 1;
                        CreateFailedTaskLog(dt.Rows[i], Ex.Message, datetimestamp, "StartScheduler");
                        continue;
                    }
                }
                System.Threading.Tasks.Task.WhenAll(LogTask);
                LogID = LogTask.Result;
                InsertSchedulerLog(date, SuccessCount, FailedCount, DuplicateCount, LogID);
                TaskFileRepo filerepo = new TaskFileRepo();

                filerepo.SendMailsForFileErrLog();

                DataSet dsFailedRecord = GetFailedTasks(datetimestamp);
                string resultfilename = CSVUtills.DataTableToCSV(dsFailedRecord.Tables[0], ",");
                StringBuilder mailbody = new StringBuilder("");
                mailbody.Append(" <body><header style=\"width:996px; margin:auto;\"><div style=\"font-family:Arial, Helvetica, sans-serif; color:#444; font-size:18px;font-weight:bold;\"> ");
                mailbody.Append(" Dear User,       </div></header><section style=\"width:996px; margin:auto;\"><div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;\"><p>Scheduler Summary : <br/> Total Records - " + dt.Rows.Count + " <br /> ");
                mailbody.Append("   Successfull -" + SuccessCount + " <br />                Failed -" + FailedCount + "<br /> Duplicate -" + DuplicateCount + "<br /></p></div> ");
                mailbody.Append(" </section> <footer style=\"width:996px; margin:auto;\"> <div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;padding:5px 0px;\">Thanks & Regards <br> Team ACT Compliance</div> ");
                mailbody.Append(" </footer></body>");
                MailUtill.SendMail("amit.nehra@myndsol.com,ajeet.kumar@myndsol.com,vinod.tiwary@myndsol.com", "Normal Daily ECompliance Result", mailbody.ToString(), "", resultfilename, "");

            }
            catch
            {
                throw;
            }
            finally
            {
                if (con != null)
                {
                    con.Close();
                    trans.Dispose();
                }
            }
        }

        public void StartAsNeededScheduler()
        {
            SqlTransaction trans = null;
            SqlConnection con = null;
            try
            {
                string datetimestamp = DateTime.Now.Year.ToString() + DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString() + DateTime.Now.Hour.ToString() + DateTime.Now.Second.ToString();
                string date = DateTime.Now.Date.Day.ToString() + "/" + DateTime.Now.Month.ToString() + "/" + DateTime.Now.Year.ToString();
                int LogID = 0;
                Task<int> LogTask = System.Threading.Tasks.Task.Factory.StartNew<int>(() => InsertSchedulerLog(date));
                int SuccessCount = 0;
                int FailedCount = 0;
                int DuplicateCount = 0;
                DataTable dt = DataLib.ExecuteDataTable("[GetAsNeededScheduledTask_New]", CommandType.StoredProcedure, null); //GetAsNeededScheduledTask

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    con = new SqlConnection(Ecompliance.Utils.DataLib.GetConnectionString());
                    if (!(con.State == ConnectionState.Open))
                    {
                        con.Open();
                    }
                    trans = con.BeginTransaction();
                    string result = "";
                    try
                    {

                        TaskRepo objTaskrepo = new TaskRepo();
                        TaskVM objVM = new TaskVM();
                        objVM.ActID = Convert.ToInt32(dt.Rows[i]["ActID"].ToString());
                        objVM.MappingID = Convert.ToInt32(dt.Rows[i]["MappingID"].ToString());
                        objVM.ActivityID = Convert.ToInt32(dt.Rows[i]["ActivityID"].ToString());
                        objVM.ActivityType = dt.Rows[i]["ContractorID"].ToString() == "0" ? "PE" : "Contractor";
                        objVM.CompanyID = Convert.ToInt32(dt.Rows[i]["CompanyID"].ToString());
                        objVM.ContractorID = Convert.ToInt32(dt.Rows[i]["ContractorID"].ToString());
                        objVM.CreatedBy = 26;
                        objVM.Creation_Desc = "";
                        objVM.SiteID = Convert.ToInt32(dt.Rows[i]["SiteID"].ToString());
                        objVM.Creation_Remarks = "";
                        objVM.ExpiryDate = Convert.ToDateTime(dt.Rows[i]["ExpDate"].ToString());
                        objVM.TaskCreationDate = date;
                        objVM.ActionType = dt.Rows[i]["ActionType"].ToString();
                        objVM.Applicable_To_Client = Convert.ToInt32(dt.Rows[i]["Applicable_To_Client"]);
                        objVM.Freq = "";
                        var results = new List<ValidationResult>();
                        var vc = new ValidationContext(objVM, null, null);
                        var isValid = Validator.TryValidateObject(objVM, vc, results, true);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                        string strerr = string.Join(" ", errors);
                        if (isValid)
                        {
                            result = objTaskrepo.AddTask(objVM, con, trans);
                            trans.Commit();
                            con.Close();
                            if (result != "-2")
                            {
                                SuccessCount += 1;
                            }
                            else if (result == "-6")
                            { DuplicateCount += 1; }
                            else
                            {
                                FailedCount += 1;
                                CreateFailedTaskLog(dt.Rows[i], result, datetimestamp, "StartAsNeededScheduler");
                            }
                        }
                        else
                        {
                            FailedCount += 1;
                            CreateFailedTaskLog(dt.Rows[i], strerr, datetimestamp, "StartAsNeededScheduler");

                        }

                    }
                    catch (Exception Ex)
                    {
                        trans.Rollback();
                        con.Close();
                        FailedCount += 1;
                        CreateFailedTaskLog(dt.Rows[i], Ex.Message, datetimestamp, "StartAsNeededScheduler");
                        continue;
                    }
                }
                System.Threading.Tasks.Task.WhenAll(LogTask);
                LogID = LogTask.Result;
                InsertSchedulerLog(date, SuccessCount, FailedCount, DuplicateCount, LogID);
                DataSet dsFailedRecord = GetFailedTasks(datetimestamp);
                string resultfilename = CSVUtills.DataTableToCSV(dsFailedRecord.Tables[0], ",");
                StringBuilder mailbody = new StringBuilder("");
                mailbody.Append(" <body><header style=\"width:996px; margin:auto;\"><div style=\"font-family:Arial, Helvetica, sans-serif; color:#444; font-size:18px;font-weight:bold;\"> ");
                mailbody.Append(" Dear User,       </div></header><section style=\"width:996px; margin:auto;\"><div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;\"><p>Scheduler Summary : <br/> Total Records - " + dt.Rows.Count + " <br /> ");
                mailbody.Append("   Successfull -" + SuccessCount + " <br />                Failed -" + FailedCount + "<br /> Duplicate -" + DuplicateCount + "<br /></p></div> ");
                mailbody.Append(" </section> <footer style=\"width:996px; margin:auto;\"> <div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;padding:5px 0px;\">Thanks & Regards <br> Team ACT Compliance</div> ");
                mailbody.Append(" </footer></body>");
                MailUtill.SendMail("amit.nehra@myndsol.com,ajeet.kumar@myndsol.com,vinod.tiwary@myndsol.com", "Normal Daily ECompliance Result", mailbody.ToString(), "", resultfilename, "");
            }
            catch
            {
                throw;
            }
            finally
            {
                if (con != null)
                {
                    con.Close();
                    trans.Dispose();
                }
            }
        }


        //It will create normal schedule at particular Date
        public void StartSchedulerOnDate(string date)
        {

            SqlTransaction trans = null;
            SqlConnection con = null;
            try
            {
                string datetimestamp = DateTime.Now.Year.ToString() + DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString() + DateTime.Now.Hour.ToString() + DateTime.Now.Second.ToString();
                string[] date1 = date.Split('/');
                string date2 = date1[2] + "/" + date1[1] + "/" + date1[0];
                int LogID = 0;
                Task<int> LogTask = System.Threading.Tasks.Task.Factory.StartNew<int>(() => InsertSchedulerLog(date2));

                int SuccessCount = 0;
                int FailedCount = 0;
                int DuplicateCount = 0;
                //'2016-12-20'

                SqlParameter[] p =
                {
                    new SqlParameter("@Date", date)

                };
                DataTable dt = DataLib.ExecuteDataTable("[GetScheduledTask_OnDate_New]", CommandType.StoredProcedure, p); //GetScheduledTask_OnDate
                //DataTable dt = DataLib.ExecuteDataTable("[GetScheduledTask_OnDate000]", CommandType.StoredProcedure, p);

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    // trans = new SqlTransaction();
                    con = new SqlConnection(Ecompliance.Utils.DataLib.GetConnectionString());
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }

                    trans = con.BeginTransaction();
                    string result = "";
                    try
                    {
                        TaskRepo objTaskrepo = new TaskRepo();
                        TaskVM objVM = new TaskVM();
                        objVM.ActID = Convert.ToInt32(dt.Rows[i]["ActID"].ToString());
                        objVM.MappingID = Convert.ToInt32(dt.Rows[i]["MappingID"].ToString());
                        objVM.ActivityID = Convert.ToInt32(dt.Rows[i]["ActivityID"].ToString());
                        objVM.ActivityType = dt.Rows[i]["ContractorID"].ToString() == "0" ? "PE" : "Contractor";
                        objVM.CompanyID = Convert.ToInt32(dt.Rows[i]["CompanyID"].ToString());
                        objVM.ContractorID = Convert.ToInt32(dt.Rows[i]["ContractorID"].ToString());
                        objVM.CreatedBy = 26;
                        objVM.Creation_Desc = "";
                        objVM.SiteID = Convert.ToInt32(dt.Rows[i]["SiteID"].ToString());
                        objVM.Creation_Remarks = "";
                        objVM.Freq = "";
                        objVM.ExpiryDate = Convert.ToDateTime(dt.Rows[i]["ExpDate"].ToString());
                        objVM.TaskCreationDate = date2;
                        objVM.ActionType = dt.Rows[i]["ActionType"].ToString();
                        objVM.Applicable_To_Client = Convert.ToInt32(dt.Rows[i]["Applicable_To_Client"]);
                        var results = new List<ValidationResult>();
                        var vc = new ValidationContext(objVM, null, null);
                        var isValid = Validator.TryValidateObject(objVM, vc, results, true);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);

                        string strerr = string.Join(" ", errors);
                        if (isValid)
                        {
                            result = objTaskrepo.AddTask(objVM, con, trans);
                            trans.Commit();
                            //if (Convert.ToInt32(result) > 0)
                            //{
                            //  //  SuccessCount += 1;
                            //    // DateTime Paydate = new DateTime(2018, 04, DateTime.DaysInMonth(2018, 04));
                            //    DateTime Paydate = new DateTime(Convert.ToInt32(date1[2]), Convert.ToInt32(date1[1]), DateTime.DaysInMonth(Convert.ToInt32(date1[2]), Convert.ToInt32(date1[1])));
                            //    // InsertTaskFile(Convert.ToInt32(result), "2018-04-30", 22,90, 61, 19, 58, DateTime.Now.ToString("yyyy/MM/dd"), "Creation Failed");
                            // //   InsertTaskFile(Convert.ToInt32(result), Paydate.ToString("yyyy-MM-dd"), Convert.ToInt32(dt.Rows[i]["State"].ToString()), objVM.CompanyID, objVM.SiteID, objVM.ActID, objVM.ActivityID, DateTime.Now.ToString("yyyy/MM/dd"), "Creation Failed");

                            //}
                            //else
                            if (result != "-2")
                            {
                                SuccessCount += 1;
                            }
                            else if (result == "-6")
                            {
                                DuplicateCount += 1;
                            }
                            else
                            {
                                FailedCount += 1;
                                CreateFailedTaskLog(dt.Rows[i], result, datetimestamp, "StartSchedulerOnDate");
                            }
                        }
                        else
                        {
                            FailedCount += 1;
                            CreateFailedTaskLog(dt.Rows[i], strerr, datetimestamp, "StartSchedulerOnDate");
                        }
                        con.Dispose();
                    }
                    catch (Exception Ex)
                    {
                        trans.Rollback();
                        FailedCount += 1;
                        CreateFailedTaskLog(dt.Rows[i], Ex.Message, datetimestamp, "StartSchedulerOnDate");
                        con.Dispose();
                        continue;
                    }

                }
                System.Threading.Tasks.Task.WhenAll(LogTask);
                LogID = LogTask.Result;
                InsertSchedulerLog(date2, SuccessCount, FailedCount, DuplicateCount, LogID);
                DataSet dsFailedRecord = GetFailedTasks(datetimestamp);
                string resultfilename = CSVUtills.DataTableToCSV(dsFailedRecord.Tables[0], ",");
                StringBuilder mailbody = new StringBuilder("");
                mailbody.Append(" <body><header style=\"width:996px; margin:auto;\"><div style=\"font-family:Arial, Helvetica, sans-serif; color:#444; font-size:18px;font-weight:bold;\"> ");
                mailbody.Append(" Dear User,       </div></header><section style=\"width:996px; margin:auto;\"><div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;\"><p>Scheduler Summary : <br/> Total Records - " + dt.Rows.Count + " <br /> ");
                mailbody.Append("   Successfull -" + SuccessCount + " <br />                Failed -" + FailedCount + "<br /> Duplicate -" + DuplicateCount + "<br /></p></div> ");
                mailbody.Append(" </section> <footer style=\"width:996px; margin:auto;\"> <div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;padding:5px 0px;\">Thanks & Regards <br> Team ACT Compliance</div> ");
                mailbody.Append(" </footer></body>");
                MailUtill.SendMail("amit.nehra@myndsol.com,ajeet.kumar@myndsol.com,vinod.tiwary@myndsol.com", "ECompliance Scheduler on Date Result", mailbody.ToString(), "", resultfilename, "");

            }
            catch (Exception ex)
            {
                // throw;
            }
            finally
            {
                if (con != null)
                {
                    con.Close();
                    trans.Dispose();
                }
            }

        }


        //It will create all task document based on Effective Date
        public void StartSchedulerOnEffectiveDate()
        {
            SqlTransaction trans = null;
            SqlConnection con = null;
            try
            {
                //Getting Datetime for inserting it into scheduler log
                string datetimestamp = DateTime.Now.Year.ToString() + DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString() + DateTime.Now.Hour.ToString() + DateTime.Now.Second.ToString();
                string date = DateTime.Now.Date.Day.ToString() + "/" + DateTime.Now.Month.ToString() + "/" + DateTime.Now.Year.ToString();
                int LogID = 0;
                //Inserting it into Scheduler Log Table
                Task<int> LogTask = System.Threading.Tasks.Task.Factory.StartNew<int>(() => InsertSchedulerLog(date, 0, 0, 0, 0, "EffectiveDateMapping"));
                int SuccessCount = 0;
                int FailedCount = 0;
                int DuplicateCount = 0;
                //Getting all the mapping with effective date

                DataTable dtMapping = DataLib.ExecuteDataTable("[GetAllEffectiveDateMappings_New]", CommandType.StoredProcedure, null); //GetAllEffectiveDateMappings
                con = new SqlConnection(Ecompliance.Utils.DataLib.GetConnectionString());

                string result = "";
                for (int i = 0; i < dtMapping.Rows.Count; i++)
                {

                    if (!(con.State == ConnectionState.Open))
                    {
                        con.Open();
                    }
                    trans = con.BeginTransaction();
                    try
                    {

                        int frequencyID = Convert.ToInt32(dtMapping.Rows[i]["Frequency"]);
                        int Reminddays = Convert.ToInt32(dtMapping.Rows[i]["RemindDays"]);
                        DateTime Startdate = Utils.DateUtils.GetFDate(dtMapping.Rows[i]["StartDate"].ToString());
                        DataTable dtscheduleddates = GetScheduledDates(frequencyID, Reminddays, Startdate);

                        for (int y = 0; y < dtscheduleddates.Rows.Count; y++)
                        {
                            DateTime Expdate = Utils.DateUtils.GetFDate(dtscheduleddates.Rows[y]["ScheduledDates"].ToString()).AddDays(Convert.ToInt32(dtMapping.Rows[i]["RemindDays"].ToString()));
                            try
                            {
                                TaskRepo objTaskrepo = new TaskRepo();
                                TaskVM objVM = new TaskVM();
                                objVM.ActID = Convert.ToInt32(dtMapping.Rows[i]["ActID"].ToString());
                                objVM.MappingID = Convert.ToInt32(dtMapping.Rows[i]["MappingID"].ToString());
                                objVM.ActivityID = Convert.ToInt32(dtMapping.Rows[i]["ActivityID"].ToString());
                                objVM.ActivityType = dtMapping.Rows[i]["ContractorID"].ToString() == "0" ? "PE" : "Contractor";
                                objVM.CompanyID = Convert.ToInt32(dtMapping.Rows[i]["CompanyID"].ToString());
                                objVM.ContractorID = Convert.ToInt32(dtMapping.Rows[i]["ContractorID"].ToString());
                                objVM.CreatedBy = 26;
                                objVM.Creation_Desc = "";
                                objVM.SiteID = Convert.ToInt32(dtMapping.Rows[i]["SiteID"].ToString());
                                objVM.Creation_Remarks = "";
                                objVM.ExpiryDate = Expdate;
                                objVM.TaskCreationDate = dtscheduleddates.Rows[y]["ScheduledDates"].ToString();
                                objVM.ActionType = dtMapping.Rows[i]["ActionType"].ToString();
                                objVM.Applicable_To_Client = Convert.ToInt32(dtMapping.Rows[i]["Applicable_To_Client"]);
                                objVM.Freq = "NotAsNeeded";
                                var results = new List<ValidationResult>();
                                var vc = new ValidationContext(objVM, null, null);
                                var isValid = Validator.TryValidateObject(objVM, vc, results, true);
                                var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                                string strerr = string.Join(" ", errors);

                                if (isValid)
                                {
                                    result = objTaskrepo.AddTask(objVM, con, trans);


                                    if (result != "-2")
                                    {
                                        SuccessCount += 1;
                                    }
                                    else if (result == "-6")
                                    {
                                        DuplicateCount += 1;
                                    }
                                    else
                                    {
                                        FailedCount += 1;
                                        CreateFailedTaskLog(dtMapping.Rows[i], result, datetimestamp, "StartSchedulerOnEffectiveDate");
                                    }
                                }
                                else
                                {
                                    FailedCount += 1;
                                    CreateFailedTaskLog(dtMapping.Rows[i], strerr, datetimestamp, "StartSchedulerOnEffectiveDate");
                                }

                            }
                            catch (Exception Ex)
                            {
                                trans.Rollback();
                                FailedCount += 1;
                                CreateFailedTaskLog(dtMapping.Rows[i], Ex.Message.ToString(), datetimestamp, "StartSchedulerOnEffectiveDate");
                                continue;
                            }

                        }

                        SqlParameter[] p = { new SqlParameter("@MappingId", Convert.ToInt32(dtMapping.Rows[i]["MappingID"])) };
                        DataLib.ExecuteScaler("UpdateEffectiveMapping", CommandType.StoredProcedure, p, con, trans);
                        trans.Commit();
                    }
                    catch (Exception Ex)
                    {

                        trans.Rollback();
                        FailedCount += 1;
                        DataRow dr = dtMapping.Rows[i];
                        CreateFailedTaskLog(dtMapping.Rows[i], Ex.Message.ToString(), datetimestamp, "StartSchedulerOnEffectiveDate");
                        continue;
                    }

                }


                System.Threading.Tasks.Task.WhenAll(LogTask);
                LogID = LogTask.Result;
                InsertSchedulerLog(date, SuccessCount, FailedCount, DuplicateCount, LogID, "EffectiveDateMapping");
                DataSet dsFailedRecord = GetFailedTasks(datetimestamp);
                string resultfilename = CSVUtills.DataTableToCSV(dsFailedRecord.Tables[0], ",");
                StringBuilder mailbody = new StringBuilder("");
                mailbody.Append(" <body><header style=\"width:996px; margin:auto;\"><div style=\"font-family:Arial, Helvetica, sans-serif; color:#444; font-size:18px;font-weight:bold;\"> ");
                mailbody.Append(" Dear User,       </div></header><section style=\"width:996px; margin:auto;\"><div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;\"><p>Scheduler Summary : <br/> Total Records - " + dtMapping.Rows.Count + " <br /> ");
                mailbody.Append("   Successfull -" + SuccessCount + " <br />                Failed -" + FailedCount + "<br /> Duplicate -" + DuplicateCount + "<br /> </p></div> ");
                mailbody.Append(" </section> <footer style=\"width:996px; margin:auto;\"> <div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;padding:5px 0px;\">Thanks & Regards <br> Team ACT Compliance</div> ");
                mailbody.Append(" </footer></body>");
                MailUtill.SendMail("amit.nehra@myndsol.com,ajeet.kumar@myndsol.com,vinod.tiwary@myndsol.com", "ECompliance Effective Date Scheduler Result", mailbody.ToString(), "", resultfilename, "");
            }
            catch
            {
                throw;
            }
            finally
            {
                con.Close();
                trans.Dispose();
            }
        }

        public DataTable GetScheduledMapping(DataTable dtMapping)
        {
            ActivityRepo repactivity = new ActivityRepo();
            DataTable dtMappingnew = dtMapping.Clone();
            try
            {
                for (int i = 0; i < dtMapping.Rows.Count; i++)
                {
                    int frequencyID = Convert.ToInt32(dtMapping.Rows[i]["Frequency"]);
                    int Reminddays = Convert.ToInt32(dtMapping.Rows[i]["RemindDays"]);
                    DateTime Startdate = Utils.DateUtils.GetFDate(dtMapping.Rows[i]["EffectiveDate"].ToString());
                    DataTable dtscheduleddates = GetScheduledDates(frequencyID, Reminddays, Startdate);
                    for (int y = 0; y < dtscheduleddates.Rows.Count; y++)
                    {
                        DataRow row = dtMapping.Rows[i];
                        row.ItemArray[6] = "";
                        DataRow rownew = dtMappingnew.NewRow();
                        dtMappingnew.ImportRow(row);
                        dtMappingnew.Rows[dtMappingnew.Rows.Count - 1]["StartDate"] = dtscheduleddates.Rows[y][0].ToString();
                    }
                }

                return dtMappingnew;
            }
            catch (Exception ex)
            {
                dtMappingnew.Clear();
                return dtMappingnew;
            }
        }
        public DataSet GetFailedTasks(string IDToken)
        {

            DataTable dtFailedRecords = new DataTable();
            try
            {
                SqlParameter[] p =
                {

                    new SqlParameter("@IDToken", IDToken)
                };
                return DataLib.ExecuteDataSet("[GetFailedTasks]", CommandType.StoredProcedure, p);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public DataTable GetScheduledDates(int frequencyID, int RemindDays, DateTime StartDate)
        {

            DataTable dt = new DataTable();
            dt.Columns.Add("ScheduledDates", typeof(string));

            //  StartDate = StartDate.AddYears(DateTime.Now.Year - StartDate.Year);
            switch (frequencyID)
            {
                case 1://HalfYearly

                    for (int i = 0; (StartDate.AddMonths(i).Date < DateTime.Now.Date); i = i + 6)
                    {
                        dt.Rows.Add((StartDate.AddMonths(i).AddDays(-RemindDays)).ToString("dd/MM/yyyy"));
                    }

                    break;
                case 3://Once inTwo YEar
                    for (int i = 0; (StartDate.AddYears(i).Date < DateTime.Now.Date); i = i + 2)
                    {
                        dt.Rows.Add((StartDate.AddYears(i).AddDays(-RemindDays)).ToString("dd/MM/yyyy"));
                    }

                    break;
                case 5: // Weekly

                    for (int i = 0; i <= (DateTime.IsLeapYear(StartDate.Year) == true ? 366 : 365) && (StartDate.AddDays(i).Date < DateTime.Now.Date); i = i + 7)
                    {
                        dt.Rows.Add(StartDate.AddDays(i).ToString("dd/MM/yyyy"));

                    }

                    break;
                case 6:// Quarterly

                    for (int i = 0; (StartDate.AddMonths(i).Date < DateTime.Now.Date); i = i + 3)
                    {
                        dt.Rows.Add((StartDate.AddMonths(i).AddDays(-RemindDays)).ToString("dd/MM/yyyy"));
                    }

                    break;

                case 7://Yearly
                    for (int i = 0; (StartDate.AddYears(i).Date < DateTime.Now.Date); i = i + 1)
                    {
                        dt.Rows.Add((StartDate.AddYears(i).AddDays(-RemindDays)).ToString("dd/MM/yyyy"));
                    }

                    break;
                case 8:// Monthly

                    for (int i = 0; (StartDate.AddMonths(i).Date < DateTime.Now.Date); i = i + 1)
                    {
                        dt.Rows.Add((StartDate.AddMonths(i).AddDays(-RemindDays)).ToString("dd/MM/yyyy"));
                    }

                    break;
            }


            return dt;
        }
        private void CreateFailedTaskLog(DataRow dr, string Result, string IDToken, string SchedulerType)
        {
            try
            {
                SiteActivityMappingSchedulerLog model = new SiteActivityMappingSchedulerLog();
                model.MappingID = Convert.ToString(dr["MappingID"].ToString());
                model.ActID = Convert.ToString(dr["ActID"].ToString() == "" ? "0" : dr["ActID"].ToString());
                model.ActivityID = Convert.ToString(dr["ActivityID"].ToString() == "" ? "0" : dr["ActivityID"].ToString());
                model.Checker = Convert.ToString(dr["Checker"].ToString() == "" ? "0" : dr["Checker"].ToString());
                model.CompanyID = Convert.ToString(dr["CompanyID"].ToString() == "" ? "0" : dr["CompanyID"].ToString());
                model.ContractorID = Convert.ToString(dr["ContractorID"].ToString() == "" ? "0" : dr["ContractorID"].ToString());
                model.StartDate = Convert.ToString((dr["StartDate"].ToString()));
                model.Maker = Convert.ToString(dr["Maker"].ToString() == "" ? "0" : dr["Maker"].ToString());
                model.RemindDays = Convert.ToString(dr["RemindDays"].ToString() == "" ? "0" : dr["RemindDays"].ToString());
                model.SiteID = Convert.ToString(dr["SiteID"].ToString() == "" ? "0" : dr["SiteID"].ToString());

                ErrorLogRepo.InsertTaskCreationErrLog(model, Result, IDToken, SchedulerType);
            }
            catch { }
        }
        private int InsertSchedulerLog(string Date, int Success = 0, int Failed = 0, int Duplicate = 0, int Tid = 0, string SchedulerName = "Task Scheduler")
        {
            try
            {

                SqlParameter[] p =
                {
                    new SqlParameter("@Date", Date),
                    new SqlParameter("@Success", Success),
                    new SqlParameter("@Failed", Failed),
                    new SqlParameter("@Duplicate", Duplicate),
                    new SqlParameter("@TID", Tid),
                    new SqlParameter("@SchedulerName", SchedulerName)
                };
                int tid = Convert.ToInt32(DataLib.ExecuteScaler("[AddUpdateSchedulerLog]", CommandType.StoredProcedure, p));

                return tid;

            }
            catch { return 0; }
        }

        //It will Create 
        public void AlertToTaskScheduler()
        {
            string strerr = "";
            string Result = "";
            int SuccessCount = 0;
            int FailedCount = 0;
            int DuplicateCount = 0;
            string date = DateTime.Now.Date.Day.ToString() + "/" + DateTime.Now.Month.ToString() + "/" + DateTime.Now.Year.ToString();
            string datetimestamp = DateTime.Now.Year.ToString() + DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString() + DateTime.Now.Hour.ToString() + DateTime.Now.Second.ToString();
            SqlTransaction trans = null;
            SqlConnection con = null;
            try
            {
                DataTable Dt = new DataTable();
                TaskVM obj = new TaskVM();
                int LogID = 0;
                Task<int> LogTask = System.Threading.Tasks.Task.Factory.StartNew<int>(() => InsertSchedulerLog(date, 0, 0, 0, 0, "Alert To Task Scheduler"));

                SqlParameter[] p = null;
                TaskRepo ObjTRepo = new TaskRepo();
                Dt = DataLib.ExecuteDataTable("GetAsNeededSheduled_New", CommandType.StoredProcedure, p);  //GetAsNeededSheduled

                for (int i = 0; i < Dt.Rows.Count; i++)
                {
                    con = new SqlConnection(Ecompliance.Utils.DataLib.GetConnectionString());
                    con.Open();
                    trans = con.BeginTransaction();
                    try
                    {
                        obj.DOCID = 0;//Convert.ToInt32(Dt.Rows[i]["DOCID"]);
                        obj.MappingID = Convert.ToInt32(Dt.Rows[i]["MappingID"]);
                        obj.ActivityType = Dt.Rows[i]["ActivityType"].ToString();
                        obj.CompanyID = Convert.ToInt32(Dt.Rows[i]["CompanyID"].ToString());
                        obj.SiteID = Convert.ToInt32(Dt.Rows[i]["SiteID"]);
                        obj.ActID = Convert.ToInt32(Dt.Rows[i]["ActID"]);
                        obj.ActivityID = Convert.ToInt32(Dt.Rows[i]["ActivityID"]);
                        obj.ContractorID = Convert.ToInt32(Dt.Rows[i]["ContractorID"]);
                        obj.Creation_Desc = Dt.Rows[i]["Creation_Desc"].ToString();
                        obj.Creation_Remarks = Dt.Rows[i]["Creation_Remarks"].ToString();
                        obj.CreatedBy = Convert.ToInt32(Dt.Rows[i]["CreatedBy"]);
                        obj.ExpiryDate = Convert.ToDateTime(Dt.Rows[i]["Expiry_Date"]);
                        obj.RemindDays = Convert.ToInt32(Dt.Rows[i]["RemindDays"]);
                        obj.ActionType = Dt.Rows[i]["ActionType"].ToString();
                        obj.Applicable_To_Client = Convert.ToInt32(Dt.Rows[i]["Applicable_To_Client"]);
                        var results = new List<ValidationResult>();
                        var vc = new ValidationContext(obj, null, null);
                        var isValid = Validator.TryValidateObject(obj, vc, results, true);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                        strerr = string.Join(" ", errors);
                        if (isValid)
                        {
                            Result = ObjTRepo.AddTask(obj, con, trans);
                            trans.Commit();
                            if (Result != "-5")
                            {
                                SqlParameter[] p1 =
                                {
                                    new SqlParameter("@DOCID", Convert.ToInt32(Dt.Rows[i]["DOCID"])),
                                    new SqlParameter("@TaskID", Result),
                                };
                                DataLib.ExecuteScaler("SetAsneededShedulerSuccess", CommandType.StoredProcedure, p1);
                                SuccessCount++;
                            }
                            else
                            {

                                CreateFailedTaskLog(Dt.Rows[i], Result, datetimestamp, "AlertToTaskScheduler");
                                FailedCount++;
                            }
                        }
                        else
                        {
                            FailedCount++;
                            trans.Rollback();
                            CreateFailedTaskLog(Dt.Rows[i], strerr, datetimestamp, "AlertToTaskScheduler");
                        }
                    }
                    catch (Exception Ex)
                    {
                        trans.Rollback();
                        CreateFailedTaskLog(Dt.Rows[i], Ex.Message, datetimestamp, "AlertToTaskScheduler");
                        FailedCount++;
                    }
                }
                System.Threading.Tasks.Task.WhenAll(LogTask);
                LogID = LogTask.Result;
                //InsertSchedulerLog(date, SuccessCount, FailedCount, LogID);
                InsertSchedulerLog(date, SuccessCount, FailedCount, DuplicateCount, LogID);
                DataSet dsFailedRecord = GetFailedTasks(datetimestamp);
                string resultfilename = CSVUtills.DataTableToCSV(dsFailedRecord.Tables[0], ",");
                StringBuilder mailbody = new StringBuilder("");
                mailbody.Append(" <body><header style=\"width:996px; margin:auto;\"><div style=\"font-family:Arial, Helvetica, sans-serif; color:#444; font-size:18px;font-weight:bold;\"> ");
                mailbody.Append(" Dear User,       </div></header><section style=\"width:996px; margin:auto;\"><div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;\"><p>Scheduler Summary : <br/> Total Records - " + Dt.Rows.Count + " <br /> ");
                mailbody.Append("   Successfull -" + SuccessCount + " <br />                Failed -" + FailedCount + "<br /> Duplicate -" + DuplicateCount + "<br /></p></div> ");
                mailbody.Append(" </section> <footer style=\"width:996px; margin:auto;\"> <div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;padding:5px 0px;\">Thanks & Regards <br> Team ACT Compliance</div> ");
                mailbody.Append(" </footer></body>");
                MailUtill.SendMail("amit.nehra@myndsol.com,ajeet.kumar@myndsol.com,vinod.tiwary@myndsol.com", "ECompliance Alert To Task Scheduler", mailbody.ToString(), "", resultfilename, "");
            }
            catch
            {
                throw;
            }
            finally
            {
                if (con != null)
                {
                    con.Close();
                    trans.Dispose();
                }
            }
        }

        public void Execute(IJobExecutionContext context)
        {
            try
            {
                StartScheduler();
            }
            catch { }
            try
            {
                StartSchedulerOnEffectiveDate();

            }
            catch { }
            try
            {
                AlertToTaskScheduler();
            }
            catch { }

            try
            {
                EmailScheduler.DailylyMailScheduler();
            }
            catch
            { }

        }

        public void ExecuteScheduler()
        {
            try
            {
                StartScheduler();
            }
            catch { }
            try
            {
                StartSchedulerOnEffectiveDate();

            }
            catch { }
            try
            {
                AlertToTaskScheduler();
            }
            catch { }

        }

        //public void Execute()
        //{
        //    try
        //    {
        //        StartScheduler();
        //    }
        //    catch { }
        //    try
        //    {
        //        AlertToTaskScheduler();
        //    }
        //    catch { }
        //    try
        //    {
        //        StartSchedulerOnEffectiveDate();
        //    }
        //    catch { }

        //}

        #region base64
        public int InsertTaskFile(int DOCID, string paydate, int StateID, int CompanyID, int SiteID, int ActID, int ActivityID, string TaskDate = null, string Status = null)
        {
            Response ret = new Response();
            int result = 0;
            TaskFileRepo repo = new TaskFileRepo();
            try
            {
                
                string FileName = "";
                Response str = new Response();
                GenerateRepRepo objReportRepo = new GenerateRepRepo();
                GenerateRepRepo.Reportdata BaseReport;
                BaseReport = objReportRepo.GenerateReport(paydate, StateID, CompanyID, SiteID, ActID, ActivityID);
               
                if (BaseReport.Base64string != "")
                {
                    string fileExt = GetFileExtension(BaseReport.Base64string);
                    if (fileExt == "")
                        fileExt = ".xls";
                    FileName = DateTime.Now.Year.ToString() + DateTime.Now.Month + DateTime.Now.Date.DayOfYear + DateTime.Now.Hour + DateTime.Now.Minute + DateTime.Now.Second + DateTime.Now.Millisecond;
                    FileName = FileName.Replace(fileExt, string.Empty);
                    FileName = FileName + fileExt;
                    string DescName = BaseReport.FileName + fileExt;
                    string path = System.Web.HttpContext.Current.Server.MapPath("~/Docs/Task/") + FileName;
                    // arrstr.SaveAs(path);
                    System.IO.File.WriteAllBytes(path, Convert.FromBase64String(BaseReport.Base64string));
                    TaskFile Model = new TaskFile();
                    Model.FileID = 0;
                    Model.DOCID = DOCID;
                    Model.Name = FileName;
                    Model.Desc = DescName;
                    Model.UAction = "Movement";
                    Model.UID = 26;
                    var results = new List<ValidationResult>();
                    var vc = new ValidationContext(Model, null, null);
                    var isValid = Validator.TryValidateObject(Model, vc, results);
                    var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                    if (isValid)
                    {
                        TaskFileRepo ObjRep = new TaskFileRepo();
                        ObjRep.InsertTaskFile(Model);
                        result = 1;
                        ret.IsSuccess = true;
                        SqlParameter[] P = { new SqlParameter("@DOCID", DOCID) };
                        string MovementRes = DataLib.ExecuteScaler("MoveToCheckerBucket", CommandType.StoredProcedure, P);
                    }
                    else
                    {
                        result = -2;
                        ret.IsSuccess = false;
                        ret.Data = "Upload failed";
                        ret.Message = "Upload failed";
                    }

                }
                else {
                    result = -1;
                    InsertTaskFileERRLog(DOCID, paydate, StateID, CompanyID, SiteID, ActID, ActivityID, "File Not Found", TaskDate, Status);
                }

                return result;

            }
            catch { return result; }


        }
        private int InsertTaskFileERRLog(int DOCID, string paydate, int StateID, int CompanyID, int SiteID, int ActID, int ActivityID, string Reason, string TaskDate = null, string Status = null)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@DOCID", DOCID),
                    new SqlParameter("@Paydate", paydate),
                    new SqlParameter("@StateID", StateID),
                    new SqlParameter("@CompanyID", CompanyID),
                    new SqlParameter("@SiteID", SiteID),
                    new SqlParameter("@ActID", ActID),
                    new SqlParameter("@ActivityID", ActivityID),
                     new SqlParameter("@TaskDate", TaskDate==""?null:TaskDate),
                    new SqlParameter("@Reason", Reason),
                     new SqlParameter("@Status", Status)

                };
                int tid = Convert.ToInt32(DataLib.ExecuteScaler("[InsertTaskFileErrLog]", CommandType.StoredProcedure, p));

                return tid;

            }
            catch (Exception ex)
            { return 0; }
        }
        public static string GetFileExtension(string base64String)
        {
            var data = base64String.Substring(0, 5);

            switch (data.ToUpper())
            {
                case "IVBOR":
                    return ".png";
                case "/9J/4":
                    return ".jpg";
                case "AAAAF":
                    return ".mp4";
                case "JVBER":
                    return ".pdf";
                case "AAABA":
                    return ".ico";
                case "UMFYI":
                    return ".rar";
                case "E1XYD":
                    return ".rtf";
                case "U1PKC":
                    return ".txt";
                case "MQOWM":
                case "77U/M":
                    return ".srt";
                default:
                    return string.Empty;
            }
        }
        #endregion
    }
}