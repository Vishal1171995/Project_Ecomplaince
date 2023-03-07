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
//using Ecompliance.Areas.Report.Models;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.Areas.Report.Models;
namespace Ecompliance.Areas.Report.Controllers
{
    [IPRangeActionFilter(Order = 2)]
    [CustomAuthActionFilter]
    [RouteArea("Report")]
    public class MyTaskController : Controller
    {
        // GET: Report/ViewTask 
        [Route("MyTaskNew", Name = "MyTaskNew")]
        public ActionResult MyTaskNew(string Type)
        {
            try {
                int UID = ((User)Session["uBo"]).UID;
                ViewBag.Type = Type;
            }
            catch { }
            return View();
        }

        [Route("MyTask", Name = "MyTask")]
        public ActionResult MyTask(string Type)
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

        [Route("MyTaskGrid", Name = "MyTaskGrid")]
        public ActionResult MyTaskGrid(string Type)
        {
            Response ret = new Response();
            try
            {
               
                int UID = ((User)Session["uBo"]).UID;
                MyTaskRepo objrepo = new MyTaskRepo();
                ret.Data = JsonSerializer.SerializeTable(objrepo.GetMyTaskGridData(Type,UID));
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
        [Route("GetMyTask", Name = "GetMyTask")]
        public ActionResult GetMyTask(string Type, int CompID, int SMonth, int TMonth, int Syear, int Tyear, int page, int pageSize, int skip, int take, List<MyTaskSortDescription> sorting, MyTaskFilterContainer filter)
        {
            Response ret = new Response();
            MyTaskRepo objRepo = new MyTaskRepo();
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
                Ds = objRepo.GetMyTask(Type, CompID, SMonth, TMonth, Syear, Tyear, UID, from, to, sortingStr, filters);
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