using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Ecompliance.Repository
{
    public class AuditorScoreCardRepo
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
        public DataSet GetScoreCardData(string CompanyID, string SiteID, string Month, string Year, string Type, string Maker, string Checker, string Auditor, int UID = 0)
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
                    new SqlParameter("@UID",UID),
                    new SqlParameter("@Maker",Maker),
                    new SqlParameter("@Checker",Checker),
                    new SqlParameter("@Auditor",Auditor)
                };
                return DataLib.ExecuteDataSet("[GetScoreCardDataAuditor]", CommandType.StoredProcedure, parameters);
            }

            catch (Exception ex)
            {
                throw;
            }



        }
    }
}