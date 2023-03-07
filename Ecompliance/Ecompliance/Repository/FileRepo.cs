using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using Ecompliance.Models;
using Ecompliance.Utils;
namespace Ecompliance.Repository
{
    public class FileRepo
    {
        public string CreateDocFile(File obj)
        {
            string result = "";
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@ActivityType", obj.ActivityID),
                    new SqlParameter("@CompID", obj.CompanyID),
                    new SqlParameter("@SiteID", obj.SiteID),
                    new SqlParameter("@ActID", obj.ActID),
                    new SqlParameter("@ActivityID", obj.ActivityID),
                    new SqlParameter("@ContractorID", obj.ContractorID),
                    new SqlParameter("@Year", obj.Year) ,
                    new SqlParameter("@Month", obj.Month),
                     new SqlParameter("@Attach1", obj.Attachment1),
                    new SqlParameter("@Attach1_FileName", obj.Attachment1_FileName),
                    new SqlParameter("@Attach2", obj.Attachment2),
                    new SqlParameter("@Attach2_FileName", obj.Attachment2_FileName),
                    new SqlParameter("@Attach3", obj.Attachment3),
                    new SqlParameter("@Attach3_FileName", obj.Attachment3_FileName),
                    new SqlParameter("@Attach4", obj.Attachment4),
                    new SqlParameter("@Attach4_FileName", obj.Attachment4_FileName),
                    new SqlParameter("@Attach5", obj.Attachment5),
                    new SqlParameter("@Attach5_FileName", obj.Attachment5_FileName),
                    new SqlParameter("@CreatedBy", obj.CreatedBy),
                };
                return DataLib.ExecuteScaler("CreateDocFile", CommandType.StoredProcedure, p);
            }
            catch(Exception ex){ throw; }
        }

        public DataTable GetCompanyForAutoFilter(string str)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@Company", str),
                };
                return DataLib.ExecuteDataTable("GetCompanyForAutoFilter", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }

        public DataTable GetFileDocument(File obj)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@FileID", obj.FileID),
                };
                return DataLib.ExecuteDataTable("GetFileDocument", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }
    }
}