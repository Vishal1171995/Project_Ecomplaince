using System;
using Ecompliance.Utils;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using Ecompliance.Areas.Admin.Models;

namespace Ecompliance.Repository
{
    public class LogErrorRepo
    {
        public int LogError(string ControllerName,string ActionName,string Error)
        {
            try
            {
                int UID =0;
                if(HttpContext.Current.Session["uBo"] != null)
                    UID = ((User)HttpContext.Current.Session["uBo"]).UID;

                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@UID", UID),
                    new SqlParameter("@ControllerName", ControllerName),
                    new SqlParameter("@ActionName", ActionName),
                    new SqlParameter("@Error", Error),
                };
                return Convert.ToInt32(DataLib.ExecuteScaler("LogError", CommandType.StoredProcedure, parameters));
            }
            catch
            {
                throw;
            }
        }
    }
}