using Ecompliance.ActionFilters;
using Ecompliance.CustomAttribute;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.Areas.Master.Models;
using Ecompliance.Repository;
using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Ecompliance.Areas.Master.Controllers
{
    [CustomAuthActionFilter(Order = 0)]
    [CustomAuthrizationActionFilter(Order = 1)]
    [RouteArea("Master")]
    public class FrequencyController : Controller
    {
        // GET: Master/Frequency
        [ViewAction]
        [Route("Frequency", Name = "FrequencyView")]
        public ActionResult FrequencyView()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken()]
        [ADDUpdateAction]
        [Route("CreateFrequency", Name = "CreateFrequency")]
        public ActionResult CreateFrequency(Frequency model)
        {
            FrequencyRepo repact = new FrequencyRepo();
            Response res = new Response();
            if (ModelState.IsValid)
            {  
                try
                {
                    model.CreatedBy = ((User)Session["uBo"]).UID;
                    res = res.GetResponse("Frequency", model.FrequencyID.ToString(), Convert.ToInt32(repact.CreateUpdateFrequency(model)), "Frequency Name");
                    return Json(res);
                }
                catch
                {
                    res = res.GetResponse("Frequency", "", -2);
                    return Json(res, JsonRequestBehavior.AllowGet);
                }
            }
            else
            {
                res.IsSuccess = false;
                res.Message = "Invalid details";
                return Json(res, JsonRequestBehavior.AllowGet);
            }
        }

        [ViewAction]
        [HttpGet]
        [Route("GetFrequency", Name = "GetFrequency")]
        public ActionResult GetFrequency(int FrequecyID)
        {
            FrequencyRepo repact = new FrequencyRepo();
            Frequency mdlact = new Frequency();
            mdlact.FrequencyID = FrequecyID;
            mdlact.IsAct = false;
            mdlact.Name = "";
            Response res = new Response();
            try
            {
                DataTable dt = repact.GetFrequencyList(mdlact);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                res.IsSuccess = false;
                res.Message = ex.Message;
                return Json(res, JsonRequestBehavior.AllowGet);
            }
        }
        [ViewAction]
        [HttpGet]
        [Route("GetFrequencyHistory", Name = "GetFrequencyHistory")]
        public ActionResult GetFrequencyHistory(int FrequecyID)
        {
            FrequencyRepo repact = new FrequencyRepo();
            Frequency mdlact = new Frequency();
            mdlact.FrequencyID = FrequecyID;
            Response res = new Response();
            try
            {
                DataTable dt = repact.GetFrequencyHistory(mdlact);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                res.IsSuccess = false;
                res.Message = ex.Message;
                return Json(res, JsonRequestBehavior.AllowGet);
            }
        }
        [ViewAction]
        [HttpGet]
        [Route("DownloadAllMapppingFrequency", Name = "DownloadAllMapppingFrequency")]
        public ActionResult DownloadAllMapppingFrequency()
        {
            Response ret = new Response();
            try
            {
                FrequencyRepo repact = new FrequencyRepo();
                Frequency model = new Frequency();
                model.FrequencyID = 0;
                model.IsAct = false;
                DataTable dt = repact.DownLoadFrequency(model);
                DataTable dtFrequency = dt.DefaultView.ToTable(false, "FrequencyID", "Frequency", "IsActNm");

                dtFrequency.Columns["IsActNm"].ColumnName = "Status";
                string FileName = CSVUtills.DataTableToCSV(dtFrequency, ",");

                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "AllMappping.csv");
            }
            catch
            {
                throw;
            }
        }

        [ADDUpdateAction]
        [HttpGet]
        [Route("DownloadSampleFrequency", Name = "DownloadSampleFrequency")]
        public ActionResult DownloadSampleFrequency()
        {
            Response ret = new Response();
            try
            {
                string FileName = Server.MapPath("~/Docs/Sample/Frequency.csv");
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "SampleFrequency.csv");
            }
            catch
            {
                throw;
            }
        }
        [ADDUpdateAction]
        [HttpPost]
        [Route("UploadFrequency", Name = "UploadFrequency")]
        public ActionResult UploadFrequency(string FileName)
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
                FrequencyRepo repact = new FrequencyRepo();
                string FilePath = Server.MapPath("~/Docs/Temp/" + FileName);
                string SampleFileName = Server.MapPath("~/Docs/Sample/Frequency.csv");
                int SuccessCount = 0;
                int FailCount = 0;
                string ResultFileName = repact.UploadFrequency(FilePath, SampleFileName, ((User)Session["uBo"]).UID, ref SuccessCount, ref FailCount);
                if (ResultFileName == "Invalid File Format")
                {
                    ret.IsSuccess = false;
                    ret.Data = "";
                    ret.Message = "Invalid File Format";
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

    }
}