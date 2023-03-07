using Ecompliance.Areas.Master.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ecompliance.Repository;
using Ecompliance.Utils;
using System.Data;
using Ecompliance.ActionFilters;
using Ecompliance.CustomAttribute;
using Ecompliance.Areas.Admin.Models;
namespace Ecompliance.Areas.Master.Controllers
{
    [CustomAuthActionFilter(Order = 0)]
    [CustomAuthrizationActionFilter(Order = 1)]
    [RouteArea("Master")]
    public class CompanyController : Controller
    {
        // GET: Master/Activity
        [ViewAction]
        [Route("Company", Name = "CompanyView")]
        public ActionResult Company()
        {
            //Declaring user list for filling maker and checker ddls
            User UMdl = new User();
            UMdl.UserID = ((User)Session["uBo"]).UID;
            UserRepo RepU = new UserRepo();
            UMdl.UID = 0;
            UMdl.IsAuth = 1;

            Customer CusMdl = new Customer();
            CustomerRepo RepCus = new CustomerRepo();
            CompanyRepo CompRep = new CompanyRepo();
            CusMdl.IsAct = true;
            CusMdl.CustID = 0;
            CusMdl.UID = ((User)Session["uBo"]).UID;
            Company Model = new Company();
            try
            {
                Model.UserList = DropdownUtils.ToSelectList(RepU.GetUser(UMdl), "UID", "User_Name");
                Model.AuditorList = DropdownUtils.ToSelectList(RepU.GetAuditor(UMdl), "UID", "User_Name");
                Model.CustomerList = DropdownUtils.ToSelectList(RepCus.GetCustomer(CusMdl).Tables[0], "CustID", "Name");
                ViewBag.Ds = RepCus.GetCustomer(CusMdl).Tables[0];//CompRep.GetCompanySnapShot();
                return View(Model);
            }
            catch
            {
                throw;
            }
        }
        [HttpGet]
        [ViewAction]
        [Route("GetCompany", Name = "GetCompany")]
        public ActionResult GetCompany(int CompanyID,int CustID)
        {
            CompanyRepo repcompany = new CompanyRepo();
            Company mdlCompany = new Company();
            mdlCompany.CompanyID = CompanyID;
            mdlCompany.Customer = CustID;
            mdlCompany.IsAct = false;
            mdlCompany.Name = "";
            mdlCompany.UID = ((User)Session["uBo"]).UID;
            Response res = new Response();
            try
            {
                DataTable dt = repcompany.GetCompanyList(mdlCompany);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                res = res.GetResponse("Company", "", -2);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
        }
        [HttpGet]
        [ViewAction]
        [Route("GetCompanyMapping", Name = "GetCompanyMapping")]
        public ActionResult GetCompanyMapping(int CompanyID,int SiteID)
        {
            SiteActivityMappingPERep ObjRepo = new SiteActivityMappingPERep();
            Response res = new Response();
            try
            {
                DataTable dt = ObjRepo.GetCompanyMapping(CompanyID, SiteID);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                res = res.GetResponse("Company", "", -2);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
        }
        [HttpGet]
        [ViewAction]
        [Route("GetContractorMapping", Name = "GetContractorMapping")]
        public ActionResult GetContractorMapping(int CompanyID,int SiteID)
        {
            SiteActivityMappingRep ObjRepo = new SiteActivityMappingRep();
            Response res = new Response();
            try
            {
                DataTable dt = ObjRepo.GetCompanyContracotMapping(CompanyID, SiteID);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                res = res.GetResponse("Company", "", -2);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
        }
        [HttpGet]
        [ViewAction]
        [Route("GetCompanyHistory", Name = "GetCompanyHistory")]
        public ActionResult GetCompanyHistory(int CompanyID)
        {
            CompanyRepo repcompany = new CompanyRepo();
            Company mdlCompany = new Company();
            mdlCompany.CompanyID = CompanyID;
            Response res = new Response();
            try
            {
                DataTable dt = repcompany.GetCompanyHistory(mdlCompany);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                res = res.GetResponse("Company", "", -2);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
        }

        [ValidateAntiForgeryToken]
        [HttpPost]
        [ADDUpdateAction]
        [Route("CreateCompany", Name = "CreateCompany")]
        public ActionResult CreateCompany(Company model)
        {
            CompanyRepo repcompany = new CompanyRepo();
            Response res = new Response();
            if (ModelState.IsValid)
            {
                try
                {

                    model.createdby = ((User)Session["uBo"]).UID;
                    res = res.GetResponse("Company", model.CompanyID.ToString(), Convert.ToInt32(repcompany.CreateUpdateCompany(model)), "Company Name");
                    return Json(res);
                }
                catch
                {
                    res = res.GetResponse("Company", "", -2);
                    return Json(res, JsonRequestBehavior.AllowGet);
                }
            }
            else
            {
                return View(model);
            }
        }
        [HttpGet]
        [ViewAction]
        [Route("DownloadAllMapppingCompany", Name = "DownloadAllMapppingCompany")]
        public ActionResult DownloadAllMapppingCompany(string CustID)
        {
            Response ret = new Response();
            try
            {
                CompanyRepo repact = new CompanyRepo();
                Company model = new Company();
                model.CompanyID = 0;
                model.Customer = Convert.ToInt32(CustID);
                model.IsAct = false;
                model.UID = ((User)Session["uBo"]).UID;
                DataTable dt = repact.GetCompanyList(model);
                DataTable dtCompany = dt.DefaultView.ToTable(false, "CompID", "Name","Code", "CustomerNm", "Address", "Contact_Person", "Phone_Number", "Email", "MakerNm", "CheckerNm", "MakerText2", "ChekcerText2", "AuditorText1", "AuditorText2", "IsActNm");
                dtCompany.Columns["Name"].ColumnName = "Company";
                dtCompany.Columns["Code"].ColumnName = "Code";
                dtCompany.Columns["CustomerNm"].ColumnName = "Customer";
                dtCompany.Columns["MakerNm"].ColumnName = "Maker";
                dtCompany.Columns["CheckerNm"].ColumnName = "Checker";
                dtCompany.Columns["ChekcerText2"].ColumnName = "Checker2";
                dtCompany.Columns["MakerText2"].ColumnName = "Maker2";
                dtCompany.Columns["AuditorText1"].ColumnName = "Auditor1";
                dtCompany.Columns["AuditorText2"].ColumnName = "Auditor2";
                dtCompany.Columns["IsActNm"].ColumnName = "Status";
                dtCompany.Columns["CompID"].ColumnName = "CompanyID";

                string FileName = CSVUtills.DataTableToCSV(dtCompany, ",");
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "CompanyMaster.csv");
            }
            catch
            {
                throw;
            }
        }
        [HttpGet]
        [ADDUpdateAction]
        [Route("DownloadSampleCompany", Name = "DownloadSampleCompany")]
        public ActionResult DownloadSampleCompany()
        {
            Response ret = new Response();
            try
            {
                string FileName = Server.MapPath("~/Docs/Sample/Company.csv");
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "SampleCompany.csv");
            }
            catch
            {
                throw;
            }
        }
       
        [HttpPost]
        [ValidateAntiForgeryToken]
        [ADDUpdateAction]
        [Route("UploadCompany", Name = "UploadCompany")]
        public ActionResult UploadCompany(string FileName)
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

                CompanyRepo repCompany = new CompanyRepo();

                string FilePath = Server.MapPath("~/Docs/Temp/" + FileName);
                string SampleFileName = Server.MapPath("~/Docs/Sample/Company.csv");
                int SuccessCount = 0;
                int FailCount = 0;
                string ResultFileName = repCompany.UploadCompany(FilePath, SampleFileName, ((User)Session["uBo"]).UID, ref  SuccessCount, ref FailCount);
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
    }
}