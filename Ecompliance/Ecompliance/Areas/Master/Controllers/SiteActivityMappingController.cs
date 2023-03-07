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
    public class SiteActivityMappingController : Controller
    {
        // GET: Master/SiteActivityMapping
        
        [ViewAction]
        [Route("ContractorMapping", Name = "ContractorMapping")]
        public ActionResult Mapping()
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
        [Route("GetSiteOfComp", Name = "GetSiteOfComp")]
        public ActionResult GetSiteOfComp(string  CompID)
        {
            Response ret = new Response();
            try
            {
                DataSet ds = new DataSet();
                Site ObjMSite = new Site();
                ObjMSite.IsAct = true;
                ObjMSite.Company = CompID;
                ObjMSite.UID = ((User)Session["Ubo"]).UID;
                SiteRepo ObjSRep = new SiteRepo();
                string jsonData = JsonSerializer.SerializeTable(ObjSRep.GetSite(ObjMSite).Tables[0]); //ds.Tables[0], Newtonsoft.Json.Formatting.None, serializerSettings);
                ret.IsSuccess = true;
                ret.Message = "";
                ret.Data = jsonData;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch { throw; }
        }

        [SkipAuthrization]
        [HttpGet]
        [Route("GetContractorOfComp", Name = "GetContractorOfComp")]
        public ActionResult GetContractorOfComp(string CompID)
        {
            Response ret = new Response();
            try
            {
                DataSet ds = new DataSet();
                Contractor ObjContractor = new Contractor();
                ObjContractor.IsAct = true;
                ObjContractor.Company = Convert.ToInt32( CompID);
                ObjContractor.UID = ((User)Session["Ubo"]).UID;
                ContractorRepo ObjContRep = new ContractorRepo();
                string jsonData = JsonSerializer.SerializeTable(ObjContRep.GetContractor(ObjContractor).Tables[0]);
                ret.IsSuccess = true;
                ret.Message = "";
                ret.Data = jsonData;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch { throw; }
        }

        [ViewAction]
        [HttpGet]
        [Route("GetMapppingCount", Name = "GetMapppingCount")]
        public ActionResult GetMapppingCount(string CompIDS,string sitesIDs,string ActIds,string ContractorIds)
        {
            Response ret = new Response();
            try
            {
                DataSet ds = new DataSet();
                SiteActivityMappingRep ObjSRep = new SiteActivityMappingRep();
                ds = ObjSRep.GetMappingCount(sitesIDs, ActIds, ContractorIds); //ds.Tables[0], Newtonsoft.Json.Formatting.None, serializerSettings);
                int TotalTask = Convert.ToInt32(ds.Tables[0].Rows[0]["Count"]);
                int TotalContracotrActive = Convert.ToInt32(ds.Tables[1].Rows[0]["Count"]);
              //  int TotalPEActive = Convert.ToInt32(ds.Tables[2].Rows[0]["Count"]);
                int TotalContracotrInActive = Convert.ToInt32(ds.Tables[3].Rows[0]["Count"]);
               // int TotalPEInActive = Convert.ToInt32(ds.Tables[4].Rows[0]["Count"]);
                int Total = TotalTask;
                int TotalActiveScheduled = TotalContracotrActive; //+ TotalPEActive;
                int TotalInActiveScheduled = TotalContracotrInActive;// +TotalPEInActive;
                int TotalUnScheduled = TotalTask - TotalActiveScheduled- TotalInActiveScheduled;
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
        [Route("DownloadAllMappping", Name = "DownloadAllMappping")]
        public ActionResult DownloadAllMappping(string CompIDS, string sitesIDs, string ActIds, string ContractorIds)
        {
            Response ret = new Response();
            try
            {
                SiteActivityMappingRep ObjSRep = new SiteActivityMappingRep();
                string FileName = ObjSRep.DownloadAllMapping(sitesIDs, ActIds, ContractorIds);
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
        [Route("DownloadAllScheduled", Name = "DownloadAllScheduled")]
        public ActionResult DownloadAllScheduled(string CompIDS, string sitesIDs, string ActIds, string ContractorIds)
        {
            Response ret = new Response();
            try
            {
                SiteActivityMappingRep ObjSRep = new SiteActivityMappingRep();
                string FileName = ObjSRep.DownloadAllScheduled(sitesIDs, ActIds, ContractorIds);
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
        [Route("DownloadAllUnScheduled", Name = "DownloadAllUnScheduled")]
        public ActionResult DownloadAllUnScheduled(string CompIDS, string sitesIDs, string ActIds, string ContractorIds)
        {
            Response ret = new Response();
            try
            {
                SiteActivityMappingRep ObjSRep = new SiteActivityMappingRep();
                string FileName = ObjSRep.DownloadAllUnScheduled(sitesIDs, ActIds, ContractorIds);
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
        [Route("DownLoadResultFile", Name = "DownLoadResultFile")]
        public ActionResult DownLoadResultFile(string FileName)
        {
            Response ret = new Response();
            try
            {
                SiteActivityMappingRep ObjSRep = new SiteActivityMappingRep();
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
        [Route("DownloadAllInActive", Name = "DownloadAllInActive")]
        public ActionResult DownloadAllInActive(string CompIDS, string sitesIDs, string ActIds, string ContractorIds)
        {
            Response ret = new Response();
            try
            {
                SiteActivityMappingRep ObjSRep = new SiteActivityMappingRep();
                string FileName = ObjSRep.DownloadAllInActive(sitesIDs, ActIds, ContractorIds);
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
        [Route("UploadMapping", Name = "UploadMapping")]
        public ActionResult UploadMapping(string fileName,int CompID)
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
                SiteActivityMappingRep ObjSRep = new SiteActivityMappingRep();
                string FilePath = Server.MapPath("~/Docs/Temp/" + fileName);
                int SuccessCount = 0;
                int FailCount = 0;
                string ResultFileName = ObjSRep.ProcessMapping(FilePath, ((User)Session["Ubo"]).UID, CompID, ref SuccessCount, ref FailCount);
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
                    ret.IsSuccess = true;
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