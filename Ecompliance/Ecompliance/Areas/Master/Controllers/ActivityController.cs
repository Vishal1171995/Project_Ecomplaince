using Ecompliance.Areas.Master.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ecompliance.Repository;
using Ecompliance.Utils;
using System.Data;
using Ecompliance.ActionFilters;
using Ecompliance.CustomAttribute;
using Ecompliance.Areas.Admin.Models;

namespace Ecompliance.Areas.Master.Controllers
{
    [CustomAuthActionFilter(Order = 0)]
    [CustomAuthrizationActionFilter(Order = 1)]
    [RouteArea("Master")]
    public class ActivityController : Controller
    {
        [ViewAction]
        [Route("NewActivity", Name = "NewActivityView")]
        public ActionResult NewActivity()
        {
            Activity Model = new Activity();
            ActRepo ActRep = new ActRepo();
            ActivityRepo ActivityRep = new ActivityRepo();
            Frequency FrequencyModel = new Frequency();
            FrequencyModel.IsAct = true;
            FrequencyRepo frequencyRep = new FrequencyRepo();
            Act ActMdl = new Act();
            ActMdl.IsAct = true;
            try
            {            
                Model.ActList = DropdownUtils.ToSelectList(ActRep.GetActList(ActMdl), "ActID", "Short_Name");
                Model.FrequencyList = DropdownUtils.ToSelectList(frequencyRep.GetFrequencyList(FrequencyModel), "FrequencyID", "Frequency");
                ViewBag.Year = DropdownUtils.ToSelectList(ActRepo.GetYear(), "Year", "Year");
                return View(Model);
            }
            catch
            {
                return View(Model);
            }
        }
        [ViewAction]
        [Route("Activity", Name = "ActivityView")]
        public ActionResult Activity()
        {
            Activity Model = new Activity();
            ActRepo ActRep = new ActRepo();
            ActivityRepo ActivityRep = new ActivityRepo();
            Frequency FrequencyModel = new Frequency();
            FrequencyModel.IsAct = true;
            FrequencyRepo frequencyRep = new FrequencyRepo();
            Act ActMdl = new Act();
            ActMdl.IsAct = true;
            try
            {
                Model.ActList = DropdownUtils.ToSelectList(ActRep.GetActList(ActMdl), "ActID", "Short_Name");
                Model.FrequencyList = DropdownUtils.ToSelectList(frequencyRep.GetFrequencyList(FrequencyModel), "FrequencyID", "Frequency");
                ViewBag.Ds = ActRep.GetActList(ActMdl); //ActivityRep.GetActivitySnapShot();
                ViewBag.Year = DropdownUtils.ToSelectList(ActRepo.GetYear(), "Year", "Year");
                return View(Model);
            }
            catch
            {
                return View(Model);
            }
        }
        [ViewAction]
        [HttpGet]
        [Route("GetActivity", Name = "GetActivity")]
        public ActionResult GetActivity(int ActivityID, int ActID)
        {
            ActivityRepo repactivity = new ActivityRepo();
            Activity mdlactivity = new Activity();
            mdlactivity.ActivityID = ActivityID;
            mdlactivity.Act = ActID;
            mdlactivity.Name = "";
            mdlactivity.IsAct = false;
            mdlactivity.CreatedBy = 3;
            Response res = new Response();
            try
            {
                DataTable dt = repactivity.GetActivityList(mdlactivity);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                res = res.GetResponse("Activity", "", -2);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
        }
        [ViewAction]
        [HttpGet]
        [Route("GetActivityHistory", Name = "GetActivityHistory")]
        public ActionResult GetActivityHistory(int ActivityID)
        {
            ActivityRepo repactivity = new ActivityRepo();
            Activity mdlactivity = new Activity();
            mdlactivity.ActivityID = ActivityID;
            Response res = new Response();
            try
            {
                DataTable dt = repactivity.GetActivityHistory(mdlactivity);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                res = res.GetResponse("Activity", "", -2);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
        }
        [ValidateAntiForgeryToken]
        [ADDUpdateAction]
        [HttpPost]
        [Route("CreateActivity", Name = "CreateActivity")]
        public ActionResult CreateActivity(Activity model)
        {
            ActivityRepo repactivity = new ActivityRepo();
            Response res = new Response();
            try
            {
                if (ModelState.IsValid)
                {
                    model.CreatedBy = ((User)Session["uBo"]).UID;
                    res = res.GetResponse("Activity", model.ActivityID.ToString(), Convert.ToInt32(repactivity.CreateUpdateActivity(model)), "Activity Name");
                    return Json(res);
                }
                else
                {
                    res = res.GetResponse("Activity", "", -2);
                    return Json(res, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                res = res.GetResponse("Activity", "", -2);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
        }
        [ViewAction]
        [HttpGet]
        [Route("GetScheduledDates", Name = "GetScheduledDates")]
        public ActionResult GetScheduledDates(int Frequency, int RemindDays,string StartDate)
        {
            ActivityRepo repactivity = new ActivityRepo();
            string [] strdate = StartDate.Split('/');
            DateTime sDate = new DateTime(Convert.ToInt32( strdate[2]),Convert.ToInt32(strdate[1]),Convert.ToInt32(strdate[0]));
            Response res = new Response();
            try
            {
                DataTable dt = repactivity.GetScheduledDates(Frequency,RemindDays,sDate);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                res = res.GetResponse("Activity", "", -2);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
        }
        [ViewAction]
        [HttpGet]
        [Route("DownloadAllMapppingActivity", Name = "DownloadAllMapppingActivity")]
        public ActionResult DownloadAllMapppingActivity(string ActID)
        {
            Response ret = new Response();
            try
            {
                ActivityRepo repact = new ActivityRepo();
                Activity model = new Activity();
                model.ActivityID = 0;
                model.Act = Convert.ToInt32(ActID);
                model.IsAct = false;
                DataTable dt = repact.GetActivityList(model);
                DataTable dtActivity = dt.DefaultView.ToTable(false, "ActivityID", "Name", "Activity_Desc", "ActNm", "FrequencyNm", "StartDate", "RemindDays", "Status", "Extendable_Exp_Date_exp");
                dtActivity.Columns["FrequencyNm"].ColumnName = "Frequency";
                dtActivity.Columns["Name"].ColumnName = "Activity";
                dtActivity.Columns["Activity_Desc"].ColumnName = "Description";
                dtActivity.Columns["ActNm"].ColumnName = "Act";
                dtActivity.Columns["Status"].ColumnName = "Status";
                dtActivity.Columns["Extendable_Exp_Date_exp"].ColumnName = "Extendable Exp Date";

                string FileName = CSVUtills.DataTableToCSV(dtActivity, ",");
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "ActivityMaster.csv");
            }
            catch
            {
                throw;
            }
        }

        [ADDUpdateAction]
        [HttpGet]
        [Route("DownloadSampleActivity", Name = "DownloadSampleActivity")]
        public ActionResult DownloadSampleActivity()
        {
            Response ret = new Response();
            try
            {
                string FileName = Server.MapPath("~/Docs/Sample/Activity.csv");
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "SampleActivity.csv");
            }
            catch
            {
                throw;
            }
        }
        [ADDUpdateAction]
        [ValidateAntiForgeryToken]
        [HttpPost]
        [Route("UploadActivity", Name = "UploadActivity")]
        public ActionResult UploadActivity(string FileName)
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
                ActivityRepo repactivity = new ActivityRepo();
                string FilePath = Server.MapPath("~/Docs/Temp/" + FileName);
                string SampleFileName = Server.MapPath("~/Docs/Sample/Activity.csv");
                int SuccessCount = 0;
                int FailCount = 0;
                string ResultFileName = repactivity.UploadActivity(FilePath, SampleFileName, ((User)Session["uBo"]).UID, ref  SuccessCount, ref FailCount);
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
    }
}