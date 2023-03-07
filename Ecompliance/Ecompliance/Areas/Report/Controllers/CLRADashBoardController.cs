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
    [CustomAuthActionFilter(Order = 1)]
    [RouteArea("Report")]
    public class CLRADashBoardController : Controller
    {
        // GET: Report/CLRADashBoard
        [Route("CLRADashBoard", Name = "CLRADashBoard")]
        public ActionResult CLRADashBoard()
        {
            try
            {
                DashBoard Model = new DashBoard();
                SelectList objlist = DropdownUtils.ToMultiSelectList(CLRADashBoardRepo.GetMappedCompany(((User)Session["uBo"]).UID), "CompID", "Name", "", true);
                Model.CompanyList = objlist;
                ViewBag.URole = ((User)Session["uBo"]).UserRole;
                return View(Model);
            }
            catch(Exception ex) { throw; }
        }
        [HttpGet]
        [Route("GetCLRADashBoardHomeCount", Name = "GetCLRADashBoardHomeCount")]
        public ActionResult GetCLRADashBoardHomeCount(string CompanyID, string SMonth, string SYear, string TMonth, string TYear)
        {
            Response res = new Response();
            CLRADashBoardRepo repdash = new CLRADashBoardRepo();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                DataTable dt = repdash.GetCLRADashBoardHomeCount(UID, CompanyID, SMonth, SYear, TMonth, TYear);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                throw;
            }
        }

        [HttpGet]
        [Route("GetCLRADashBoardCompTot", Name = "GetCLRADashBoardCompTot")]
        public ActionResult GetCLRADashBoardCompTot(string CompanyID, string SMonth, string SYear, string TMonth, string TYear)
        {
            Response res = new Response();
            CLRADashBoardRepo repdash = new CLRADashBoardRepo();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                DataTable dt = repdash.GetCLRADashBoardCompanyTot(CompanyID, SMonth, SYear, TMonth, TYear, UID);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                throw;
            }
        }

        [HttpGet]
        [Route("GetCLRADashBoardSiteWise", Name = "GetCLRADashBoardSiteWise")]
        public ActionResult GetCLRADashBoardSiteWise(string CompanyID, string SMonth, string SYear, string TMonth, string TYear)
        {
            Response res = new Response();
            CLRADashBoardRepo repdash = new CLRADashBoardRepo();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                DataTable dt = repdash.GetCLRADashBoardSiteWise(CompanyID, SMonth, SYear, TMonth, TYear, UID);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                throw;
            }
        }

        [HttpGet]
        [Route("GetCLRADashBoardActWise", Name = "GetCLRADashBoardActWise")]
        public ActionResult GetCLRADashBoardActWise(string CompanyID, string SMonth, string SYear, string TMonth, string TYear)
        {
            Response res = new Response();
            CLRADashBoardRepo repdash = new CLRADashBoardRepo();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                object objdash = repdash.GetCLRADashBoardActWise(CompanyID, SMonth, SYear, TMonth, TYear, UID);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeObject(objdash);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                throw;
            }
        }
        [HttpGet]
        [Route("GetCLRADashBoardActClick", Name = "GetCLRADashBoardActClick")]
        public ActionResult GetCLRADashBoardActClick(string CompanyID, string ActID, string Status, string SMonth, string SYear, string TMonth, string TYear)
        {
            Response res = new Response();
            CLRADashBoardRepo repdash = new CLRADashBoardRepo();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                DataTable dt = repdash.GetCLRADashBoardActClick(CompanyID, ActID, Status, SMonth, SYear, TMonth, TYear, UID);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                throw;
            }
        }
        #region MapDashboard
        [Route("CLRASiteMapDashboard", Name = "CLRASiteMapDashboard")]
        public ActionResult CLRASiteMapDashboard(string CompanyID, string SMonth, string SYear, string TMonth, string TYear)
        {
            TaskRepo TReop = new TaskRepo();
            DataTable Dt = new DataTable();
            try
            {
                return View();
            }
            catch
            {
                return View();
            }

        }
        #endregion
    }
}