using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using Ecompliance.Areas.Master.Models;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.Areas.Report.Models;
using Ecompliance.Utils;
using Newtonsoft.Json;
using Ecompliance.Areas.FileExplorer.Models;
using System.Text;

namespace Ecompliance.Repository
{
    public class FileExplorerRepo
    {
        public Response GetFileExplorer()
        {
            Customer CustModel = new Customer();
            CustomerRepo objCustRepo = new CustomerRepo();
            DataSet DsCust = new DataSet();
            TaskRepo objTask = new TaskRepo();
            List<CustomerFileExplorer> finalTree = new List<CustomerFileExplorer>();
            Response ret = new Response();
            try
            {
                CustModel.CustID = 0;
                CustModel.IsAct = true;
                CustModel.Name = "";
                CustModel.UID = ((User)HttpContext.Current.Session["uBo"]).UID;
                DsCust = objCustRepo.GetCustomer(CustModel);
                for (int i = 0; i < DsCust.Tables[0].Rows.Count; i++)
                {
                    //Customer List
                    CustomerFileExplorer objCust = new CustomerFileExplorer();
                    objCust.text = DsCust.Tables[0].Rows[i]["Name"].ToString();
                    objCust.CustID = Convert.ToInt32(DsCust.Tables[0].Rows[i]["CustID"]);
                    objCust.expanded = false;

                    // Company List
                    Company CompModel = new Company();
                    CompanyRepo objComp = new CompanyRepo();
                    CompModel.CompanyID = 0;
                    CompModel.Customer = objCust.CustID;
                    CompModel.IsAct = true;
                    CompModel.Name = "";
                    CompModel.UID = ((User)HttpContext.Current.Session["uBo"]).UID;
                    
                    DataTable dtComp = new DataTable();
                    dtComp = objComp.GetCompanyList(CompModel);
                    List<CompanyFileExplorer> items = new List<CompanyFileExplorer>();

                    for (int j = 0; j < dtComp.Rows.Count; j++)
                    {
                        CompanyFileExplorer objCompany = new CompanyFileExplorer();
                        objCompany.text = dtComp.Rows[j]["Name"].ToString();
                        objCompany.CompID = Convert.ToInt32(dtComp.Rows[j]["CompID"]);
                        objCompany.SiteID = 0;
                        objCompany.ActID = 0;
                        objCompany.ActivityID = 0;
                        objCompany.Year = 0;
                        objCompany.Month = "";
                        objCompany.expanded = false;
                        DataTable dtSite = new DataTable();
                        dtSite = TaskRepo.GetMappedSite(objCompany.CompID, ((User)HttpContext.Current.Session["uBo"]).UID);
                        
                        List<SiteFileExplorer> items1 = new List<SiteFileExplorer>();
                        for (int k = 0; k < dtSite.Rows.Count; k++)
                        {
                            SiteFileExplorer objSite = new SiteFileExplorer();
                            objSite.text = dtSite.Rows[k]["Name"].ToString();
                            objSite.SiteID = Convert.ToInt32(dtSite.Rows[k]["SiteID"].ToString());
                            objSite.CompID = objCompany.CompID;
                            objSite.ActID = 0;
                            objSite.ActivityID = 0;
                            objSite.Year = 0;
                            objSite.Month = "";
                            objSite.expanded = false;
                            items1.Add(objSite);

                            DataTable dtAct = new DataTable();
                            dtAct = TaskRepo.GetMappedActs(objCompany.CompID, 0, objSite.SiteID);
                            
                            List<ActFileExplorer> itemsAct = new List<ActFileExplorer>();
                            for (int l = 0; l < dtAct.Rows.Count; l++)
                            {
                                ActFileExplorer objAct = new ActFileExplorer();
                                objAct.text = dtAct.Rows[l]["Name"].ToString();
                                objAct.ActID = Convert.ToInt32(dtAct.Rows[l]["ActID"].ToString());
                                objAct.CompID = objCompany.CompID;
                                objAct.SiteID = objSite.SiteID;
                                objAct.ActivityID = 0;
                                objAct.Year = 0;
                                objAct.expanded = false;
                                
                                DataTable dtActivity = new DataTable();
                                dtActivity = TaskRepo.GetMappedActivity(objCompany.CompID, 0, objSite.SiteID, objAct.ActID);
                                List<ActivityFileExplorer> itemsActivity = new List<ActivityFileExplorer>();
                                for (int m = 0; m < dtActivity.Rows.Count; m++)
                                {
                                    ActivityFileExplorer objActivity = new ActivityFileExplorer();
                                    objActivity.text = dtActivity.Rows[m]["Name"].ToString();
                                    objActivity.ActivityID = Convert.ToInt32(dtActivity.Rows[m]["ActivityID"]);
                                    objActivity.CompID = objCompany.CompID;
                                    objActivity.SiteID = objSite.SiteID;
                                    objActivity.ActID = objAct.ActID;
                                    objActivity.Year = 0;
                                    objActivity.Month = "";
                                    objActivity.expanded = false;
                                    objActivity.items = GetYearMonth(objActivity.ActivityID, objActivity.CompID, objActivity.SiteID, objActivity.ActID);
                                    itemsActivity.Add(objActivity);
                                }
                                objAct.items = itemsActivity;
                                itemsAct.Add(objAct);
                            }
                            objSite.items = itemsAct;
                        }
                        objCompany.items = items1;
                        items.Add(objCompany);
                    }
                    objCust.items = items;
                    finalTree.Add(objCust);
                }
                ret.Data = JsonConvert.SerializeObject(finalTree);
                ret.IsSuccess = true;
                return ret;
            }
            catch { throw; }
        }

        public List<FileExplorer> GetCustomerTreeView(int CustID,int FileID,int ParentId,int UID)
        {
            Customer CustModel = new Customer();
            CustomerRepo objCustRepo = new CustomerRepo();
            DataSet DsCust = new DataSet();
            List<FileExplorer> finalTree = new List<FileExplorer>();
            Response ret = new Response();
            try
            {
                //CustModel.UID = ((User)HttpContext.Current.Session["uBo"]).UID;
                
                DsCust = GetFileExplorer(CustID,FileID,ParentId,UID);
                for (int i = 0; i < DsCust.Tables[0].Rows.Count; i++)
                {
                    //Customer List
                    FileExplorer objCust = new FileExplorer();
                    if (CustID == 0 && FileID == 0 && ParentId == 0)
                    {
                        objCust.text = DsCust.Tables[0].Rows[i]["CustomerName"].ToString();
                        objCust.id = 0;
                        objCust.hasChildren = Convert.ToBoolean(Convert.ToInt32(DsCust.Tables[0].Rows[i]["hasChildren"]));
                        objCust.ParentId = 0;
                        objCust.CustomerID = Convert.ToInt32(DsCust.Tables[0].Rows[i]["CustomerID"]);
                        objCust.expanded = false;
                        finalTree.Add(objCust);
                    }
                    else
                    {
                        objCust.text = DsCust.Tables[0].Rows[i]["FileOriginalName"].ToString();
                        objCust.id = Convert.ToInt32(DsCust.Tables[0].Rows[i]["FileID"]);
                        objCust.hasChildren = Convert.ToBoolean(Convert.ToInt32(DsCust.Tables[0].Rows[i]["hasChildren"]));
                        objCust.ParentId = Convert.ToInt32(DsCust.Tables[0].Rows[i]["PID"]); ;
                        objCust.CustomerID = Convert.ToInt32(DsCust.Tables[0].Rows[i]["CustomerID"]);
                        objCust.expanded = false;
                        finalTree.Add(objCust);
                    }
                }
                
                return finalTree;
            }
            catch
            {
                throw;
            }
        }
        public DataSet GetFileExplorer(int CustID, int FileID, int ParentId,int UID)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@CustomerID", CustID),
                    new SqlParameter("@ParrentID", ParentId),
                    new SqlParameter("@FileID", FileID),
                    new SqlParameter("@UID", UID)
                };
                return DataLib.ExecuteDataSet("GetFileExplorer_25_09_2017", CommandType.StoredProcedure, p); //GetFileExplorer
            }
            catch { throw; }
        }
        public string GetParrentFolder(int? FileID,string FileType)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@FileID", FileID),
                    new SqlParameter("@FileType", FileType)
                };
                return DataLib.ExecuteScaler("GetParrentFolder", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }
        public string GetParrentFolderForRename(int? FileID)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@FileID", FileID),
                };
                return DataLib.ExecuteScaler("GetParrentFolderForRename", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }
        public string CreateNewFolder(int? CustID, int? FileID, int? ParentID, string FolderName,string SystemGenPath,int UID)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@CustomerID", CustID),
                    new SqlParameter("@FileID", FileID),
                    new SqlParameter("@ParrentID", ParentID),
                    new SqlParameter("@OriginalName", FolderName),
                    new SqlParameter("@SystemGenPath", SystemGenPath),
                    new SqlParameter("@UID", UID),
                };
                return DataLib.ExecuteScaler("CreateNewFolder", CommandType.StoredProcedure, p);
            }
            catch
            {
                throw;
            }
        }

        public string DeleteFolder(int? FileID, int UID)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@FileID", FileID),
                    new SqlParameter("@UID", UID),
                };
                return DataLib.ExecuteScaler("DeleteFolder", CommandType.StoredProcedure, p);
            }
            catch
            {
                throw;
            }
        }

        public DataSet GetAllChildFile(int CustID,int FileID)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@CustomerID", CustID),
                    new SqlParameter("@FileID", FileID),
                };
                return DataLib.ExecuteDataSet("GetAllChildFile", CommandType.StoredProcedure, p);
            }
            catch
            {
                throw;
            }
        }
        public DataSet GetFileMetaData(int CustID, int FileID, int FileMetaID)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@CustomerID", CustID),
                    new SqlParameter("@FileMetaID", FileMetaID),
                };
                return DataLib.ExecuteDataSet("GetFileMetaData", CommandType.StoredProcedure, p);
            }
            catch
            {
                throw;
            }
        }

        public string AddFile(int CustID, int FileID, string OriginalFileName, string TempFileName, string MetaValue, string FileTypeName,string FileExtention,double FileSize,int CreatedBy)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@FileID", FileID),
                    new SqlParameter("@CustomerID", CustID),
                    new SqlParameter("@FileOriginalName", OriginalFileName),
                    new SqlParameter("@FileSystemGeneratedName", TempFileName),
                    new SqlParameter("@FileTypeName", FileTypeName),
                    new SqlParameter("@MetaValue", MetaValue),
                    new SqlParameter("@FileExtention", FileExtention),
                    new SqlParameter("@FileSize", FileSize),
                    new SqlParameter("@CreatedBy", CreatedBy)
                };
                return DataLib.ExecuteScaler("AddFile", CommandType.StoredProcedure, p);
            }
            catch
            {
                throw;
            }
        }
        public DataSet GetFileInfo(int FileID)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@FileID", FileID),
                };
                return DataLib.ExecuteDataSet("GetFileInfo", CommandType.StoredProcedure, p);
            }
            catch
            {
                throw;
            }
        }
        public DataSet GetMetaDetaFileForSearch(int CustID, int FileID, string text)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@CustID", CustID),
                    new SqlParameter("@FileID", FileID),
                    new SqlParameter("@text", text),
                };
                return DataLib.ExecuteDataSet("GetMetaDetaFileForSearch", CommandType.StoredProcedure, p);
            }
            catch
            {
                throw;
            }
        }
        public string RenmaeFile(int FileID, string OldName, string NewName,string NewPath,string Filetype)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@FileID", FileID),
                    new SqlParameter("@OldName", OldName),
                    new SqlParameter("@NewName", NewName),
                    new SqlParameter("@FileSystemGeneratedName", NewPath),
                    new SqlParameter("@Filetype", Filetype),
                };
                return DataLib.ExecuteScaler("RenmaeFile", CommandType.StoredProcedure, p);
            }
            catch
            {
                throw;
            }
        }
        public List<YearFileExplorer> GetYearMonth(int ActivityID, int CompID, int SiteID, int ActID)
        {
            try
            {
                List<YearFileExplorer> items = new List<YearFileExplorer>();
                for (int i=0; i < 3; i++)
                {
                    YearFileExplorer obj = new YearFileExplorer();
                    int year;
                    if (i == 0)
                    {
                        year = Convert.ToInt32(DateTime.Now.AddYears(-1).Year);
                    }
                    else
                    {
                        year = Convert.ToInt32(DateTime.Now.AddYears(i-1).Year);
                    }

                    obj.text = year.ToString();
                    obj.Year = year;
                    obj.CompID = CompID;
                    obj.SiteID = SiteID;
                    obj.ActID = ActID;
                    obj.ActivityID = ActivityID;
                    obj.Month = "";
                    obj.expanded = false;
                    obj.items = Month(ActivityID, CompID, SiteID, ActID, year);
                    items.Add(obj);
                }

                return items;
            }
            catch { throw; }
        }
        public List<MonthFileExplorer> Month(int ActivityID, int CompID, int SiteID, int ActID,int Year)
        {
            try
            {
                List<MonthFileExplorer> items = new List<MonthFileExplorer>();
                items.Add(new MonthFileExplorer("JAN", "JAN", CompID, SiteID, ActID, ActivityID, Year, false));
                items.Add(new MonthFileExplorer("FEB", "FEB", CompID, SiteID, ActID, ActivityID, Year, false));
                items.Add(new MonthFileExplorer("MAR", "MAR", CompID, SiteID, ActID, ActivityID, Year, false));
                items.Add(new MonthFileExplorer("APR", "APR", CompID, SiteID, ActID, ActivityID, Year, false));
                items.Add(new MonthFileExplorer("MAY", "MAY", CompID, SiteID, ActID, ActivityID, Year, false));
                items.Add(new MonthFileExplorer("JUNE", "JUNE", CompID, SiteID, ActID, ActivityID, Year, false));
                items.Add(new MonthFileExplorer("JULY", "JULY", CompID, SiteID, ActID, ActivityID, Year, false));
                items.Add(new MonthFileExplorer("AUG", "AUG", CompID, SiteID, ActID, ActivityID, Year, false));
                items.Add(new MonthFileExplorer("SEPT", "SEPT", CompID, SiteID, ActID, ActivityID, Year, false));
                items.Add(new MonthFileExplorer("OCT", "OCT", CompID, SiteID, ActID, ActivityID, Year, false));
                items.Add(new MonthFileExplorer("NOV", "NOV", CompID, SiteID, ActID, ActivityID, Year, false));
                items.Add(new MonthFileExplorer("DEC", "DEC", CompID, SiteID, ActID, ActivityID, Year, false));
                return items;
            }
            catch
            { throw; }
        }

        public DataTable GetDocFileExplorer(int CompID,int SiteID,int ActID,int ActivityID,int Year,string Month,int UID)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@CompID",CompID ),
                    new SqlParameter("@SiteID",SiteID ),
                    new SqlParameter("@ActID",ActID ),
                    new SqlParameter("@ActivityID",ActivityID ),
                    new SqlParameter("@Year",Year ),
                    new SqlParameter("@Month",Month ),
                    new SqlParameter("@UID",UID ),
                };

                return DataLib.ExecuteDataTable("GetDocFileExplorer", CommandType.StoredProcedure, parameters);
            }
            catch (Exception ex) { throw; }
        }

        public string SendMailEXl(string RootParentFolder, int FileID)
        {
            StringBuilder mailbody = new StringBuilder("");
            string mailTo = "";
            string CC = "";
            string BCC = "";
            mailbody.Append("<body><header style=\"width:996px; margin:auto;\"><div style=\"font-family:Arial, Helvetica, sans-serif; color:#444; font-size:18px;font-weight:bold;\"> ");
            mailbody.Append(" Dear User,       </div></header><section style=\"width:996px; margin:auto;\"><div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;\"><p>The following activity has been initiated on MyndAct portal file explore. The summary of the same is as below:  ");
            mailbody.Append("<br>User have uploaded a document. <br>Request you to take the necessary action, if any, so that the compliance task can be completed within stipulated time period<br>");
            mailbody.Append(" Click here to login to MyndAct http://myndact.com/?AspxAutoDetectCookieSupport=1  </p></div> ");
            mailbody.Append(" </section> <footer style=\"width:996px; margin:auto;\"> <div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;padding:5px 0px;\">Thanks & Regards <br> MyndAct Team</div> ");
            mailbody.Append(" </footer></body>");


            DataTable dt = new DataTable();
            // dt = DataLib.ExecuteDataTable("GetCustomerUsersEmail", CommandType.StoredProcedure, null);
            //  if (uRole == "User")
            //  if (RootParentFolder == "Input From EXL")
            // {
            //for (int i = 0; i < dt.Rows.Count; i++)
            //{
            //    if (dt.Rows[i]["Role"].ToString() == "Customer Admin" || dt.Rows[i]["Role"].ToString()=="User")
            //    {
            //        mailTo += dt.Rows[i]["Email"].ToString() + ",";
            //    }
            //}

            // }
            //    else if(uRole == "Customer Admin")
            //else if (RootParentFolder == "")
            //{
            //for (int i = 0; i < dt.Rows.Count; i++)
            //{
            //    if (dt.Rows[i]["Role"].ToString() == "Client Admin" )
            //    {
            //        mailTo += dt.Rows[i]["Email"].ToString() + ",";
            //    }
            //}

            //    }


            //  mailTo = mailTo.TrimEnd(',');
            DataTable dtEmails = GetFileEmails(FileID);
            if (dtEmails.Rows.Count > 0)
            {
                mailTo = dtEmails.Rows[0]["To"].ToString();
                CC = dtEmails.Rows[0]["CC"].ToString();
                BCC = dtEmails.Rows[0]["BCC"].ToString();
            }
            if (mailTo != "")
            {
                //    mailTo = "pallavi.bhardwaj@myndsol.com";
                MailUtill.SendMail(mailTo, "Document Upload Alert", mailbody.ToString(),CC, "", BCC);
            }






            return "";
        }

        public DataTable GetFileEmails(int FileID)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@FileID", FileID),
                };
                return DataLib.ExecuteDataTable("GetFileEmails", CommandType.StoredProcedure, p);
            }
            catch
            {
                throw;
            }
        }

        public DataTable RootParent(int FileID)
        {

            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@FileID", FileID),
                };
                return DataLib.ExecuteDataTable("GetRootParent", CommandType.StoredProcedure, p);

            }
            catch
            {
                throw;
            }

        }
    }
 
}