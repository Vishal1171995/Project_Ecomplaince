using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Ecompliance.Areas.Admin.Models;
using System.Text;
using Ecompliance.ViewModel;
using System.ComponentModel.DataAnnotations;
using Ecompliance.Areas.Master.Models;

namespace Ecompliance.Repository
{
    public class UserRepo
    {

        #region Admin
        public int CreateUpdateUser(User model)
        {
            try
            {
                //Generation Random Number for Encryption
                model.skey = RandomUtils.RandomString(6);
                model.Passkey = AesEncUtil.EncryptText(model.User_Name, model.skey + model.User_Name);
                model.Passkey = model.Passkey.Replace("/", "").Replace("\\", "");
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@UID", model.UID ),
                    new SqlParameter("@Last_Name", model.Last_Name ),
                    new SqlParameter("@First_Name", model.First_Name ),                    
                    new SqlParameter("@UserName", model.User_Name ),
                    new SqlParameter("@Email", model.Email),
                    new SqlParameter("@Role", model.Role),
                    new SqlParameter("@Contact_Number", model.Contact_Number),
                    new SqlParameter("@Company", model.Company),
                    new SqlParameter("@Customer", model.Customer),
                    new SqlParameter("@Contractor", model.Contractor ),
                    new SqlParameter("@Skey", model.skey),
                    new SqlParameter("@CreatedBy", model.CreatedBy) ,
                    new SqlParameter("@PassKey", model.Passkey) 
                                    
                };
                int res = Convert.ToInt32(DataLib.ExecuteScaler("AddUpdateUser", CommandType.StoredProcedure, parameters));
                if (res > 0 && model.UID == 0)
                {
                    StringBuilder mailbody = new StringBuilder("");
                    mailbody.Append(" <body><header style=\"width:996px; margin:auto;\"><div style=\"font-family:Arial, Helvetica, sans-serif; color:#444; font-size:18px;font-weight:bold;\"> ");
                    mailbody.Append(" Dear " + model.First_Name + " " + model.Last_Name + ",       </div></header><section style=\"width:996px; margin:auto;\"><div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;\"><p>You have Successfully registered ");
                    mailbody.Append("on <span style=\"color:#ff6600;\"> ACTIVE COMPLIANCE TRACKING</span> portal. Please <a style=\"color:#ff6600;text-decoration:none;\" href=\"https://myndact.com/ActivateUser/" + model.Passkey + "\"> click here </a> to generate password. </p></div> ");
                    mailbody.Append(" </section> <footer style=\"width:996px; margin:auto;\"> <div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;padding:5px 0px;\">Thanks & Regards <br> Team ACT Compliance</div> ");
                    mailbody.Append(" </footer></body>");
                    MailUtill.SendMail(model.Email, "Greetings from ACT", mailbody.ToString(), "", "", "ajeet.kumar@myndsol.com");
                }
                //In Case of new User Send him Activation Email To his Email
                return res;
            }
            catch
            {
                throw;
            }
        }
        public int CreateUpdateUser(User model, SqlTransaction trans, SqlConnection con)
        {
            try
            {
                //Generation Random Number for Encryption
                model.skey = RandomUtils.RandomString(6);
                model.Passkey = AesEncUtil.EncryptText(model.User_Name, model.skey + model.User_Name);
                model.Passkey = model.Passkey.Replace("/", "").Replace("\\", "");
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@UID", model.UID ),
                    new SqlParameter("@Last_Name", model.Last_Name ),
                    new SqlParameter("@First_Name", model.First_Name ),                    
                    new SqlParameter("@UserName", model.User_Name ),
                    new SqlParameter("@Email", model.Email),
                    new SqlParameter("@Role", model.Role),
                    new SqlParameter("@Contact_Number", model.Contact_Number),
                    new SqlParameter("@Company", model.Company),
                    new SqlParameter("@Customer", model.Customer),
                    new SqlParameter("@Contractor", model.Contractor ),
                    new SqlParameter("@Skey", model.skey),
                    new SqlParameter("@CreatedBy", model.CreatedBy) ,
                    new SqlParameter("@PassKey", model.Passkey) 
                                    
                };
                int res = Convert.ToInt32(DataLib.ExecuteScaler("AddUpdateUser", CommandType.StoredProcedure, parameters, con, trans));
                if (res > 0 && model.UID == 0)
                {
                    StringBuilder mailbody = new StringBuilder("");
                    mailbody.Append(" <body><header style=\"width:996px; margin:auto;\"><div style=\"font-family:Arial, Helvetica, sans-serif; color:#444; font-size:18px;font-weight:bold;\"> ");
                    mailbody.Append(" Dear " + model.First_Name + " " + model.Last_Name + ",       </div></header><section style=\"width:996px; margin:auto;\"><div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;\"><p>Thank You for registering with ");
                    mailbody.Append("<span style=\"color:#ff6600;\"> ACTIVE COMPLIANCE TRACKING</span> portal. Please <a style=\"color:#ff6600;text-decoration:none;\" href=\"https://myndact.com/ActivateUser/" + model.Passkey + "\"> click here </a> for account activation . </p></div> ");
                    mailbody.Append(" </section> <footer style=\"width:996px; margin:auto;\"> <div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;padding:5px 0px;\">Thanks & Regards <br> Team ACT Compliance</div> ");
                    mailbody.Append(" </footer></body>");
                    MailUtill.SendMail(model.Email, "Greetings from ACT", mailbody.ToString(), "", "", "");
                }
                //In Case of new User Send him Activation Email To his Email
                return res;
            }
            catch
            {
                throw;
            }
        }
        public DataTable GetUser(User model)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@UID",model.UID ),
                    new SqlParameter("@CompID",model.Company ),
                    new SqlParameter("@ContractorID",model.Contractor ),
                    new SqlParameter("@IsAuth",model.IsAuth ),
                    new SqlParameter("@PassKey",model.Passkey ),
                    new SqlParameter("@User_Name",model.User_Name ),
                    new SqlParameter("@UserID",model.UserID )
                };
                return DataLib.ExecuteDataTable("[GetUser]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }

        public DataTable GetAuditor(User model)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@UID",model.UID ),
                    new SqlParameter("@CompID",model.Company ),
                    new SqlParameter("@ContractorID",model.Contractor ),
                    new SqlParameter("@IsAuth",model.IsAuth ),
                    new SqlParameter("@PassKey",model.Passkey ),
                    new SqlParameter("@User_Name",model.User_Name ),
                    new SqlParameter("@UserID",model.UserID )
                };
                return DataLib.ExecuteDataTable("[GetAuditor]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }
        public DataTable GetUserHistory(User model)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@UID",model.UID )
                };
                return DataLib.ExecuteDataTable("[GetUserHistory]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }
        public DataTable GetActivateUser(string UID)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@UID",UID )
                };
                return DataLib.ExecuteDataTable("[GetActivateUser]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }

        public string DownLoadUser(User model)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@UID",model.UID ),
                    new SqlParameter("@Company",model.Company ),
                    new SqlParameter("@IsAct",model.IsAuth )
                };
                dt = DataLib.ExecuteDataTable("[GetCompanyList]", CommandType.StoredProcedure, parameters);
                return CSVUtills.DataTableToCSV(dt, ",");
            }
            catch { throw; }
        }
        public bool CheckColumnFormatUser(string FilePath, string SampleFilePath)
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
        public string UploadUser(string FilePath, string SampleFilePath, int CreatedBy, ref int SuccessCount, ref int FailCount)
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
                if (!CheckColumnFormatUser(FilePath, SampleFilePath))
                {
                    return "Invalid File Format";
                }
                dt.Columns.Add("Response");
                dt.Columns.Add("Message");


                UserVM1 VM;
                User Model;

                UserRepo objActRep = new UserRepo();

                RoleRepo objRoleRep = new RoleRepo();
                Role MdlRole;

                ContractorRepo objContractorrepo = new ContractorRepo();
                Contractor MdlContractor;

                CompanyRepo objCompanyRep = new CompanyRepo();
                Company MdlCompany;

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    //Only checking Required validation using View Model
                    try
                    {
                        string strerr = "";
                        VM = new UserVM1();
                        VM.UID = Convert.ToInt32((dt.Rows[i]["UID"]).ToString().Replace("\"", ""));
                        VM.User_Name = (dt.Rows[i]["User_Name"]).ToString().Replace("\"", "");
                        VM.First_Name = Convert.ToString(dt.Rows[i]["First_Name"]).Replace("\"", "");
                        VM.Last_Name = Convert.ToString(dt.Rows[i]["Last_Name"]).Replace("\"", "");
                        VM.Email = Convert.ToString(dt.Rows[i]["Email"]).Replace("\"", "");
                        VM.Role = Convert.ToString(dt.Rows[i]["Role"]).Replace("\"", "");
                        VM.Contact_Number = Convert.ToString(dt.Rows[i]["Contact_Number"]).Replace("\"", "");
                        VM.Company = Convert.ToString(dt.Rows[i]["Company"]).Replace("\"", "");
                        VM.Contractor = Convert.ToString(dt.Rows[i]["Contractor"]).Replace("\"", "");
                        VM.skey = Convert.ToString(dt.Rows[i]["skey"]).Replace("\"", "");
                        VM.Password = Convert.ToString(dt.Rows[i]["Password"]).Replace("\"", "");
                        VM.IsAuth = Convert.ToInt32(dt.Rows[i]["IsAuth"].ToString().Replace("\"", ""));
                        VM.CreatedBy = CreatedBy;

                        var results = new List<ValidationResult>();
                        var vc = new ValidationContext(VM, null, null);
                        var isValid = Validator.TryValidateObject(VM, vc, results, true);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                        strerr = string.Join(" ", errors);
                        if (isValid)
                        {
                            Model = new User();
                            Model.UID = Convert.ToInt32((dt.Rows[i]["UID"]).ToString().Replace("\"", ""));

                            //Getting ContractorId from DataBase
                            MdlContractor = new Contractor();
                            MdlContractor.Name = VM.Contractor;
                            MdlContractor.IsAct = true;
                            MdlContractor.ContractorID = 0;
                            DataTable dtContractor = (objContractorrepo.GetContractor(MdlContractor)).Tables[0];
                            if (dtContractor.Rows.Count > 0)
                            {
                                Model.Contractor = Convert.ToInt32(dtContractor.Rows[0]["ContractorID"].ToString().Replace("\"", ""));
                            }
                            else
                            {
                                Model.Contractor = -1;
                            }
                            //Now Getting CompanyID (UID) From DataBase
                            MdlCompany = new Company();
                            MdlCompany.Name = VM.Company;

                            MdlCompany.IsAct = true;
                            MdlCompany.CompanyID = 0;
                            DataTable dtCompany = (objCompanyRep.GetCompanyList(MdlCompany));
                            if (dtCompany.Rows.Count > 0)
                            {
                                Model.Company = Convert.ToInt32(dtCompany.Rows[0]["CompID"].ToString().Replace("\"", ""));
                            }
                            else
                            {
                                Model.Company = -1;
                            }

                            //Now Getting RoleID (UID) From DataBase
                            MdlRole = new Role();
                            MdlRole.Name = VM.Role;

                            MdlRole.IsAct = true;
                            MdlRole.RoleID = 0;
                            DataTable dtRole = (objRoleRep.GetRole(MdlRole)).Tables[0];
                            if (dtRole.Rows.Count > 0)
                            {
                                Model.Role = Convert.ToInt32(dtRole.Rows[0]["RoleID"].ToString().Replace("\"", ""));
                            }
                            else
                            {
                                Model.Role = -1;
                            }


                            Model.User_Name = VM.User_Name;
                            Model.First_Name = VM.First_Name;
                            Model.Last_Name = VM.Last_Name;
                            Model.Email = VM.Email;
                            Model.Contact_Number = VM.Contact_Number;
                            Model.Email = VM.Email;
                            Model.skey = VM.skey;
                            Model.Password = VM.Password;
                            Model.CreatedBy = VM.CreatedBy;

                            results = new List<ValidationResult>();
                            vc = new ValidationContext(Model, null, null);
                            isValid = Validator.TryValidateObject(Model, vc, results, true);
                            errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                            strerr = string.Join(" ", errors);
                            if (isValid)
                            {
                                int Result = Convert.ToInt32(CreateUpdateUser(Model));
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
        public DataTable GetCompanyForUser(string CustIDs)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@CustIDs",CustIDs ),
                };
                return DataLib.ExecuteDataTable("[GetCompanyForUser]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }

        public DataTable getUserRole(int UID)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@UID",UID ),
                };
                return DataLib.ExecuteDataTable("[getUserRole]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }
        public string UpdateRoleAssign(int UID, string CustIDs, string CompIDs)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@UID",UID ),
                    new SqlParameter("@CustIDs",CustIDs ),
                    new SqlParameter("@CompIDs",CompIDs ),
                };
                return DataLib.ExecuteScaler("[UpdateUserRoleAssign]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }
        #endregion

        #region Account
        public int ActivateUser(UserVM model)
        {
            try
            {
                //Get User Information for password encryption
                User objU = new User();
                objU.Passkey = model.Passkey;
                objU.UID = 0;
                DataTable dt = new DataTable();
                dt = GetUser(objU);
                if (dt.Rows.Count == 1)
                {
                    //string sKey = dt.Rows[0]["Skey"].ToString();
                    model.Password = HashingLib.GenerateSHA512String(model.Password);// AesEncUtil.EncryptText(model.Password, sKey + dt.Rows[0]["UID"].ToString());
                }
                else
                {
                    return 0;
                }
                if (CheckPasswordHistory(Convert.ToInt32(dt.Rows[0]["UID"].ToString()), model.Password) == 0)
                {
                    SqlParameter[] parameters = new SqlParameter[]
                {                   
                    new SqlParameter("@PassKey", model.Passkey) ,                                 
                    new SqlParameter("@Password", model.Password)
                };
                    int res = Convert.ToInt32(DataLib.ExecuteScaler("ActivateUser", CommandType.StoredProcedure, parameters));
                    return res;
                }
                else { return -5; }
            }
            catch
            {
                throw new Exception();
            }
        }

        private void LogLogin(int UID)
        {

            try
            {
                string IPAddress = CommanUtills.GetIPAddress();
                SqlParameter[] P = new SqlParameter[] { 
                    new SqlParameter("@UID", UID) ,
                    new SqlParameter("@IPAddress", IPAddress) 
                };
                DataLib.ExecuteScaler("LogUserLogin", CommandType.StoredProcedure, P);
            }
            catch { }
        }

        public void SetLogOut(int UID)
        {

            try
            {
                SqlParameter[] P = new SqlParameter[] { new SqlParameter("@UID", UID) };
                DataLib.ExecuteScaler("SetLogOut", CommandType.StoredProcedure, P);
            }
            catch { }
        }
        public User Authenticate(LoginVM model, ref string Message)
        {

            User objU = new User();
            try
            {
                //Get User Information 

                DataTable dt = new DataTable();
                SqlParameter[] parameters = new SqlParameter[]
                {                   
                    new SqlParameter("@UserName", model.UserName)
                };
                dt = DataLib.ExecuteDataTable("[AuthenticateUser000_New]", CommandType.StoredProcedure, parameters);
                if (dt.Rows.Count == 1)
                {
                    //Decrypt user password from the database
                    //string sKey = dt.Rows[0]["Skey"].ToString();
                    string Password = dt.Rows[0]["Password"].ToString();//AesEncUtil.DecryptText(dt.Rows[0]["Password"].ToString(), sKey + dt.Rows[0]["UID"].ToString());
                    // Check for Expired Password 
                    model.Password = HashingLib.GenerateSHA512String(model.Password);
                    int PassChangeBefore = Convert.ToInt32(dt.Rows[0]["PassChangeDayCount"]);

                    if (PassChangeBefore<=60)
                    {

                        //If password is correct proceed for Next Step
                        if (Password == model.Password)
                        {
                            string IsAuth = "0";
                            IsAuth = Convert.ToString(dt.Rows[0]["IsAuth"]);
                            switch (IsAuth)
                            {
                                //1 means valid user. Load all the details into user objects
                                case "1":
                                    {
                                        objU.UID = Convert.ToInt32(dt.Rows[0]["UID"]);
                                        objU.Role = Convert.ToInt32(dt.Rows[0]["Role"]);
                                        objU.User_Name = Convert.ToString(dt.Rows[0]["User_Name"]);
                                        objU.Email = Convert.ToString(dt.Rows[0]["Email"]);
                                        objU.First_Name = Convert.ToString(dt.Rows[0]["First_Name"]);
                                        objU.Last_Name = Convert.ToString(dt.Rows[0]["Last_Name"]);
                                        objU.UserRole = Convert.ToString(dt.Rows[0]["RoleName"]);
                                        objU.PassChangeDays =60- PassChangeBefore;
                                        objU.Customer = Convert.ToInt32(dt.Rows[0]["CustID"]);
                                        objU.Logo = Convert.ToString(dt.Rows[0]["Logo"]);
                                        //Create log for user login
                                        LogLogin(objU.UID);
                                        Message = "success";
                                        return objU;
                                    }
                                //0 Means User has been created but not activated
                                case "0":
                                    {
                                        Message = "In Active User.";
                                        return objU;
                                    }
                                //2 Means User has been deactivated by admin
                                case "2":
                                    {
                                        Message = "Invalid user name or password.";
                                        return objU;
                                    }
                                //3 Means that user has tried more than three time to login with wrong password
                                case "5":
                                    {
                                        Message = "Your account has been locked.Please contact your admin for its resolution";
                                        return objU;
                                    }
                                default:
                                    {
                                        Message = "Invalid user name or password.";
                                        return objU;
                                    }
                            }
                        }
                        else
                        {
                            Message = "Invalid Password.";
                            return objU;
                        }
                    }
                    else {
                        //BlockUser(model.UserName, "Password Expired");
                        Message = "PasswordExpired";
                        return objU;
                    }
                }
                else
                {
                    Message = "Invalid user name or password.";
                    return objU;
                }

            }
            catch
            {
                Message = "Invalid user name or password.";
                return objU;
            }
        }
        public string ForgetPassword(string UserName)
        {
            string ret = "";
            try
            {
                DataTable dt = new DataTable();
                User uBo = new User();
                uBo.UID = 0;
                uBo.IsAuth = 1;
                uBo.Passkey = "";
                uBo.User_Name = UserName;
                dt = GetUser(uBo);
                if (dt.Rows.Count == 1)
                {
                    if (dt.Rows[0]["IsAuth"].ToString() != "1")
                    {
                        ret = "Invalid user name.";
                        return ret;
                    }
                    uBo.UID = Convert.ToInt32(dt.Rows[0]["UID"].ToString());
                    uBo.First_Name = dt.Rows[0]["First_Name"].ToString();
                    uBo.Last_Name = dt.Rows[0]["Last_Name"].ToString();
                    uBo.Email = dt.Rows[0]["Email"].ToString();
                    uBo.skey = RandomUtils.RandomString(6);
                    uBo.Passkey = AesEncUtil.EncryptText(uBo.User_Name, uBo.skey + uBo.User_Name);
                    uBo.Passkey = uBo.Passkey.Replace("/", "").Replace("\\", "");
                    SqlParameter[] parameters = new SqlParameter[]
                        {
                            new SqlParameter("@UID", uBo.UID ),
                            new SqlParameter("@PassKey", uBo.Passkey)
                        };
                    int res = Convert.ToInt32(DataLib.ExecuteScaler("ResetPassLink", CommandType.StoredProcedure, parameters));
                    if (res > 0)
                    {
                        StringBuilder mailbody = new StringBuilder("");
                        mailbody.Append("<body><header style=\"width:996px; margin:auto;\"><div style=\"font-family:Arial, Helvetica, sans-serif; color:#444; font-size:18px;font-weight:bold;\"> ");
                        mailbody.Append(" Dear " + uBo.First_Name +  ",       </div></header><section style=\"width:996px; margin:auto;\"><div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;\"><p>We have received your request to change password  ");
                        mailbody.Append("on <span style=\"color:#ff6600;\"> ACTIVE COMPLIANCE TRACKING</span> portal. Please <a style=\"color:#ff6600;text-decoration:none;\" href=\"https://myndact.com/ActivateUser/" + uBo.Passkey + "\"> click here </a> to regenerate your password. </p></div> ");
                        mailbody.Append(" </section> <footer style=\"width:996px; margin:auto;\"> <div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;padding:5px 0px;\">Thanks & Regards <br> Team ACT Compliance</div> ");
                        mailbody.Append(" </footer></body>");
                        MailUtill.SendMail(uBo.Email, "Password Reset from ACT", mailbody.ToString(), "", "", "");
                    }

                    return "Password reset link has been sent on your email.Please check your email inbox and reset your password";
                    //In Case of new User Send him Activation Email To his Email
                    // return ret;
                }
                else
                {
                    ret = "Invalid user name.";
                    return ret;
                }

            }
            catch { throw; }
        }

        public string SendActivationLinkOnUnBlock(int UID)
        {
            string ret = "";
            try
            {
                DataTable dt = new DataTable();
                User uBo = new User();
                uBo.UID = UID;
                uBo.IsAuth = 1;
                uBo.Passkey = "";
                uBo.User_Name = "";
                dt = GetUser(uBo);
                if (dt.Rows.Count == 1)
                {
                   
                    uBo.UID = Convert.ToInt32(dt.Rows[0]["UID"].ToString());
                    uBo.First_Name = dt.Rows[0]["First_Name"].ToString();
                    uBo.Last_Name = dt.Rows[0]["Last_Name"].ToString();
                    uBo.Email = dt.Rows[0]["Email"].ToString();
                    uBo.skey = RandomUtils.RandomString(6);
                    uBo.Passkey = AesEncUtil.EncryptText(uBo.User_Name, uBo.skey + uBo.User_Name);
                    uBo.Passkey = uBo.Passkey.Replace("/", "").Replace("\\", "");
                    SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@UID", uBo.UID ),
                    new SqlParameter("@PassKey", uBo.Passkey)
                                    
                };
                    int res = Convert.ToInt32(DataLib.ExecuteScaler("ResetPassLink", CommandType.StoredProcedure, parameters));
                    if (res > 0)
                    {
                        StringBuilder mailbody = new StringBuilder("");
                        mailbody.Append(" <body><header style=\"width:996px; margin:auto;\"><div style=\"font-family:Arial, Helvetica, sans-serif; color:#444; font-size:18px;font-weight:bold;\"> ");
                        mailbody.Append(" Dear " + uBo.First_Name + " " + uBo.Last_Name + ",       </div></header><section style=\"width:996px; margin:auto;\"><div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;\"><p>We have received your request to change password  ");
                        mailbody.Append("on <span style=\"color:#ff6600;\"> ACTIVE COMPLIANCE TRACKING</span> portal. Please <a style=\"color:#ff6600;text-decoration:none;\" href=\"https://myndact.com/ActivateUser/" + uBo.Passkey + "\"> click here </a> to regenerate your password. </p></div> ");
                        mailbody.Append(" </section> <footer style=\"width:996px; margin:auto;\"> <div style=\"color:#333;font-size:14px;font-family:Arial, Helvetica, sans-serif;padding:5px 0px;\">Thanks & Regards <br> Team ACT Compliance</div> ");
                        mailbody.Append(" </footer></body>");
                        MailUtill.SendMail(uBo.Email, "Password Reset from ACT", mailbody.ToString(), "", "", "");
                    }

                    return "Password reset link has been sent on your email.Please check your email inbox and reset your password";
                    //In Case of new User Send him Activation Email To his Email
                    // return ret;
                }
                else
                {
                    ret = "Invalid user name.";
                    return ret;
                }

            }
            catch { throw; }
        }
        public int UpdateProfile(User model)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
               {
                    new SqlParameter("@UID", model.UID ),
                    new SqlParameter("@Last_Name", model.Last_Name ),
                    new SqlParameter("@First_Name", model.First_Name ),
                    new SqlParameter("@UserName", model.User_Name ),
                    new SqlParameter("@Email", model.Email),
                    new SqlParameter("@Contact_Number", model.Contact_Number)
               };
                int res = Convert.ToInt32(DataLib.ExecuteScaler("UpdateProfile", CommandType.StoredProcedure, parameters));
                return res;
            }

            catch
            {
                throw new Exception();
            }
        }
        public string ChangePassword(User userModel, ChangePasswordVM changePasswordVM)
        {
            try
            {
                var dt = new DataTable();
                var objUserRepo = new UserRepo();
                dt = objUserRepo.GetUser(userModel);

                if (dt.Rows.Count == 1)
                {
                    //string Password = AesEncUtil.DecryptText(dt.Rows[0]["Password"].ToString(), dt.Rows[0]["skey"].ToString() + dt.Rows[0]["UID"].ToString());
                    string Password = dt.Rows[0]["Password"].ToString();
                    changePasswordVM.Password = HashingLib.GenerateSHA512String(changePasswordVM.Password);
                    if (string.Equals(changePasswordVM.Password, Password))
                    {
                        //changePasswordVM.NewPassword = AesEncUtil.EncryptText(changePasswordVM.NewPassword, dt.Rows[0]["Skey"].ToString() + dt.Rows[0]["UID"].ToString());
                        changePasswordVM.NewPassword = HashingLib.GenerateSHA512String(changePasswordVM.NewPassword);// AesEncUtil.EncryptText(changePasswordVM.NewPassword, dt.Rows[0]["Skey"].ToString() + dt.Rows[0]["UID"].ToString());

                        if (CheckPasswordHistory(userModel.UID, changePasswordVM.NewPassword) == 0)
                        {
                            SqlParameter[] parameters = new SqlParameter[]
                            {
                                  new SqlParameter("@UID", userModel.UID) ,
                                  new SqlParameter("@Password", changePasswordVM.NewPassword)
                            };
                            int res = Convert.ToInt32(DataLib.ExecuteScaler("UpdatePassword", CommandType.StoredProcedure, parameters));
                            if (res > 0)
                            {
                                return "Your password has been successfully changed!";
                            }
                            else
                            {
                                return "Invalid User.";
                            }
                        }
                        else 
                        {
                            return "Your New Password cannot be last three previous passwords."; 
                        }
                    }
                    else
                    {
                        return "Invalid Current Password.";
                    }
                }
                else
                {
                    return "Invalid User.";
                }
            }
            catch
            {
                return "Please Try Again Later.";
            }
        }
        public User UpdateUserInfo(int UID)
        {
            var objUser = new User();
            try
            {
                DataTable dt = new DataTable();
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@UID", UID)
                };
                dt = DataLib.ExecuteDataTable("UpdateUserInfo", CommandType.StoredProcedure, parameters);
                if (dt.Rows.Count == 1)
                {
                    objUser.UID = Convert.ToInt32(dt.Rows[0]["UID"]);
                    objUser.User_Name = Convert.ToString(dt.Rows[0]["User_Name"]);
                    objUser.Email = Convert.ToString(dt.Rows[0]["Email"]);
                    objUser.First_Name = Convert.ToString(dt.Rows[0]["First_Name"]);
                    objUser.Last_Name = Convert.ToString(dt.Rows[0]["Last_Name"]);
                    objUser.Contact_Number = Convert.ToString(dt.Rows[0]["Contact_Number"]);
                    objUser.Role = Convert.ToInt32(dt.Rows[0]["Role"]);
                    objUser.Customer = Convert.ToInt32(dt.Rows[0]["Customer"]);
                    objUser.Company = Convert.ToInt32(dt.Rows[0]["Company"]);
                    objUser.Contractor = Convert.ToInt32(dt.Rows[0]["Contractor"]);
                    objUser.UserRole = Convert.ToString(dt.Rows[0]["RoleName"]);
                }
                return objUser;
            }
            catch
            {
                return objUser;
            }
        }

        public Response  PasswordExpiredAlert(ResetPasswordVM VM)
        {
            Response Res = new Response();
            try
            {
                //ResetPasswordVM
                User userModel = new User();
                userModel.User_Name = VM.UserID;
                //userModel.IsAuth = 1;
                var dt = new DataTable();
                var objUserRepo = new UserRepo();
                dt = objUserRepo.GetUser(userModel);
                if(dt.Rows.Count==0)
                {
                    Res.IsSuccess = false;
                    Res.Message = "Invalid User.";
                    return Res;
                }
                if(dt.Rows[0]["IsAuth"].ToString()!="1")
                {
                    Res.IsSuccess = false;
                    Res.Message = "Invalid User.";
                    return Res;
                }
                //string sKey = dt.Rows[0]["Skey"].ToString();
                //string Password = AesEncUtil.DecryptText(dt.Rows[0]["Password"].ToString(), sKey + dt.Rows[0]["UID"].ToString());
                string Password = dt.Rows[0]["Password"].ToString();
                VM.CurrentPassword = HashingLib.GenerateSHA512String(VM.CurrentPassword.Trim());
                if(Password !=VM.CurrentPassword.Trim())
                {
                    Res.IsSuccess = false;
                    Res.Message = "Your Current Password is not correct.";
                    return Res;
                }
                int UID=Convert.ToInt32(dt.Rows[0]["UID"].ToString());
                //VM.NewPassword = AesEncUtil.EncryptText(VM.NewPassword, dt.Rows[0]["Skey"].ToString() + dt.Rows[0]["UID"].ToString());
                VM.NewPassword = HashingLib.GenerateSHA512String(VM.NewPassword);
                int PassHis=CheckPasswordHistory(UID, VM.NewPassword);
                if (PassHis>0)
                {
                    Res.IsSuccess = false;
                    Res.Message = "You can not re-use the last 3 previously used passwords.";
                    return Res;
                }
                SqlParameter[] parameters = new SqlParameter[]
                            {
                                  new SqlParameter("@UID", UID) ,
                                  new SqlParameter("@Password", VM.NewPassword)
                            };
                int res = Convert.ToInt32(DataLib.ExecuteScaler("UpdatePassword", CommandType.StoredProcedure, parameters));
                if (res > 0)
                {

                    Res.IsSuccess = true;
                    Res.Message = "Your password has been successfully changed!";
                    return Res;
                }
                else
                {
                    Res.IsSuccess = false;
                    Res.Message = "Something went wrong. Please try again later.";
                    return Res;
                }

                
            }
            catch
            {
                Res.IsSuccess = false;
                Res.Message = "Something went wrong. Please try again later.";
                return Res;
            }
        }


        public int CheckPasswordHistory(int UID , string Password)
        {
            SqlParameter[] paramsoldcheck = new SqlParameter[] {  new SqlParameter("@UID", UID) ,
                          new SqlParameter("@Password", Password)  };
            int reschk = Convert.ToInt32(DataLib.ExecuteScaler("CheckPasswordHistory", CommandType.StoredProcedure, paramsoldcheck));
            return reschk;
        }


        public int GetPassTry(string  UserName )
        {
            SqlParameter[] paramsoldcheck = new SqlParameter[] {  new SqlParameter("@UserName", UserName) ,
                        };
            int reschk = Convert.ToInt32(DataLib.ExecuteScaler("GetPassTry", CommandType.StoredProcedure, paramsoldcheck));
            return reschk;
        }

        public int BlockUser(string UserName, string Reason, int UID=0)
        {
            SqlParameter[] paramsoldcheck = new SqlParameter[] {  new SqlParameter("@UserName", UserName) ,
                new SqlParameter("@BlockedReason", Reason) ,
                new SqlParameter("@UID", UID) ,
                        };
            int reschk = Convert.ToInt32(DataLib.ExecuteScaler("BlockUser", CommandType.StoredProcedure, paramsoldcheck));
            return reschk;
        }

        public int UnBlockBlockUser(string UserName, string Reason, int UID=0)
        {
          
            SqlParameter[] paramsoldcheck = new SqlParameter[] {  new SqlParameter("@UserName", UserName) ,
                new SqlParameter("@BlockedReason", Reason) , new SqlParameter("@UID", UID) ,
                        };
            int reschk = Convert.ToInt32(DataLib.ExecuteScaler("UnBlockUser", CommandType.StoredProcedure, paramsoldcheck));
            return reschk;
        }
        #endregion

        #region ActActivity
        public DataSet GetActActivitydata(string CustIDs,string UserID)
        {
            try {
                SqlParameter[] parameters = new SqlParameter[]
                {
                new SqlParameter("@CustIDs",CustIDs),
                new SqlParameter("@UserID",UserID)
                };
                return DataLib.ExecuteDataSet("[GetActAndActivityList]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }
        public string UpdateUserActActivity(int UID, string ActivityTIDs)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@UID",UID ),
                    new SqlParameter("@ActivityTIDs",ActivityTIDs ),
                };
                return DataLib.ExecuteScaler("[UpdateUserActActivity]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }

       
        #endregion
    }
}
