using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Ecompliance.Areas.ACT2.Repository
{
    public class FileManagerRepo
    {


        public DataTable GetPayDate()
        {

            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = null;
                return DataLib.ExecuteDataTable("[GetPayDate]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }

        }


        //public List<FileExplorer> GetCustomerTreeView(int CustID, int FileID, int ParentId, int UID)
        //{
        //    Customer CustModel = new Customer();
        //    CustomerRepo objCustRepo = new CustomerRepo();
        //    DataSet DsCust = new DataSet();
        //    List<FileExplorer> finalTree = new List<FileExplorer>();
        //    Response ret = new Response();
        //    try
        //    {
        //        //CustModel.UID = ((User)HttpContext.Current.Session["uBo"]).UID;

        //        DsCust = GetFileExplorer(CustID, FileID, ParentId, UID);
        //        for (int i = 0; i < DsCust.Tables[0].Rows.Count; i++)
        //        {
        //            //Customer List
        //            FileExplorer objCust = new FileExplorer();
        //            if (CustID == 0 && FileID == 0 && ParentId == 0)
        //            {
        //                objCust.text = DsCust.Tables[0].Rows[i]["CustomerName"].ToString();
        //                objCust.id = 0;
        //                objCust.hasChildren = Convert.ToBoolean(Convert.ToInt32(DsCust.Tables[0].Rows[i]["hasChildren"]));
        //                objCust.ParentId = 0;
        //                objCust.CustomerID = Convert.ToInt32(DsCust.Tables[0].Rows[i]["CustomerID"]);
        //                objCust.expanded = false;
        //                finalTree.Add(objCust);
        //            }
        //            else
        //            {
        //                objCust.text = DsCust.Tables[0].Rows[i]["FileOriginalName"].ToString();
        //                objCust.id = Convert.ToInt32(DsCust.Tables[0].Rows[i]["FileID"]);
        //                objCust.hasChildren = Convert.ToBoolean(Convert.ToInt32(DsCust.Tables[0].Rows[i]["hasChildren"]));
        //                objCust.ParentId = Convert.ToInt32(DsCust.Tables[0].Rows[i]["PID"]); ;
        //                objCust.CustomerID = Convert.ToInt32(DsCust.Tables[0].Rows[i]["CustomerID"]);
        //                objCust.expanded = false;
        //                finalTree.Add(objCust);
        //            }
        //        }

        //        return finalTree;
        //    }
        //    catch
        //    {
        //        throw;
        //    }
        //}

        public DataSet GetFileMetaData(int CustID, int FileID, int FileMetaID)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@CustomerID", CustID),
                    new SqlParameter("@FileMetaID", FileMetaID),
                };
                return DataLib.ExecuteDataSet("GetFileMetaData", CommandType.StoredProcedure, p);
            }
            catch
            {
                throw;
            }
        }

        public string GetParrentFolder(int? FileID, string FileType)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@FileID", FileID),
                    new SqlParameter("@FileType", FileType)
                };
                return DataLib.ExecuteScaler("GetParrentFolder", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }

        public DataSet GetFileInfo(int FileID)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@FileID", FileID),
                };
                return DataLib.ExecuteDataSet("GetFileInfo", CommandType.StoredProcedure, p);
            }
            catch
            {
                throw;
            }
        }

        public DataSet GetAllChildFile(int CustID, int FileID)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@CustomerID", CustID),
                    new SqlParameter("@FileID", FileID),
                };
                return DataLib.ExecuteDataSet("GetAllChildFile", CommandType.StoredProcedure, p);
            }
            catch
            {
                throw;
            }
        }
    }

}