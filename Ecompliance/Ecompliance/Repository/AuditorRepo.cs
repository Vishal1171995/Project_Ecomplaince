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
    public class AuditorRepo
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
        public DataTable GetAuditorScoreCardData(string CompanyID, string SiteID, string Month, string Year, string Type, int UID = 0)
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
                };
                return DataLib.ExecuteDataTable("[GetAuditorScoreCardData]", CommandType.StoredProcedure, parameters);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public Response SetAuditee_Auditor(List<Auditor> Model, int UID, string Status)
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
            catch (Exception ex) { throw; }
        }
    }
}