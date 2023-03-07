using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Ecompliance.Repository
{
    public class BulkApprovalRepo
    {
        public DataSet GetBulkApprovalGrid(string Type, int UID, string ActivityType, string CompIDs, string SiteIDs, string ContractorIDs, string ActIDs, string ActivityIDs, string ExpDate, string Month, string Year, string FromDate, string ToDate, string DocID, string SortingStr, string FilterStr)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Type",Type),
                    new SqlParameter("@UID",UID),
                    new SqlParameter("@ActivityType",ActivityType),
                    new SqlParameter("@CompIDs",CompIDs),
                    new SqlParameter("@SiteIDs",SiteIDs),
                    new SqlParameter("@ContractorIDs",ContractorIDs),
                    new SqlParameter("@ActIDs",ActIDs),
                    new SqlParameter("@ActivityIDs",ActivityIDs),
                    new SqlParameter("@ExpDate",ExpDate),
                    new SqlParameter("@Month",Month),
                    new SqlParameter("@Year",Year),
                    new SqlParameter("@FromDate",FromDate),
                    new SqlParameter("@ToDate",ToDate),
                    new SqlParameter("@DocID",DocID),
                    new SqlParameter("@SQLSortString",SortingStr),
                    new SqlParameter("@SQLFilterString",FilterStr)
                };
                return DataLib.ExecuteDataSet("GetBulkApprovalGrid", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }
    }
}