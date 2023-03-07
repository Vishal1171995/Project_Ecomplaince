using Ecompliance.ActionFilters;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.Areas.Master.Models;
using Ecompliance.CustomAttribute;
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
    [CustomAuthActionFilter(Order=0)]
    [CustomAuthrizationActionFilter(Order=1)]
    [RouteArea("Master")]
    public class StateController : Controller
    {
        // GET: Master/State
        [ViewAction]
        [Route("State", Name = "StateView")]
        public ActionResult StateView()
        {
            StateRepo repact = new StateRepo();
            State mdlact = new State();
            mdlact.CountyList = DropdownUtils.ToSelectList(repact.GetCountry(mdlact).Tables[0], "CountryID", "Name");
            return View(mdlact);
        }

        [HttpPost]
        [ValidateAntiForgeryToken()]
        [ADDUpdateAction]
        [Route("CreateState", Name = "CreateState")]
        public ActionResult CreateState(State model)
        {
            StateRepo repact = new StateRepo();
            Response res = new Response();
            if (ModelState.IsValid)
            {
                try
                {
                    model.CreatedBy = ((User)Session["uBo"]).UID;
                    res = res.GetResponse("State", model.StateID.ToString(), Convert.ToInt32(repact.CreateUpdateState(model)), "State Name");
                    return Json(res);
                }
                catch
                {
                    res = res.GetResponse("State", "", -2);
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
        [Route("GetState", Name = "GetState")]
        public ActionResult GetState(int StateID)
        {
            StateRepo repact = new StateRepo();
            State mdlact = new State();
            mdlact.StateID = StateID;
            mdlact.IsAct = false;
            mdlact.Name = "";
            mdlact.CountyList= DropdownUtils.ToSelectList(repact.GetCountry(mdlact).Tables[0], "CountryID", "Name");
            Response res = new Response();
            try
            {
                DataTable dt = repact.GetStateList(mdlact);
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
        [Route("DownloadAllMapppingState", Name = "DownloadAllMapppingState")]
        public ActionResult DownloadAllMapppingState()
        {
            Response ret = new Response();
            try
            {
                StateRepo repact = new StateRepo();
                State model = new State();
                model.StateID = 0;
                model.IsAct = false;

                DataTable dt = repact.DownLoadState(model);
                DataTable dtState = dt.DefaultView.ToTable(false, "StateID", "CountryNm", "Name", "Geofence", "IsActNm");
                dtState.Columns["CountryNm"].ColumnName = "Country";
                dtState.Columns["IsActNm"].ColumnName = "Status";

                string FileName = CSVUtills.DataTableToCSV(dtState, ",");
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "StateMaster.csv");
            }
            catch
            {
                throw;
            }
        }


        [ADDUpdateAction]
        [HttpGet]
        [Route("DownloadSampleState", Name = "DownloadSampleState")]
        public ActionResult DownloadSampleFrequency()
        {
            Response ret = new Response();
            try
            {
                string FileName = Server.MapPath("~/Docs/Sample/State.csv");
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "SampleState.csv");
            }
            catch
            {
                throw;
            }
        }
        [ADDUpdateAction]
        [ValidateAntiForgeryToken]
        [HttpPost]
        [Route("UploadState", Name = "UploadState")]
        public ActionResult UploadState(string FileName)
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

                StateRepo repact = new StateRepo();

                string FilePath = Server.MapPath("~/Docs/Temp/" + FileName);
                string SampleFileName = Server.MapPath("~/Docs/Sample/State.csv");
                int SuccessCount = 0;
                int FailCount = 0;
                string ResultFileName = repact.ProcessMappingState(FilePath, SampleFileName, ((User)Session["uBo"]).UID, ref SuccessCount, ref FailCount);
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
        [ViewAction]
        [HttpGet]
        [Route("GetStateHistory", Name = "GetStateHistory")]
        public ActionResult GetStateHistory(int StateID)
        {
            StateRepo repact = new StateRepo();
            State mdlact = new State();
            mdlact.StateID = StateID;
            Response res = new Response();
            try
            {
                DataTable dt = repact.GetStateHistory(mdlact);
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
    }
}