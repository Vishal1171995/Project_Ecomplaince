using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using Ecompliance.Utils;
using Ecompliance.Areas.Master.Models;
using System.ComponentModel.DataAnnotations;
namespace Ecompliance.Repository
{
    public class CustomerRepo
    {
        public DataSet GetCustomer(Customer obj)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@CustID", obj.CustID),
                    new SqlParameter("@IsAct", obj.IsAct),
                    new SqlParameter("@Name", obj.Name),
                    new SqlParameter("@UID",obj.UID )
                };
                return DataLib.ExecuteDataSet("GetCustomer", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }

        public DataTable GetIPRange(string CustID,string TID)
        {
            try {
                SqlParameter[] p ={
                new SqlParameter("@CustID",Convert.ToInt32(CustID)),
                new SqlParameter("@TID",Convert.ToInt32(TID))
            };
                return DataLib.ExecuteDataTable("GetIPRange", CommandType.StoredProcedure, p);
            }
            catch
            {
                throw;
            }
        }


        public string AddUpdateIPRange(int TID, int CustID, string IPRange, string EndIPAddress, int IsAct, int CreatedBy, string command = "")
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@TID",TID ),
                    new SqlParameter("@CustID",CustID ),
                    new SqlParameter("@IPRange",IPRange ),
                    new SqlParameter("@EndIPAddress",EndIPAddress ),
                     new SqlParameter("@IsAct",IsAct ),
                    new SqlParameter("@CreatedBy",CreatedBy ),
                    new SqlParameter("@Command",command ),
                };
                return DataLib.ExecuteScaler("[AddUpdateDeleteIPRange]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }
        public DataSet GetCustomerHistory(Customer obj)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@CustID", obj.CustID)
                 
                };
                return DataLib.ExecuteDataSet("GetCustomerHistory", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }

        public string AddUpdateCustomer(Customer obj)
        {
            string result = "";
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@CustID", obj.CustID),
                    new SqlParameter("@Name", obj.Name),
                    new SqlParameter("@Code", obj.Code),
                    new SqlParameter("@IsAct", obj.IsAct),
                    new SqlParameter("@EnableIPAddress", obj.EableIPAddress),
                    new SqlParameter("@SubDomain", obj.SubDomain),
                    new SqlParameter("@CreatedBy",obj.CreatedBy)
                };
                result = DataLib.ExecuteScaler("AddUpdateCustomer2809", CommandType.StoredProcedure, p);
            }
            catch
            { result = "fail"; }
            return result;
        }

        public string AddUpdateCustomer(Customer obj, SqlTransaction trans, SqlConnection con)
        {
            string result = "";
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@CustID", obj.CustID),
                    new SqlParameter("@Name", obj.Name),
                    new SqlParameter("@Code", obj.Code),
                    new SqlParameter("@IsAct", obj.IsAct),
                    new SqlParameter("@CreatedBy",obj.CreatedBy),
                    new SqlParameter("@SubDomain",obj.SubDomain)
                };
                
                result = DataLib.ExecuteScaler("AddUpdateCustomer", CommandType.StoredProcedure, p,con,trans);
            }
            catch
            { result = "fail"; }
            return result;
        }
        public string DownLoadCustomer(Customer model)
        {
            DataTable dt = new DataTable();
            string filename = "";
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                   new SqlParameter("@CustID", model.CustID),
                    new SqlParameter("@IsAct", model.IsAct)
                };

                dt = DataLib.ExecuteDataTable("[GetCustomer]", CommandType.StoredProcedure, parameters);
                filename = CSVUtills.DataTableToCSV(dt, ",");
                return filename;
            }
            catch { return ""; }

        }
        public bool CheckColumnFormatCustomer(string FilePath, string SampleFilePath)
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
        public string ProcessMappingCustomer(string FilePath, string SampleFilePath, int CreatedBy, ref int SuccessCount, ref int FailCount)
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

                if (!CheckColumnFormatCustomer(FilePath, SampleFilePath))
                {
                    return "Invalid File Format";
                }
                dt.Columns.Add("Response");
                dt.Columns.Add("Message");

                Customer Model;



                CustomerRepo objActRep = new CustomerRepo();




                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    //Only checking Required validation using View Model
                    try
                    {
                        Model = new Customer();
                        Model.CustID = Convert.ToInt32((dt.Rows[i]["CustID"]).ToString().Replace("\"", ""));
                        Model.Name = Convert.ToString(dt.Rows[i]["Name"]).Replace("\"", "");
                        Model.Code = Convert.ToString(dt.Rows[i]["Code"]).Replace("\"", "");
                        Model.SubDomain = Convert.ToString(dt.Rows[i]["SubDomain"]).Replace("\"", "");
                        Model.IsAct = Convert.ToBoolean(dt.Rows[i]["Status"].ToString().Replace("\"", "") == "1" ? true : false);
                     

                        var results = new List<ValidationResult>();
                        var vc = new ValidationContext(Model, null, null);
                        var isValid = Validator.TryValidateObject(Model, vc, results);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                        if (isValid)
                        {
                            int Result = Convert.ToInt32(AddUpdateCustomer(Model));
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
    }
}