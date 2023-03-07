using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ecompliance.Repository;
using Ecompliance.Utils;
using Ecompliance.ActionFilters;
using System.Data;
using Ecompliance.CustomAttribute;
namespace Ecompliance.Areas.Report.Controllers
{
    [CustomAuthrizationActionFilter(Order = 1)]
    [CustomAuthActionFilter(Order = 0)]
    [RouteArea("Report")]
    public class UserLogController : Controller
    {
        // GET: Report/UserLog
        [ViewAction]
        [Route("LogUser", Name = "LogUser")]
        public ActionResult LogUser()
        {
            return View();
        }
        [ViewAction]
        [Route("GetLogUser", Name = "GetLogUser")]
        public ActionResult GetLogUser(string FromDate, string ToDate, int page, int pageSize, int skip, int take, List<SortDescription> sorting, FilterContainer filter)
        {
            Response ret = new Response();
            LogUserRepo objRepo = new LogUserRepo();
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
                Ds = objRepo.GetLogUser(FromDate, ToDate, from, to, sortingStr, filters);
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