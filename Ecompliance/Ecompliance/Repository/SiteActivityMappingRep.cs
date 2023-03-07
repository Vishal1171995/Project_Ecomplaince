using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using Ecompliance.Utils;
using Ecompliance.Areas.Master.Models;
using System.Web.Hosting;
using System.ComponentModel.DataAnnotations;
using Ecompliance.Areas.Admin.Models;

namespace Ecompliance.Repository
{
    public class SiteActivityMappingRep
    {
        #region Download
        public string  DownloadAllMapping(string SiteIDs, string ActIDs, string ContractorIds)
        {
            try
            {
                DataSet ds = new DataSet();
                SqlParameter[] p = new SqlParameter[] { new SqlParameter("@SiteID", SiteIDs), new SqlParameter("@ACTID", ActIDs), new SqlParameter("@Contractor", ContractorIds) };
                ds = DataLib.ExecuteDataSet("GetALLMapping", CommandType.StoredProcedure, p);
                return CSVUtills.DataTableToCSV(ds.Tables[0], ",");
            }
            catch
            {
                throw;
            }
        }


        public string DownloadAllScheduled(string SiteIDs, string ActIDs, string ContractorIds)
        {
            try
            {
                DataSet ds = new DataSet();
                SqlParameter[] p = new SqlParameter[] { new SqlParameter("@SiteID", SiteIDs), new SqlParameter("@ACTID", ActIDs), new SqlParameter("@Contractor", ContractorIds) };
                ds = DataLib.ExecuteDataSet("GetALLScheduledMapping", CommandType.StoredProcedure, p);
                return CSVUtills.DataTableToCSV(ds.Tables[0], ",");
            }
            catch
            {
                throw;
            }
        }
        public string DownloadAllUnScheduled(string SiteIDs, string ActIDs, string ContractorIds)
        {
            try
            {
                DataSet ds = new DataSet();
                SqlParameter[] p = new SqlParameter[] { new SqlParameter("@SiteID", SiteIDs), new SqlParameter("@ACTID", ActIDs), new SqlParameter("@Contractor", ContractorIds) };
                ds = DataLib.ExecuteDataSet("GetALLUnscheduledMapping", CommandType.StoredProcedure, p);
                return CSVUtills.DataTableToCSV(ds.Tables[0], ",");
            }
            catch
            {
                throw;
            }
        }
        public string DownloadAllInActive(string SiteIDs, string ActIDs, string ContractorIds)
        {
            try
            {
                DataSet ds = new DataSet();
                SqlParameter[] p = new SqlParameter[] { new SqlParameter("@SiteID", SiteIDs), new SqlParameter("@ACTID", ActIDs), new SqlParameter("@Contractor", ContractorIds) };
                ds = DataLib.ExecuteDataSet("[GetALLInactiveMapping]", CommandType.StoredProcedure, p);
                return CSVUtills.DataTableToCSV(ds.Tables[0], ",");
            }
            catch
            {
                throw;
            }
        } 

        public DataSet GetMappingCount(string SiteIDs, string ActIDs, string ContractorIds)
        {
            try
            {
                DataSet ds = new DataSet();
                SqlParameter[] p = new SqlParameter[] { new SqlParameter("@SiteID", SiteIDs), new SqlParameter("@ACTID", ActIDs), new SqlParameter("@Contractor", ContractorIds) };
                ds = DataLib.ExecuteDataSet("GetMappingCount", CommandType.StoredProcedure, p);
                return ds;
            }
            catch
            {
                throw;
            }
        }

        public DataSet GetALLActiveMapping(string SiteIDs, string ActIDs, string ContractorIds)
        {
            try
            {
                DataSet ds = new DataSet();
                SqlParameter[] p = new SqlParameter[]
                { new SqlParameter("@SiteID", SiteIDs), new SqlParameter("@ACTID", ActIDs), new SqlParameter("@Contractor", ContractorIds) };
                ds = DataLib.ExecuteDataSet("GetMappingCount", CommandType.StoredProcedure, p);
                return ds;
            }
            catch
            {
                throw;
            }
        }


        public DataSet GetALLInActiveMapping(string SiteIDs, string ActIDs, string ContractorIds)
        {
            try
            {
                DataSet ds = new DataSet();
                SqlParameter[] p = new SqlParameter[] 
                { new SqlParameter("@SiteID", SiteIDs), new SqlParameter("@ACTID", ActIDs), new SqlParameter("@Contractor", ContractorIds) };
                ds = DataLib.ExecuteDataSet("GetMappingCount", CommandType.StoredProcedure, p);
                return ds;
            }
            catch
            {
                throw;
            }
        }


        public DataSet GetRemainingMapp(string SiteIDs, string ActIDs, string ContractorIds)
        {
            try
            {
                DataSet ds = new DataSet();
                SqlParameter[] p = new SqlParameter[] 
                { new SqlParameter("@SiteID", SiteIDs), new SqlParameter("@ACTID", ActIDs), new SqlParameter("@Contractor", ContractorIds) };
                ds = DataLib.ExecuteDataSet("GetMappingCount", CommandType.StoredProcedure, p);
                return ds;
            }
            catch
            {
                throw;
            }
        }
        #endregion Download

        public DataTable GetCompanyContracotMapping(int CompID,int SiteID)
        {
            try
            {
                SqlParameter[] p = { new SqlParameter("@CompID", CompID), new SqlParameter("@SiteID", SiteID) };
                return DataLib.ExecuteDataTable("GetCompanyContracotMapping", CommandType.StoredProcedure, p);
            }
            catch
            {
                throw new Exception("GetCompanyMapping");
            }
        }
        public string AddUpdateMapping(SiteActivityMapping Model)
        {
            try
            {
                string effdatestr = ""; //string strtdt = "";
                if (Model.EffectiveDate.Year != 1900)
                    effdatestr = Model.EffectiveDate.Day.ToString() + "/" + Model.EffectiveDate.Month.ToString() + "/" + Model.EffectiveDate.Year.ToString();
                SqlParameter[] p =
                {
                    new SqlParameter("@MapppingID", Model.MappingID),
                    new SqlParameter("@CompanyID", Model.CompanyID),
                    new SqlParameter("@SiteID", Model.SiteID),
                    new SqlParameter("@ActID", Model.ActID),
                    new SqlParameter("@ActivityID", Model.ActivityID),
                    new SqlParameter("@ContractorID", Model.ContractorID),
                    new SqlParameter("@StartDate", Model.StartDate),           
                    new SqlParameter("@EffectiveDate", effdatestr ),    
                    new SqlParameter("@RemindDays", Model.RemindDays),
                    new SqlParameter("@CreatedBy", Model.CreatedBy),
                    new SqlParameter("@Maker", Model.Maker),
                    new SqlParameter("@Checker", Model.Checker),
                    new SqlParameter("@Frequency", Model.Frequency),
                    new SqlParameter("@IsAct", Model.IsAct)
                };
                return DataLib.ExecuteScaler("InsertMapping00", CommandType.StoredProcedure, p); //InsertMapping
            }
            catch
            {
                throw new Exception("AddUpdateMapping");
            }
        }
        public string ProcessMapping(string FilePath, int CreatedBy, int CompID,  ref int  SuccessCount, ref int  FailCount)
        {
            try
            {
                //string FilePath = HostingEnvironment.MapPath("~/Docs/Temp/") + filename; 
                //Convert csv file into DataTable
                DataTable dt = null;
                try
                {
                    dt = CSVUtills.CSVToDataTable(FilePath, ',');
                    foreach (DataRow row in dt.Rows)
                    {
                        row["NextDueDate"] = row["NextDueDate"].ToString().Replace("-", "/");
                        row["EffectiveDate"] = row["EffectiveDate"].ToString().Replace("-", "/");
                        dt.AcceptChanges();
                    }
                }
                catch (Exception Ex)
                {
                    //return Ex.Message;
                    return "Invalid File Format";
                }
                if (! (dt.Columns.Contains("DOCID") && dt.Columns.Contains("Site") && dt.Columns.Contains("Contractor") && dt.Columns.Contains("Act")
                    && dt.Columns.Contains("Activity") && dt.Columns.Contains("NextDueDate") && dt.Columns.Contains("EffectiveDate")
                    && dt.Columns.Contains("RemindDays") && dt.Columns.Contains("IsActive")
                    && dt.Columns.Contains("Maker") && dt.Columns.Contains("Checker") && dt.Columns.Contains("Frequency")))
                {
                return "Invalid File Format";
                }
                dt.Columns.Add("Response");
                dt.Columns.Add("Message");
                SiteActivityMapping Model;
                string strerr = "";
                SiteActivityMappingVM VM;

                SiteRepo objSRep = new SiteRepo();
                Site MdlSite ;

                ContractorRepo objConRep = new ContractorRepo();
                Contractor MdlContractor;

                ActRepo objActRep = new ActRepo();
                Act MdlAct;

                ActivityRepo objActivityRep = new ActivityRepo();
                Activity MdlActivity;

                User MdlUser;
                UserRepo objuserrepo = new UserRepo();

                Frequency mdlFreq;
                FrequencyRepo objFreqRepo = new FrequencyRepo();

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    //Only checking Required validation using View Model
                    try
                    {
                        VM = new SiteActivityMappingVM();
                        VM.SiteID = Convert.ToString((dt.Rows[i]["Site"]).ToString().Replace("\"",""));
                        try
                        {
                            if (dt.Rows[i]["NextDueDate"].ToString().Replace("\"", "") != "")
                                VM.StartDate = DateUtils.GetFDate(dt.Rows[i]["NextDueDate"].ToString().Replace("\"", ""));
                            else
                                VM.StartDate = null;

                        }
                        catch { strerr = "Invalid Next Due Date Format(Must be in dd/MM/yyyy);"; throw; }
                        try
                        {
                            if (dt.Rows[i]["EffectiveDate"].ToString().Replace("\"", "") != "")
                                VM.EffectiveDate = DateUtils.GetFDate(dt.Rows[i]["EffectiveDate"].ToString().Replace("\"", ""));
                            else VM.EffectiveDate = new DateTime(1900, 1, 1);
                        }
                        catch { strerr = "Invalid Effective Date Format(Must be in dd/MM/yyyy);"; throw; }
                   
                        VM.ContractorID = Convert.ToString(dt.Rows[i]["Contractor"]).Replace("\"", "");
                        VM.ActID = Convert.ToString(dt.Rows[i]["Act"]).Replace("\"", "");
                        VM.ActivityID = Convert.ToString(dt.Rows[i]["Activity"]).Replace("\"", "");
                        VM.RemindDays = Convert.ToInt32((dt.Rows[i]["RemindDays"]).ToString().Replace("\"", ""));
                        VM.IsAct = dt.Rows[i]["IsActive"].ToString().Replace("\"", "") == "" ? "0" : dt.Rows[i]["IsActive"].ToString().Replace("\"", ""); //dt.Rows[i]["IsActive"].ToString().Replace("\"", "");
                        VM.Maker = dt.Rows[i]["Maker"].ToString().Replace("\"", "");
                        VM.Checker = dt.Rows[i]["Checker"].ToString().Replace("\"", "");
                        VM.Frequency = dt.Rows[i]["Frequency"].ToString().Replace("\"", "");
                        VM.CompanyID = CompID.ToString();
                        var results = new List<ValidationResult>();
                        var vc = new ValidationContext(VM, null, null);
                        var isValid = Validator.TryValidateObject(VM, vc, results,true);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                        strerr = string.Join(" ", errors);
                        if (isValid)
                        {
                            Model = new SiteActivityMapping();
                            Model.CompanyID = CompID;
                            //Model.Frequency = VM.Frequency;
                            Model.MappingID = Convert.ToInt32((dt.Rows[i]["DOCID"]).ToString().Replace("\"", ""));
                            MdlSite = new Site();
                            //Getting SiteId from DataBase
                            MdlSite.Name = VM.SiteID;
                            MdlSite.Company = CompID.ToString();
                            MdlSite.IsAct = true;
                            MdlSite.SiteID = 0;
                            DataTable dtS = objSRep.GetSite(MdlSite).Tables[0];
                            if (dtS.Rows.Count > 0)
                            {
                                Model.SiteID = Convert.ToInt32(dtS.Rows[0]["SiteID"].ToString().Replace("\"", ""));
                            }
                            else
                            {
                                Model.SiteID = -1;
                            }
                            //Now Getting ContractorID From DataBase
                            MdlContractor = new Contractor();
                            // If it is for PE then pass 0 
                            if (VM.ContractorID.ToUpper() != "PE")
                            {
                                MdlContractor = new Contractor();
                                MdlContractor.IsAct = true;
                                MdlContractor.Name = VM.ContractorID;
                                MdlContractor.IsAct = true;
                                DataTable dtCon = objConRep.GetContractor(MdlContractor).Tables[0];
                                if (dtCon.Rows.Count > 0)
                                {
                                    Model.ContractorID = Convert.ToInt32(dtCon.Rows[0]["ContractorID"].ToString().Replace("\"", ""));//ContractorID
                                }
                                else
                                {
                                    Model.ContractorID = -1;
                                }
                            }
                            else
                            {
                                Model.ContractorID = 0;
                            }

                            //Now Getting ActID From DataBase
                            MdlAct = new Act();
                            MdlAct.IsAct = true;
                            MdlAct.Short_Name = VM.ActID;
                            MdlAct.ActID = 0;
                            DataTable dtAct = objActRep.GetActList(MdlAct);
                            if (dtAct.Rows.Count > 0)
                            {
                                Model.ActID = Convert.ToInt32(dtAct.Rows[0]["ActID"].ToString().Replace("\"", ""));
                            }
                            else
                            {
                                Model.ActID = -1;
                            }

                            //Now Getting Activity ID from Data
                            MdlActivity = new Activity();
                            MdlActivity.ActivityID = 0;
                            MdlActivity.IsAct = true;
                            MdlActivity.Act = Model.ActID;
                            MdlActivity.Name = VM.ActivityID;
                            DataTable dtActivity = objActivityRep.GetActivityList(MdlActivity);

                            if (dtActivity.Rows.Count > 0)
                            {
                                Model.ActivityID = Convert.ToInt32(dtActivity.Rows[0]["ActivityID"].ToString().Replace("\"", ""));
                            }
                            else
                            {   
                                Model.ActivityID = -1;
                            }

                            //Now Getting MakerID (UID) From DataBase
                            if (string.IsNullOrEmpty(VM.Maker.Trim()))
                                Model.Maker = 0;
                            else
                            {
                                MdlUser = new User();
                                MdlUser.User_Name = VM.Maker;
                                MdlUser.Company = 0;
                                MdlUser.Contractor = 0;
                                MdlUser.IsAuth = 1;
                                MdlUser.UID = 0;
                                DataTable dtUser = (objuserrepo.GetUser(MdlUser));
                                if (dtUser.Rows.Count > 0)
                                {
                                    Model.Maker = Convert.ToInt32(dtUser.Rows[0]["UID"].ToString().Replace("\"", ""));
                                }
                                else
                                {
                                    Model.Maker = -1;
                                }
                            }

                            //Now Getting CheckerID (UID) From DataBase
                            if (string.IsNullOrEmpty(VM.Checker.Trim()))
                                Model.Checker = 0;
                            else
                            {
                                MdlUser = new User();
                                MdlUser.User_Name = VM.Checker;
                                MdlUser.Company = 0;
                                MdlUser.Contractor = 0;
                                MdlUser.IsAuth = 1;
                                MdlUser.UID = 0;
                                DataTable dtchecker = (objuserrepo.GetUser(MdlUser));
                                if (dtchecker.Rows.Count > 0)
                                {
                                    Model.Checker = Convert.ToInt32(dtchecker.Rows[0]["UID"].ToString().Replace("\"", ""));
                                }
                                else
                                {
                                    Model.Checker = -1;
                                }
                             }
                            //Now Getting FrequencyID From DataBase
                            if (string.IsNullOrEmpty(VM.Frequency.Trim()))
                                Model.Frequency = 0;
                            else
                            {
                                mdlFreq = new Frequency();
                                mdlFreq.FrequencyID = 0;
                                mdlFreq.IsAct = true;
                                mdlFreq.Name = VM.Frequency.Trim();
                                DataTable dtFreq = objFreqRepo.GetFrequencyList(mdlFreq);
                                if (dtFreq.Rows.Count > 0)
                                {
                                    Model.Frequency = Convert.ToInt32(dtFreq.Rows[0]["FrequencyID"].ToString().Replace("\"", ""));
                                }
                                else
                                {
                                    Model.Frequency = -1;
                                }
                            }


                            if (VM.StartDate != null && VM.EffectiveDate.Year != 1900)
                            {
                                Model.StartDate = GetEffectiveStartDate(VM.Frequency, (DateTime)VM.StartDate, (DateTime)VM.EffectiveDate);
                            }
                            else
                            {
                                Model.StartDate = VM.StartDate;
                            }
                            // Change logic by vinod 27 July 20017 Discussion by ajeet & nehra sir==================
                            if (VM.StartDate != null)
                            {
                                if ((DateTime)VM.EffectiveDate > (DateTime)VM.StartDate)
                                    Model.EffectiveDate = new DateTime(1900, 1, 1);
                                else
                                    Model.EffectiveDate = VM.EffectiveDate;
                            }
                            else
                            {
                                Model.EffectiveDate = VM.EffectiveDate;
                            }
                            //=======================================================================================
                            Model.RemindDays = VM.RemindDays;
                            Model.IsAct = VM.IsAct;
                            Model.CreatedBy = CreatedBy;

                            results = new List<ValidationResult>();
                            vc = new ValidationContext(Model, null, null);
                            isValid = Validator.TryValidateObject(Model, vc, results,true);
                            errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                            strerr = string.Join(" ", errors);
                            if (isValid)
                            {
                              int Result= Convert.ToInt32(AddUpdateMapping(Model));
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
                                  else if (Result == -10)
                                      dt.Rows[i]["Message"] = "Invalid DocID or Invalid docid/Company,Contractor Combination.";
                                  else
                                  {
                                      dt.Rows[i]["Response"] = "Failed";
                                  }
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
                        if (strerr == "")
                        {
                            dt.Rows[i]["Message"] = "Invalid Data Format";
                        }
                        else { dt.Rows[i]["Message"] = strerr; }
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

        public DateTime GetEffectiveStartDate(string frequencyID, DateTime StartDate, DateTime EffectiveDate)
        {
            DateTime ReturnDate = StartDate;

            StartDate = StartDate.AddYears(DateTime.Now.Year - StartDate.Year);
            switch (frequencyID)
            {
                case "Half Yearly":

                    for (int i = 0; ReturnDate.AddMonths(-i) >= EffectiveDate; i = i + 6)
                    {
                        ReturnDate = ReturnDate.AddMonths(-i);
                    }
                    break;
                case "Once In Two Year":
                    for (int i = 0; ReturnDate.AddYears(-i) >= EffectiveDate; i = i + 2)
                    {
                        ReturnDate = ReturnDate.AddYears(-i);
                    }
                    break;
                case "Weekly":

                    for (int i = 0; ReturnDate.AddDays(-i) >= EffectiveDate; i = i + 7)
                    {
                        ReturnDate = ReturnDate.AddDays(-i);
                    }
                    break;
                case "Quarterly":

                    for (int i = 0; ReturnDate.AddMonths(-i) >= EffectiveDate; i = i + 3)
                    {
                        ReturnDate = ReturnDate.AddMonths(-i);
                    }
                    break;

                case "Yearly"://Yearly
                    for (int i = 0; ReturnDate.AddYears(-i) >= EffectiveDate; i = i + 1)
                    {
                        ReturnDate = ReturnDate.AddYears(-i);
                    }
                    break;
                case "Monthly"://Monthly
                    for (int i = 0; ReturnDate.AddMonths(-i) >= EffectiveDate; i = i + 1)
                    {
                        ReturnDate = ReturnDate.AddMonths(-i);
                    }
                    break;
            }


            return ReturnDate;
        }

    }
}