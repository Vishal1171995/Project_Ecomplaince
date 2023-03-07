using Ecompliance.ActionFilters;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.Areas.Report.Models;
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
    [IPRangeActionFilter(Order = 2)]
    [CustomAuthActionFilter]
    [RouteArea("Report")]
    public class CLRAMyTaskController : Controller
    {
        [Route("CLRAMyTask", Name = "CLRAMyTask")]
        public ActionResult CLRAMyTask(string Type)
        {
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                if (Type != null)
                    ViewBag.Type = Type;
                else
                    ViewBag.Type = "Need To Act";
            }
            catch { }
            return View();
        }
        [Route("CLRAMyTaskGrid", Name = "CLRAMyTaskGrid")]
        public ActionResult CLRAMyTaskGrid(string Type)
        {
            Response ret = new Response();
            try
            {

                int UID = ((User)Session["uBo"]).UID;
                CLRAMyTaskRepo objrepo = new CLRAMyTaskRepo();
                ret.Data = JsonSerializer.SerializeTable(objrepo.GetMyTaskGridData(Type, UID));
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
        [Route("GetCLRAMyTask", Name = "GetCLRAMyTask")]
        public ActionResult GetCLRAMyTask(string Type, int CompID, int SMonth, int TMonth, int Syear, int Tyear, int page, int pageSize, int skip, int take, List<MyTaskSortDescription> sorting, MyTaskFilterContainer filter)
        {
            Response ret = new Response();
            CLRAMyTaskRepo objRepo = new CLRAMyTaskRepo();
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
                    sortingStr = objRepo.sortMyTask(sorting);
                }
                #endregion
                #region filtering
                string filters = "";
                if (filter != null)
                {
                    filters = objRepo.FilterMyTask(filter);
                }
                #endregion
                sortingStr = sortingStr.TrimStart(',');
                int UID = ((User)Session["uBo"]).UID;
                if (sortingStr == "") sortingStr = null;
                if (filters == "") filters = null;
                Ds = objRepo.GetCLRAMyTask(Type, CompID, SMonth, TMonth, Syear, Tyear, UID, from, to, sortingStr, filters);
                string data = JsonSerializer.SerializeTable(Ds.Tables[0]);
                ret.IsSuccess = true;
                ret.Data = "{\"Data\":" + data + ",\"Total\":" + Ds.Tables[1].Rows[0]["Total"] + "}";
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