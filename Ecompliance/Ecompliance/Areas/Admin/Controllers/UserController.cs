using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.Areas.Master.Models;
using Ecompliance.Utils;
using Ecompliance.Repository;
using System.Data;
using Ecompliance.ActionFilters;
using Ecompliance.CustomAttribute;

namespace Ecompliance.Areas.Admin.Controllers
{
    [CustomAuthActionFilter(Order = 0)]
    [CustomAuthrizationActionFilter(Order = 1)]
    [RouteArea("Admin")]
    public class UserController : Controller
    {
        // GET: Admin/User
        [ViewAction]
        [Route("Users", Name = "UserView")]        
        public ActionResult Users()
        {
            //Initialising User model
            User Model = new User();
            Company ObjComp = new Company();
            ObjComp.CompanyID = 0;
            ObjComp.IsAct = true;
            ObjComp.UID = ((User)Session["uBo"]).UID;
            //Company Repo for getting list of company
            CompanyRepo ObjCompRep = new CompanyRepo();
            Model.CompanyList = DropdownUtils.ToSelectList(ObjCompRep.GetCompanyList(ObjComp), "CompID", "Name");
            //Getting Role From Role Repo
            Role ObjRole = new Role();
            ObjRole.IsAct = true;
            ObjRole.RoleID = 0;
            ObjRole.UID = ((User)Session["uBo"]).UID;
            RoleRepo ObjRoleRep = new RoleRepo();
            Model.RoleList = DropdownUtils.ToSelectList(ObjRoleRep.GetRole(ObjRole).Tables[0], "RoleID", "Name");
            //Getting Role From Contractor Repo
            Contractor ObjContractor = new Contractor();
            ObjContractor.ContractorID = 0;
            ObjContractor.IsAct = true;
            ContractorRepo ObjContracRep = new ContractorRepo();
            Model.ContractorList = DropdownUtils.ToSelectList(ObjContracRep.GetContractor(ObjContractor).Tables[0], "ContractorID", "Name");
            Customer objcustomer = new Customer();
            objcustomer.CustID = 0;
            objcustomer.IsAct = true;
            objcustomer.UID = ((User)Session["uBo"]).UID;
            CustomerRepo objCustomerrep = new CustomerRepo();
            Model.CustomerList = DropdownUtils.ToSelectList(objCustomerrep.GetCustomer(objcustomer).Tables[0], "CustID", "Name"); 
            try
            {
                return View(Model);
            }
            catch
            {
                throw new Exception();
            }
        }
        
        [HttpPost]
        [ADDUpdateAction]
        [ValidateAntiForgeryToken]
        [Route("createUser", Name = "createUser")]       
        public ActionResult CreateUser(User objU)
        {
            Response ret = new Response();
            if (ModelState.IsValid)
            {
                try
                {
                    UserRepo objUBO = new UserRepo();
                    objU.CreatedBy = ((User)Session["uBo"]).UID;
                    ret = ret.GetResponse("User", objU.UID.ToString(), objUBO.CreateUpdateUser(objU), "User Name");
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
                catch (Exception ex)
                {
                    ret = ret.GetResponse("User", "", -2);
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
            }
            else
            {
                return View(objU);
            }

        }

        [ViewAction]
        [HttpGet]
        [Route("getUser", Name = "getUser")]        
        public ActionResult getUser(string UID)
        {
            UserRepo objUBO = new UserRepo();
            User objModel = new User();
            Response ret = new Response();
            try
            {
                objModel.UID = Convert.ToInt32(UID);
                objModel.Company = 0;
                objModel.Contractor = 0;
                objModel.Customer = 0;
                objModel.IsAuth = 0;
                objModel.UserID = ((User)Session["uBo"]).UID;
                ret.Data = JsonSerializer.SerializeTable(objUBO.GetUser(objModel));
                ret.IsSuccess = true;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ret.IsSuccess = false;
                ret.Message = ex.Message;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
        }

        [ViewAction]
        [HttpGet]
        [Route("getUserHistory", Name = "getUserHistory")]
        public ActionResult getUserHistory(string UID)
        {
            UserRepo objUBO = new UserRepo();
            User objModel = new User();
            Response ret = new Response();
            try
            {
                objModel.UID = Convert.ToInt32(UID);
                objModel.Company = 0;
                objModel.Contractor = 0;
                objModel.IsAuth = 1;
                ret.Data = JsonSerializer.SerializeTable(objUBO.GetUserHistory(objModel));
                ret.IsSuccess = true;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ret.IsSuccess = false;
                ret.Message = ex.Message;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
        }

        [ViewAction]
        [HttpGet]
        [Route("GetActivateUser", Name = "GetActivateUser")]
        public ActionResult getActivateUser(string UID)
        {
            UserRepo objUBO = new UserRepo();
            Response ret = new Response();
            try
            {

                ret.Data = JsonSerializer.SerializeTable(objUBO.GetActivateUser(UID));
                ret.IsSuccess = true;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ret.IsSuccess = false;
                ret.Message = ex.Message;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
        }

        [ViewAction]
        [HttpGet]
        [Route("DownloadAllMapppingUser", Name = "DownloadAllMapppingUser")]
        public ActionResult DownloadAllMapppingUser()
        {
            Response ret = new Response();
            try
            {
                UserRepo repuser = new UserRepo();
                User model = new User();
                model.UID = 0;
                model.Company = 0;
                model.Contractor = 0;
                model.IsAuth = 1;
                model.UserID = ((User)Session["uBo"]).UID;
                DataTable dt = repuser.GetUser(model);
                DataTable dtUser = dt.DefaultView.ToTable(false, "UID", "User_Name", "FullName", "Email", "RoleName", "Contact_Number", "CompName", "ContName", "CustName", "Status");
                dtUser.Columns["User_Name"].ColumnName = "User Id";
                dtUser.Columns["FullName"].ColumnName = "User Name";
                dtUser.Columns["Contact_Number"].ColumnName = "Contact Number";
                dtUser.Columns["RoleName"].ColumnName = "Role Name";
                dtUser.Columns["CompName"].ColumnName = "Company Name";
                dtUser.Columns["ContName"].ColumnName = "Contractor Name";
                dtUser.Columns["CustName"].ColumnName = "Customer Name";

                string FileName = CSVUtills.DataTableToCSV(dtUser, ",");
               // string FileName = repuser.GetUser(model);
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "UserMaster.csv");
            }
            catch
            {
                throw;
            }
        }

        [ViewAction]
        [HttpGet]
        [Route("DownloadSampleUser", Name = "DownloadSampleUser")]
        public ActionResult DownloadSampleUser()
        {
            Response ret = new Response();
            try
            {
                string FileName = Server.MapPath("~/Docs/Sample/User.csv");
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "SampleUser.csv");
            }
            catch
            {
                throw;
            }
        }

        [ADDUpdateAction]
        [ValidateAntiForgeryToken]
        [HttpPost]
        [Route("UploadUser", Name = "UploadUser")]
        public ActionResult UploadUser(string FileName)
        {
            Response ret = new Response();
            try
            {
                string[] arr = FileName.Split('.');

                if (arr[1].ToString().ToUpper() != "CSV")
                {
                    ret = ret.GetResponse("Mapping", "Upload", -2000, "", "", "Invalid file type.");
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }

                UserRepo repact = new UserRepo();

                string FilePath = Server.MapPath("~/Docs/Temp/" + FileName);
                string SampleFileName = Server.MapPath("~/Docs/Sample/User.csv");
                int SuccessCount = 0;
                int FailCount = 0;
                string ResultFileName = repact.UploadUser(FilePath, SampleFileName, ((User)Session["uBo"]).UID, ref  SuccessCount, ref FailCount);
                if (ResultFileName == "Invalid File Format")
                {
                    ret.IsSuccess = false;
                    ret.Data = "";
                    ret.Message = "Invalid File Format";
                }
                else if (ResultFileName == "Please remove all the comma from your file.")
                {
                    ret = ret.GetResponse("", "", -2);
                    ret.Message = "Please remove all the commas from your file.";
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    string data = "{\"Success\":\"" + SuccessCount + "\",\"Failed\":\"" + FailCount + "\",\"FileName\":\"" + ResultFileName.Replace("\\", "\\\\") + "\"}";
                    ret = ret.GetResponse("Mapping", "GetMapping", -1000, "", data, "");
                }

                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                throw;
            }
        }

        [ViewAction]
        [ValidateAntiForgeryToken]
        [HttpPost]
        [Route("BlockUnblockUser", Name = "BlockUnblockUser")]
        public ActionResult BlockUnblockUser(string UID, string Status)
        {
            UserRepo objUBO = new UserRepo();
          
            Response ret = new Response();
            try
            {
                if (Status == "0") { 
                     objUBO.BlockUser("","Blocked by Admin", Convert.ToInt32(UID)); }
                else { objUBO.UnBlockBlockUser("", "UnBlocked by Admin", Convert.ToInt32(UID));
                objUBO.SendActivationLinkOnUnBlock(Convert.ToInt32(UID));
                }
               
                ret.IsSuccess = true;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ret.IsSuccess = false;
                ret.Message = ex.Message;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
        }

        [ViewAction]
        [HttpGet]
        [Route("getCustomerForuser", Name = "getCustomerForuser")]
        public ActionResult getCustomerForuser()
        {
            CustomerRepo obj = new CustomerRepo();
            Customer objModel = new Customer();
            Response ret = new Response();
            try
            {
                objModel.CustID = 0;
                objModel.IsAct = true;
                objModel.Name = "";
                objModel.UID = ((User)Session["uBo"]).UID;
                ret.Data = JsonSerializer.SerializeTable(obj.GetCustomer(objModel).Tables[0]);
                ret.IsSuccess = true;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ret.IsSuccess = false;
                ret.Message = ex.Message;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
        }
        [ViewAction]
        [HttpGet]
        [Route("getUserRole", Name = "getUserRole")]
        public ActionResult getUserRole(int UID)
        {
            UserRepo obj = new UserRepo();
            Response ret = new Response();
            try
            {
                ret.Data = JsonSerializer.SerializeTable(obj.getUserRole(UID));
                ret.IsSuccess = true;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ret.IsSuccess = false;
                ret.Message = ex.Message;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
        }
        [ViewAction]
        [HttpGet]
        [Route("getCompanyForuser", Name = "getCompanyForuser")]
        public ActionResult getCompanyForuser(string CustIDs)
        {
            UserRepo obj = new UserRepo();
            Response ret = new Response();
            try
            {
                ret.Data = JsonSerializer.SerializeTable(obj.GetCompanyForUser(CustIDs));
                ret.IsSuccess = true;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ret.IsSuccess = false;
                ret.Message = ex.Message;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
        }

        [ViewAction]
        [HttpGet]
        [Route("UpdateRoleAssign", Name = "UpdateRoleAssign")]
        public ActionResult UpdateRoleAssign(int UID, string CustIDs, string CompIDs)
        {
            UserRepo obj = new UserRepo();
            Response ret = new Response();
            try
            {
                ret.Message = obj.UpdateRoleAssign(UID, CustIDs, CompIDs);
                ret.IsSuccess = true;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ret.IsSuccess = false;
                ret.Message = ex.Message;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
        }

        #region GetAct&Activity
        [ViewAction]
        [HttpGet]
        [Route("Role_Assignment", Name = "Role_Assignment")]
        public ActionResult Role_Assignment(string CustIDs,string UserID)
        {
            UserRepo obj = new UserRepo();
            Response ret = new Response();
            DataSet ds = new DataSet();
            try
            {
               ds=   obj.GetActActivitydata(CustIDs,UserID);

                ViewBag.ActivityDS = ds;
                ViewBag.UID = UserID;
            }
            catch (Exception ex)
            {
                ret.IsSuccess = false;
                ret.Message = ex.Message;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            return View();
        }


        [ViewAction]
        [ValidateAntiForgeryToken]
        [HttpPost]
        [Route("UpdateUserActActivity", Name = "UpdateUserActActivity")]
        public ActionResult UpdateUserActActivity(int UID, string ActivityTIDs)
        {
            UserRepo obj = new UserRepo();
            Response ret = new Response();
            try
            {
                ret.Message = obj.UpdateUserActActivity(UID, ActivityTIDs);
                ret.IsSuccess = true;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ret.IsSuccess = false;
                ret.Message = ex.Message;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
        }
        #endregion
    }
}