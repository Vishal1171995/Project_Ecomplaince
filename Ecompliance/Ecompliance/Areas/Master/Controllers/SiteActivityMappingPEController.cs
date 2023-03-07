using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ecompliance.Utils;
using Ecompliance.Repository;
using Ecompliance.Areas.Master.Models;
using System.Data;
using Ecompliance.ActionFilters;
using Ecompliance.CustomAttribute;
using Ecompliance.Areas.Admin.Models;
namespace Ecompliance.Areas.Master.Controllers
{
    [CustomAuthActionFilter(Order = 0)]
    [CustomAuthrizationActionFilter(Order = 1)]
    [RouteArea("Master")]
    public class SiteActivityMappingPEController : Controller
    {
         [ViewAction]
        [Route("PEMapping", Name = "PEMapping")]
        public ActionResult MappingPE()
        {
            try
            {
                Company ObjComp = new Company();
                ObjComp.CompanyID = 0;
                ObjComp.IsAct = true;
                ObjComp.UID = ((User)Session["Ubo"]).UID;
                CompanyRepo ObjCompRep = new CompanyRepo();
                ViewBag.CompList = DropdownUtils.ToSelectList(ObjCompRep.GetCompanyList(ObjComp), "CompID", "Name");

                Act ObjAct = new Act();
                ObjAct.ActID = 0;
                ObjAct.IsAct = true;
                ActRepo ObjActRepo = new ActRepo();
                ViewBag.ActList = DropdownUtils.ToMultiSelectList(ObjActRepo.GetActList(ObjAct), "ActID", "Short_Name");

                return View();
            }
            catch
            {
                throw;
            }
        }

        [SkipAuthrization]
        [HttpGet]
        [Route("GetSiteOfCompPE", Name = "GetSiteOfCompPE")]
        public ActionResult GetSiteOfCompPE(string CompID)
        {
            Response ret = new Response();
            try
            {
                DataSet ds = new DataSet();
                Site ObjMSite = new Site();
                ObjMSite.IsAct = true;
                ObjMSite.Company = CompID;
                ObjMSite.UID=((User)Session["uBo"]).UID;
                SiteRepo ObjSRep = new SiteRepo();
                string jsonData = JsonSerializer.SerializeTable(ObjSRep.GetSite(ObjMSite).Tables[0]); //ds.Tables[0], Newtonsoft.Json.Formatting.None, serializerSettings);
                ret.IsSuccess = true;
                ret.Message = "";
                ret.Data = jsonData;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch { throw; }
        }

        [ADDUpdateAction]
        [HttpPost]
        [Route("GetMapppingCountPE", Name = "GetMapppingCountPE")]
        public ActionResult GetMapppingCountPE(string CompIDS, string sitesIDs, string ActIds)
        {
            Response ret = new Response();
            try
            {
                DataSet ds = new DataSet();
                SiteActivityMappingPERep ObjSRep = new SiteActivityMappingPERep();
                ds = ObjSRep.GetMappingCount(sitesIDs, ActIds);
                int TotalTask = Convert.ToInt32(ds.Tables[5].Rows[0]["Count"]);
                int TotalPEActive = Convert.ToInt32(ds.Tables[2].Rows[0]["Count"]);
                int TotalPEInActive = Convert.ToInt32(ds.Tables[4].Rows[0]["Count"]);
                int Total = TotalTask;
                int TotalActiveScheduled = TotalPEActive;
                int TotalInActiveScheduled = TotalPEInActive;
                int TotalUnScheduled = TotalTask - TotalActiveScheduled - TotalInActiveScheduled;
                string Data = Total + "," + TotalActiveScheduled + "," + TotalUnScheduled + "," + TotalInActiveScheduled;
                ret = ret.GetResponse("Mapping", "GetMapping", -1000, "", Data);
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                ret = ret.GetResponse("Mapping", "", -2);
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
        }

        [ViewAction]
        [HttpGet]
        [Route("DownloadAllMapppingPE", Name = "DownloadAllMapppingPE")]
        public ActionResult DownloadAllMapppingPE(string CompIDS, string sitesIDs, string ActIds)
        {
            Response ret = new Response();
            try
            {
                SiteActivityMappingPERep ObjSRep = new SiteActivityMappingPERep();
                string FileName = ObjSRep.DownloadAllMapping(sitesIDs, ActIds);
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "AllMappping.csv");
            }
            catch
            {
                throw;
            }
        }

        [ViewAction]
        [HttpGet]
        [Route("DownloadAllScheduledPE", Name = "DownloadAllScheduledPE")]
        public ActionResult DownloadAllScheduledPE(string CompIDS, string sitesIDs, string ActIds)
        {
            Response ret = new Response();
            try
            {
                SiteActivityMappingPERep ObjSRep = new SiteActivityMappingPERep();
                string FileName = ObjSRep.DownloadAllScheduled(sitesIDs, ActIds);
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "AllActiveScheduled.csv");
            }
            catch
            {
                throw;
            }
        }

          [ViewAction]
          [HttpGet]
        [Route("DownloadAllUnScheduledPE", Name = "DownloadAllUnScheduledPE")]
        public ActionResult DownloadAllUnScheduledPE(string CompIDS, string sitesIDs, string ActIds)
        {
            Response ret = new Response();
            try
            {
                SiteActivityMappingPERep ObjSRep = new SiteActivityMappingPERep();
                string FileName = ObjSRep.DownloadAllUnScheduled(sitesIDs, ActIds);
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "AllUnScheduled.csv");
            }
            catch
            {
                throw;
            }
        }


         [ViewAction]
         [HttpGet]
        [Route("DownLoadResultFilePE", Name = "DownLoadResultFilePE")]
        public ActionResult DownLoadResultFilePE(string FileName)
        {
            Response ret = new Response();
            try
            {
                SiteActivityMappingPERep ObjSRep = new SiteActivityMappingPERep();

                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "ResultFile.csv");
            }
            catch
            {
                throw;
            }
        }

          [ViewAction]
          [HttpGet]
        [Route("DownloadAllInActivePE", Name = "DownloadAllInActivePE")]
        public ActionResult DownloadAllInActivePE(string CompIDS, string sitesIDs, string ActIds)
        {
            Response ret = new Response();
            try
            {
                SiteActivityMappingPERep ObjSRep = new SiteActivityMappingPERep();
                string FileName = ObjSRep.DownloadAllInActive(sitesIDs, ActIds);
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "AllInActiveScheduled.csv");
            }
            catch
            {
                throw;
            }
        }


         [ADDUpdateAction]
         [ValidateAntiForgeryToken]
         [HttpPost]
        [Route("UploadMappingPE", Name = "UploadMappingPE")]
        public ActionResult UploadMappingPE(string fileName, int CompID)
        {
            Response ret = new Response();
            try
            {
                string[] arr = fileName.Split('.');
                
                if (arr[1].ToString().ToUpper() != "CSV")
                {
                    ret = ret.GetResponse("Mapping", "Upload", -2000, "", "", "Invalid file type.");
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
                if (CompID <= 0)
                {
                    ret = ret.GetResponse("Mapping", "Upload", -2000, "", "", "Company required.");
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
                SiteActivityMappingPERep ObjSRep = new SiteActivityMappingPERep();
                string FilePath = Server.MapPath("~/Docs/Temp/" + fileName);
                int SuccessCount = 0;
                int FailCount = 0;
                string ResultFileName = ObjSRep.ProcessMapping(FilePath, ((User)Session["uBo"]).UID, CompID, ref SuccessCount, ref FailCount);
                if (ResultFileName == "Invalid File Format")
                {
                    ret.IsSuccess = false;
                    ret.Data = "";
                    ret.Message = "Invalid File Format";
                }
                else if (ResultFileName == "Please remove all the comma from your file.")
                {
                    ret = ret.GetResponse("Mapping", "", -2);
                    ret.Message = "Please remove all the commas from your file.";
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    //DataTable dt = CSVUtills.CSVToDataTable(FilePath, ',');
                    string data = "{\"Success\":\"" + SuccessCount + "\",\"Failed\":\"" + FailCount + "\",\"FileName\":\"" + ResultFileName.Replace("\\", "\\\\") + "\"}";
                    ret = ret.GetResponse("Mapping", "GetMapping", -1000, "", data, "");
                }

                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                ret = ret.GetResponse("Mapping", "", -2);
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
        }
    }
}