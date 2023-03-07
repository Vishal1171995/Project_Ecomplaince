using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using Ecompliance.Models;
using System.Data.SqlClient;
using Ecompliance.Utils;
using System.Text;
using System.IO;

namespace Ecompliance.Repository
{
    public class TaskFileRepo
    {
        enum MonthName
        {
            Jan,
            Feb,
            Mar,
            Apr,
            May,
            Jun,
            Jul,
            Aug,
            Sep,
            Oct,
            Nov,
            Dec
        }
        public DataTable GetTaskFile(TaskFile model)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[] { new SqlParameter("@DOCID", model.DOCID), new SqlParameter("@FileID", model.FileID) };
                dt = DataLib.ExecuteDataTable("[GetTaskFile]", CommandType.StoredProcedure, parameters);
                return dt;
            }
            catch
            {
                throw;
            }
        }

        public int InsertTaskFile(TaskFile model)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@DOCID", model.DOCID ),            
                    new SqlParameter("@Name", model.Name),
                    new SqlParameter("@Desc", model.Desc),
                    new SqlParameter("@UploadAction", model.UAction ),
                    new SqlParameter("@UID", model.UID)
                };
                return Convert.ToInt32(DataLib.ExecuteScaler("InsertTaskFile", CommandType.StoredProcedure, parameters));
            }

            catch
            {
                throw;
            }
        }

        public int DeleteTaskFile(TaskFile model)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]{new SqlParameter("@DOCID", model.DOCID ),new SqlParameter("@FileID", model.FileID)};
                return Convert.ToInt32(DataLib.ExecuteScaler("DeleteTaskFile", CommandType.StoredProcedure, parameters));
            }

            catch
            {
                throw;
            }
        }


        public DataTable GetEmailsTaskFile(int CompanyID)
        {

            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[] { new SqlParameter("@CompanyID", CompanyID)};
                dt = DataLib.ExecuteDataTable("[GetCompanyEmailIds]", CommandType.StoredProcedure, parameters);
                return dt;
            }
            catch
            {
                throw;
            }

        }

        public DataSet GetFailedTaskFile(string Year = null, string Month = null, string CustomerID = null, string CompanyID = null)
        {

            DataSet dt = new DataSet();
            try
            {
                SqlParameter[] parameters = new SqlParameter[] { new SqlParameter("@Year", Year), new SqlParameter("@Month", Month) ,
                    new SqlParameter("@CustomerID", CustomerID),new SqlParameter("@CompanyID", CompanyID)
                };
                dt = DataLib.ExecuteDataSet("[GetTaskFileErrLog_0920]", CommandType.StoredProcedure, parameters);
                return dt;
            }
            catch
            {
                throw;
            }

        }



       

        public void SendMailsForFileErrLog() {
            try
            {
                DataSet ds = GetFailedTaskFile();
                DataTable dtrecords = ds.Tables[0];
                DataTable dtSiteData = ds.Tables[1];
                DataTable dtCompanyData = ds.Tables[2];
                foreach (DataRow row in dtSiteData.Rows)
                {
                    dtrecords.DefaultView.RowFilter = "SiteID=" + row["SiteID"].ToString();
                    DataTable dtfilteredrecords = dtrecords.DefaultView.ToTable();
                    string FileName = CSVUtills.DataTableToCSV(dtfilteredrecords, ",");
                    StringBuilder mailbody = new StringBuilder("");
                    mailbody.Append(" <body><header style=\"width:996px; margin:auto;\"><div style=\"font-family:Arial, Helvetica, sans-serif; color:#444; font-size:18px;font-weight:bold;\"> ");
                    mailbody.Append(" Dear User,       </div></header><section style=\"width:996px; margin:auto;\"><div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;\"><p>File Creation for Site '" + dtfilteredrecords.Rows[0]["Site"] + "' has failed on some documents, total number of file creation failed are " + dtfilteredrecords.Rows.Count);
                    mailbody.Append("</p></div> ");
                    mailbody.Append(" </section> <footer style=\"width:996px; margin:auto;\"> <div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;padding:5px 0px;\">Thanks & Regards <br> Team ACT Compliance</div> ");
                    mailbody.Append(" </footer></body>");
                    MailUtill.SendMail(row["Email"].ToString(), "File creation Result", mailbody.ToString(), "", FileName, "");

                }

                foreach (DataRow row in dtCompanyData.Rows)
                {
                    dtrecords.DefaultView.RowFilter = "CompanyID=" + row["CompID"].ToString();
                    DataTable dtfilteredrecords = dtrecords.DefaultView.ToTable();
                    string FileName = CSVUtills.DataTableToCSV(dtfilteredrecords, ",");
                    StringBuilder mailbody = new StringBuilder("");
                    mailbody.Append(" <body><header style=\"width:996px; margin:auto;\"><div style=\"font-family:Arial, Helvetica, sans-serif; color:#444; font-size:18px;font-weight:bold;\"> ");
                    mailbody.Append(" Dear User,       </div></header><section style=\"width:996px; margin:auto;\"><div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;\"><p>File Creation for Company '" + dtfilteredrecords.Rows[0]["Company"] + "' has failed on some documents, total number of file creation failed are " + dtfilteredrecords.Rows.Count);
                    mailbody.Append("</p></div> ");
                    mailbody.Append(" </section> <footer style=\"width:996px; margin:auto;\"> <div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;padding:5px 0px;\">Thanks & Regards <br> Team ACT Compliance</div> ");
                    mailbody.Append(" </footer></body>");
                    MailUtill.SendMail(row["Email"].ToString(), "File creation Result", mailbody.ToString(), "", FileName, "");

                }
            }
            catch { }
            // dtRecords.DefaultView

        }


        public Response RunManualCreation(string Year, string Month, string CustomerID, string CompanyID)
        {
            Response ret = new Response();

            DataTable dt = GetFailedTaskFile(Year, Month, CustomerID, CompanyID).Tables[0];
            if (dt.Rows.Count == 0)
            {
                ret.IsSuccess = true;
                ret.Message = "No files to process for the given date !";
                return ret;
            }
            Scheduler scheduler = new Scheduler();
            int Successcount = 0;
            int FailedCount = 0;
            foreach (DataRow row in dt.Rows)
            {
                int result = scheduler.InsertTaskFile(Convert.ToInt32(row["DocID"].ToString()), row["Paydate1"].ToString(), Convert.ToInt32(row["StateID"].ToString()), Convert.ToInt32(row["CompanyID"].ToString()), Convert.ToInt32(row["SiteID"].ToString()), Convert.ToInt32(row["ActID"].ToString()), Convert.ToInt32(row["ActivityID"].ToString()), row["TaskDate"].ToString(), "Manual Creation Failed");
                if (result == 1)
                { Successcount += 1; }
                else { FailedCount += 1; }
            }
            SendMailsForFileErrLog();
            ret.IsSuccess = true;
            ret.Message = "Files processed for the given date. <br/> Total Records Processed :" + dt.Rows.Count + " , Out of which " + Successcount.ToString() + " processed successfully and " + FailedCount + " failed.";
            return ret;
        }
        public DataTable GetDatForFileErrReport(string Type , string Date, int uid)
        {

            DataTable  dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[] { new SqlParameter("@UID", uid) ,
                new SqlParameter("@Type", Type)
                ,new SqlParameter("@Date", Date)
                };
                dt = DataLib.ExecuteDataTable("[GetTaskFileErrLogReport]", CommandType.StoredProcedure, parameters);
                return dt;
            }
            catch
            {
                throw;
            }
            //  GetTaskFileErrLogReport
        }


        public Response GetTaskFileForDownload(int Month, int Year,  int CustID, int CompID, int SiteID, int uid, string SessionID)
        {
            Response res = new Response();
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                { new SqlParameter("@UID", uid),
                new SqlParameter("@Month", Month),
                  new SqlParameter("@Year", Year),
                new SqlParameter("@CustomerID", CustID),
                new SqlParameter("@CompanyID", CompID),
                new SqlParameter("@SiteID", SiteID)
                   };
                dt = DataLib.ExecuteDataTable("[GetFilesForDownload]", CommandType.StoredProcedure, parameters);
                if (!(Directory.Exists(System.Web.HttpContext.Current.Server.MapPath("~/Docs/TaskFileDownload"))))
                { Directory.CreateDirectory(System.Web.HttpContext.Current.Server.MapPath("~/Docs")+ "\\TaskFileDownload"); }
                if (dt.Rows.Count > 0)
                {
                   
                    
                    string password = "";
                    string path = System.Web.HttpContext.Current.Server.MapPath("~/Docs/TaskFileDownload");
                    if ((Directory.Exists(path + "\\" + SessionID)))
                    { Directory.Delete(path + "\\" + SessionID, true); }
                    Directory.CreateDirectory(path + "\\" + SessionID);
                    if ((Directory.Exists(path + "\\" + SessionID + "\\" + Month + "-" + Year)))
                    { Directory.Delete(path + "\\" + SessionID + "\\" + Month + "-" + Year, true); }
                    Directory.CreateDirectory(path + "\\" + SessionID + "\\" + Month + "-" + Year);
                    DataTable dtCustomers = dt.DefaultView.ToTable("Customer", true, "Customer");

                    foreach (DataRow row in dtCustomers.Rows)
                    {   // First loop customer Folder
                        try {
                            if ((Directory.Exists(path + "\\" + SessionID + "\\" + Month + "-" + Year + "\\" + row["Customer"])))
                            {
                                Directory.Delete(path + "\\" + SessionID + "\\" + Month + "-" + Year + "\\" + row["Customer"], true);
                            }
                            Directory.CreateDirectory(path + "\\" + SessionID + "\\" + Month + "-" + Year + "\\" + row["Customer"]);
                            MonthName MonthInitial;
                            Enum.TryParse<MonthName>((Month-1).ToString(), out MonthInitial);
                            password = row["Customer"].ToString().Replace("'", "''").Substring(0,3)+"@" + MonthInitial + Year;
                            dt.DefaultView.RowFilter = "Customer ='" + row["Customer"].ToString().Replace("'", "''") + "'";
                            DataTable dtCustData = dt.DefaultView.ToTable();
                            foreach (DataRow custrow in dtCustData.DefaultView.ToTable("Company", true, "Company").Rows)
                            { // Second loop Comapany Folder
                                try {
                                    
                                    if ((Directory.Exists(path + "\\" + SessionID + "\\" + Month + "-" + Year + "\\" + row["Customer"] + "\\" + custrow["Company"])))
                                    { Directory.Delete(path + "\\" + SessionID + "\\" + Month + "-" + Year + "\\" + row["Customer"] + "\\" + custrow["Company"], true); }
                                    Directory.CreateDirectory(path + "\\" + SessionID + "\\" + Month + "-" + Year + "\\" + row["Customer"] + "\\" + custrow["Company"]);

                                    dt.DefaultView.RowFilter = "Company ='" + custrow["Company"].ToString().Replace("'", "''") + "'";
                                    DataTable dtCompData = dt.DefaultView.ToTable();
                                    foreach (DataRow comprow in dtCompData.DefaultView.ToTable("", true, "Site").Rows)
                                    { // Third loop Site Folder
                                        try {
                                            if ((Directory.Exists(path + "\\" + SessionID + "\\" + Month + "-" + Year + "\\" + row["Customer"] + "\\" + custrow["Company"] + "\\" + comprow["Site"])))
                                            { Directory.Delete(path + "\\" + SessionID + "\\" + Month + "-" + Year + "\\" + row["Customer"] + "\\" + custrow["Company"] + "\\" + comprow["Site"], true); }
                                            Directory.CreateDirectory(path + "\\" + SessionID + "\\" + Month + "-" + Year + "\\" + row["Customer"] + "\\" + custrow["Company"] + "\\" + comprow["Site"]);

                                            dt.DefaultView.RowFilter = "Site ='" + comprow["Site"].ToString().Replace("'", "''") + "'";
                                            DataTable dtSiteData = dt.DefaultView.ToTable();

                                            foreach (DataRow siterow in dtSiteData.Rows)
                                            {
                                                string filename = siterow["Name"].ToString();
                                                string filenameDownload = siterow["Desc"].ToString();
                                                string filepath = System.Web.HttpContext.Current.Server.MapPath("~/Docs/Task/") + filename;
                                                //  string CopyPath = System.Web.HttpContext.Current.Server.MapPath("~/Docs/TaskFileDownload/") + SessionID + Month + "-" + Year + "\\" + row["Customer"] + "\\" + custrow["Company"] + "\\" + comprow["Site"] + "\\" + filename;
                                                string CopyPath = System.Web.HttpContext.Current.Server.MapPath("~/Docs/TaskFileDownload/") + SessionID +"\\"+ Month + "-" + Year + "\\" + row["Customer"] + "\\" + custrow["Company"] + "\\" + comprow["Site"] + "\\" + filenameDownload;
                                                if (System.IO.File.Exists(CopyPath))
                                                    System.IO.File.Delete(CopyPath);
                                                if (System.IO.File.Exists(filepath))
                                                {
                                                    System.IO.File.Copy(filepath, CopyPath);
                                                }
                                            }
                                        }
                                        catch(Exception ex)
                                        { continue; }

                                        // Third loop Site Folder
                                    }

                                }
                                catch
                                { continue; }
                                // Second loop Comapany Folder
                            }
                        }
                        catch 
                        { continue; }
                        //               First Loop Customer Folder
                        //{ }
                    }


                    res.Data = password;
                    res.IsSuccess = true;
                    res.Message = "Files Generated";


                }

        }
            catch(Exception ex)
            {
                res.Data = "";
                res.IsSuccess = false;
                res.Message = "Files Generation Failed";
            }



            return res;



        }

    }
}