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
    [CustomAuthActionFilter]
    [RoutePrefix("Checker")]
    [CustomAuthrizationActionFilter(Order = 1)]
    public class CheckerBulkApprovelController : Controller
    {
        // GET: CheckerBulkApprovel
        [ViewAction]
        [Route("BulkApprovel", Name = "CheckerBulkApprovel")]
        public ActionResult BulkApprovel()
        {

            try
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
            catch
            {
                throw;

            }
        }
        [ViewAction]
        [HttpPost]
        [Route("GetBulkApprovalGrid", Name = "GetBulkApprovalGrid")]
        public ActionResult GetBulkApprovalGrid(string Type, string ActivityType, string CompIDs, string SiteIDs, string ContractorIDs, string ActIDs, string ActivityIDs, string ExpDate, string Month, string Year, string FromDate, string ToDate, string DocID, List<SortDescription> sorting, FilterContainer filter)
        {
            Response ret = new Response();
            TaskRepo objRepo = new TaskRepo();
            DataSet Ds = new DataSet();
            try
            {
                if (ExpDate != "")
                {
                    string[] arrDate = ExpDate.Split('/');
                    ExpDate = arrDate[2] + "-" + arrDate[1] + "-" + arrDate[0];
                }
                DataTable newDt = new DataTable();
                string sortingStr = "";
                #region Sorting
                if (sorting != null)
                {
                    sortingStr = objRepo.sortGrid(sorting);
                }
                #endregion
                #region filtering
                string filters = "";
                if (filter != null)
                {
                    filters = objRepo.FilterGrid(filter);
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
                BulkApprovalRepo objBRepo = new BulkApprovalRepo();
                Ds = objBRepo.GetBulkApprovalGrid(Type, UID, ActivityType, CompIDs, SiteIDs, ContractorIDs, ActIDs, ActivityIDs, ExpDate, Month, Year, FromDate, ToDate, DocID, sortingStr, filters);
                string data = JsonSerializer.SerializeTable(Ds.Tables[0]);
                ret.IsSuccess = true;
                ret.Data = "{\"Data\":" + data + ",\"Total\":0}";
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
    }
}