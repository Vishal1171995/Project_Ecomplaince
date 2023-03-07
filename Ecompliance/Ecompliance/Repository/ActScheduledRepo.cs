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
    public class ActScheduledRepo
    {
       


        public DataTable GetActScheduledData(string CompanyID, string Month, string Year, string Type,int UID=0)
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
                      new SqlParameter("@UID",UID)
                    
                    

                     
                };

                dt = DataLib.ExecuteDataTable("[GetActScheduledReport_1]", CommandType.StoredProcedure, parameters);

                return dt;
            }

            catch
            {
                throw;
            }



        }


        public DataTable GetActScheduledDataDetails(string CompanyID, string SiteID,string ActID, string Month, string Year, string Type,int UID=0 )
        {

            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Type",Type),
                    new SqlParameter("@CompanyId",CompanyID),
                    new SqlParameter("@SiteID",SiteID),
                    new SqlParameter("@ActID",ActID),
                    new SqlParameter("@Month",Month),
                    new SqlParameter("@Year",Year),
                      new SqlParameter("@UID",UID)
                    
                    

                     
                };

                dt = DataLib.ExecuteDataTable("[GetActScheduledReport_Details]", CommandType.StoredProcedure, parameters);

                return dt;
            }

            catch
            {
                throw;
            }



        }
    }
}