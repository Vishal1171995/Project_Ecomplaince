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
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Ecompliance.Repository
{
    public class ScoreCardRepo
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
        public DataTable GetScoreCardData(string CompanyID,string SiteID, string Month, string Year,string Type, int UID=0)
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
                return  DataLib.ExecuteDataTable("[GetScoreCardData_1]", CommandType.StoredProcedure, parameters);
            }

            catch
            {
                throw;
            }

          

        }

    }
}