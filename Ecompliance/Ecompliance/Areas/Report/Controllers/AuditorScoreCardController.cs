using Ecompliance.ActionFilters;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.CustomAttribute;
using Ecompliance.Repository;
using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Ecompliance.Areas.Report.Controllers
{
    [CustomAuthActionFilter(Order = 0)]
    [CustomAuthrizationActionFilter(Order = 1)]
    [RouteArea("Report")]
    public class AuditorScoreCardController : Controller
    {
        // GET: Report/AuditorScoreCard
        //[CustomAuthrizationActionFilter(Order = 1)]
        [ViewAction]
        [Route("AuditorScoreCard", Name = "AuditorScoreCard")]
        public ActionResult AuditorScoreCard()
        {
            try
            {
                ViewBag.Company = DropdownUtils.ToSelectList(TaskRepo.GetMappedCompany(((User)Session["uBo"]).UID), "CompID", "Name");
                ViewBag.Year = DropdownUtils.ToSelectList(AuditorScoreCardRepo.GetYear(), "Year", "Year");
                return View();
            }
            catch { throw; }
        }
        [ViewAction]
        [HttpGet]
        [Route("GetAuditorScoreCardData", Name = "GetAuditorScoreCardData")]
        public ActionResult GetScoreCardData1(string CompanyID, string SiteID, string Month, string Year, string Type, string Maker, string Checker, string Auditor)
        {
            Response res = new Response();
            AuditorScoreCardRepo scorerepo = new AuditorScoreCardRepo();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                DataSet DsData = scorerepo.GetScoreCardData(CompanyID, SiteID, Month, Year, Type, Maker, Checker, Auditor, UID);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeObject(DsData);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                throw;
            }
        }
    }
}