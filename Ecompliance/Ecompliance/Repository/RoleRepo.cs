using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using Ecompliance.Utils;
using Ecompliance.Areas.Admin.Models;
namespace Ecompliance.Repository
{
    public class RoleRepo
    {
        public DataSet GetRole(Role obj)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@RoleID", obj.RoleID),
                    new SqlParameter("@IsAct", obj.IsAct),
                    new SqlParameter("@UID", obj.UID )
                };
                return DataLib.ExecuteDataSet("GetRole", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }

        public string AddUpdateRole(Role obj)
        {
            string result = "";
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@RoleID", obj.RoleID),
                    new SqlParameter("@Name", obj.Name),
                    new SqlParameter("@Desc", obj.Desc),
                    new SqlParameter("@Type", obj.Type) ,
                    new SqlParameter("@IsAct", obj.IsAct),
                    new SqlParameter("@CreatedBy", 1),
                };
                result = DataLib.ExecuteScaler("AddUpdateRole", CommandType.StoredProcedure, p);
            }
            catch
            { result = "-2"; }
            return result;
        }
    }
}