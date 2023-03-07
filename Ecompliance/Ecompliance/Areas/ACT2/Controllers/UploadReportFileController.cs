using Ecompliance.CustomAttribute;
using Ecompliance.Utils;
using Ecompliance.Areas.ACT2.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.ActionFilters;

namespace Ecompliance.Areas.ACT2.Controllers
{
    [RouteArea("ACT2")]
    [CustomAuthActionFilter(Order = 0)]
    [CustomAuthrizationActionFilter(Order = 1)]
    public class UploadReportFileController : Controller
    {
        [ViewAction]
        [Route("UploadReportFile",Name = "UploadReportFileACT2")]
        public ActionResult UploadReportFile()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [ADDUpdateAction]
        [Route("UploadSalaryRegister", Name = "UploadSalaryRegister")]
        public ActionResult UploadSalaryRegister(string FileName)
        {
            Response ret = new Response();
            try
            {
                string[] arr = FileName.Split('.');
                if (arr[1].ToString().ToUpper() != "CSV")
                {
                    ret = ret.GetResponse("Mapping", "Upload", -2000, "", "", "Invalid file type.");
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }

                UploadReportRepo repReport = new UploadReportRepo();

                string FilePath = Server.MapPath("~/Docs/Temp/" + FileName);
                string SampleFileName = Server.MapPath("~/Docs/Sample/SalaryRegister.csv");
                int SuccessCount = 0;
                int FailCount = 0;
                string ResultFileName = repReport.UploadSalaryRegister(FilePath, SampleFileName, ((User)Session["uBo"]).UID, ref SuccessCount, ref FailCount);
                if (ResultFileName == "Invalid File Format")
                {
                    ret.IsSuccess = false;
                    ret.Data = "";
                    ret.Message = "Invalid File Format";
                }
                else if (ResultFileName == "Please remove all the comma from your file.")
                {
                    ret = ret.GetResponse("", "", -2);
                    ret.Message = "Please remove all the commas from your file.";
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    string data = "{\"Success\":\"" + SuccessCount + "\",\"Failed\":\"" + FailCount + "\",\"FileName\":\"" + ResultFileName.Replace("\\", "\\\\") + "\"}";
                    ret = ret.GetResponse("Mapping", "GetMapping", -1000, "", data, "");
                }
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                throw;
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [ADDUpdateAction]
        [Route("UploadMusterRollData", Name = "UploadMusterRollData")]
        public ActionResult UploadMusterRollData(string FileName)
        {
            Response ret = new Response();
            try
            {
                string[] arr = FileName.Split('.');
                if (arr[1].ToString().ToUpper() != "CSV")
                {
                    ret = ret.GetResponse("Mapping", "Upload", -2000, "", "", "Invalid file type.");
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }

                UploadReportRepo repReport = new UploadReportRepo();

                string FilePath = Server.MapPath("~/Docs/Temp/" + FileName);
                string SampleFileName = Server.MapPath("~/Docs/Sample/MusterRollData.csv");
                int SuccessCount = 0;
                int FailCount = 0;
                string ResultFileName = repReport.UploadMusterRolldata(FilePath, SampleFileName, ((User)Session["uBo"]).UID, ref SuccessCount, ref FailCount);
                if (ResultFileName == "Invalid File Format")
                {
                    ret.IsSuccess = false;
                    ret.Data = "";
                    ret.Message = "Invalid File Format";
                }
                else if (ResultFileName == "Please remove all the comma from your file.")
                {
                    ret = ret.GetResponse("", "", -2);
                    ret.Message = "Please remove all the commas from your file.";
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    string data = "{\"Success\":\"" + SuccessCount + "\",\"Failed\":\"" + FailCount + "\",\"FileName\":\"" + ResultFileName.Replace("\\", "\\\\") + "\"}";
                    ret = ret.GetResponse("Mapping", "GetMapping", -1000, "", data, "");
                }
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                throw;
            }
        }

        [HttpGet]
        [ADDUpdateAction]
        [Route("DownloadSampleSalary", Name = "DownloadSampleSalary")]
        public ActionResult DownloadSampleSalary()
        {
            Response ret = new Response();
            try
            {
                string FileName = Server.MapPath("~/Docs/Sample/SalaryRegister.csv");
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "SampleSalaryRegister.csv");
            }
            catch
            {
                throw;
            }
        }

        [HttpGet]
        [ADDUpdateAction]
        [Route("DownloadMusterRollData", Name = "DownloadMusterRollData")]
        public ActionResult DownloadMusterRollData()
        {
            Response ret = new Response();
            try
            {
                string FileName = Server.MapPath("~/Docs/Sample/MusterRollData.csv");
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "SampleMusterRollData.csv");
            }
            catch
            {
                throw;
            }
        }

        [ViewAction]
        [HttpGet]
        [Route("DownLoadRepResultFile", Name = "DownLoadRepResultFile")]
        public ActionResult DownLoadRepResultFile(string FileName)
        {
            Response ret = new Response();
            try
            {
                //SiteActivityMappingRep ObjSRep = new SiteActivityMappingRep();
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