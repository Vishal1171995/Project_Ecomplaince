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
    public class ContractorRepo
    {
        public DataSet GetContractor(Contractor obj)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@ContractorID", obj.ContractorID),
                    new SqlParameter("@IsAct", obj.IsAct),
                    new SqlParameter("@Name", obj.Name),
                    new SqlParameter("@CompID", obj.Company),
                    new SqlParameter("@UID",obj.UID )
                };
                return DataLib.ExecuteDataSet("GetContractor", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }

        public DataSet GetContractorHistory(Contractor obj)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@ContractorID", obj.ContractorID)

                };
                return DataLib.ExecuteDataSet("GetContractorHistory", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }

        public string AddUpdateContractor(Contractor obj)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@ContractorID", obj.ContractorID),
                    new SqlParameter("@Name", obj.Name),
                    new SqlParameter("@Company", obj.Company),
                    new SqlParameter("@Address", obj.Address),
                    new SqlParameter("@Contact_Person", obj.Contact_Person) ,
                    new SqlParameter("@Contact_Number", obj.Contact_Number) ,
                    new SqlParameter("@Email", obj.Email) ,
                    new SqlParameter("@PF_Code", obj.PF_Code),
                    new SqlParameter("@ESI_Code", obj.ESI_Code),
                    new SqlParameter("@IsAct", obj.IsAct),
                    new SqlParameter("@CreatedBy", obj.CreatedBy),
                    //new SqlParameter("@UID", UID)
                };
                return DataLib.ExecuteScaler("AddUpdateContractor", CommandType.StoredProcedure, p);
            }
            catch
            {
                throw;
            }
        }

        public string DownLoadContractor(Contractor model)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                  new SqlParameter("@ContractorID", model.ContractorID),
                    new SqlParameter("@IsAct", model.IsAct)
                };
                dt = DataLib.ExecuteDataTable("[GetContractor]", CommandType.StoredProcedure, parameters);
                return CSVUtills.DataTableToCSV(dt, ",");
            }
            catch { throw; }

        }
        public bool CheckColumnFormatContractor(string FilePath, string SampleFilePath)
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


        public DataSet GetContractorSnapShot()
        {
            try
            {
                SqlParameter[] p = null;
                return DataLib.ExecuteDataSet("GetContractorSnapShot", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }
        public string UploadContractor(string FilePath, string SampleFilePath, int CreatedBy, ref int SuccessCount, ref int FailCount)
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
                if (!CheckColumnFormatContractor(FilePath, SampleFilePath))
                {
                    return "Invalid File Format";
                }
                dt.Columns.Add("Response");
                dt.Columns.Add("Message");
                Contractor Model;
                ContractorRepo objActRep = new ContractorRepo();
                CompanyRepo objCompanyRep = new CompanyRepo();
                Company MdlCompany;
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    //Only checking Required validation using View Model
                    try
                    {
                        string strerr = "";
                        Model = new Contractor();
                        Model.ContractorID = Convert.ToInt32((dt.Rows[i]["ContractorID"]).ToString().Replace("\"", ""));
                        Model.Name = Convert.ToString(dt.Rows[i]["Name"]).Replace("\"", "");
                        Model.CompanyText = Convert.ToString((dt.Rows[i]["Company"]).ToString().Replace("\"", ""));
                        Model.Address = Convert.ToString(dt.Rows[i]["Address"]).Replace("\"", "");
                        Model.Contact_Person = Convert.ToString(dt.Rows[i]["Contact_Person"]).Replace("\"", "");
                        Model.Contact_Number = Convert.ToString(dt.Rows[i]["Contact_Number"]).Replace("\"", "");
                        Model.Email = Convert.ToString(dt.Rows[i]["Email"]).Replace("\"", "");
                        Model.PF_Code = Convert.ToString(dt.Rows[i]["PF_Code"]).Replace("\"", "");
                        Model.ESI_Code = Convert.ToString(dt.Rows[i]["ESI_Code"]).Replace("\"", "");
                        Model.IsAct = Convert.ToBoolean(dt.Rows[i]["Status"].ToString().Replace("\"", "") == "1" ? true : false);
                        Model.CreatedBy = CreatedBy;

                        if (Model.Contact_Number == "") { Model.Contact_Number = null; }
                        if (Model.Email == "") { Model.Email = null; }

                        //Getting CompanyId from DataBase
                        MdlCompany = new Company();
                        MdlCompany.Name = Model.CompanyText;
                        MdlCompany.IsAct = true;
                        MdlCompany.CompanyID = 0;
                        MdlCompany.UID = CreatedBy;
                        DataTable dtCompany = (objCompanyRep.GetCompanyList(MdlCompany));
                        if (dtCompany.Rows.Count > 0)
                        {
                            Model.Company = Convert.ToInt32(dtCompany.Rows[0]["CompID"].ToString().Replace("\"", ""));
                        }
                        else
                        {
                            Model.Company = -1;
                        }

                        var results = new List<ValidationResult>();
                        var vc = new ValidationContext(Model, null, null);
                        var isValid = Validator.TryValidateObject(Model, vc, results, true);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                        strerr = string.Join(" ", errors);
                        if (isValid)
                        {
                            int Result = Convert.ToInt32(AddUpdateContractor(Model));
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
                                else
                                {
                                    dt.Rows[i]["Response"] = "Failed";
                                }
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

    }
   

}