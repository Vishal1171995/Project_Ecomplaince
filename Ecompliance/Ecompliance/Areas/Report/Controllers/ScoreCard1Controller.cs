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
    public class ScoreCard1Controller : Controller
    {
        [CustomAuthrizationActionFilter(Order = 1)]
        [ViewAction]
        [Route("ScoreCard1", Name = "ScoreCard1")]
        public ActionResult ScoreCard1()
        {
            try
            {
                ViewBag.Company = DropdownUtils.ToSelectList(TaskRepo.GetMappedCompany(((User)Session["uBo"]).UID), "CompID", "Name");
                ViewBag.Year = DropdownUtils.ToSelectList(ScoreCard1Repo.GetYear(), "Year", "Year");
                return View();
            }
            catch { throw; }
        }
        [ViewAction]
        [HttpGet]
        [Route("GetScoreCardData1", Name = "GetScoreCardData1")]
        public ActionResult GetScoreCardData1(string CompanyID, string SiteID, string Month, string Year, string Type,string Maker,string Checker,string Auditor)
        {
            Response res = new Response();
            ScoreCard1Repo scorerepo = new ScoreCard1Repo();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                DataSet DsData = scorerepo.GetScoreCardData(CompanyID, SiteID, Month, Year, Type,Maker,Checker,Auditor, UID);
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