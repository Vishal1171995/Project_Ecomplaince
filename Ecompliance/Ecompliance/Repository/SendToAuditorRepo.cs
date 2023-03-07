using Ecompliance.Areas.Report.Models;
using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Ecompliance.Repository
{
    public class SendToAuditorRepo
    {
        public static DataTable GetYear()
        {
            DataTable dt = new DataTable();
            try
            {

                dt.Columns.Add("Year", typeof(string));
                for (int i = 2016; i <= DateTime.Now.Year; i++)
                {
                    dt.Rows.Add(i.ToString());
                }
                return dt;
            }
            catch
            {
                throw;
            }
        }
        public DataTable GetSendToScoreCardData(string CompanyID, string SiteID, string Month, string Year, string Type, int UID = 0)
        {

            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Type",Type),
                    new SqlParameter("@CompanyId",CompanyID),
                    new SqlParameter("@Month",Month),
                    new SqlParameter("@Year",Year),
                    new SqlParameter("@Site",SiteID),
                    new SqlParameter("@UID",UID)
                    //new SqlParameter("@Maker",Maker),
                    //new SqlParameter("@Checker",Checker),
                    //new SqlParameter("@Auditor",Auditor)
                };
                return DataLib.ExecuteDataTable("[GetSendToScoreCardData]", CommandType.StoredProcedure, parameters);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public Response SetAuditee_Auditor(List<SendToAuditor> Model,int UID,string Status)
        {
            int result = 0;
            Response res = new Response();
            try
            {
                if (Model.Count > 0)
                {
                    for (int i = 0; i < Model.Count; i++)
                    {
                        SqlParameter[] parameters = new SqlParameter[]
                        {
                            new SqlParameter("@DOCID",Model[i].DocID),
                            new SqlParameter("@Remarks",Model[i].Remarks),
                            new SqlParameter("@UID",UID),
                            new SqlParameter("@Status",Status)
                        };
                        result = Convert.ToInt32(DataLib.ExecuteScaler("SetAuditee_Auditor_1", CommandType.StoredProcedure, parameters));
                    }
                }
                res.IsSuccess = true;
                res.Message = "Updated sucessfully";
                return res;
            }
            catch(Exception ex) { throw; }
        }

        // Vivek===================================================
        public DataSet GetCRMMSGData(int DOCID)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                new SqlParameter("@DOC_ID",DOCID),
                };
                return DataLib.ExecuteDataSet("[GETCRMMSG_DATA]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }
        public Response SetUploaderRemarks(string Remarks, int Docid,int UID)
        {
            Response res = new Response();
            int result = 0;
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                new SqlParameter("@DOCID",Docid),
                new SqlParameter("@Remarks",Remarks),
                new SqlParameter("@UID",UID),
                };
                result = Convert.ToInt32(DataLib.ExecuteScaler("SetAuditeeUploaderRemarks", CommandType.StoredProcedure, parameters));
                res.IsSuccess = true;
                res.Message = "Updated sucessfully";
                return res;
            }
            catch (Exception ex) { throw; }
        }


    }
}