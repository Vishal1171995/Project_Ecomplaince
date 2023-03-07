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
    [IPRangeActionFilter(Order=2)]
    [CustomAuthActionFilter(Order=1)]    
    [RouteArea("Report")]
    public class DashBoardController : Controller
    {
     
        
        [Route("DashBoard", Name = "DashBoard")]
        public ActionResult DashBoard()
        {
          //  int UID = ((User)Session["uBo"]).UID;
            DashBoard Model = new DashBoard();
            SelectList objlist = DropdownUtils.ToMultiSelectList(DashBoardRepo.GetMappedCompany(((User)Session["uBo"]).UID), "CompID", "Name", "", true);
            Model.CompanyList = objlist;
          //  ViewBag.UID = UID;
            ViewBag.URole = ((User)Session["uBo"]).UserRole;
            return View(Model);
        }
        [HttpGet]
        [Route("GetDashBoardHomeCount", Name = "GetDashBoardHomeCount")]
        public ActionResult GetDashBoardHomeCount(string CompanyID, string SMonth, string SYear, string TMonth, string TYear)
        {
            Response res = new Response();
            DashBoardRepo repdash = new DashBoardRepo();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                DataTable dt = repdash.GetDashBoardHomeCount(UID, CompanyID, SMonth, SYear, TMonth, TYear);
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
        [Route("GetDashBoardCompTot", Name = "GetDashBoardCompTot")]
        public ActionResult GetDashBoardCompTot(string CompanyID, string SMonth, string SYear, string TMonth, string TYear)
        {
            Response res = new Response();
            DashBoardRepo repdash = new DashBoardRepo();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                DataTable dt = repdash.GetDashBoardCompanyTot(CompanyID, SMonth, SYear, TMonth, TYear, UID);
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
        [Route("GetDashBoardSiteWise", Name = "GetDashBoardSiteWise")]
        public ActionResult GetDashBoardSiteWise(string CompanyID, string SMonth, string SYear, string TMonth, string TYear)
        {
            Response res = new Response();
            DashBoardRepo repdash = new DashBoardRepo();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                DataTable dt = repdash.GetDashBoardSiteWise(CompanyID, SMonth, SYear, TMonth, TYear,UID);
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
        [Route("GetDashBoardActWise", Name = "GetDashBoardActWise")]
        public ActionResult GetDashBoardActWise(string CompanyID, string SMonth, string SYear, string TMonth, string TYear)
        {
            Response res = new Response();
            DashBoardRepo repdash = new DashBoardRepo();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                object objdash = repdash.GetDashBoardActWise(CompanyID, SMonth, SYear, TMonth, TYear, UID);
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
        [Route("GetDashBoardActClick", Name = "GetDashBoardActClick")]
        public ActionResult GetDashBoardActClick(string CompanyID, string ActID, string Status ,string SMonth, string SYear, string TMonth, string TYear)
        {
            Response res = new Response();
            DashBoardRepo repdash = new DashBoardRepo();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                DataTable dt = repdash.GetDashBoardActClick(CompanyID,ActID,Status, SMonth, SYear, TMonth, TYear,UID);
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
        [Route("SiteMapDashboard", Name = "SiteMapDashboard")]
        public ActionResult SiteMapDashboard(string CompanyID, string SMonth, string SYear, string TMonth, string TYear)
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