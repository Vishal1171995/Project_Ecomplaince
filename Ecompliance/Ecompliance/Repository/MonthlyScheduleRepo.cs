
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


namespace Ecompliance.Repository
{
    public class MonthlyScheduleRepo
    {

       


        public DataTable GetMonthlyScheudledData(string CompanyID, string Month, string Year, string Type, int UID=0)
        {

            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("CompanyID",CompanyID),
                    new SqlParameter("@Type",Type),
                  
                    new SqlParameter("@Month",Month),
                    new SqlParameter("@Year",Year),
                    new SqlParameter("@UID",UID)
                };

                dt = DataLib.ExecuteDataTable("[MonthlyScheduled_1]", CommandType.StoredProcedure, parameters);

                return dt;
            }

            catch
            {
                throw;
            }



        }


    }
}