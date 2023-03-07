using Ecompliance.ActionFilters;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.CustomAttribute;
using Ecompliance.Repository;
using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Ecompliance.Areas.ACT2.Controllers
{
    [RouteArea("ACT2")]
    [CustomAuthActionFilter(Order = 0)]
    [CustomAuthrizationActionFilter(Order = 1)]
    public class TaskFileErrorReportController : Controller
    {
        // GET: ACT2/TaskFileErrorReport
        [ViewAction]
        [Route("TaskFileErrorReport", Name = "TaskFileErrorReport")]       
        public ActionResult TaskFileErrorReport()
        {
            return View();
        }

        [ADDUpdateAction]
        [Route("TaskFileErrorReportPost", Name = "TaskFileErrorReportPost")]
        [HttpPost]
        public ActionResult TaskFileErrorReportPost(string Type, string Date)
        {
            try
            {
                Response res = new Response();
                int uid = ((User)Session["uBo"]).UID;
                TaskFileRepo repo = new TaskFileRepo();
                DateTime Date1 = Convert.ToDateTime(Date);
                DataTable dt = repo.GetDatForFileErrReport(Type, Date, uid);

                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch { throw; }
        }
    }
}