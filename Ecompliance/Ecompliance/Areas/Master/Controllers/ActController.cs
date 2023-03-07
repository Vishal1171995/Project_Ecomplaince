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
using Ecompliance.CustomAttribute;
using Ecompliance.Areas.Admin.Models;

namespace Ecompliance.Areas.Master.Controllers
{
    [CustomAuthActionFilter(Order = 0)]
    [CustomAuthrizationActionFilter(Order = 1)]
    [RouteArea("Master")]
    public class ActController : Controller
    {
        [ViewAction]
        [Route("Acts", Name = "ActView")]
        public ActionResult ActView()
        {
            try
            {
                return View();
            }
            catch
            {
                throw;
            }
        }
        [ADDUpdateAction]
        [ValidateAntiForgeryToken]
        [HttpPost]
        [Route("CreateAct", Name = "CreateAct")]
        public ActionResult CreateAct(Act model)
        {
            ActRepo repact = new ActRepo();
            Response res = new Response();
            try
            {
                if (ModelState.IsValid)
                {
                    model.CreatedBy= ((User)Session["uBo"]).UID;
                    res = res.GetResponse("Act", model.ActID.ToString(), Convert.ToInt32(repact.CreateUpdateAct(model)), "Act Name ");
                    return Json(res);
                }
                else
                { return View(); }
            }
            catch 
            {
                res = res.GetResponse("Act", "", -2);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
        }
        [ViewAction]
        [HttpGet]
        [Route("GetAct", Name = "GetAct")]
        public ActionResult GetAct(int ActID)
        {
            ActRepo repact = new ActRepo();
            Act mdlact = new Act();
            mdlact.ActID = ActID;
            mdlact.IsAct = false;
            mdlact.Short_Name ="";
            Response res = new Response();
            try
            {              
                DataTable dt = repact.GetActList(mdlact);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch(Exception ex)
            {
                res.IsSuccess = false;
                res.Message = ex.Message;
                return Json(res, JsonRequestBehavior.AllowGet);
            }
        }
        [ViewAction]
        [HttpGet]
        [Route("GetActHistory", Name = "GetActHistory")]
        public ActionResult GetActHistory(int ActID)
        {
            ActRepo repact = new ActRepo();
            Act mdlact = new Act();
            mdlact.ActID = ActID;
            Response res = new Response();
            try
            {
                DataTable dt = repact.GetActHistory(mdlact);
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
        [Route("DownloadAllMapppingAct", Name = "DownloadAllMapppingAct")]
        public ActionResult DownloadAllMapppingAct()
        {
            Response ret = new Response();
            try
            {
                ActRepo repact = new ActRepo();
                Act model = new Act();
                model.ActID = 0;
                model.IsAct = false;
                DataTable dt = repact.GetActList(model);
                DataTable dtAct = dt.DefaultView.ToTable(false, "ActID", "Full_Name", "Short_Name", "IsActNm");

                dtAct.Columns["IsActNm"].ColumnName = "Status";

                string FileName = CSVUtills.DataTableToCSV(dtAct, ",");
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "ActMaster.csv");
            }
            catch
            {
                throw;
            }
        }

        [ADDUpdateAction]
        [HttpGet]
        [Route("DownloadSampleAct", Name = "DownloadSampleAct")]
        public ActionResult DownloadSampleAct()
        {
            Response ret = new Response();
            try
            {
                string FileName = Server.MapPath("~/Docs/Sample/Act.csv");
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "SampleAct.csv");
            }
            catch
            {
                throw;
            }
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        [ADDUpdateAction]
        [Route("UploadAct", Name = "UploadAct")]
        public ActionResult UploadAct(string FileName)
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
                ActRepo repact = new ActRepo();
                string FilePath = Server.MapPath("~/Docs/Temp/" + FileName);
                string SampleFileName = Server.MapPath("~/Docs/Sample/Act.csv");
                int SuccessCount = 0;
                int FailCount = 0;
                string ResultFileName = repact.UploadAct(FilePath, SampleFileName, ((User)Session["uBo"]).UID, ref  SuccessCount, ref FailCount);
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
                    ret = ret.GetResponse("Act", "ActUpload", -1000, "", data, "");
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