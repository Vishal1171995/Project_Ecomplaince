using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ecompliance.Areas.Master.Models;
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
    public class LocationController : Controller
    {
        // GET: Master/Location
        [ViewAction]
        [Route("Location", Name = "LocationView")]
        public ActionResult location()
        {
            StateRepo repact = new StateRepo();
            State stateModel = new State();
            Location locModel = new Location();
            try
            {
                stateModel.StateID = 0;
                stateModel.Name = "";
                stateModel.IsAct = true;
                stateModel.Geofence = "";
                stateModel.CountryID = 0;
                locModel.StateList = DropdownUtils.ToSelectList(repact.GetStateList(stateModel), "StateID", "Name");
                return View(locModel);
            }
            catch { return View(locModel); }
        }
        [HttpPost]
        [ValidateAntiForgeryToken()]
        [ADDUpdateAction]
        [Route("CreateLocation", Name = "CreateLocation")]
        public ActionResult CreateLocation(Location model)
        {
            LocationRepo repLoc = new LocationRepo();
            Response res = new Response();
            if (ModelState.IsValid)
            {
                try
                {
                    model.UID = ((User)Session["uBo"]).UID;
                    res = res.GetResponse("Location", model.LocationID.ToString(), Convert.ToInt32(repLoc.AddUpdateLocation(model)), "Location Name");
                    return Json(res);
                }
                catch
                {
                    res = res.GetResponse("Location", "", -2);
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
        [Route("GetLocation", Name = "GetLocation")]
        public ActionResult GetLocation(int LocationID)
        {
            LocationRepo objRepo = new LocationRepo();
            Location objModel = new Location();
            Response ret = new Response();
            try
            {
                objModel.LocationID = LocationID;
                objModel.IsAct = false;
                objModel.State = 0;
                objModel.Name = "";
                objModel.UID = ((User)Session["uBo"]).UID;
                ret.Data = JsonSerializer.SerializeTable(objRepo.GetLocation(objModel).Tables[0]);
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

        [ViewAction]
        [HttpGet]
        [Route("GetLocationHistory", Name = "GetLocationHistory")]
        public ActionResult GetLocationHistory(int LocationID)
        {
            LocationRepo obj = new LocationRepo();
            Location objModel = new Location();
            Response ret = new Response();
            try
            {
                objModel.LocationID = LocationID;
                ret.Data = JsonSerializer.SerializeTable(obj.GetLocationHistory(objModel).Tables[0]);
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
        [ViewAction]
        [HttpGet]
        [Route("DownloadAllLocation", Name = "DownloadAllLocation")]
        public ActionResult DownloadAllLocation()
        {
            Response ret = new Response();
            try
            {
                LocationRepo reploc = new LocationRepo();
                Location model = new Location();
                model.LocationID = 0;
                // model.Act = 0;
                model.IsAct = false;
                model.UID = ((User)Session["uBo"]).UID;
                DataTable dt = (reploc.GetLocation(model)).Tables[0];
                DataTable dtLocation = dt.DefaultView.ToTable(false, "LocationID", "Name","State", "IsActText");

                dtLocation.Columns["IsActText"].ColumnName = "Status";
                dtLocation.Columns["Name"].ColumnName = "Location";
                // string FileName= repact.DownLoadActivity(model);
                string FileName = CSVUtills.DataTableToCSV(dtLocation, ",");
                //  string FileName = repact.DownLoadCustomer(model);
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "LocationMaster.csv");
            }
            catch
            {
                throw;
            }
        }
        [ADDUpdateAction]
        [HttpGet]
        [Route("DownloadSampleLocation", Name = "DownloadSampleLocation")]
        public ActionResult DownloadSampleLocation()
        {
            Response ret = new Response();
            try
            {
                string FileName = Server.MapPath("~/Docs/Sample/Location.csv");
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "SampleLocation.csv");
            }
            catch
            {
                throw;
            }
        }

        [ValidateAntiForgeryToken]
        [ADDUpdateAction]
        [HttpPost]
        [Route("UploadLocation", Name = "UploadLocation")]
        public ActionResult UploadLocation(string FileName)
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

                LocationRepo repLocation = new LocationRepo();

                string FilePath = Server.MapPath("~/Docs/Temp/" + FileName);
                string SampleFileName = Server.MapPath("~/Docs/Sample/Location.csv");
                int SuccessCount = 0;
                int FailCount = 0;
                string ResultFileName = repLocation.ProcessMappingLocation(FilePath, SampleFileName, ((User)Session["uBo"]).UID, ref  SuccessCount, ref FailCount);
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