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
    public class SendToAuditorController : Controller
    {
        [CustomAuthrizationActionFilter(Order = 1)]
        [ViewAction]
        [Route("SendToAuditor", Name = "SendToAuditor")]
        public ActionResult SendToAuditor()
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
        [Route("GetSendToScoreCardData", Name = "GetSendToScoreCardData")]
        public ActionResult GetSendToScoreCardData(string CompanyID, string SiteID, string Month, string Year, string Type)
        {
            Response res = new Response();
            SendToAuditorRepo sendToRepo = new SendToAuditorRepo();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                DataTable dt = sendToRepo.GetSendToScoreCardData(CompanyID, SiteID, Month, Year, Type, UID);
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
        [Route("SetAuditee_Auditor", Name = "SetAuditee_Auditor")]
        public ActionResult SetAuditee_Auditor(List<SendToAuditor> Model,string Type)
        {
            Response res = new Response();
            SendToAuditorRepo sendToRepo = new SendToAuditorRepo();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                res = sendToRepo.SetAuditee_Auditor(Model, UID,Type);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                throw;
            }
        }

        //Viveck=======================================================================
        [ADDUpdateAction]
        [HttpPost]
        [Route("SetUploaderRemarks", Name = "SetUploaderRemarks")]
        public ActionResult SetUploaderRemarks(string Remarks, int Docid)
        {
            Response res = new Response();
            SendToAuditorRepo sendToRepo = new SendToAuditorRepo();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                res = sendToRepo.SetUploaderRemarks(Remarks, Docid, UID);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                throw;
            }
        }
        [HttpGet]
        [Route("GetCRMMSGData", Name = "GetCRMMSGData")]
        public ActionResult GetCRMMSGData(int DocID)
        {
            Response res = new Response();
            SendToAuditorRepo sendToRepo = new SendToAuditorRepo();
            try
            {
                DataSet DsData = sendToRepo.GetCRMMSGData(DocID);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(DsData.Tables[0]);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                throw;
            }
        }

        [ViewAction]
        [HttpGet]
        [Route("GetSendAuditorMappedSite", Name = "GetSendAuditorMappedSite")]
        public ActionResult GetSendAuditorMappedSite(string CompanyID)
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