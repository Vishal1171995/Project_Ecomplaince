using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using Ecompliance.ViewModel;
using Ecompliance.Models;
using Ecompliance.Utils;
using Ecompliance.Controllers;
using System.Net;
using System.IO;
using Newtonsoft.Json.Linq;

namespace Ecompliance.Repository
{
    public class TaskRepo
    {

        #region General
        public string AddTask(TaskVM obj, SqlConnection con, SqlTransaction trans)
        {
            Response res = new Response();
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@DocID", obj.DOCID),
                    new SqlParameter("@MappingID", obj.MappingID),
                    new SqlParameter("@ActivityType", obj.ActivityType),
                    new SqlParameter("@CompID", obj.CompanyID),
                    new SqlParameter("@SiteID", obj.SiteID) ,
                    new SqlParameter("@ActID", obj.ActID),
                    new SqlParameter("@ActivityID", obj.ActivityID),
                    new SqlParameter("@ContractorID", obj.ContractorID),
                    new SqlParameter("@CreationDesc", obj.Creation_Desc),
                    new SqlParameter("@CreationRemarks", obj.Creation_Remarks),
                    //new SqlParameter("@IsAut", obj.IsAuth),
                    new SqlParameter("@CreatedBy", obj.CreatedBy),
                    new SqlParameter("@ExpiryDate", obj.ExpiryDate),
                    new SqlParameter("@TaskCreationDate", obj.TaskCreationDate),
                    new SqlParameter("@ActionType", obj.ActionType),
                    new SqlParameter("@Applicable_To_Client", obj.Applicable_To_Client)
                };
                res.Data = DataLib.ExecuteScaler("[CreateDocTask_New_02_FEB]", CommandType.StoredProcedure, p, con, trans); //CreateDocTask
                if (Convert.ToInt32(res.Data) > 0)
                {

                    if (obj.ActionType == "Automatic")
                    {
                        // GET All parameters for web service call  -----Start
                        DataTable dt = new DataTable();
                        try
                        {
                            SqlParameter[] parameter =
                            {
                        new SqlParameter("@DOCID", res.Data)
                    };
                            dt = DataLib.ExecuteDataTable("GET_TOKEN_RESULT_DATA", CommandType.StoredProcedure, parameter, con, trans);
                            if (dt.Rows.Count > 0)
                            {
                                try
                                {
                                    //http://172.16.20.9:82/act.svc/getToken?paydate=2018-12-31&hub=delhi&loc=bhopal&client=AGARWAL%20INDUSTRIES&assgn=A1-BHL&tid=230

                                    WebRequest request = WebRequest.Create("http://g4sact.myndsolution.com/act.svc/getToken?paydate=" + dt.Rows[0]["TASK_CREATION"].ToString() + "&hub=" + dt.Rows[0]["hub"].ToString() + "&loc=" + dt.Rows[0]["Location_Name"].ToString() + "&client=" + dt.Rows[0]["Company_Name"].ToString() + "&assgn=" + dt.Rows[0]["Site_Code"].ToString() + "&tid=" + dt.Rows[0]["Print_temp_tid"].ToString());
                                    request.Method = "GET";
                                    WebResponse response = request.GetResponse();
                                    StreamReader reader = new StreamReader(response.GetResponseStream());
                                    string str = reader.ReadLine();
                                    dynamic data = JObject.Parse(str);
                                    bool IsSuccess = data.getTokenResult.IsSuccess;
                                    string has = data.getTokenResult.Hash;
                                    int Tid = data.getTokenResult.TID;

                                    if (IsSuccess)
                                    {

                                        SqlParameter[] p1 =
                                        {
                                    new SqlParameter("@DOCID", res.Data),
                                    new SqlParameter("@HASH", has),
                                    new SqlParameter("@INTEGRATION_TID",Tid),
                                    new SqlParameter("@UPLOADEDACTION", "INTEGRATION") ,

                                };
                                        DataLib.ExecuteScaler("ADD_ECOM_TASK", CommandType.StoredProcedure, p1, con, trans);
                                    }
                                }
                                catch (Exception ex)
                                {
                                    return res.Data;
                                }
                            }
                        }
                        catch (Exception ex) { return res.Data; }
                    }
                }
            }

            catch (Exception ex)
            {
                throw new NotImplementedException(ex.Message.ToString(), ex);
            }
            return res.Data;
        }

      


        public string CreateDocAsNeeded(TaskVM obj)
        {

            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@DocID", obj.DOCID),
                     new SqlParameter("@MappingID", obj.MappingID),
                    new SqlParameter("@TaskID", obj.TaskID),
                    new SqlParameter("@ActivityType", obj.ActivityType),
                    new SqlParameter("@CompID", obj.CompanyID),
                    new SqlParameter("@SiteID", obj.SiteID) ,
                    new SqlParameter("@ActID", obj.ActID),
                     new SqlParameter("@ActivityID", obj.ActivityID),
                    new SqlParameter("@ContractorID", obj.ContractorID),
                    new SqlParameter("@CreationDesc", obj.Creation_Desc),
                    new SqlParameter("@CreationRemarks", obj.Creation_Remarks),
                    //new SqlParameter("@IsAut", obj.IsAuth),
                    new SqlParameter("@CreatedBy", obj.CreatedBy),
                    new SqlParameter("@ExpiryDate", obj.ExpiryDate),
                    new SqlParameter("@RemindDays", obj.RemindDays),
                    new SqlParameter("@ActionType", obj.ActivityType),
                    new SqlParameter("@Applicable_To_Client", obj.Applicable_To_Client),
                };
                return DataLib.ExecuteScaler("CreateDocAsNeeded_New", CommandType.StoredProcedure, p); //CreateDocAsNeeded
            }
            catch (Exception ex) { throw; }
        }

        public DataTable GetActivityActionType(TaskVM obj)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@CompID", obj.CompanyID),
                    new SqlParameter("@SiteID", obj.SiteID),
                    new SqlParameter("@ActID", obj.ActID),
                    new SqlParameter("@ActivityID", obj.ActivityID)
                };
                return DataLib.ExecuteDataTable("GetActivityActionType", CommandType.StoredProcedure, p);
            }
            catch (Exception ex) { throw; }
        }

        public string GetRemindDays(TaskVM obj)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@CompID", obj.CompanyID),
                    new SqlParameter("@SiteID", obj.SiteID) ,
                    new SqlParameter("@ActID", obj.ActID),
                     new SqlParameter("@ActivityID", obj.ActivityID),
                    new SqlParameter("@ContractorID", obj.ContractorID),
                };
                return DataLib.ExecuteScaler("GetRemindDays", CommandType.StoredProcedure, p);
            }
            catch (Exception ex) { throw; }
        }

        public DataTable GetTaskDocument(Task obj, SqlConnection conn = null, SqlTransaction trans = null)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@DOCID", obj.DOCID),
                };
                if (conn != null)
                    return DataLib.ExecuteDataTable("GetTaskDocument", CommandType.StoredProcedure, p, conn, trans);
                else
                    return DataLib.ExecuteDataTable("GetTaskDocument", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }
        public DataSet GetActivityForAllAerts(string ActIds)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("ActIds",ActIds),
                };
                return DataLib.ExecuteDataSet("GetActivityForAllAerts", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }

        public DataSet GetMappedActsForMultipleSite(string SiteIds)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    //new SqlParameter("CompID",CompID),
                    //new SqlParameter("ContractorID",ContractorID),
                    new SqlParameter("SiteIds",SiteIds),
                };
                return DataLib.ExecuteDataSet("GetMappedActsForMultipleSite", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }

        public DataTable GetAsneededDocument(Task obj)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@DOCID", obj.DOCID),
                    new SqlParameter("@CreatedBy", obj.CreatedBy),
                };
                return DataLib.ExecuteDataTable("GetAsneededDocument", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }

        public Task GetTaskobject(string DocID)
        {
            DataTable Dt = new DataTable();
            Task TModel = new Task();
            try
            {
                TModel.DOCID = Convert.ToInt32(DocID);
                Dt = GetTaskDocument(TModel);
                if (Dt.Rows.Count > 0)
                {
                    TModel.CreatedByText = Dt.Rows[0]["CreatedBy"].ToString();
                    TModel.CurrUser = Convert.ToInt32(Dt.Rows[0]["CurUser"]);
                    TModel.CreatedDate = Dt.Rows[0]["CreatedDate"].ToString();
                    TModel.CurrentStatus = Dt.Rows[0]["CurrStatus"].ToString();
                    TModel.ActivityType = Dt.Rows[0]["ActivityType"].ToString();
                    TModel.Company = Dt.Rows[0]["CompName"].ToString();
                    TModel.Site = Dt.Rows[0]["SiteName"].ToString();
                    TModel.Act = Dt.Rows[0]["ActName"].ToString();
                    TModel.Activity = Dt.Rows[0]["ActivityName"].ToString();
                    TModel.Contractor = Dt.Rows[0]["ContName"].ToString();
                    TModel.ActivityCompDate = Dt.Rows[0]["Action_CompletionDate"].ToString();
                    TModel.ExpiryDate = Dt.Rows[0]["Expiry_Date"].ToString();
                    TModel.Creation_Desc = Dt.Rows[0]["Creation_Desc"].ToString();
                    TModel.Frequency = Dt.Rows[0]["FrequencyID"].ToString();
                    TModel.MakerRemarks = Dt.Rows[0]["Maker_Remark"].ToString();
                    TModel.Checker = Dt.Rows[0]["Checker"].ToString();
                    TModel.ExtendebleExpDate = Convert.ToInt32(Dt.Rows[0]["Extendable_Exp_Date"]);
                    TModel.ExtendebleExpDate_Remarks = Dt.Rows[0]["Extendable_Exp_Date_Remark"].ToString();
                }
            }
            catch
            {
                throw;
            }
            return TModel;
        }
        public DataSet GetDocTaskGrid(string Type, int UID, int From, int To, string SortingStr, string FilterStr)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Type",Type),
                    new SqlParameter("@UID",UID),
                    new SqlParameter("@FromNumber",From),
                    new SqlParameter("@ToNumber",To),
                    new SqlParameter("@SQLSortString",SortingStr),
                    new SqlParameter("@SQLFilterString",FilterStr)
                };
                return DataLib.ExecuteDataSet("GetDocTaskGrid_1", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }
        public DataSet GetDocTaskGrid(string Type, int CompID, int SMonth, int TMonth, int Syear, int Tyear, int UID, int From, int To, string SortingStr, string FilterStr)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Type",Type),
                    new SqlParameter("@CompID",CompID),
                    new SqlParameter("@SMonth",SMonth),
                    new SqlParameter("@TMonth",TMonth),
                    new SqlParameter("@Syear",Syear),
                    new SqlParameter("@Tyear",Tyear),
                    new SqlParameter("@UID",UID),
                    new SqlParameter("@FromNumber",From),
                    new SqlParameter("@ToNumber",To),
                    new SqlParameter("@SQLSortString",SortingStr),
                    new SqlParameter("@SQLFilterString",FilterStr)
                };
                return DataLib.ExecuteDataSet("GetDocTaskGrid_1_04042017", CommandType.StoredProcedure, parameters); //GetDocTaskGrid_1
            }
            catch
            {
                throw;
            }
        }
        public DataSet GetDocTaskSearchGrid(string Type, int UID, string ActivityType, string CompIDs, string SiteIDs, string ContractorIDs, string ActIDs, string ActivityIDs, string ExpDate, string Month, string Year, string FromDate, string ToDate, string DocID, string Compliance_Nature, int From, int To, string SortingStr, string FilterStr)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Type",Type),
                    new SqlParameter("@UID",UID),
                    new SqlParameter("@ActivityType",ActivityType),
                    new SqlParameter("@CompIDs",CompIDs),
                    new SqlParameter("@SiteIDs",SiteIDs),
                    new SqlParameter("@ContractorIDs",ContractorIDs),
                    new SqlParameter("@ActIDs",ActIDs),
                    new SqlParameter("@ActivityIDs",ActivityIDs),
                    new SqlParameter("@ExpDate",ExpDate),
                    new SqlParameter("@Month",Month),
                    new SqlParameter("@Year",Year),
                    new SqlParameter("@FromDate",FromDate),
                    new SqlParameter("@ToDate",ToDate),
                    new SqlParameter("@DocID",DocID),
                    new SqlParameter("@FromNumber",From),
                    new SqlParameter("@ToNumber",To),
                    new SqlParameter("@SQLSortString",SortingStr),
                    new SqlParameter("@SQLFilterString",FilterStr),
                    new SqlParameter("@Compliance_Nature",Compliance_Nature)
                    //@Compliance_Nature
                };
                return DataLib.ExecuteDataSet("GetDocTaskSearchGrid", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }

        public DataSet GetMyAsNeeded(int UID, int From, int To, string SortingStr, string FilterStr)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@UID",UID),
                    new SqlParameter("@FromNumber",From),
                    new SqlParameter("@ToNumber",To),
                    new SqlParameter("@SQLSortString",SortingStr),
                    new SqlParameter("@SQLFilterString",FilterStr)
                };
                return DataLib.ExecuteDataSet("GetMyAsNeeded_1", CommandType.StoredProcedure, parameters);
            }
            catch (Exception ex) { throw; }
        }

        public DataSet GetMyAsNeeded(int CompID, int SMonth, int TMonth, int Syear, int Tyear, int UID, int From, int To, string SortingStr, string FilterStr)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@CompID",CompID),
                    new SqlParameter("@SMonth",SMonth),
                    new SqlParameter("@TMonth",TMonth),
                    new SqlParameter("@Syear",Syear),
                    new SqlParameter("@Tyear",Tyear),
                    new SqlParameter("@UID",UID),
                    new SqlParameter("@FromNumber",From),
                    new SqlParameter("@ToNumber",To),
                    new SqlParameter("@SQLSortString",SortingStr),
                    new SqlParameter("@SQLFilterString",FilterStr)
                };
                return DataLib.ExecuteDataSet("GetMyAsNeeded_1_1", CommandType.StoredProcedure, parameters); //GetMyAsNeeded_1
            }
            catch (Exception ex) { throw; }
        }

        public DataTable GetAsNeededForDetails(string DocID)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@DocID", DocID),
                };
                return DataLib.ExecuteDataTable("GetAsNeededForDetails", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }
        public DataTable GetAsNeeded_His(string DocID)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@DocID", DocID),
                };
                return DataLib.ExecuteDataTable("GetAsNeeded_His", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }

        public Task GetAsneededForDetailsObject(string DocID)
        {
            Task TModel = new Task();
            DataTable Dt = new DataTable();
            try
            {
                Dt = GetAsNeededForDetails(DocID);
                if (Dt.Rows.Count > 0)
                {
                    TModel.DOCID = Convert.ToInt32(Dt.Rows[0]["DOCID"].ToString());
                    TModel.CreatedByText = Dt.Rows[0]["User_Name"].ToString();
                    TModel.CreatedBy = Convert.ToInt32(Dt.Rows[0]["CreatedBy"].ToString());
                    //TModel.CurrUser = Convert.ToInt32(Dt.Rows[0]["CurUser"]);
                    TModel.CreatedDate = Dt.Rows[0]["CreatedOn"].ToString();
                    //TModel.CurrentStatus = Dt.Rows[0]["CurrStatus"].ToString();
                    TModel.ActivityType = Dt.Rows[0]["ActivityType"].ToString();
                    TModel.Company = Dt.Rows[0]["CompName"].ToString();
                    TModel.Site = Dt.Rows[0]["SiteName"].ToString();
                    TModel.Act = Dt.Rows[0]["ActName"].ToString();
                    TModel.Activity = Dt.Rows[0]["ActivityName"].ToString();
                    TModel.Contractor = Dt.Rows[0]["ContName"].ToString();
                    //TModel.ActivityCompDate = Dt.Rows[0]["Action_CompletionDate"].ToString();
                    TModel.ExpiryDate = Dt.Rows[0]["ExpiryDate"].ToString();
                    TModel.Creation_Desc = Dt.Rows[0]["Creation_Desc"].ToString();
                    //TModel.MakerRemarks = Dt.Rows[0]["Maker_Remark"].ToString();
                    TModel.Creation_Remarks = Dt.Rows[0]["Creation_Remarks"].ToString();
                    TModel.Checker = Dt.Rows[0]["Checker"].ToString();

                }
                return TModel;
            }
            catch
            {
                throw;
            }
        }

        #endregion


        #region DropDownFilter
        public static DataTable GetMappedCompany(int UID)
        {
            try
            {
                SqlParameter[] p = { new SqlParameter("@UID", UID) };

                return DataLib.ExecuteDataTable("GetMappedCompany", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }

        public static DataTable GetMappedSite(int CompID, int UID)
        {
            try
            {
                SqlParameter[] p = { new SqlParameter("@CompID", CompID), new SqlParameter("@UID", UID) };
                return DataLib.ExecuteDataTable("GetMappedSite", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }
        public static DataTable GetMappedActs(int CompID, int ContractorID, int SiteID)
        {
            try
            {
                SqlParameter[] p = { new SqlParameter("@CompID", CompID), new SqlParameter("@ContractorID", ContractorID), new SqlParameter("@SiteID", SiteID) };
                return DataLib.ExecuteDataTable("GetMappedActs", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }
        public static DataTable GetMappedContractor(int CompID, int SiteID, int UID)
        {
            try
            {
                SqlParameter[] p = { new SqlParameter("@CompanyID", CompID), new SqlParameter("@SiteID", SiteID), new SqlParameter("@UID", UID) };
                return DataLib.ExecuteDataTable("GetMappedContractor", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }
        public static DataTable GetMappedActivity(int CompanyID, int ContractorID, int SiteID, int ActID)
        {
            try
            {
                SqlParameter[] p = { new SqlParameter("@CompanyID", CompanyID), new SqlParameter("@ContractorID", ContractorID), new SqlParameter("@SiteID", SiteID), new SqlParameter("@ActID", ActID) };
                return DataLib.ExecuteDataTable("GetMappedActivity", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }
        #endregion

        #region Workflow
        public string SendToVarify(TaskVerifyVM obj)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@UID", obj.UID),
                    new SqlParameter("@DOCID", obj.DocID),
                    new SqlParameter("@Remark", obj.Remark),
                    new SqlParameter("@ActivityCompletionDate", obj.ActivityCompDate) ,
                    new SqlParameter("@DelayReason", obj.DelayReason),
                };
                return DataLib.ExecuteScaler("SendToVarify", CommandType.StoredProcedure, p);
            }
            catch (Exception ex) { throw; }
        }

        public Response Approve_Auditor(int UID, int DocID, String Remarks)
        {
            SqlTransaction trans = null;
            SqlConnection con = null;
            string ApprRes;
            Response Res = new Response();
            try
            {
                con = new SqlConnection(Ecompliance.Utils.DataLib.GetConnectionString());
                con.Open();
                trans = con.BeginTransaction();
                SqlParameter[] p =
                {
                    new SqlParameter("@UID", UID),
                    new SqlParameter("@DOCID", DocID),
                    new SqlParameter("@Remark", Remarks),
                };
                //ApprRes = "1";// DataLib.ExecuteScaler("Approve", CommandType.StoredProcedure,p,con,trans);
                ApprRes = DataLib.ExecuteScaler("Approve0", CommandType.StoredProcedure, p, con, trans);
                if (ApprRes != "1")
                {
                    trans.Rollback();
                    Res.IsSuccess = false;
                    Res.Message = "Invalid Action.";
                    Res.Data = ApprRes;
                    return Res;
                }
                trans.Commit();
                Res.IsSuccess = true;
                Res.Message = "Task approved successfully.";
                Res.Data = ApprRes;
                return Res;

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

        public Response Approve(int UID, int DocID, String Remarks, int Repeat, DateTime ExpiryDate, int RemindDays)
        {
            SqlTransaction trans = null;
            SqlConnection con = null;
            string ApprRes;
            Response Res = new Response();
            try
            {
                con = new SqlConnection(Ecompliance.Utils.DataLib.GetConnectionString());
                con.Open();
                trans = con.BeginTransaction();
                DataTable Dt = new DataTable();
                Task TModel = new Task();
                TModel.DOCID = DocID;
                Dt = GetTaskDocument(TModel, con, trans);
                string Curr_Status = Dt.Rows[0]["CurrStatus"].ToString().ToUpper();
                if (Curr_Status == "Pending with auditor".ToUpper())
                {
                    trans.Commit();
                    con.Dispose();
                    trans.Dispose();
                    return Approve_Auditor(UID, DocID, Remarks);
                }
                SqlParameter[] p =
                {
                    new SqlParameter("@UID", UID),
                    new SqlParameter("@DOCID", DocID),
                    new SqlParameter("@Remark", Remarks),
                };
                //ApprRes = "1";// DataLib.ExecuteScaler("Approve", CommandType.StoredProcedure,p,con,trans);
                ApprRes = DataLib.ExecuteScaler("Approve_SendToAuditor", CommandType.StoredProcedure, p, con, trans);

                //User Do not opted repeat. Dont proceed further
                if (Repeat == 0)
                {
                    trans.Commit();
                    Res.IsSuccess = true;
                    Res.Message = "Task approved successfully.";
                    Res.Data = ApprRes;
                    return Res;
                }
                //Something went wrong in document Approval/Movement. RollBack transaction 
                if (ApprRes != "1")
                {
                    trans.Rollback();
                    Res.IsSuccess = false;
                    Res.Message = "Invalid Action.";
                    Res.Data = ApprRes;
                    return Res;
                }

                //Document Approved successfully. Now Create new alert if frequency is asneeded and user opted for new recreation
                //Get Created task details from database

                if (Dt.Rows.Count == 1)
                {
                    //Frequency of alert is not AsNeeded: Do not proceed further
                    if (Dt.Rows[0]["FrequencyID"].ToString() != "9")
                    {
                        trans.Commit();
                        Res.IsSuccess = true;
                        Res.Message = "Task approved successfully.";
                        Res.Data = ApprRes;
                        return Res;
                    }


                    TaskVM TaskM = new TaskVM();
                    TaskM.TaskID = 0;
                    TaskM.CreatedBy = UID;
                    TaskM.CurrUser = UID;
                    //Now Populate Modal
                    TaskM.ActivityType = Convert.ToString(Dt.Rows[0]["ActivityType"]);
                    TaskM.CompanyID = Convert.ToInt32(Dt.Rows[0]["CompanyID"]);
                    TaskM.SiteID = Convert.ToInt32(Dt.Rows[0]["SiteID"]);
                    TaskM.ActID = Convert.ToInt32(Dt.Rows[0]["ActID"]);
                    TaskM.ActivityID = Convert.ToInt32(Dt.Rows[0]["ActivityID"]);
                    TaskM.ContractorID = Convert.ToInt32(Dt.Rows[0]["ContractorID"]);
                    TaskM.Creation_Desc = "";
                    TaskM.Creation_Remarks = "Reference DOCID:" + DocID;
                    TaskM.CreatedBy = UID;
                    TaskM.ExpiryDate = ExpiryDate;
                    TaskM.TaskCreationDate = DateTime.Now.ToShortDateString();
                    DateTime CurrDate = new DateTime(System.DateTime.Now.Year, System.DateTime.Now.Month, System.DateTime.Now.Day, 0, 0, 0);
                    DateTime NextDate = TaskM.ExpiryDate.AddDays(-RemindDays);
                    int Datediff = DateTime.Compare(NextDate, CurrDate);
                    //if (DateTime.Now.Day == TaskM.ExpiryDate.Day && DateTime.Now.Month == TaskM.ExpiryDate.Month && DateTime.Now.Year == TaskM.ExpiryDate.Year && TaskM.DOCID == 0)
                    if (Datediff == 0)
                    {
                        try
                        {
                            int ret = Convert.ToInt32(AddTask(TaskM, con, trans));
                            if (ret > 0)
                            {
                                trans.Commit();
                                Res.IsSuccess = true;
                                Res.Message = "Task approved successfully." + "New Task DOCID:" + ret;
                                Res.Data = ret.ToString();
                                return Res;

                            }
                            else
                            {
                                trans.Rollback();
                                ApprRes = "Failed: Maker not found.";
                                return Res;
                            }
                        }
                        catch (Exception ex)
                        {
                            trans.Rollback();
                            throw;
                        }

                    }
                    else
                    {
                        int NewDOCID = Convert.ToInt32(CreateDocAsNeeded(TaskM));
                        if (NewDOCID > 0)
                        {
                            trans.Commit();
                            Res.IsSuccess = true;
                            Res.Message = "Task approved successfully." + "New Alert DOCID:" + NewDOCID;
                            Res.Data = NewDOCID.ToString();
                            return Res;
                        }
                        else
                        {
                            trans.Rollback();
                            ApprRes = "Failed: Maker not found.";
                            Res.IsSuccess = false;
                            Res.Message = ApprRes;
                            Res.Data = NewDOCID.ToString();
                            return Res;
                        }
                    }
                }
                else
                {
                    throw new Exception();
                }
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
        public string Reconsider(int UID, int DocID, String Remarks)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@UID", UID),
                    new SqlParameter("@DOCID", DocID),
                    new SqlParameter("@Remark", Remarks),
                };
                return DataLib.ExecuteScaler("Reconsider", CommandType.StoredProcedure, p);
            }
            catch (Exception ex) { throw; }
        }


        public DataSet GetDocMovement(int DOCID)
        {
            try
            {
                SqlParameter[] p = { new SqlParameter("@DOCID", DOCID) };
                return DataLib.ExecuteDataSet("GetDocMovement", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }
        public DataTable GetExtExPDate(int DOCID)
        {
            try
            {
                SqlParameter[] p = { new SqlParameter("@DOCID", DOCID) };
                return DataLib.ExecuteDataTable("GetExtExPDate", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }
        public string SetExtExpDate(int DocID, string ExtExpDate, int UID, string Remarks)
        {
            string[] arrExpDate = ExtExpDate.Split('/');
            string formatedExpDate = arrExpDate[2] + "-" + arrExpDate[1] + "-" + arrExpDate[0];
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@DocID", DocID),
                    new SqlParameter("@ExtExpDate", formatedExpDate),
                    new SqlParameter("@UID", UID),
                    new SqlParameter("@Remarks", Remarks),
                };
                return DataLib.ExecuteScaler("SetExtExpDate", CommandType.StoredProcedure, p);
            }
            catch (Exception ex) { throw; }
        }
        public DataTable GETExtendedExpDateHis(int DOCID)
        {
            try
            {
                SqlParameter[] p = { new SqlParameter("@DOCID", DOCID) };
                return DataLib.ExecuteDataTable("GETExtendedExpDateHis", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }
        #endregion

        private void SendMail(int DocID, string Action)
        {
            try
            {
                DataTable dt = new DataTable();
                Task objT = new Task();
                objT.DOCID = DocID;
                dt = GetTaskDocument(objT);
                string CompName = "";
                string ActName = "";
                string ActivityName = "";
                string ContractorName = "";
                string MakerEmail = "";
                string MakerName = "";
                string CheckerEmail = "";
                string CheckerName = "";
                string CurrStatus = "";
                string ActivityType = "";

                CurrStatus = Convert.ToString(dt.Rows[0]["CurrStatus"]);
                CompName = Convert.ToString(dt.Rows[0]["CompName"]);
                ActName = Convert.ToString(dt.Rows[0]["ActName"]);
                ActivityName = Convert.ToString(dt.Rows[0]["ActivityName"]);
                ContractorName = Convert.ToString(dt.Rows[0]["ContName"]);
                ContractorName = Convert.ToString(dt.Rows[0]["ContName"]);
                MakerEmail = Convert.ToString(dt.Rows[0]["MakerEmail"]);
                MakerName = Convert.ToString(dt.Rows[0]["MakerName"]);
                CheckerEmail = Convert.ToString(dt.Rows[0]["CheckerEmail"]);
                CheckerName = Convert.ToString(dt.Rows[0]["CheckerName"]);
                ActivityType = Convert.ToString(dt.Rows[0]["ActivityType"]);

            }
            catch { }

        }

        #region Grid Sort And Filter
        public string sortGrid(List<SortDescription> sorting)
        {
            string sortingStr = "";
            try
            {
                if (sorting != null)
                {
                    if (sorting.Count != 0)
                    {
                        for (int i = 0; i < sorting.Count; i++)
                        {
                            if (sorting[i].field == "DOCID") sorting[i].field = "T.DOCID";
                            if (sorting[i].field == "CompName") sorting[i].field = "C.Name";
                            if (sorting[i].field == "SiteName") sorting[i].field = "S.Name";
                            if (sorting[i].field == "ActName") sorting[i].field = "Act.Short_Name";
                            if (sorting[i].field == "ActivityName") sorting[i].field = "A.Name";
                            if (sorting[i].field == "ContName") sorting[i].field = "Cont.Name";
                            if (sorting[i].field == "Creation_Desc") sorting[i].field = "T.Creation_Desc";
                            if (sorting[i].field == "CurrStatus") sorting[i].field = "T.CurrStatus";
                            if (sorting[i].field == "Creation_Remarks") sorting[i].field = "T.Creation_Remarks";
                            if (sorting[i].field == "User_Name") sorting[i].field = "U.User_Name";
                            if (sorting[i].field == "ExpiryDate") sorting[i].field = "T.Expiry_Date";
                            if (sorting[i].field == "TaskCreationDate") sorting[i].field = "T.TaskCreationDate";

                            sortingStr += ", " + sorting[i].field + " " + sorting[i].dir;
                        }
                    }
                }
                return sortingStr;
            }
            catch
            {
                throw;
            }
        }

        public string FilterGrid(FilterContainer filter)
        {
            string filters = "";
            string logic;
            string condition = "";
            try
            {

                int c = 1;
                if (filter != null)
                {
                    for (int i = 0; i < filter.filters.Count; i++)
                    {
                        logic = filter.logic;

                        //filter.filters[i].field
                        if (filter.filters[i].field == "DOCID") filter.filters[i].field = "T.DOCID";
                        if (filter.filters[i].field == "CompName") filter.filters[i].field = "C.Name";
                        if (filter.filters[i].field == "SiteName") filter.filters[i].field = "S.Name";
                        if (filter.filters[i].field == "ActName") filter.filters[i].field = "Act.Short_Name";
                        if (filter.filters[i].field == "ActivityName") filter.filters[i].field = "A.Name";
                        if (filter.filters[i].field == "ContName") filter.filters[i].field = "Cont.Name";
                        if (filter.filters[i].field == "Creation_Desc") filter.filters[i].field = "T.Creation_Desc";
                        if (filter.filters[i].field == "CurrStatus") filter.filters[i].field = "T.CurrStatus";
                        if (filter.filters[i].field == "Creation_Remarks") filter.filters[i].field = "T.Creation_Remarks";
                        if (filter.filters[i].field == "User_Name") filter.filters[i].field = "U.User_Name";
                        if (filter.filters[i].field == "Delay_Region") filter.filters[i].field = "T.Delay_Region";
                        if (filter.filters[i].field == "ExpiryDate")
                        {
                            filter.filters[i].field = "CAST(T.Expiry_Date AS DATE)";
                            string date = Convert.ToDateTime(filter.filters[i].value).Date.ToString();
                            string[] arr = date.Split(' ');
                            string[] arr1 = arr[0].Split('/');
                            filter.filters[i].value = arr1[2] + "-" + arr1[1] + "-" + arr1[0];
                        }
                        if (filter.filters[i].field == "Action_CompletionDate")
                        {
                            filter.filters[i].field = "CAST(T.Action_CompletionDate AS DATE)";
                            string date = Convert.ToDateTime(filter.filters[i].value).Date.ToString();
                            string[] arr = date.Split(' ');
                            string[] arr1 = arr[0].Split('/');
                            filter.filters[i].value = arr1[2] + "-" + arr1[1] + "-" + arr1[0];
                        }
                        if (filter.filters[i].field == "TaskCreationDate")
                        {
                            filter.filters[i].field = "CAST(T.TaskCreationDate AS DATE)";
                            string date = Convert.ToDateTime(filter.filters[i].value).Date.ToString();
                            string[] arr = date.Split(' ');
                            string[] arr1 = arr[0].Split('/');
                            filter.filters[i].value = arr1[2] + "-" + arr1[1] + "-" + arr1[0];
                        }

                        if (filter.filters[i].field == "RemindDays") filter.filters[i].field = "T.RemindDays";

                        if (filter.filters[i].@operator == "eq")
                        {
                            condition = " = '" + filter.filters[i].value + "' ";
                        }
                        if (filter.filters[i].@operator == "neq")
                        {
                            condition = " != '" + filter.filters[i].value + "' ";
                        }
                        if (filter.filters[i].@operator == "startswith")
                        {
                            condition = " Like '" + filter.filters[i].value + "%' ";
                        }
                        if (filter.filters[i].@operator == "contains")
                        {
                            condition = " Like '%" + filter.filters[i].value + "%' ";
                        }
                        if (filter.filters[i].@operator == "doesnotcontains")
                        {
                            condition = " Not Like '%" + filter.filters[i].value + "%' ";
                        }
                        if (filter.filters[i].@operator == "endswith")
                        {
                            condition = " Like '%" + filter.filters[i].value + "' ";
                        }
                        if (filter.filters[i].@operator == "gte")
                        {
                            condition = " >= '" + filter.filters[i].value + "' ";
                        }
                        if (filter.filters[i].@operator == "gt")
                        {
                            condition = " > '" + filter.filters[i].value + "' ";
                        }
                        if (filter.filters[i].@operator == "lte")
                        {
                            condition = " <= '" + filter.filters[i].value + "' ";
                        }
                        if (filter.filters[i].@operator == "lt")
                        {
                            condition = "< '" + filter.filters[i].value + "' ";
                        }
                        filters += filter.filters[i].field + condition;
                        if (filter.filters.Count > c)
                        {
                            filters += logic;
                            filters += " ";
                        }
                        c++;
                    }
                }
                return filters;
            }
            catch
            {
                throw;
            }
        }

        #endregion




    }
}