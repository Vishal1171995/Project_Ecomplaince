using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ecompliance.ViewModel;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.Utils;
using Ecompliance.Repository;
using Ecompliance.ActionFilters;
using System.Data;
using Ecompliance.Areas.Master.Models;
using CaptchaMvc.HtmlHelpers;  

namespace Ecompliance.Controllers
{
    public class AccountController : Controller
    {
        // GET: Account
        [AllowAnonymous]
        [Route("~/", Name = "Defaultloginview")]
        [Route("login",Name="loginview")]
        public ActionResult Login()
        {
            if (Session["uBo"] != null)
            {
                if (((User)Session["uBo"]).PassChangeDays < 5)
                {
                    return RedirectToAction("PasswordExpiredAlert", "Account");
                }
                else
                {
                    

                    if ((((User)Session["uBo"]).Customer == 507))
                    {

                        if ((((User)Session["uBo"]).Role == 25))
                            return RedirectToAction("Auditor", "Auditor", new { area = "Report" });

                        if ((((User)Session["uBo"]).Role == 26))

                            return RedirectToAction("SendToAuditor", "SendToAuditor", new { area = "Report" });

                        return RedirectToAction("CLRADashBoard", "CLRADashBoard", new { area = "Report" });
                    }
                    return RedirectToAction("DashBoard", "DashBoard", new { area = "Report" });
                }
            }
            else
            {
                return View();
            }
            
        }

        [AllowAnonymous]
        [Route("ResetExpiredPassword", Name = "ResetExpiredPassword")]
        public ActionResult ResetExpiredPassword()
        {
            try
            {
                
                return View();
            }
            catch
            {
                throw;
            }

        }

        [CustomAuthActionFilter]
        [Route("PasswordExpiredAlert", Name = "PasswordExpiredAlert")]
        public ActionResult PasswordExpiredAlert()
        {
            try
            {
                return View();
            }
            catch { throw; }

        }

        [ValidateAntiForgeryToken()]
        [HttpPost]
        public ActionResult UpdateExpiredPassword(ResetPasswordVM model)
        {
            Response Res = new Response();
            try
            {
                if (ModelState.IsValid)
                {
                    UserRepo uRepo = new UserRepo();
                    Res = uRepo.PasswordExpiredAlert(model);
                }
                else
                {
                    Res.IsSuccess = false;
                    Res.Message = "Invalid details";
                }
                return Json(Res, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                Res.IsSuccess = false;
                Res.Message = "Invalid details";
                return Json(Res, JsonRequestBehavior.AllowGet);
            }
        }

        [Route("loginout", Name = "loginout")]
        public ActionResult Loginout()
        {
            //Setting User Log out time in the database
            UserRepo uRepo = new UserRepo();
            try
            {
                uRepo.SetLogOut(((User)Session["uBo"]).UID);
            }
            catch { }
            Session.Clear();
            Session.Abandon();
            Session.RemoveAll();

            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                Response.Cookies["ASP.NET_SessionId"].Value = string.Empty;
                Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddMonths(-20);
            }
            //return View();
            return RedirectToAction("Login", "Account");
        }


        [HttpPost]
        [ValidateAntiForgeryToken()]
        [Route("login", Name = "login")]
        public ActionResult Login(LoginVM User)
        {
            try
            {

                if (ModelState.IsValid)
                {

                    UserRepo ObjURep = new UserRepo();
                    User ObjU = new User();
                    
                    String Message = "";
                    ObjU = ObjURep.Authenticate(User, ref Message);

                    if (Message == "success")
                    {
                        Session["uBo"] = ObjU;
                        int uid = ((User)Session["uBo"]).UID;
                        MenuRepo objM = new MenuRepo();
                        string userRole = ((Ecompliance.Areas.Admin.Models.User)Session["uBo"]).UserRole;
                        DataTable dt = objM.GetUserMenu(userRole);
                        Session["uMenu"] = dt;
                        if (((User)Session["uBo"]).PassChangeDays < 5)
                        {
                            return RedirectToAction("PasswordExpiredAlert", "Account");
                        }
                        else
                        {

                            if ((((User)Session["uBo"]).Customer == 507))
                            {

                                if ((((User)Session["uBo"]).Role == 25))
                                    return RedirectToAction("Auditor", "Auditor", new { area = "Report" });

                                if ((((User)Session["uBo"]).Role == 26))

                                    return RedirectToAction("SendToAuditor", "SendToAuditor", new { area = "Report" });
                                return RedirectToAction("CLRADashBoard", "CLRADashBoard", new { area = "Report" });
                            }

                                
                            return RedirectToAction("DashBoard", "DashBoard", new { area = "Report" });
                        }
                    }
                    //Invalid Password.
                    else if (Message == "Invalid Password.")
                    {
                        Message = "Invalid user name or password.";
                        int passtry = ObjURep.GetPassTry(User.UserName);
                        if (passtry >= 5)
                        {
                            ObjURep.BlockUser(User.UserName, "Consecutive 5 invalid credential attempt by the user.");
                            Message = "This Account has been blocked please contact your Admin for activation.";
                        }
                        ModelState.AddModelError("", Message);
                        return View(User);
                    }
                    else if (Message == "PasswordExpired")
                    {
                        ModelState.AddModelError("", "Your password has been expired.Please update your password.");
                        ResetPasswordVM model = new ResetPasswordVM();
                        model.UserID = User.UserName;
                        return View("ResetExpiredPassword", model);
                        //return View(User);
                    }
                    else
                    {
                        ModelState.AddModelError("", "Invalid user name or password.");
                        return View(User);
                    }
                }

                else
                    return View(User);
            }
            catch
            {
                throw;
            }
        }


        [Route("ActivateUser/{Passkey}", Name = "ActivateUser")]
        public ActionResult ActivateUser(string Passkey)
        {
            try
            {
                UserVM model = new UserVM();
                model.Passkey = Passkey;
                return View(model);
            }
            catch { throw; }
            
        }


        [Route("ForgetPassword", Name = "ForgetPassword")]
        public ActionResult ForgetPassword(string UserName)
        {
            Response ret = new Response();
            try
            {
                if (UserName.Trim() == "")
                {
                    ret.Message = "Please enter your user name.";
                }
                else
                {
                    UserRepo uRep = new UserRepo();
                    string res = uRep.ForgetPassword(UserName);
                    ret.Message = res;
                }
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch(Exception Ex)
            {
                ret.IsSuccess = false;
                ret.Message = Ex.Message;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }

        }
      
        [ValidateAntiForgeryToken()]
        [HttpPost]
        public ActionResult CreatePass(UserVM model)
        {
            Response ret = new Response();
            try
            {
                if (ModelState.IsValid)
                {
                    UserRepo uRepo = new UserRepo();
                    int res = uRepo.ActivateUser(model);
                    if (res == 1)
                    {
                        ret.IsSuccess = true;
                        ret.Message = "";
                    }
                     else if(res==-5)
                    {
                        ret.IsSuccess = false;
                        ret.Message = "Your New Password cannot be any of the previous passwords.";
                    }
                    else
                    {
                        ret.IsSuccess = false;
                        ret.Message = "Invalid url";
                    }
                }
                else
                {
                    ret.IsSuccess = false;
                    ret.Message = "Invalid details";
                }
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                ret.IsSuccess = false;
                ret.Message = "Invalid details";
                return Json(ret, JsonRequestBehavior.AllowGet);

            }
            
        }

        [IPRangeActionFilter(Order = 2)]
        [CustomAuthActionFilter]
        [Route("ChangePassword", Name = "ChangePasswordView")]
        public ActionResult ChangePassword()
        {
            try
            {
                return View();
            }
            catch
            {
                throw;
            }
        }

        [HttpPost]
        [CustomAuthActionFilter]
        [ValidateAntiForgeryToken()]
        [Route("ChangePassword", Name = "ChangePassword")]
        public ActionResult ChangePassword(ChangePasswordVM model)
        {
            var ret = new Response();
            try
            {
                if (ModelState.IsValid)
                {
                    var uRepo = new UserRepo();
                    string res = uRepo.ChangePassword(((User)Session["Ubo"]), model);
                    if (res == "Your password has been successfully changed!")
                    {
                        ret.IsSuccess = true;
                        ret.Message = res;
                        return Json(ret, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        ret.IsSuccess = false;
                        ret.Message = res;
                        return Json(ret, JsonRequestBehavior.AllowGet);
                    }
                }
                else
                {
                    ret.IsSuccess = false;
                    ret.Message = "Invalid details";
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
            }
            catch
            {
                ret.IsSuccess = false;
                ret.Message = "Invalid details";
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
        }


        //Change password functionality added by Mayank 15/12/2016
        [IPRangeActionFilter(Order = 2)]
        [CustomAuthActionFilter]
        [Route("UpdateProfile", Name = "UpdateProfileView")]
        public ActionResult UpdateProfile()
        {
            try
            {
                var Rolerep = new RoleRepo();
                var userRep = new UserRepo();
                DataTable dt = new DataTable();
                Session["Ubo"] = userRep.UpdateUserInfo(((User)Session["Ubo"]).UID);
                var user = (User)Session["Ubo"];
                var roleModel = new Role();
                user.RoleList = DropdownUtils.ToSelectList(Rolerep.GetRole(roleModel).Tables[0], "RoleID", "Name");

                if (user.Role == 18)
                {
                    CustomerRepo objCustomerrep = new CustomerRepo();
                    Customer objcustomer = new Customer();
                    objcustomer.CustID = 0;
                    objcustomer.IsAct = true;
                    objcustomer.UID = ((User)Session["uBo"]).UID;
                    user.CustomerList = DropdownUtils.ToSelectList(objCustomerrep.GetCustomer(objcustomer).Tables[0], "CustID", "Name");
                }
                else if (user.Role == 19)
                {
                    var conmpanyRep = new CompanyRepo();
                    var companyModel = new Company();
                    companyModel.CompanyID = 0;
                    companyModel.IsAct = true;
                    companyModel.UID = ((User)Session["uBo"]).UID;
                    user.CompanyList = DropdownUtils.ToSelectList(conmpanyRep.GetCompanyList(companyModel), "CompID", "Name");
                }
                else if (user.Role == 20)
                {
                    Contractor ObjContractor = new Contractor();
                    ObjContractor.ContractorID = 0;
                    ObjContractor.IsAct = true;
                    ContractorRepo ObjContracRep = new ContractorRepo();
                    user.ContractorList = DropdownUtils.ToSelectList(ObjContracRep.GetContractor(ObjContractor).Tables[0], "ContractorID", "Name");
                }
                return View(user);
            }
            catch
            {
                throw;
            }
        }

        [HttpPost]
        [CustomAuthActionFilter]
        [ValidateAntiForgeryToken]
        [IPRangeActionFilter(Order = 2)]
        [Route("UpdateProfile", Name = "UpdateProfile")]
        public ActionResult UpdateProfile(User model)
        {
            var ret = new Response();
            try
            {
                if (ModelState.IsValid)
                {
                    var uRepo = new UserRepo();
                    int res = uRepo.UpdateProfile(model);
                    if (res == 1)
                    {
                        Session["Ubo"] = uRepo.UpdateUserInfo(model.UID);
                        ret.IsSuccess = true;
                        ret.Message = "Your profile has been updated successfully!";
                        return Json(ret, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        ret.IsSuccess = false;
                        ret.Message = "There were some internal error please contaact admin";
                        return Json(ret, JsonRequestBehavior.AllowGet);
                    }
                }
                else
                {
                    ret.IsSuccess = false;
                    ret.Message = "Invalid details";
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
            }
            catch
            {
                ret.IsSuccess = false;
                ret.Message = "Invalid details";
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
        }
    }
}