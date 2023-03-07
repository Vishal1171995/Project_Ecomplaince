using Ecompliance.ActionFilters;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.CustomAttribute;
using Ecompliance.Repository;
using Ecompliance.Utils;
using Ecompliance.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Ecompliance.Controllers
{
    //[CustomAuthrizationActionFilter(Order = 1)]
    [CustomAuthActionFilter]
    [RoutePrefix("document")]
    public class MakerBulkApprovalController : Controller
    {
        //[ViewAction]
        [Route("MakerBulkApproval", Name = "MakerBulkApproval")]
        public ActionResult MakerBulkApproval(string Type)
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
        //[ADDUpdateAction]
        [HttpPost]
        [ValidateAntiForgeryToken()]
        [Route("MakerBulkApprove", Name = "MakerBulkApprove")]
        public ActionResult MakerBulkApprove(List<TaskVerifyVM> TaskVerifyVM)
        {
            MakerBulkApprovalRepo obj = new MakerBulkApprovalRepo();
            Response ret = new Response();
            User ObjU = new User();
            try
            {
                int SuccessCount = 0;
                int FailCount = 0;
                string ResultFileName = obj.MakerBulkApprove(TaskVerifyVM, ((User)Session["uBo"]).UID, ref SuccessCount, ref FailCount);
                string data = "{\"Success\":\"" + SuccessCount + "\",\"Failed\":\"" + FailCount + "\",\"FileName\":\"" + ResultFileName.Replace("\\", "\\\\") + "\"}";
                ret = ret.GetResponse("Mapping", "GetMapping", -1000, "", data, "");
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw;
            }

        }
        //[ViewAction]
        [HttpGet]
        [Route("DownLoadMakerApproveResultFile", Name = "DownLoadMakerApproveResultFile")]
        public ActionResult DownLoadMakerApproveResultFile(string FileName)
        {
            Response ret = new Response();
            try
            {
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "ResultFile.csv");
            }
            catch
            {
                throw;
            }
        }
    }
}