using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Ecompliance.Utils;
using System.Data;
using System.Data.SqlClient;

namespace Ecompliance.Repository
{
    public class QuickStartRepo
    {
        public DataTable GetQuickStartStatus(int UID)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]{new SqlParameter("@UID",UID )};
                return DataLib.ExecuteDataTable("[GetQuickStartStatus]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }

        }
    }
}