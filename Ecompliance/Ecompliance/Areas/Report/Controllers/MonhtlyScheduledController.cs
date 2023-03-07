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
    [CustomAuthrizationActionFilter(Order = 1)]
    [CustomAuthActionFilter(Order = 0)]
    [RouteArea("Report")]
    public class MonhtlyScheduledController : Controller
    {
        // GET: Report/MonhtlyScheduled
         [CustomAuthrizationActionFilter(Order = 1)]
         [ViewAction]
         [Route("MonthlyScheduled", Name = "MonthlyScheduled")]
        public ActionResult MonthlyScheduled()
        {
            try
            {
                ViewBag.Company = DropdownUtils.ToSelectList(TaskRepo.GetMappedCompany(((User)Session["uBo"]).UID), "CompID", "Name");
                ViewBag.Year = DropdownUtils.ToSelectList(ScoreCardRepo.GetYear(), "Year", "Year");
                return View();
            }
            catch
            { throw; }
        }
        [ViewAction]
        [HttpGet]
        [Route("GetMonthlyScheudledData", Name = "GetMonthlyScheudledData")]
        public ActionResult GetMonthlyScheudledData(string CompanyID, string Month, string Year, string Type)
        {
            Response res = new Response();
            MonthlyScheduleRepo repo = new MonthlyScheduleRepo();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                DataTable dt = repo.GetMonthlyScheudledData(CompanyID, Month, Year, Type, UID);
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