using Ecompliance.Areas.Master.Models;
using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Ecompliance.Repository
{
    public class StateRepo
    {
        public DataSet GetCountry(State obj)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@CountryID", obj.CountryID),
                    new SqlParameter("@IsAct", obj.IsActCountry),
                    new SqlParameter("@Name",obj.CountryName)
                };
                return DataLib.ExecuteDataSet("GetCountry", CommandType.StoredProcedure, p);
            }
            catch
            { 
                throw; 
            }
        }
        public DataTable GetStateList(State model)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@StateID",model.StateID),
                     new SqlParameter("@CountryID",model.Country ),
                     new SqlParameter("@Name",model.Name),
                     new SqlParameter("@Geofence",model.Geofence),
                     new SqlParameter("@IsAct",model.IsAct)
                };
                return DataLib.ExecuteDataTable("[GetStateList]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }
        public DataTable DownLoadState(State model)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@StateID",model.StateID ),
                     new SqlParameter("@IsAct", Convert.ToInt16(model.IsAct))
                };

                dt = DataLib.ExecuteDataTable("[GetStateList]", CommandType.StoredProcedure, parameters);
                return dt;
            }
            catch { throw; }

        }
        public int CreateUpdateState(State model)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@StateID", model.StateID),
                    new SqlParameter("@Name", model.Name),
                    new SqlParameter("@Country", model.Country),
                    new SqlParameter("@Geofence", model.Geofence),
                    new SqlParameter("@IsAct", model.IsAct),
                    new SqlParameter("@UID", model.CreatedBy)
                };
                return Convert.ToInt32(DataLib.ExecuteScaler("CreateUpdateState", CommandType.StoredProcedure, parameters));
            }
            catch
            {
                throw;
            }
        }
        public DataTable GetStateHistory(State model)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@StateId",model.StateID)
                };
                return DataLib.ExecuteDataTable("GetStateHistory", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }
        public string ProcessMappingState(string FilePath, string SampleFilePath, int CreatedBy, ref int SuccessCount, ref int FailCount)
        {
            try
            {
                DataTable dt = null;
                try
                {
                    dt = CSVUtills.CSVToDataTable(FilePath, ',');
                }
                catch (Exception Ex)
                {
                    return Ex.Message;
                }
                if (!CheckColumnFormatActivity(FilePath, SampleFilePath))
                {
                    return "Invalid File Format";
                }
                dt.Columns.Add("Response");
                dt.Columns.Add("Message");
                State Model;
                string strerr = "";
                StateRepo objStateRep = new StateRepo();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    //Only checking Required validation using View Model
                    try
                    {
                        Model = new State();
                        Model.StateID = Convert.ToInt32((dt.Rows[i]["StateID"]).ToString().Replace("\"", ""));
                        Model.Name = Convert.ToString(dt.Rows[i]["Name"]).Replace("\"", "");
                        Model.IsAct = Convert.ToBoolean(dt.Rows[i]["Status"].ToString().Replace("\"", "") == "1" ? true : false);
                        Model.CountryName = Convert.ToString(dt.Rows[i]["Country"]).Replace("\"", "");
                        Model.IsActCountry = true;
                        Model.CreatedBy = CreatedBy;
                        Model.CountryID = Convert.ToInt32(objStateRep.GetCountry(Model).Tables[0].Rows.Count==0?-1: objStateRep.GetCountry(Model).Tables[0].Rows[0]["CountryID"]);
                        var results = new List<ValidationResult>();
                        var vc = new ValidationContext(Model, null, null);
                        var isValid = Validator.TryValidateObject(Model, vc, results,true);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                        strerr = string.Join(" ", errors);
                        if (isValid)
                        {
                            int Result = Convert.ToInt32(CreateUpdateState(Model));
                            if (Result >= 0)
                            {
                                SuccessCount += 1;
                                dt.Rows[i]["Response"] = "Success";
                            }
                            else
                            {
                                FailCount += 1;
                                if (Result == -1)
                                {
                                    dt.Rows[i]["Message"] = "Duplicate";
                                }
                                dt.Rows[i]["Response"] = "Failed";
                            }
                        }
                        else
                        {
                            FailCount += 1;
                            dt.Rows[i]["Response"] = "Failed";
                            dt.Rows[i]["Message"] = strerr;
                        }

                    }
                    catch
                    {
                        FailCount += 1;
                        dt.Rows[i]["Response"] = "Failed";
                        dt.Rows[i]["Message"] = "Invalid Data Format";
                        continue;
                    }
                }
                //Converting dt into csv FIle
                FilePath = CSVUtills.DataTableToCSV(dt, ",");
                return FilePath;
            }
            catch
            {
                throw;
            }
        }
        public bool CheckColumnFormatActivity(string FilePath, string SampleFilePath)
        {
            bool ret = true;
            DataTable dt = CSVUtills.CSVToDataTable(SampleFilePath, ',');
            DataTable dt2 = CSVUtills.CSVHeaderToDataTable(FilePath, ',');

            for (int i = 0; i < dt.Columns.Count; i++)
            {
                if (!(dt2.Columns.Contains(dt.Columns[i].ColumnName)))
                {
                    ret = false;
                    return ret;
                }
            }

            return ret;
        }

    }
}