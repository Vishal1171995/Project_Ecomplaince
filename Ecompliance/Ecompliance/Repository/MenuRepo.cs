using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using Ecompliance.Utils;
using System.Data.SqlClient;
using Ecompliance.Areas.Admin.Models;

namespace Ecompliance.Repository
{
    public class MenuRepo
    {

        public DataTable GetMenu(string Roles, int Mid = 0)
        {
            try
            {
                DataTable dt = new DataTable();
                SqlParameter[] P = new SqlParameter[] { 
                    new SqlParameter("@Roles", Roles),
                    new SqlParameter("@Mid", Mid)
                };
                dt = DataLib.ExecuteDataTable("GetMenu", CommandType.StoredProcedure, P);
                return dt;
            }
            catch
            {
                throw;
            }
        }
        public DataTable GetUserMenu(string Roles)
        {
            try
            {
                DataTable dt = new DataTable();
                SqlParameter[] P = new SqlParameter[] {
                    new SqlParameter("@Roles", Roles)
                };
                dt = DataLib.ExecuteDataTable("GetUserMenu", CommandType.StoredProcedure, P);
                return dt;
            }
            catch
            {
                throw ;
            }
        }

        public string UpdateMenuRoles(Menu obj)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@TID", obj.MenuID),
                    new SqlParameter("@Roles", obj.Role),
                };
                return DataLib.ExecuteScaler("UpdateMenuRole", CommandType.StoredProcedure, p);
            }
            catch
            { throw; }
        }
    }
}