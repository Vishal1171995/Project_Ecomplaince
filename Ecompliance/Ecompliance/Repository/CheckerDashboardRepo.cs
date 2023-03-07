using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using Ecompliance.Utils;
namespace Ecompliance.Repository
{
    public class CheckerDashboardRepo
    {
        public DataSet GetCheckerDashboard(int UID, int From, int To, string SortingStr, string FilterStr)
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
                return DataLib.ExecuteDataSet("GetCheckerDashboard_1", CommandType.StoredProcedure, parameters); //GetDocTaskGrid_1
            }
            catch
            {
                throw;
            }
        }
    }
}