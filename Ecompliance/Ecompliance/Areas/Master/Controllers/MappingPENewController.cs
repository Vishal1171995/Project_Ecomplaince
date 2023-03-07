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
    [CustomAuthActionFilter(Order = 0)]
    [CustomAuthrizationActionFilter(Order = 1)]
    [RouteArea("Master")]
    public class MappingPENewController : Controller
    {
        [ViewAction]
        [Route("PEMappingNew", Name = "PEMappingNew")]
        public ActionResult MappingPENew()
        {
            try
           {
                Company ObjComp = new Company();
                ObjComp.CompanyID = 0;
                ObjComp.IsAct = true;
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
        [Route("GetSiteOfCompPENew", Name = "GetSiteOfCompPENew")]
        public ActionResult GetSiteOfCompPENew(string CompID)
        {
            Response ret = new Response();
            try
            {
                DataSet ds = new DataSet();
                Site ObjMSite = new Site();
                ObjMSite.IsAct = true;
                ObjMSite.Company = CompID;
                ObjMSite.UID = ((User)Session["uBo"]).UID;
                SiteRepo ObjSRep = new SiteRepo();
                string jsonData = JsonSerializer.SerializeTable(ObjSRep.GetSite(ObjMSite).Tables[0]); //ds.Tables[0], Newtonsoft.Json.Formatting.None, serializerSettings);
                ret.IsSuccess = true;
                ret.Message = "";
                ret.Data = jsonData;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch { throw; }
        }


        [ViewAction]
        [Route("GetMapppingPENew", Name = "GetMapppingPENew")]
        public ActionResult GetMapppingPENew( string sitesIDs, string ActIds)
        {
            Response ret = new Response();
            try
            {
                DataTable dt = new DataTable();
                SiteActivityMappingPERep ObjSRep = new SiteActivityMappingPERep();
                 
                string jsonData = JsonSerializer.SerializeObject(ObjSRep.GetMappingNew(sitesIDs, ActIds)); //ds.Tables[0], Newtonsoft.Json.Formatting.None, serializerSettings);
                ret.IsSuccess = true;
                ret.Message = "";
                ret.Data = jsonData;
                return Json(ret, JsonRequestBehavior.AllowGet);
               
            }
            catch
            {
                ret = ret.GetResponse("Mapping", "", -2);
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
        }


        [ADDUpdateAction]
        [Route("UploadMappingPENew", Name = "UploadMappingPENew")]
        public ActionResult UploadMappingPENew(int CompID, string Act, string Activity, string StartDate, string RemindDays, string Site)
        {
            Response ret = new Response();
            try
            {
             
                if (CompID <= 0)
                {
                    ret = ret.GetResponse("Mapping", "Upload", -2000, "", "", "Company required.");
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
                SiteActivityMappingPERep ObjSRep = new SiteActivityMappingPERep();
              
                string ResultFileName = ObjSRep.ProcessMappingNew(CompID, ((User)Session["uBo"]).UID,Act,Activity,StartDate,RemindDays,Site);
                if (ResultFileName == "Success")
                {
                    ret = ret.GetResponse("Mapping", "GetMapping", -1000, "", "Success", "");
                }
                else if (ResultFileName == "Duplicate")
                {
                    ret.IsSuccess = true;
                    ret.Data = "";
                    ret.Message = "Duplicate";
                }
                else if (ResultFileName == "Failed")
                {                                  
                    ret.IsSuccess = false;
                    ret.Data = "";
                    ret.Message = "Failed";
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