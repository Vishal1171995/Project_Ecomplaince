using Ecompliance.ActionFilters;
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

namespace Ecompliance.Controllers
{
    [CustomAuthrizationActionFilter(Order = 1)]
    [CustomAuthActionFilter]
    [RoutePrefix("Reports")]
    public class ReportDataHeaderController : Controller
    {
        // GET: ReportDataHeader
        [ViewAction]
        [Route("Compliance-Nature-Wise-Report", Name = "ReportDataHeader")]
        public ActionResult ReportDataHeader()
        {
            Company ObjComp = new Company();
            ObjComp.CompanyID = 0;
            ObjComp.IsAct = true;
            ObjComp.UID = ((User)Session["uBo"]).UID;
            CompanyRepo ObjCompRep = new CompanyRepo();
            SelectList objlist = DropdownUtils.ToSelectList(TaskRepo.GetMappedCompany(((User)Session["uBo"]).UID), "CompID", "Name");

            ViewBag.CompList = objlist;//DropdownUtils.ToSelectList(ObjCompRep.GetCompanyList(ObjComp), "CompID", "Name");

            Act ObjAct = new Act();
            ObjAct.ActID = 0;
            ObjAct.IsAct = true;
            ObjAct.UID = ((User)Session["uBo"]).UID;
            ActRepo ObjActRepo = new ActRepo();
            ViewBag.ActList = DropdownUtils.ToMultiSelectList(ObjActRepo.GetActList(ObjAct), "ActID", "Short_Name");

            Activity ObjActivity = new Activity();
            ObjActivity.Act = 0;
            ObjActivity.ActivityID = 0;
            ObjActivity.IsAct = true;
            ObjActivity.UID = ((User)Session["uBo"]).UID;
            ActivityRepo ObjActivityRepo = new ActivityRepo();
            ViewBag.ActivityList = DropdownUtils.ToMultiSelectList(ObjActivityRepo.GetActivityList(ObjActivity), "ActivityID", "Name");
            return View();
        }

        [ViewAction]
        [Route("ReportData", Name = "ReportData")]
        public ActionResult ReportData()
        {
            return View();

        }
        [ViewAction]
        [HttpPost]
        [Route("GetDocReportSearchGrid", Name = "GetDocReportSearchGrid")]
        public ActionResult GetDocReportSearchGrid(string Type, string ActivityType, string CompIDs, string SiteIDs, string ContractorIDs, string ActIDs, string ActivityIDs, string ExpDate, string Month, string Year, string FromDate, string ToDate, string DocID, int page, int pageSize, int skip, int take, List<SortDescription> sorting, FilterContainer filter)
        {
            Response ret = new Response();
            ReportDataHeaderRepo ReportRepo = new ReportDataHeaderRepo();
            DataSet Ds = new DataSet();
            try
            {
                if (ExpDate != "")
                {
                    string[] arrDate = ExpDate.Split('/');
                    ExpDate = arrDate[2] + "-" + arrDate[1] + "-" + arrDate[0];
                }
                DataTable newDt = new DataTable();
                int from = skip + 1; //(page - 1) * pageSize + 1;
                int to = take * page; // page * pageSize;
                string sortingStr = "";
                #region Sorting
                if (sorting != null)
                {
                    sortingStr = ReportRepo.sortGrid(sorting);
                }
                #endregion
                #region filtering
                string filters = "";
                if (filter != null)
                {
                    filters = ReportRepo.FilterGrid(filter);
                }
                #endregion
                sortingStr = sortingStr.TrimStart(',');
                int UID = ((User)Session["uBo"]).UID;
                if (sortingStr == "") sortingStr = null;
                if (filters == "") filters = null;
                if (FromDate != "")
                {
                    string[] arrFromDate = FromDate.Split('/');
                    FromDate = arrFromDate[2] + "-" + arrFromDate[1] + "-" + arrFromDate[0];
                }
                if (ToDate != "")
                {
                    string[] arrToDate = ToDate.Split('/');
                    ToDate = arrToDate[2] + "-" + arrToDate[1] + "-" + arrToDate[0];
                }
                // Ds = ReportRepo.GetDocTaskSearchGrid(Type, UID, ActivityType, CompIDs, SiteIDs, ContractorIDs, ActIDs, ActivityIDs, ExpDate, Month, Year, FromDate, ToDate, DocID, from, to, sortingStr, filters);
                string data = JsonSerializer.SerializeTable(Ds.Tables[0]);
                //JsonSerializer.SerializeObject(Ds);
                ret.IsSuccess = true;
                ret.Data = "{\"Data\":" + data + ",\"Total\":" + Ds.Tables[1].Rows[0]["TotalCount"] + "}";
                ret.Message = "success";
            }
            catch (Exception ex)
            {
                ret.IsSuccess = true;
                ret.Data = "{\"Data\":[],\"Total\":" + 0 + "}";
            }
            var jsonResult = Json(ret, JsonRequestBehavior.AllowGet);
            jsonResult.MaxJsonLength = int.MaxValue;
            return jsonResult;
        }
        [ViewAction]
        [HttpPost]
        [Route("GetReportDataHeaderWise", Name = "GetReportDataHeaderWise")]
        public ActionResult GetReportDataHeaderWise(string Type, string ActivityType, string CompIDs, string SiteIDs, string ContractorIDs, string ActIDs, string ActivityIDs, string ExpDate, string Month, string Year, string FromDate, string ToDate, string DocID,string Compliance_nature,string Compliance_Status, int page, int pageSize, int skip, int take, List<SortDescription> sorting, FilterContainer filter)
        {
            Response ret = new Response();
            ReportDataHeaderRepo ReportRepo = new ReportDataHeaderRepo();
            DataSet Ds = new DataSet();
            try
            {
                if (ExpDate != "")
                {
                    string[] arrDate = ExpDate.Split('/');
                    ExpDate = arrDate[2] + "-" + arrDate[1] + "-" + arrDate[0];
                }
                DataTable newDt = new DataTable();
                int from = skip + 1; //(page - 1) * pageSize + 1;
                int to = take * page; // page * pageSize;
                string sortingStr = "";
             
                #region Sorting
                if (sorting != null)
                {
                    sortingStr = ReportRepo.sortGrid(sorting);
                }
                #endregion
                #region filtering
                string filters = "";
                if (filter != null)
                {
                    filters = ReportRepo.FilterGrid(filter);
                }
                #endregion
                sortingStr = sortingStr.TrimStart(',');
               
                int UID = ((User)Session["uBo"]).UID;
                if (sortingStr == "") sortingStr = null;
                if (filters == "") filters = null;
                if (FromDate != "")
                {
                    string[] arrFromDate = FromDate.Split('/');
                    FromDate = arrFromDate[2] + "-" + arrFromDate[1] + "-" + arrFromDate[0];
                }
                if (ToDate != "")
                {
                    string[] arrToDate = ToDate.Split('/');
                    ToDate = arrToDate[2] + "-" + arrToDate[1] + "-" + arrToDate[0];
                }
                string SQlGroupby = "Compliance_nature";
               // string Compliance_Nature = "";
               // string Compliance_Status = "";
                Ds = ReportRepo.GetDocTaskSearchGrid(Type, UID, ActivityType, CompIDs, SiteIDs, ContractorIDs, ActIDs, ActivityIDs, ExpDate, Month, Year, FromDate, ToDate, DocID, from, to, sortingStr, filters, SQlGroupby, Compliance_nature, Compliance_Status);
                DataTable dtAct = new DataTable();
                DataTable dtComponent = new DataTable();
                ViewBag.dtAct = Ds.Tables[3];
                ViewBag.dtComponent = Ds.Tables[2];
                string Actdata = JsonSerializer.SerializeTable(Ds.Tables[3]);
                string Componentdata = JsonSerializer.SerializeTable(Ds.Tables[2]);
                string data= JsonSerializer.SerializeTable(Ds.Tables[0]);
                ret.IsSuccess = true;
                ret.Data = "{\"Actdata\":" + Actdata + ",\"Componentdata\":" + Componentdata + ", \"Data\":" + data + ",\"Total\":" + Ds.Tables[1].Rows[0]["TotalCount"] + "}";
                ret.Message = "success";
            }
            catch (Exception ex)
            {
                ret.IsSuccess = true;
                ret.Data = "{\"Actdata\":[],\"Componentdata\":[],\"Data\":[],\"Total\":" + 0 + "}";
            }
            var jsonResult = Json(ret, JsonRequestBehavior.AllowGet);
            jsonResult.MaxJsonLength = int.MaxValue;
            return jsonResult;
        }
        [ViewAction]
        [HttpGet]
        [Route("GetRMappedSite", Name = "GetRMappedSite")]
        public ActionResult GetRMappedSite(string CompanyID)
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
        [ViewAction]
        [HttpGet]
        [Route("GetContractorOfReTaskFilter", Name = "GetContractorOfReTaskFilter")]
        public ActionResult GetContractorOfReTaskFilter(int CompID)
        {
            Response ret = new Response();
            try
            {
                DataSet ds = new DataSet();
                Contractor ObjMContractor = new Contractor();
                ObjMContractor.IsAct = true;
                ObjMContractor.Company = CompID;
                ObjMContractor.UID = ((User)Session["uBo"]).UID;
                ContractorRepo ObjSRep = new ContractorRepo();
                string jsonData = JsonSerializer.SerializeTable(ObjSRep.GetContractor(ObjMContractor).Tables[0]); //ds.Tables[0], Newtonsoft.Json.Formatting.None, serializerSettings);
                ret.IsSuccess = true;
                ret.Message = "";
                ret.Data = jsonData;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch { throw; }
        }

        [ViewAction]
        [HttpGet]
        [Route("GetRepActivityForAllAerts", Name = "GetRepActivityForAllAerts")]
        public ActionResult GetRepActivityForAllAerts(string ActIds)
        {
            Response ret = new Response();
            TaskRepo objRepo = new TaskRepo();
            try
            {
                DataSet ds = new DataSet();
                string jsonData = JsonSerializer.SerializeTable(objRepo.GetActivityForAllAerts(ActIds).Tables[0]);
                //ds.Tables[0], Newtonsoft.Json.Formatting.None, serializerSettings);
                ret.IsSuccess = true;
                ret.Message = "";
                ret.Data = jsonData;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch { throw; }
        }
        [ViewAction]
        [HttpGet]
        [Route("GetRepMappedActsForMultipleSite", Name = "GetRepMappedActsForMultipleSite")]
        public ActionResult GetRepMappedActsForMultipleSite(string SiteIDs)
        {
            Response ret = new Response();
            TaskRepo objRepo = new TaskRepo();
            try
            {
                DataSet ds = new DataSet();
                string jsonData = JsonSerializer.SerializeTable(objRepo.GetMappedActsForMultipleSite(SiteIDs).Tables[0]);
                //ds.Tables[0], Newtonsoft.Json.Formatting.None, serializerSettings);
                ret.IsSuccess = true;
                ret.Message = "";
                ret.Data = jsonData;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch { throw; }
        }
    }
}