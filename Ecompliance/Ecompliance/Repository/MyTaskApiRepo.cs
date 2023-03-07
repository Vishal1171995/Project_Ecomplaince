using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Ecompliance.Repository
{
    public class MyTaskApiRepo
    {
        public DataTable GetMyTask(string Type, int CompID, int SMonth, int TMonth, int Syear, int Tyear, int UID, int From, int To, string SortingStr, string FilterStr)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Type",Type),
                    new SqlParameter("@CompID",CompID),
                    new SqlParameter("@SMonth",SMonth),
                    new SqlParameter("@TMonth",TMonth),
                    new SqlParameter("@Syear",Syear),
                    new SqlParameter("@Tyear",Tyear),
                    new SqlParameter("@UID",UID),
                    new SqlParameter("@FromNumber",From),
                    new SqlParameter("@ToNumber",To),
                    new SqlParameter("@SQLSortString",SortingStr),
                    new SqlParameter("@SQLFilterString",FilterStr)
                };
                return DataLib.ExecuteDataTable("GetMyTaskForAPI", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }

        public DataSet GetDocDtlForAPI(int DOCID)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@DOCID",DOCID),
                };
                return DataLib.ExecuteDataSet("GetDocDtlForAPI", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }
    }
}