
using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Hosting;
using System.ComponentModel.DataAnnotations;
using System.IO;
using System.Web.Mvc;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.Areas.FileExplorer.Models;

namespace Ecompliance.Repository
{
    public class FileMetaDataRepo
    {
        public DataTable GetMetaDataList(FileMetaData model)
        {

            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@FileMetaID",model.FileMetaID ),
                    new SqlParameter("@CustomerID",model.CustomerID ),                   
                  
                 
                };

                return DataLib.ExecuteDataTable("[GetMetaDataList]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }

        }
        public DataTable GetCompanyHistory(FileMetaData model)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@CompanyID",model.FileMetaID  )
                   
                };
                return DataLib.ExecuteDataTable("[GetCompanyHistory]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }
        public int CreateUpdateMetaData(FileMetaData model)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@FileMetaID", model.FileMetaID ),
                    new SqlParameter("@CustomerID", model.CustomerID),
                    new SqlParameter("@Description", model.Description),
                    new SqlParameter("@MetaData", model.MetaData),
                    new SqlParameter("@FileTypeName", model.FileTypeName),
                   new SqlParameter("@CreatedBy", model.CreatedBy),
                  
                };
                return Convert.ToInt32(DataLib.ExecuteScaler("CreateUpdateMetaData", CommandType.StoredProcedure, parameters));
            }
            catch
            {
                throw;
            }
        }
    }
}