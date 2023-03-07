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
    [CustomAuthrizationActionFilter(Order = 1)]
    [RouteArea("Report")]
   
    public class TaskReconsilationController : Controller
    {
        // GET: Report/ActScheduled
        [CustomAuthrizationActionFilter]
        [ViewAction]
        [Route("TaskReconsilation", Name = "TaskReconsilation")]
        public ActionResult TaskReconsilation()
        {
            try
            {
                Company ObjComp = new Company();
                ObjComp.CompanyID = 0;
                ObjComp.IsAct = true;
                ObjComp.UID = ((User)Session["uBo"]).UID;
                CompanyRepo ObjCompRep = new CompanyRepo();
                SelectList objlist = DropdownUtils.ToSelectList(TaskRepo.GetMappedCompany(((User)Session["uBo"]).UID), "CompID", "Name");

                ViewBag.CompList = objlist;
                //DropdownUtils.ToSelectList(ObjCompRep.GetCompanyList(ObjComp), "CompID", "Name");

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
            catch { return View(); }

        }


        [ViewAction]
        [HttpPost]
        [Route("GetDocTaskReport", Name = "GetDocTaskReport")]
        public ActionResult GetDocTaskReport(string Type, string ActivityType, string CompIDs, string SiteIDs, string ContractorIDs, string ActIDs, string ActivityIDs, string ExpDate,  string FromDate, string ToDate, string DocID, int page, int pageSize, int skip, int take, List<SortDescription> sorting, FilterContainer filter)
        {
            Response ret = new Response();
            TaskReconsilationRepo objRepo = new TaskReconsilationRepo();
            DataSet Ds = new DataSet();
            try
            {
               
                DataTable newDt = new DataTable();
                int from = skip + 1; //(page - 1) * pageSize + 1;
                int to = take * page; // page * pageSize;
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
                Ds = objRepo.GetTaskReconsilationData(Type, UID, ActivityType, CompIDs, SiteIDs,  ActIDs, ActivityIDs,  FromDate, ToDate, DocID, from, to, sortingStr, filters);
                string data = JsonSerializer.SerializeTable(Ds.Tables[0]);
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



    }
   
}