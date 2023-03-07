using Ecompliance.Utils;
using Ecompliance.CustomAttribute;
using Ecompliance.ActionFilters;
using System;
using Ecompliance.Areas.ACT2.Repository;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ecompliance.Areas.Master.Models;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.Repository;
using System.Data;

namespace Ecompliance.Areas.ACT2.Controllers
{
    [RouteArea("ACT2")]
    [CustomAuthActionFilter(Order =0)]
    [CustomAuthrizationActionFilter(Order =1)]
    public class BackDateReportController : Controller
    {
        [ViewAction]
        [Route("BackDateScheduler",Name = "BackDateScheduler")]
        public ActionResult BackDateScheduler()
        {
            DownloadTaskFilesRepo Downloadrepo = new DownloadTaskFilesRepo();
            Customer Custmdl = new Customer();
            Custmdl.UID = ((User)Session["uBo"]).UID;
            ViewBag.Company = DropdownUtils.ToSelectList(TaskRepo.GetMappedCompany(((User)Session["uBo"]).UID), "CompID", "Name");
            ViewBag.Customer = DropdownUtils.ToSelectList(Downloadrepo.GetCustomerACT2(Custmdl).Tables[0], "CustID", "Name");

            return View();
        }
        [HttpGet]
        [ViewAction]
        [Route("GetBackompany", Name = "GetBackompany")]
        public ActionResult GetBackompany(int CompanyID, int CustID)
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
        [HttpPost]
        [ValidateAntiForgeryToken()]
        [ADDUpdateAction]
        [Route("RunSchudler", Name = "RunSchudler")]
        public ActionResult RunSchudler(string Year, string Month, int CustomerID, int CompanyID)
        {
            Response res = new Response();
            try
            {
                BackDateRepo objrepo = new BackDateRepo();
                if (Year.Length > 2)
                {
                    objrepo.ExecuteFileScheduler(Year, Month, CustomerID, CompanyID);
                    res.IsSuccess = true;
                    return Json(res, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    res.IsSuccess = false;
                    return Json(res, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                res.IsSuccess = false;
                res.Message = ex.Message;
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            // return View();
        }
    }
}