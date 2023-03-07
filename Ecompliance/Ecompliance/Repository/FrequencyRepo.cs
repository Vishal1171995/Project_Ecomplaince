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
    public class FrequencyRepo
    {
        public DataTable GetFrequencyList(Frequency model)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@FrequencyID",model.FrequencyID ),
                    new SqlParameter("@IsAct",model.IsAct ),
                    new SqlParameter("@Frequency",model.Name)
                };
                return DataLib.ExecuteDataTable("[GetFrequencyList]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }
        public int CreateUpdateFrequency(Frequency model)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@FrequencyID", model.FrequencyID ),
                    new SqlParameter("@Name", model.Name),
                    new SqlParameter("@IsAct", model.IsAct),
                    new SqlParameter("@UID", model.CreatedBy)
                };
                return Convert.ToInt32(DataLib.ExecuteScaler("CreateUpdateFrequency", CommandType.StoredProcedure, parameters));
            }
            catch
            {
                throw;
            }
        }
        public DataTable GetFrequencyHistory(Frequency model)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@FrequencyId",model.FrequencyID)
                };
                return DataLib.ExecuteDataTable("[GetFrequencyHistory]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }
        public DataTable DownLoadFrequency(Frequency model)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@FrequencyID",model.FrequencyID ),
                    new SqlParameter("@IsAct", Convert.ToInt16(model.IsAct))
                };

                dt = DataLib.ExecuteDataTable("[GetFrequencyList]", CommandType.StoredProcedure, parameters);
                return dt;
            }
            catch { throw; }

        }
        public string UploadFrequency(string FilePath, string SampleFilePath, int CreatedBy, ref int SuccessCount, ref int FailCount)
        {
            try
            {
                DataTable dt = CSVUtills.CSVToDataTable(FilePath, ',');
                if (!CheckColumnFormatActivity(FilePath, SampleFilePath))
                {
                    return "Invalid File Format";
                }
                dt.Columns.Add("Response");
                dt.Columns.Add("Message");
                Frequency Model;
                string strerr = "";
                FrequencyRepo objActRep = new FrequencyRepo();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    //Only checking Required validation using View Model
                    try
                    {
                        Model = new Frequency();
                        Model.FrequencyID = Convert.ToInt32((dt.Rows[i]["FrequencyID"]).ToString().Replace("\"", ""));
                        Model.Name = Convert.ToString(dt.Rows[i]["Frequency"]).Replace("\"", "");
                        Model.IsAct = Convert.ToBoolean(dt.Rows[i]["IsActive"].ToString().Replace("\"", "") == "1" ? true : false);
                        Model.CreatedBy = CreatedBy;
                        var results = new List<ValidationResult>();
                        var vc = new ValidationContext(Model, null, null);
                        var isValid = Validator.TryValidateObject(Model, vc, results);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                        strerr = string.Join(" ", errors);
                        if (isValid)
                        {
                            int Result = Convert.ToInt32(CreateUpdateFrequency(Model));
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