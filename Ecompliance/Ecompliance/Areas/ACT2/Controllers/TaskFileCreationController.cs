using Ecompliance.ActionFilters;
using Ecompliance.Areas.ACT2.Repository;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.Areas.Master.Models;
using Ecompliance.CustomAttribute;
using Ecompliance.Repository;
using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Ecompliance.Areas.ACT2.Controllers
{
    [RouteArea("ACT2")]
    [CustomAuthActionFilter(Order = 0)]
    [CustomAuthrizationActionFilter(Order = 1)]
    public class TaskFileCreationController : Controller
    {
        [ViewAction]
        [Route("TaskFileRun", Name = "TaskFileRun")]
        public ActionResult TaskFileRun()
        {
            DownloadTaskFilesRepo Downloadrepo = new DownloadTaskFilesRepo();
            Customer Custmdl = new Customer();
            Custmdl.UID = ((User)Session["uBo"]).UID;
            ViewBag.CompanyList = DropdownUtils.ToSelectList(TaskRepo.GetMappedCompany(((User)Session["uBo"]).UID), "CompID", "Name");
            ViewBag.CustomerList = DropdownUtils.ToSelectList(Downloadrepo.GetCustomerACT2(Custmdl).Tables[0], "CustID", "Name");
            return View();
        }

        [HttpGet]
        [ViewAction]
        [Route("GetBackCompany", Name = "GetBackCompany")]
        public ActionResult GetBackCompany(int CompanyID, int CustID)
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
        [ADDUpdateAction]
        [Route("TaskFileRunPost", Name = "TaskFileRunPost")]
        [HttpPost]
        public ActionResult TaskFileRunPost(string Year,string Month,string CustomerID, string CompanyID)
        {
            Response ret = new Response();
            TaskFileRepo repo = new TaskFileRepo();
            try {
                if (Year.Length > 2)
                {
                     repo.RunManualCreation(Year, Month, CustomerID, CompanyID);
                    ret.IsSuccess = true;
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    ret.IsSuccess = false;
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
            }
            catch {
                ret.IsSuccess = false;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
        }
    }
}