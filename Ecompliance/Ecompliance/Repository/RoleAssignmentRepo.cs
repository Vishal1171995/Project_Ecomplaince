using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Ecompliance.Repository
{
    public class RoleAssignmentRepo
    {
        public DataTable GetCustomer(int UID)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[] { new SqlParameter("@UID",UID) };
                return DataLib.ExecuteDataTable("[GetCustomerForRoleAsignment]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }

        public DataTable GetCompany(int UID)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[] { new SqlParameter("@UID", UID) };
                return DataLib.ExecuteDataTable("[GetCompanyForRoleAsignment]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }

        public DataTable Getsite(int UID)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[] { new SqlParameter("@UID", UID) };
                return DataLib.ExecuteDataTable("[GetSiteForRoleAsignment]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }
    }
}