using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using Ecompliance.ViewModel;
using Ecompliance.Models;
using Ecompliance.Utils;

namespace Ecompliance.Repository
{
    public class DataMigrationRepo
    {
        public DataTable GetDataMigration()
        {
            try
            {
                SqlParameter[] p = null;
                return DataLib.ExecuteDataTable("GetDataMigration", CommandType.StoredProcedure, p);
            }
            catch(Exception ex) { throw; }
        }
        public string AddDataMigrationTask(TaskVM obj, SqlConnection con, SqlTransaction trans,int oldTID)
        {

            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@DocID", obj.DOCID),
                    new SqlParameter("@ActivityType", obj.ActivityType),
                    new SqlParameter("@CompID", obj.CompanyID), //obj.CompanyID 
                    new SqlParameter("@SiteID", obj.SiteID) ,
                    new SqlParameter("@ActID", obj.ActID),
                     new SqlParameter("@ActivityID", obj.ActivityID),
                    new SqlParameter("@ContractorID", obj.ContractorID),
                    new SqlParameter("@CreationDesc", obj.Creation_Desc),
                    new SqlParameter("@CreationRemarks", obj.Creation_Remarks),
                    //new SqlParameter("@IsAut", obj.IsAuth),
                    new SqlParameter("@CreatedBy", obj.CreatedBy),
                    new SqlParameter("@ExpiryDate", obj.ExpiryDate),
                    new SqlParameter("@TaskCreationDate", obj.TaskCreationDate),
                    new SqlParameter("@OLDDOCID", oldTID)
                };
                return DataLib.ExecuteScaler("CreateDocTask000", CommandType.StoredProcedure, p, con, trans);
            }
            catch (Exception ex) { throw new NotImplementedException(ex.Message.ToString(), ex); }
        }
        public string SendToVarifyForMigration(TaskVerifyVM obj, string ActivityCompDate, SqlConnection con, SqlTransaction trans)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@UID", obj.UID),
                    new SqlParameter("@DOCID", obj.DocID),
                    new SqlParameter("@Remark", obj.Remark),
                    new SqlParameter("@ActivityCompletionDate", ActivityCompDate) ,
                     new SqlParameter("@DelayReason", obj.DelayReason),
                };
                return DataLib.ExecuteScaler("SendToVarify000", CommandType.StoredProcedure, p,con, trans);
            }
            catch (Exception ex) { throw; }
        }
        public string ApproveForMigration(int UID, int DocID, String Remarks, string AprDate, string ATat, SqlConnection con, SqlTransaction trans)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@UID", UID),
                    new SqlParameter("@DOCID", DocID),
                    new SqlParameter("@ApprDate", AprDate),
                    new SqlParameter("@ATat", ATat),
                    new SqlParameter("@Remark", Remarks),
                };
                return DataLib.ExecuteScaler("Approve000", CommandType.StoredProcedure, p, con, trans);
            }
            catch (Exception ex) { throw; }
        }

        public string ReconsiderForMigration(int UID, int DocID, String Remarks)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@UID", UID),
                    new SqlParameter("@DOCID", DocID),
                    new SqlParameter("@Remark", Remarks),
                };
                return DataLib.ExecuteScaler("Reconsider", CommandType.StoredProcedure, p);
            }
            catch (Exception ex) { throw; }
        }

        #region filemigration
        public DataTable GetAttachment()
        {
            try
            {
                SqlParameter[] p = null;
                return DataLib.ExecuteDataTable("Getcar24Attachment", CommandType.StoredProcedure, p);
            }
            catch (Exception ex) { throw; }
        }

        public int InsertTaskFile_Migration(string TID, string Desc, string Name)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@DOCID", TID ),
                    new SqlParameter("@Name", Name),
                    new SqlParameter("@Desc", Desc),
                    new SqlParameter("@UploadAction", "Data Migration From BPM" ),
                    new SqlParameter("@UID", 26)
                };
                return Convert.ToInt32(DataLib.ExecuteScaler("InsertTaskFile_Migration", CommandType.StoredProcedure, parameters));
            }

            catch
            {
                throw;
            }
        }

        #endregion
    }
}