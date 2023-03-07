using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
//using Ecompliance.Utils;
using System.Linq;
using System.Web;

namespace Ecompliance.Areas.ACT2.Repository
{
    public class BackDateRepo
    {
        Scheduler obj = new Scheduler();
        public void ExecuteFileScheduler(string Year, string Month, int CustomerID, int CompanyID)
        {
            DataTable dt = new DataTable();
            int PayYear = Convert.ToInt32(Year);
            int PayMonth = Convert.ToInt32(Month);
            PayYear = PayMonth == 12 ? PayYear + 1 : PayYear;
            PayMonth = PayMonth == 12 ? 1 : PayMonth + 1;
            try
            {
                SqlParameter[] p =
                 {
                    new SqlParameter("@Month", PayMonth),
                       new SqlParameter("@Year", PayYear),
                       new SqlParameter("@CustomerID", CustomerID),
                       new SqlParameter("@CompanyID", CompanyID)
                };
                dt = DataLib.ExecuteDataTable("[GetDocTaskFileNotGen]", CommandType.StoredProcedure, p);
            }
            catch { }
            DateTime Paydate = new DateTime(Convert.ToInt32(Year), Convert.ToInt32(Month), DateTime.DaysInMonth(Convert.ToInt32(Year), Convert.ToInt32(Month)));

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                obj.InsertTaskFile(Convert.ToInt32(dt.Rows[i]["DOCID"]), Paydate.ToString("yyyy-MM-dd"), Convert.ToInt32(dt.Rows[i]["State"].ToString()), Convert.ToInt32(dt.Rows[i]["Companyid"].ToString()), Convert.ToInt32(dt.Rows[i]["SiteID"].ToString()), Convert.ToInt32(dt.Rows[i]["Actid"].ToString()), Convert.ToInt32(dt.Rows[i]["Activityid"].ToString()), DateTime.Now.ToString("yyyy/MM/dd"), "Creation Failed");

            }

        }
    }
}