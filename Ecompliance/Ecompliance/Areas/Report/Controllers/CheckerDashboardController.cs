using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ecompliance.ActionFilters;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.Utils;
using Ecompliance.Repository;
using System.Data;
namespace Ecompliance.Areas.Report.Controllers
{
    [CustomAuthActionFilter]
    [RouteArea("Report")]
    public class CheckerDashboardController : Controller
    {
        // GET: Report/CheckerDashboard
        [Route("CheckerDashboard", Name = "CheckerDashboard")]
        public ActionResult CheckerDashboard()
        {
            return View();
        }
        [HttpPost]
        [Route("GetCheckerDashboard", Name = "GetCheckerDashboard")]
        public ActionResult GetCheckerDashboard(int page, int pageSize, int skip, int take, List<SortDescription> sorting, FilterContainer filter)
        {
            Response ret = new Response();
            CheckerDashboardRepo objRepo = new CheckerDashboardRepo();
            TaskRepo objT = new TaskRepo();
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
                    sortingStr = objT.sortGrid(sorting);
                }
                #endregion
                #region filtering
                string filters = "";
                if (filter != null)
                {
                    filters = objT.FilterGrid(filter);
                }
                #endregion
                sortingStr = sortingStr.TrimStart(',');
                int UID = ((User)Session["uBo"]).UID;
                if (sortingStr == "") sortingStr = null;
                if (filters == "") filters = null;
                Ds = objRepo.GetCheckerDashboard(UID, from, to, sortingStr, filters);

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
            return Json(ret);
        }
    }
}