using Ecompliance.Areas.Master.Models;
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

namespace Ecompliance.Repository
{
    public class ActRepo
    {
        public DataTable GetActList(Act model)
        {

            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@ActID",model.ActID ),
                    new SqlParameter("@IsAct",model.IsAct ),
                    new SqlParameter("@ShortName",model.Short_Name)
                };
                dt = DataLib.ExecuteDataTable("[GetActList]", CommandType.StoredProcedure, parameters);
                return dt;
            }

            catch
            {
                throw;
            }
        }

        public DataTable GetActHistory(Act model)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]{new SqlParameter("@ActID",model.ActID )};
                dt = DataLib.ExecuteDataTable("[GetActHistory]", CommandType.StoredProcedure, parameters);
                return dt;
            }
            catch
            {
                throw;
            }
        }
        public int CreateUpdateAct(Act model)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@ActID", model.ActID ),            
                    new SqlParameter("@Full_Name", model.Full_Name),
                    new SqlParameter("@Short_Name", model.Short_Name),
                    new SqlParameter("@IsAct", model.IsAct ),
                    new SqlParameter("@UID", model.CreatedBy)
                                    
                };
                return Convert.ToInt32(DataLib.ExecuteScaler("CreateUpdateAct", CommandType.StoredProcedure, parameters));
            }
            catch
            {
                throw;
            }
        }

        public string DownLoadAct(Act model)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@ActID",model.ActID ),
                     new SqlParameter("@IsAct", Convert.ToInt16(model.IsAct))
                };
                 dt = DataLib.ExecuteDataTable("[GetActList]", CommandType.StoredProcedure, parameters );
                 return CSVUtills.DataTableToCSV(dt,",");
            }
            catch { throw; }
            
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
        public string UploadAct(string FilePath, string SampleFilePath, int CreatedBy, ref int SuccessCount, ref int FailCount)
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
                Act Model;
                ActRepo objActRep = new ActRepo();
                ActivityRepo objActivityRep = new ActivityRepo();
                string strerr = "";
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    //Only checking Required validation using View Model
                    try
                    {
                        Model = new Act();
                        Model.ActID = Convert.ToInt32((dt.Rows[i]["ActID"]).ToString().Replace("\"", ""));
                        Model.Short_Name = Convert.ToString(dt.Rows[i]["Short_Name"]).Replace("\"", "");
                        Model.Full_Name = Convert.ToString(dt.Rows[i]["Full_Name"]).Replace("\"", "");
                        Model.IsAct = Convert.ToBoolean(dt.Rows[i]["Status"].ToString().Replace("\"", "") == "1" ? true : false);
                        Model.CreatedBy = CreatedBy;
                        
                        var results = new List<ValidationResult>();
                        var vc = new ValidationContext(Model, null, null);
                        var isValid = Validator.TryValidateObject(Model, vc, results,true);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                        strerr = string.Join(" ", errors);
                        if (isValid)
                        {
                            int Result = Convert.ToInt32(CreateUpdateAct(Model));
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

        public static DataTable GetYear()
        {
            DataTable dt = new DataTable();
            try
            {

                dt.Columns.Add("Year", typeof(string));
                for (int i = 2016; i <= DateTime.Now.Year; i++)
                {
                    dt.Rows.Add(i.ToString());
                }
                return dt;
            }
            catch
            {
                throw;
            }
        }
    }
}