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
    [CustomAuthrizationActionFilter(Order = 1)]
    [RouteArea("Report")]
    public class StartDateCompController : Controller
    {
        // GET: Report/StartDateComp
        //[CustomAuthrizationActionFilter]
        [ViewAction]
        [Route("StartDateComp", Name = "StartDateComp")]
        public ActionResult StartDateComp()
        {
            try
            {
                ViewBag.Company = DropdownUtils.ToSelectList(TaskRepo.GetMappedCompany(((User)Session["uBo"]).UID), "CompID", "Name");
                //ViewBag.Year = DropdownUtils.ToSelectList(ScoreCardRepo.GetYear(), "Year", "Year");
                return View();
            }
            catch { return View(); }
        }
        [HttpGet]
        [Route("GetStartDatComp", Name = "GetStartDatComp")]
        public ActionResult GetStartDatComp(string CompanyID)
        {
            Response res = new Response();
            StartDateCompRepo repo = new StartDateCompRepo();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                DataTable dt = repo.GetStartDatComp(CompanyID, UID);
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