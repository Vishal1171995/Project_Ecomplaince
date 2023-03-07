using Ecompliance.ActionFilters;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.Areas.Report.Models;
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
    [CustomAuthrizationActionFilter(Order = 1)]
    [CustomAuthActionFilter(Order = 0)]
    [RouteArea("Report")]
    public class AuditorController : Controller
    {
        [CustomAuthrizationActionFilter(Order = 1)]
        [ViewAction]
        [Route("Auditor", Name = "Auditor")]
        public ActionResult Auditor()
        {
            ViewBag.Company = DropdownUtils.ToSelectList(TaskRepo.GetMappedCompany(((User)Session["uBo"]).UID), "CompID", "Name");
            ViewBag.Year = DropdownUtils.ToSelectList(AuditorRepo.GetYear(), "Year", "Year");
            return View();
        }
        [ViewAction]
        [HttpGet]
        [Route("GetAuditorScoreCardData1", Name = "GetAuditorScoreCardData1")]
        public ActionResult GetAuditorScoreCardData1(string CompanyID, string SiteID, string Month, string Year, string Type)
        {
            Response res = new Response();
            AuditorRepo sendToRepo = new AuditorRepo();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                DataTable dt = sendToRepo.GetAuditorScoreCardData(CompanyID, SiteID, Month, Year, Type, UID);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                throw;
            }
        }
        [ADDUpdateAction]
        [HttpPost]
        [Route("SetAuditor", Name = "SetAuditor")]
        public ActionResult SetAuditor(List<Auditor> Model, string Type)
        {
            Response res = new Response();
            AuditorRepo sendToRepo = new AuditorRepo();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                res = sendToRepo.SetAuditee_Auditor(Model, UID, Type);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                throw;
            }
        }

        [ViewAction]
        [HttpGet]
        [Route("GetAuditorMappedSite", Name = "GetAuditorMappedSite")]
        public ActionResult GetAuditorMappedSite(string CompanyID)
        {
            //TaskRepo obj = new TaskRepo();
            Response ret = new Response();
            try
            {
                ret.Data = JsonSerializer.SerializeTable(TaskRepo.GetMappedSite(Convert.ToInt32(CompanyID), ((User)Session["uBo"]).UID));
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
    }
}