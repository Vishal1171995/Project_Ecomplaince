using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Ecompliance.Areas.Master.Models;

namespace Ecompliance.Repository
{
    public class ErrorLogRepo
    {
        public static void InsertTaskCreationErrLog(SiteActivityMappingSchedulerLog Model, string ErrMsg, string IDToken, string SchedulerName)
        {
            SqlParameter[] p =
                {
                    new SqlParameter("@MappingID", Model.MappingID),
                    new SqlParameter("@ActID", Model.ActID),
                    new SqlParameter("@ActivityID", Model.ActivityID),
                    new SqlParameter("@Checker", Model.Checker),
                    new SqlParameter("@CompanyID", Model.CompanyID),
                    new SqlParameter("@ContractorID", Model.ContractorID),
                    new SqlParameter("@StartDate", Model.StartDate),
                    new SqlParameter("@Maker", Model.Maker),                
                    new SqlParameter("@RemindDays", Model.RemindDays),  
                    new SqlParameter("@SiteID", Model.SiteID),
                    new SqlParameter("@ErrorMessage", ErrMsg),
                    new SqlParameter("@IDToken", IDToken),
                    new SqlParameter("@SchedulerName", SchedulerName)
                   
                };
            string tid = DataLib.ExecuteScaler("[AddTaskCreationErrLog]", CommandType.StoredProcedure, p);
        }

    }
}