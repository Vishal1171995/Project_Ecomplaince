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
using Ecompliance.Areas.Admin.Models;



namespace Ecompliance.Repository
{
    public class CompanyRepo
    {
        public DataTable GetCompanyList(Company model)
        {

            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@CompanyID",model.CompanyID ),
                    new SqlParameter("@Customer",model.Customer ),
                    new SqlParameter("@IsAct",model.IsAct ),
                    new SqlParameter("@Name",model.Name ),
                    new SqlParameter("@UID",model.UID )
                };
               
                return DataLib.ExecuteDataTable("[GetCompanyList]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }

        }
        public DataTable GetCompanyHistory(Company model)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@CompanyID",model.CompanyID )
                   
                };
                return DataLib.ExecuteDataTable("[GetCompanyHistory]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }
        public int CreateUpdateCompany(Company model)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@CompanyID", model.CompanyID ),
                    new SqlParameter("@Name", model.Name),
                    new SqlParameter("@Address", model.Address),
                    new SqlParameter("@Customer", model.Customer),
                    new SqlParameter("@Contact_Person", model.Contact_Person),
                    new SqlParameter("@Ph_Number", model.Phone_Number),
                    new SqlParameter("@Email", model.Email ),
                    new SqlParameter("@Maker", model.Maker),
                    new SqlParameter("@Checker", model.Checker),
                     new SqlParameter("@Maker2", model.Maker2),
                    new SqlParameter("@Checker2", model.Checker2),
                     new SqlParameter("@Auditor1", model.Auditor1),
                    new SqlParameter("@Auditor2", model.Auditor2),
                    new SqlParameter("@CreatedBy", model.createdby),
                    new SqlParameter("@IsAct", model.IsAct ),
                    new SqlParameter("@Code", model.CompanyCode )
                };
                return Convert.ToInt32(DataLib.ExecuteScaler("CreateUpdateCompanyNew", CommandType.StoredProcedure, parameters));
            }
            catch
            {
                throw;
            }
        }

        public string DownLoadCompany(Company model)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                  new SqlParameter("@CompanyID",model.CompanyID ),
                       new SqlParameter("@Customer",model.Customer ),
                    new SqlParameter("@IsAct",model.IsAct )
                };

                dt = DataLib.ExecuteDataTable("[GetCompanyList]", CommandType.StoredProcedure, parameters);
                return CSVUtills.DataTableToCSV(dt, ",");
            }
            catch { throw; }
        }
        public bool CheckColumnFormatCompany(string FilePath, string SampleFilePath)
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

        public string UploadCompany(string FilePath, string SampleFilePath, int CreatedBy, ref int SuccessCount, ref int FailCount)
        {
            try
            {
                //Convert csv file into DataTable
                DataTable dt = null;
                try
                {
                    dt = CSVUtills.CSVToDataTable(FilePath, ',');
                }
                catch (Exception Ex)
                {
                    return Ex.Message;
                }

                if (!CheckColumnFormatCompany(FilePath, SampleFilePath))
                {
                    return "Invalid File Format";
                }
                dt.Columns.Add("Response");
                dt.Columns.Add("Message");

                Company Model;

                CompanyVM VM;

                CustomerRepo objCustomerRep = new CustomerRepo();
                Customer MdlCustomer;

                UserRepo objuserrepo = new UserRepo();
                User MdlUser;
                
                CompanyRepo objCompanyRep = new CompanyRepo();

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    //Only checking Required validation using View Model
                    try
                    {
                        string strerr = "";
                        VM = new CompanyVM();
                        VM.CompanyID = Convert.ToInt32((dt.Rows[i]["CompanyID"]).ToString().Replace("\"", ""));
                        VM.Address = Convert.ToString(dt.Rows[i]["Address"]).Replace("\"", "");
                        VM.Name = Convert.ToString(dt.Rows[i]["Name"]).Replace("\"", "");
                        VM.Customer = dt.Rows[i]["Customer"].ToString().Replace("\"", "");
                        VM.Contact_Person = dt.Rows[i]["Contact_Person"].ToString().Replace("\"", "");
                        VM.Phone_Number = (dt.Rows[i]["Phone_Number"]).ToString().Replace("\"", "");
                        VM.Email = (dt.Rows[i]["Email"]).ToString().Replace("\"", "");
                        VM.Maker = (dt.Rows[i]["Maker"]).ToString().Replace("\"", "");
                        VM.Checker = (dt.Rows[i]["Checker"]).ToString().Replace("\"", "");
                        VM.CompanyCode = (dt.Rows[i]["CompanyCode"]).ToString().Replace("\"", "");
                        VM.IsAct = Convert.ToBoolean(dt.Rows[i]["Status"].ToString().Replace("\"", "") == "1" ? true : false);
                        VM.createdby = CreatedBy;
                        if (VM.Email == "") { VM.Email = null; }
                        var results = new List<ValidationResult>();
                        var vc = new ValidationContext(VM, null, null);
                        var isValid = Validator.TryValidateObject(VM, vc, results,true);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                        strerr = string.Join(" ", errors);
                        if (isValid)
                        {
                            Model = new Company();
                            Model.CompanyID = Convert.ToInt32((dt.Rows[i]["CompanyID"]).ToString().Replace("\"", ""));

                            //Getting CustomerId from DataBase
                            MdlCustomer = new Customer();
                            MdlCustomer.Name = VM.Customer;
                            MdlCustomer.IsAct = true;
                            MdlCustomer.CustID = 0;
                            MdlCustomer.UID = CreatedBy;
                            DataTable dtCustomer = (objCustomerRep.GetCustomer(MdlCustomer)).Tables[0];
                            if (dtCustomer.Rows.Count > 0)
                            {
                                Model.Customer = Convert.ToInt32(dtCustomer.Rows[0]["CustID"].ToString().Replace("\"", ""));
                            }
                            else
                            {
                                Model.Customer = -1;
                            }
                            //Now Getting MakerID (UID) From DataBase
                            MdlUser = new User();
                            MdlUser.User_Name = VM.Maker;
                            MdlUser.Company = 0;
                            MdlUser.Contractor = 0;
                            MdlUser.IsAuth = 1;
                            MdlUser.UID = 0;
                            MdlUser.UserID = CreatedBy;
                            DataTable dtUser = (objuserrepo.GetUser(MdlUser));
                            if (dtUser.Rows.Count > 0)
                            {
                                Model.Maker = Convert.ToInt32(dtUser.Rows[0]["UID"].ToString().Replace("\"", ""));
                            }
                            else
                            {
                                Model.Maker = -1;
                            }

                            //Now Getting CheckerID (UID) From DataBase
                            MdlUser = new User();
                            MdlUser.User_Name = VM.Checker;
                            MdlUser.Company = 0;
                            MdlUser.Contractor = 0;
                            MdlUser.IsAuth = 1;
                            MdlUser.UID = 0;
                            MdlUser.UserID = CreatedBy;
                            DataTable dtchecker = (objuserrepo.GetUser(MdlUser));
                            if (dtchecker.Rows.Count > 0)
                            {
                                Model.Checker = Convert.ToInt32(dtchecker.Rows[0]["UID"].ToString().Replace("\"", ""));
                            }
                            else
                            {
                                Model.Checker = -1;
                            }
                            Model.Name = VM.Name;
                            Model.CompanyCode = VM.CompanyCode;
                            Model.Address = VM.Address;
                            Model.Contact_Person = VM.Contact_Person;
                            Model.Phone_Number = VM.Phone_Number;
                            Model.Email = VM.Email;                            
                            Model.IsAct = VM.IsAct;
                            Model.createdby = VM.createdby;

                            results = new List<ValidationResult>();
                            vc = new ValidationContext(Model, null, null);
                            isValid = Validator.TryValidateObject(Model, vc, results,true);
                            errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                            strerr = string.Join(" ", errors);
                            if (isValid)
                            {
                                int Result = Convert.ToInt32(CreateUpdateCompany(Model));
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
                                dt.Rows[i]["Response"] = strerr;
                            }
                        }
                        else
                        {
                            FailCount += 1;
                            dt.Rows[i]["Response"] = "Failed";
                            dt.Rows[i]["Message"] = strerr;
                            //Message
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
        public DataSet GetCompanySnapShot()
        {

            try
            {
                SqlParameter[] parameters = null;
                return DataLib.ExecuteDataSet("GetCompanySnapShot", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }

        }
        //vivek
        public DataTable GetCompanyByLocation(Company model, int LocationID)
        {

            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]{
                    new SqlParameter("@LocationID",LocationID )
                };

                return DataLib.ExecuteDataTable("[GetCompanyByLocation]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }

        }


    }
}