using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using Ecompliance.Areas.Master.Models;
using Ecompliance.Utils;
using System.ComponentModel.DataAnnotations;

namespace Ecompliance.Repository
{
    public class LocationRepo
    {
        public int AddUpdateLocation(Location model)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@LocationID", model.LocationID),
                    new SqlParameter("@State", model.State),
                    new SqlParameter("@Name", model.Name),
                    new SqlParameter("@IsAct", model.IsAct),
                    new SqlParameter("@UID", model.UID),
                };
                return Convert.ToInt32(DataLib.ExecuteScaler("AddUpdateLocation", CommandType.StoredProcedure, parameters));
            }
            catch
            {
                throw;
            }
        }
        public DataSet GetLocation(Location model)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@LocationID", model.LocationID),
                    new SqlParameter("@State", model.State),
                    new SqlParameter("@Name", model.Name),
                    new SqlParameter("@IsAct",model.IsAct )
                };
                return DataLib.ExecuteDataSet("GetLocation", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }
        public DataSet GetLocationHistory(Location obj)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@LocationID", obj.LocationID)
                 
                };
                return DataLib.ExecuteDataSet("GetLocationHistory", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }

        public string ProcessMappingLocation(string FilePath, string SampleFilePath, int CreatedBy, ref int SuccessCount, ref int FailCount)
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
                if (!CheckColumnFormatLocation(FilePath, SampleFilePath))
                {
                    return "Invalid File Format";
                }
                dt.Columns.Add("Response");
                dt.Columns.Add("Message");
                Location Model;
                LocationRepo objLocRep = new LocationRepo();

                StateRepo objStateRep = new StateRepo();
                State MdlState;
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    //Only checking Required validation using View Model
                    try
                    {
                        Model = new Location();
                        Model.LocationID = Convert.ToInt32((dt.Rows[i]["LocationID"]).ToString().Replace("\"", ""));
                        Model.Name = Convert.ToString(dt.Rows[i]["Name"]).Replace("\"", "");
                        Model.StateName = Convert.ToString(dt.Rows[i]["State"]).Replace("\"", "");
                        Model.IsAct = Convert.ToBoolean(dt.Rows[i]["Status"].ToString().Replace("\"", "") == "1" ? true : false);
                        //Getting StateID from DataBase
                        MdlState = new State();
                        MdlState.StateID = 0;
                        MdlState.Name = Model.StateName;
                        MdlState.IsAct = true;
                        DataTable dtState = objStateRep.GetStateList(MdlState);
                        if (dtState.Rows.Count > 0)
                        {
                            Model.State = Convert.ToInt32(dtState.Rows[0]["StateID"].ToString().Replace("\"", ""));
                        }
                        else
                        {
                            Model.State = -1;
                        }
                        var results = new List<ValidationResult>();
                        var vc = new ValidationContext(Model, null, null);
                        var isValid = Validator.TryValidateObject(Model, vc, results, true);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                        if (isValid)
                        {
                            int Result = Convert.ToInt32(AddUpdateLocation(Model));
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

                    }
                    catch
                    {
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
        public bool CheckColumnFormatLocation(string FilePath, string SampleFilePath)
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