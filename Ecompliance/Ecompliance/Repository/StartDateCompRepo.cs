using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using Ecompliance.Utils;
namespace Ecompliance.Repository
{
    public class StartDateCompRepo
    {
        public DataTable GetStartDatComp(string CompanyID,int UID = 0)
        {

            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@CompanyId",CompanyID),
                    new SqlParameter("@UID",UID)
                };
                dt = DataLib.ExecuteDataTable("[GetStartDatComp_1]", CommandType.StoredProcedure, parameters);
                return dt;
            }
            catch
            {
                throw;
            }
        }
    }
}