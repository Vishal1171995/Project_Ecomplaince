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
    public class SiteActivityMappingPERep
    {
        #region Download
        public string DownloadAllMapping(string SiteIDs, string ActIDs)
        {
            try
            {
                DataSet ds = new DataSet();
                SqlParameter[] p = new SqlParameter[] { new SqlParameter("@SiteID", SiteIDs), new SqlParameter("@ACTID", ActIDs) };
                ds = DataLib.ExecuteDataSet("GetALLMappingPE_0", CommandType.StoredProcedure, p);
                return CSVUtills.DataTableToCSV(ds.Tables[0], ",");
            }
            catch
            {
                throw;
            }
        }


        public string DownloadAllScheduled(string SiteIDs, string ActIDs)
        {
            try
            {
                DataSet ds = new DataSet();
                SqlParameter[] p = new SqlParameter[] { new SqlParameter("@SiteID", SiteIDs), new SqlParameter("@ACTID", ActIDs) };
                ds = DataLib.ExecuteDataSet("GetALLScheduledMappingPE", CommandType.StoredProcedure, p);
                return CSVUtills.DataTableToCSV(ds.Tables[0], ",");
            }
            catch
            {
                throw;
            }
        }
        public string DownloadAllUnScheduled(string SiteIDs, string ActIDs)
        {
            try
            {
                DataSet ds = new DataSet();
                SqlParameter[] p = new SqlParameter[] { new SqlParameter("@SiteID", SiteIDs), new SqlParameter("@ACTID", ActIDs)};
                ds = DataLib.ExecuteDataSet("GetALLUnscheduledMappingPE0", CommandType.StoredProcedure, p);
                return CSVUtills.DataTableToCSV(ds.Tables[0], ",");
            }
            catch
            {
                throw;
            }
        }
        public string DownloadAllInActive(string SiteIDs, string ActIDs)
        {
            try
            {
                DataSet ds = new DataSet();
                SqlParameter[] p = new SqlParameter[] { new SqlParameter("@SiteID", SiteIDs), new SqlParameter("@ACTID", ActIDs) };
                ds = DataLib.ExecuteDataSet("[GetALLInactiveMappingPE0]", CommandType.StoredProcedure, p);
                return CSVUtills.DataTableToCSV(ds.Tables[0], ",");
            }
            catch
            {
                throw;
            }
        }

        public DataSet GetMappingCount(string SiteIDs, string ActIDs)
        {
            try
            {
                DataSet ds = new DataSet();
                SqlParameter[] p = new SqlParameter[] { new SqlParameter("@SiteID", SiteIDs), new SqlParameter("@ACTID", ActIDs) };
                ds = DataLib.ExecuteDataSet("GetMappingCount", CommandType.StoredProcedure, p);
                return ds;
            }
            catch
            {
                throw;
            }
        }

        public DataSet GetALLActiveMapping(string SiteIDs, string ActIDs)
        {
            try
            {
                DataSet ds = new DataSet();
                SqlParameter[] p = new SqlParameter[] { new SqlParameter("@SiteID", SiteIDs), new SqlParameter("@ACTID", ActIDs) };
                ds = DataLib.ExecuteDataSet("GetMappingCount", CommandType.StoredProcedure, p);
                return ds;
            }
            catch
            {
                throw;
            }
        }

        public DataSet GetALLInActiveMapping(string SiteIDs, string ActIDs)
        {
            try
            {
                DataSet ds = new DataSet();
                SqlParameter[] p = new SqlParameter[] { new SqlParameter("@SiteID", SiteIDs), new SqlParameter("@ACTID", ActIDs)};
                ds = DataLib.ExecuteDataSet("GetMappingCount", CommandType.StoredProcedure, p);
                return ds;
            }
            catch
            {
                throw;
            }
        }
        public DataSet GetRemainingMapp(string SiteIDs, string ActIDs)
        {
            try
            {
                DataSet ds = new DataSet();
                SqlParameter[] p = new SqlParameter[] { new SqlParameter("@SiteID", SiteIDs), new SqlParameter("@ACTID", ActIDs) };
                ds = DataLib.ExecuteDataSet("GetMappingCount", CommandType.StoredProcedure, p);
                return ds;
            }
            catch
            {
                throw;
            }
        }

        #endregion Download

        public DataTable GetCompanyMapping(int CompID,int SiteID)
        {
            try
            {
                SqlParameter[] p = { new SqlParameter("@CompID", CompID), new SqlParameter("@SiteID", SiteID) };
                return DataLib.ExecuteDataTable("GetCompanyMapping", CommandType.StoredProcedure, p);
            }
            catch
            {
                throw new Exception("GetCompanyMapping");
            }
        }
        public string AddUpdateMapping(SiteActivityMappingPE Model)
        {
            string result = "";
            string effdatestr = "";// string strtdt = "";
            if (Model.EffectiveDate.Year != 1900)
                effdatestr = Model.EffectiveDate.Day.ToString() + "/" + Model.EffectiveDate.Month.ToString() + "/" + Model.EffectiveDate.Year.ToString();
            //if (Model.StartDate != null)
            //    strtdt = Model.StartDate.Day.ToString() + "/" + Model.StartDate.Month.ToString() + "/" + Model.StartDate.Year.ToString();
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@MapppingID", Model.MappingID),
                    new SqlParameter("@CompanyID", Model.CompanyID),
                    new SqlParameter("@SiteID", Model.SiteID),
                    new SqlParameter("@ActID", Model.ActID),
                    new SqlParameter("@ActivityID", Model.ActivityID),                    
                    new SqlParameter("@StartDate",Model.StartDate),                   
                    new SqlParameter("@EffectiveDate", effdatestr ),                  
                    new SqlParameter("@RemindDays", Model.RemindDays),
                    new SqlParameter("@CreatedBy", Model.CreatedBy),
                    new SqlParameter("@Maker", Model.Maker),
                    new SqlParameter("@Checker", Model.Checker),
                     new SqlParameter("@Maker2", Model.Maker2),
                    new SqlParameter("@Checker2", Model.Checker2),
                     new SqlParameter("@Auditor1", Model.Auditor1),
                    new SqlParameter("@Auditor2", Model.Auditor2),
                    new SqlParameter("@ActionType", Model.ActionType),
                    new SqlParameter("@Applicable_To_Client", Model.Applicable_To_Client),
                    new SqlParameter("@Frequency", Model.Frequency),
                    new SqlParameter("@IsAct", Model.IsAct)
                };
                return DataLib.ExecuteScaler("InsertMappingPE000_New", CommandType.StoredProcedure, p); //InsertMappingPE000 //InsertMappingPE
            }
            catch
            {
                throw new Exception("AddUpdateMapping");
            }
        }
        public string ProcessMapping(string FilePath, int CreatedBy, int CompID, ref int SuccessCount, ref int FailCount)
        {
            try
            {
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
                catch(Exception Ex)
                {
                    //return Ex.Message;
                    return "Invalid File Format";
                }
                if (!(dt.Columns.Contains("DOCID") && dt.Columns.Contains("Site") && dt.Columns.Contains("NextDueDate") && dt.Columns.Contains("EffectiveDate") 
                    && dt.Columns.Contains("Act") && dt.Columns.Contains("Activity") 
                     && dt.Columns.Contains("RemindDays") && dt.Columns.Contains("IsActive") &&  dt.Columns.Contains("Frequency")
                    && dt.Columns.Contains("Maker1") && dt.Columns.Contains("Maker2") && dt.Columns.Contains("Checker1") && dt.Columns.Contains("Checker2") && dt.Columns.Contains("Auditor1") && dt.Columns.Contains("Auditor2")
                    && dt.Columns.Contains("ActionType") && dt.Columns.Contains("Applicable_To_Client")))
                {
                    return "Invalid File Format";
                }

                dt.Columns.Add("Response");
                dt.Columns.Add("Message");

                SiteActivityMappingPE Model;
                string strerr = "";
                SiteActivityMappingPEVM VM;

                SiteRepo objSRep = new SiteRepo();
                Site MdlSite;
                
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
                        VM = new SiteActivityMappingPEVM();
                        VM.SiteID = Convert.ToString((dt.Rows[i]["Site"]).ToString().Replace("\"", ""));
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
                            else VM.EffectiveDate = new DateTime(1900,1,1);
                        }
                        catch { strerr = "Invalid Effective Date Format(Must be in dd/MM/yyyy);"; throw; }

                        VM.ActID = Convert.ToString(dt.Rows[i]["Act"]).Replace("\"", "");
                        VM.ActivityID = Convert.ToString(dt.Rows[i]["Activity"]).Replace("\"", "");
                        VM.RemindDays = Convert.ToInt32((dt.Rows[i]["RemindDays"]).ToString().Replace("\"", ""));
                        VM.IsAct = dt.Rows[i]["IsActive"].ToString().Replace("\"", "") == "" ? "0" : dt.Rows[i]["IsActive"].ToString().Replace("\"", "");
                        VM.Maker = dt.Rows[i]["Maker1"].ToString().Replace("\"", "");
                        VM.Checker = dt.Rows[i]["Checker1"].ToString().Replace("\"", "");
                        VM.Maker2 = (dt.Rows[i]["Maker2"]).ToString().Replace("\"", "").Trim();
                        VM.Checker2 = (dt.Rows[i]["Checker2"]).ToString().Replace("\"", "").Trim();
                        VM.Auditor1 = (dt.Rows[i]["Auditor1"]).ToString().Replace("\"", "").Trim();
                        VM.Auditor2 = (dt.Rows[i]["Auditor2"]).ToString().Replace("\"", "").Trim();
                        VM.ActionType = (dt.Rows[i]["ActionType"]).ToString().Replace("\"", "").Trim();
                        VM.Applicable_To_Client = dt.Rows[i]["Applicable_To_Client"].ToString().Replace("\"", "") == "" ? "0" : dt.Rows[i]["Applicable_To_Client"].ToString().Replace("\"", "");
                        VM.Frequency = dt.Rows[i]["Frequency"].ToString().Replace("\"", "");
                        VM.CompanyID = CompID.ToString();
                        var results = new List<ValidationResult>();
                        var vc = new ValidationContext(VM, null, null);
                        var isValid = Validator.TryValidateObject(VM, vc, results, true);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                        strerr = string.Join(" ", errors);
                        if (isValid)
                        {
                            Model = new SiteActivityMappingPE();
                            //Model.Frequency = VM.Frequency;
                            Model.CompanyID = CompID;
                            Model.MappingID = Convert.ToInt32((dt.Rows[i]["DOCID"]).ToString().Replace("\"", ""));
                            MdlSite = new Site();
                            //Getting SiteId from DataBase
                            MdlSite.Name = VM.SiteID;
                            MdlSite.Company = CompID.ToString();
                            MdlSite.IsAct = true;
                            MdlSite.SiteID = 0;
                            MdlSite.UID = CreatedBy;
                            DataTable dtS = objSRep.GetSite(MdlSite).Tables[0];
                            if (dtS.Rows.Count > 0)
                            {
                                Model.SiteID = Convert.ToInt32(dtS.Rows[0]["SiteID"].ToString().Replace("\"", ""));
                            }
                            else
                            {
                                Model.SiteID = -1;
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
                                MdlUser.UID = 0; MdlUser.UserID = CreatedBy;
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
                            //Now Getting Maker2ID (UID) From DataBase
                            if (string.IsNullOrEmpty(VM.Maker2.Trim()))
                                Model.Maker2 = 0;
                            else
                            {
                                MdlUser = new User();
                                MdlUser.User_Name = VM.Maker2;
                                MdlUser.Company = 0;
                                MdlUser.Contractor = 0;
                                MdlUser.IsAuth = 1;
                                MdlUser.UID = 0; MdlUser.UserID = CreatedBy;
                                DataTable dtUser = (objuserrepo.GetUser(MdlUser));
                                if (dtUser.Rows.Count > 0)
                                {
                                    Model.Maker2 = Convert.ToInt32(dtUser.Rows[0]["UID"].ToString().Replace("\"", ""));
                                }
                                else
                                {
                                    Model.Maker2 = -1;
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
                                MdlUser.UID = 0; MdlUser.UserID = CreatedBy;
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


                            //Now Getting Checker2ID (UID) From DataBase
                            if (string.IsNullOrEmpty(VM.Checker2.Trim()))
                                Model.Checker2 = 0;
                            else
                            {
                                MdlUser = new User();
                                MdlUser.User_Name = VM.Checker2;
                                MdlUser.Company = 0;
                                MdlUser.Contractor = 0;
                                MdlUser.IsAuth = 1;
                                MdlUser.UID = 0; MdlUser.UserID = CreatedBy;
                                DataTable dtchecker = (objuserrepo.GetUser(MdlUser));
                                if (dtchecker.Rows.Count > 0)
                                {
                                    Model.Checker2 = Convert.ToInt32(dtchecker.Rows[0]["UID"].ToString().Replace("\"", ""));
                                }
                                else
                                {
                                    Model.Checker2 = -1;
                                }
                            }

                            MdlUser = new User();
                            MdlUser.Company = 0;
                            MdlUser.Contractor = 0;
                            MdlUser.IsAuth = 1;
                            MdlUser.UID = 0; MdlUser.UserID = CreatedBy;
                            //Now Getting AuditorID (UID) From DataBase
                            if (string.IsNullOrEmpty(VM.Auditor1.Trim()))
                                Model.Auditor1 = 0;
                            else
                            {
                                MdlUser.User_Name = VM.Auditor1;
                                DataTable dtAuditor1 = (objuserrepo.GetAuditor(MdlUser));
                                if (dtAuditor1.Rows.Count > 0)
                                {
                                    Model.Auditor1 = Convert.ToInt32(dtAuditor1.Rows[0]["UID"].ToString().Replace("\"", ""));
                                }
                                else
                                {
                                    Model.Auditor1 = -1;
                                }
                            }

                           
                            //Now Getting Auditor2ID (UID) From DataBase
                            if (string.IsNullOrEmpty(VM.Auditor2.Trim()))
                                Model.Auditor2 = 0;
                            else
                            {
                                MdlUser.User_Name = VM.Auditor2;
                                DataTable dtAuditor2 = (objuserrepo.GetAuditor(MdlUser));
                                if (dtAuditor2.Rows.Count > 0)
                                {
                                    Model.Auditor2 = Convert.ToInt32(dtAuditor2.Rows[0]["UID"].ToString().Replace("\"", ""));
                                }
                                else
                                {
                                    Model.Auditor2 = -1;
                                }
                            }
                            Model.ActionType = VM.ActionType;
                            Model.Applicable_To_Client = Convert.ToInt32(VM.Applicable_To_Client.ToString());
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
                                if(dtFreq.Rows.Count > 0)
                                {
                                    Model.Frequency = Convert.ToInt32(dtFreq.Rows[0]["FrequencyID"].ToString().Replace("\"", ""));
                                }
                                else
                                {
                                    Model.Frequency = -1;
                                }
                            }

                         //   DateTime tmp; //= (DateTime)VM.StartDate;
                          //  DateTime.TryParse(VM.StartDate.ToString(),out tmp );
                       
                            if (VM.StartDate != null && VM.EffectiveDate.Year != 1900)
                            {  Model.StartDate = GetEffectiveStartDate(VM.Frequency,(DateTime)VM.StartDate,(DateTime)VM.EffectiveDate);}
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
                            isValid = Validator.TryValidateObject(Model, vc, results, true);
                            errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                            strerr = string.Join(" ", errors);
                            if (isValid)
                            {
                                int Result = Convert.ToInt32(AddUpdateMapping(Model));
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
                                        dt.Rows[i]["Message"] = "Invalid DocID or Invalid docid/Company Combination.";
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
                           
                        }
                    }
                    catch(Exception ex)
                    {
                        FailCount += 1;
                        dt.Rows[i]["Response"] = "Failed";
                        if(strerr ==""){
                        dt.Rows[i]["Message"] = "Invalid Data Format";}
                        else {   dt.Rows[i]["Message"] = strerr;}
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
        

        public eReport GetMappingNew(string SiteID, string ActID)
        {
            try
            {
                eReport res = new eReport();
                SqlParameter[] p = { new SqlParameter("@SiteID", SiteID),
                                new SqlParameter("@ACTID", ActID),   };
                DataTable dt =  DataLib.ExecuteDataTable("[GetALLMappingPEWithSite]", CommandType.StoredProcedure, p);               
                grdcolumns ObjCols;
                List<grdcolumns> listcol = new List<grdcolumns> { };
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    ObjCols = new grdcolumns();
                    ObjCols.field = dt.Columns[i].ColumnName.Replace(" ","");
                    ObjCols.title = dt.Columns[i].ColumnName;
                  
                    if (dt.Columns[i].ColumnName != "Act" && dt.Columns[i].ColumnName != "Activity" && dt.Columns[i].ColumnName != "Frequency" && dt.Columns[i].ColumnName != "StartDate" && dt.Columns[i].ColumnName != "RemindDays")
                    {
                        ObjCols.title = "<input type='checkbox' chk='" + dt.Columns[i].ColumnName.Replace(" ", "") + "' class='chkbxAll'  >" + dt.Columns[i].ColumnName + "</input>";
                        ObjCols.template = "<input type='checkbox' #:" + dt.Columns[i].ColumnName.Replace(" ", "") + "?'checked=checked':'' # class='chkbx' chk='" + dt.Columns[i].ColumnName.Replace(" ", "") + "'  ></input>";
                    }
                    listcol.Add(ObjCols);
                    dt.Columns[i].ColumnName = dt.Columns[i].ColumnName.Replace(" ", "");
                }
                   res.columns = listcol;
                   res.data = JsonSerializer.SerializeTable(dt);
                    return res;
            }
            catch
            {
                throw new Exception("GetMappingNew");
            }
        }


        public string ProcessMappingNew(int Company,int CreatedBy,string Act, string Activity, string StartDate,string RemindDays,string Site)
        {
            try
            {       

                SiteActivityMappingPE Model;
                string strerr = "";
                SiteActivityMappingPEVM VM;

                SiteRepo objSRep = new SiteRepo();
                Site MdlSite;

                ActRepo objActRep = new ActRepo();
                Act MdlAct;

                ActivityRepo objActivityRep = new ActivityRepo();
                Activity MdlActivity;

                User MdlUser;
                UserRepo objuserrepo = new UserRepo();
               
                    //Only checking Required validation using View Model
                    try
                    {
                        VM = new SiteActivityMappingPEVM();
                        VM.SiteID = Site;
                        VM.StartDate = DateUtils.GetFDate(StartDate);
                        VM.ActID = Act;
                        VM.ActivityID = Activity;
                        VM.RemindDays =Convert.ToInt32( RemindDays);
                        VM.IsAct = "1";
                        VM.Maker = "";
                        VM.Checker ="";
                        VM.CompanyID = Company.ToString();
                        var results = new List<ValidationResult>();
                        var vc = new ValidationContext(VM, null, null);
                        var isValid = Validator.TryValidateObject(VM, vc, results, true);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                        strerr = string.Join(" ", errors);
                        if (isValid)
                        {
                            Model = new SiteActivityMappingPE();
                            Model.CompanyID = Company;
                            Model.MappingID = 0;// Convert.ToInt32((dt.Rows[i]["DOCID"]).ToString().Replace("\"", ""));
                            MdlSite = new Site();
                            //Getting SiteId from DataBase
                            MdlSite.Name = VM.SiteID;
                            MdlSite.Company = Company.ToString();
                            MdlSite.IsAct = true;
                            MdlSite.SiteID = 0;
                            MdlSite.UID = CreatedBy;
                            DataTable dtS = objSRep.GetSite(MdlSite).Tables[0];
                            if (dtS.Rows.Count > 0)
                            {
                                Model.SiteID = Convert.ToInt32(dtS.Rows[0]["SiteID"].ToString().Replace("\"", ""));
                            }
                            else
                            {
                                Model.SiteID = -1;
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
                                MdlUser.UserID = CreatedBy;
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
                                Model.Maker = 0;
                            else
                            {
                                MdlUser = new User();
                                MdlUser.User_Name = VM.Checker;
                                MdlUser.Company = 0;
                                MdlUser.Contractor = 0;
                                MdlUser.IsAuth = 1;
                                MdlUser.UID = 0;
                                MdlUser.UserID = CreatedBy;
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
                            Model.StartDate = VM.StartDate;
                            Model.RemindDays = VM.RemindDays;
                            Model.IsAct = VM.IsAct;
                            Model.CreatedBy = CreatedBy;

                            results = new List<ValidationResult>();
                            vc = new ValidationContext(Model, null, null);
                            isValid = Validator.TryValidateObject(Model, vc, results, true);
                            errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                            strerr = string.Join(" ", errors);
                            if (isValid)
                            {
                                int Result = Convert.ToInt32(AddUpdateMapping(Model));
                                if (Result >= 0)
                                {
                                    return "Success";
                                }
                                else
                                {
                                   
                                    if (Result == -1)
                                    {
                                        return  "Duplicate";
                                    }
                                   
                                }
                            }
                            else
                            {
                                return "Failed";
                            }
                        }
                       
                    }
                    catch
                    {
                        return "Failed";
                    }
                
                //Converting dt into csv FIle
               // FilePath = CSVUtills.DataTableToCSV(dt, ",");
                return "";
            }
            catch
            {
                throw;
            }
        }

        public DateTime   GetEffectiveStartDate(string frequencyID, DateTime StartDate, DateTime EffectiveDate)
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
                        for (int i = 0; ReturnDate.AddYears(-i) >= EffectiveDate; i = i +2)
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
                    for (int i = 0; ReturnDate.AddMonths(-1) >= EffectiveDate; i = i + 1)
                    {
                        ReturnDate = ReturnDate.AddMonths(-1);
                    }
                    break;
            }


            return ReturnDate;
        }
    }

    public class eReport
    {

        public string data { get; set; }
        public List<grdcolumns> columns { get; set; }

    }

    public class grdcolumns
    {

        public string field { get; set; }
        public string title { get; set; }
        // public string type { get; set; }
         public string template { get; set; }
        
         // Public Property template As String = ""

    }

}