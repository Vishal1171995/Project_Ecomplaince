using System;
using System.Collections.Generic;
using System.Linq;
using Ecompliance.Areas.Master.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ecompliance.Repository;
using Ecompliance.Utils;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using Ecompliance.ActionFilters;
using Ecompliance.Areas.Report.Models;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.CustomAttribute;

namespace Ecompliance.Areas.Report.Controllers
{
    [CustomAuthActionFilter(Order = 0)]
   
    [RouteArea("Report")]
    public class ActScheduledController : Controller
    {
        // GET: Report/ActScheduled
        [CustomAuthrizationActionFilter]
        [ViewAction]
        [Route("ActScheduled", Name = "ActScheduled")]
        public ActionResult ActScheduled()
        {
            try
            {
                ViewBag.Company = DropdownUtils.ToSelectList(TaskRepo.GetMappedCompany(((User)Session["uBo"]).UID), "CompID", "Name");
                ViewBag.Year = DropdownUtils.ToSelectList(ScoreCardRepo.GetYear(), "Year", "Year");
                return View();
            }
            catch { return View(); }

        }

        [HttpGet]
        [Route("GetActScheduledData", Name = "GetActScheduledData")]
        public ActionResult GetActScheduledData(string CompanyID, string Month, string Year, string Type)
        {
            Response res = new Response();
            ActScheduledRepo repo = new ActScheduledRepo();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                DataTable dt = repo.GetActScheduledData(CompanyID, Month, Year, Type, UID);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                throw;
            }
        }

        [HttpGet]
        [Route("GetActScheduledDataDetails", Name = "GetActScheduledDataDetails")]
        public ActionResult GetActScheduledDataDetails(string CompanyID, string SiteID, string ActID, string Month, string Year, string Type)
        {
            Response res = new Response();
            ActScheduledRepo repo = new ActScheduledRepo();
            try
            {
                DataTable dt = repo.GetActScheduledDataDetails(CompanyID, SiteID, ActID, Month, Year, Type);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                throw;
            }
        }

    }
}