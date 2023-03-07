using System;
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
    [CustomAuthrizationActionFilter(Order = 1)]
    [CustomAuthActionFilter(Order = 1)]
    [RouteArea("Report")]
    public class FileExplorerController : Controller
    {
        [Route("FileExplorer1", Name = "FileExplorer1")]
        public ActionResult FileExplorer1()
        {
            return View();
        }
        [Route("GetFileExplorer", Name = "GetFileExplorer")]
        public ActionResult GetFileExplorer()
        {
            //TaskRepo obj = new TaskRepo();
            Response ret = new Response();
            CustomerRepo objCust = new CustomerRepo();
            FileExplorerRepo objRepo = new FileExplorerRepo();
            try
            {
                ret = objRepo.GetFileExplorer();
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ret.IsSuccess = false;
                ret.Message = ex.Message;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
        }
        [Route("GetDocFileExplorer", Name = "GetDocFileExplorer")]
        public ActionResult GetDocFileExplorer(int CompID,int SiteID,int ActID,int ActivityID,int Year,string Month)
        {
            //TaskRepo obj = new TaskRepo();
            Response ret = new Response();
            CustomerRepo objCust = new CustomerRepo();
            FileExplorerRepo objRepo = new FileExplorerRepo();
            DataTable dt = new DataTable();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                dt = objRepo.GetDocFileExplorer(CompID, SiteID, ActID, ActivityID, Year, Month, UID);
                ret.Data = JsonSerializer.SerializeTable(dt);
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

        [Route("DownloadDocFile", Name = "DownloadDocFile")]
        public ActionResult DownloadDocFile(string Attachment)
        {
            FileRepo ObjRepo = new FileRepo();
            Response res = new Response();
            try
            {
                string FileName = Server.MapPath("~/Docs/File/") + Attachment;
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, FileName);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
    }
}