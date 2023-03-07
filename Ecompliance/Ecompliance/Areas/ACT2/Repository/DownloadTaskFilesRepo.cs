using Ecompliance.Areas.Master.Models;
using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Ecompliance.Areas.ACT2.Repository
{
    public class DownloadTaskFilesRepo
    {
        public void GetDownloadTaskFiles()
        { }

        public DataSet GetCustomerACT2(Customer obj)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@CustID", obj.CustID),
                    new SqlParameter("@IsAct", obj.IsAct),
                    new SqlParameter("@Name", obj.Name),
                    new SqlParameter("@UID",obj.UID )
                };
                return DataLib.ExecuteDataSet("GetCustomerACT2", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }

    }
}