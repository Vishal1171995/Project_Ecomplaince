using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ecompliance.Areas.ACT2.ViewModel;
using Ecompliance.Utils;
using Ecompliance.Areas.Master.Models;
using Ecompliance.Repository;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.ActionFilters;
using Ecompliance.Areas.ACT2.Repository;
using Ecompliance.CustomAttribute;

namespace Ecompliance.Areas.ACT2.Controllers
{
    [RouteArea("ACT2")]
    [CustomAuthActionFilter(Order = 0)]
    [CustomAuthrizationActionFilter(Order = 1)]
    public class GenerateReportController : Controller
    {
        // GET: ACT2/GenerateReport
        [ViewAction]
        [Route("GenerateReport", Name = "RenderGenerateReportACT2")]
        public ActionResult GenerateReport()
        {
            try
            {
                GenerateReportVM ObjVM = new GenerateReportVM();
                //Populating Company list
                //Company objComp = new Company();
                //objComp.CompanyID = 0;
                //objComp.IsAct = true;
                //objComp.UID = ((User)Session["uBo"]).UID;
                //CompanyRepo objCompRepo = new CompanyRepo();
                //ObjVM.CompanyList = DropdownUtils.ToSelectList(objCompRepo.GetCompanyList(objComp), "CompID", "Name");
                //Populating Site List
                SiteRepo objSiteRepo = new SiteRepo();
                ObjVM.StateList = DropdownUtils.ToSelectList(objSiteRepo.GetState(0).Tables[0], "StateID", "Name");

                GenerateReportRepo ObjR = new GenerateReportRepo();
                ObjVM.PayDateList = DropdownUtils.ToSelectList(ObjR.GetPayDate(), "PayDate", "ShowPayDate");
                ObjVM.GroupList = new SelectList(new[]
                {
                    new {ID="0", Name="Single Page"},
                    new {ID="1", Name="Multiple Page"}

                },
                "ID", "Name", 1);
              
               
                return View(ObjVM);
                
            }
            catch
            {
                throw;
            }
        }

        [ViewAction]
        [HttpGet]
        [Route("GetCompanyByLocation", Name = "GetCompanyByLocation")]
        public ActionResult GetCompanyByLocation(int LocationID)
        {
            CompanyRepo objRepo = new CompanyRepo();
            Company objModel = new Company();
            Response ret = new Response();
            try
            {
                objModel.UID = ((User)Session["uBo"]).UID;
                ret.Data = JsonSerializer.SerializeTable(objRepo.GetCompanyByLocation(objModel,LocationID));
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
        [Route("GetSiteByCompany",Name = "GetSiteByCompany")]
        public ActionResult GetSiteByCompany(int StateID, int LocationID, int CompanyID)
        {
            SiteRepo objSite = new SiteRepo();
            Site objModel = new Site();
            Response re = new Response();
          
            try
            {
                objModel.UID = ((User)Session["uBo"]).UID;
                re.Data = JsonSerializer.SerializeTable(objSite.GetSiteByCompany(StateID,LocationID,CompanyID));
                re.IsSuccess = true;
                return Json(re, JsonRequestBehavior.AllowGet);
            }
            catch(Exception ex)
            {
                re.IsSuccess = false;
                re.Message = ex.Message;
                return Json(re, JsonRequestBehavior.AllowGet);
            }

        }
        
        [HttpPost]
        [ValidateAntiForgeryToken()]
        [ADDUpdateAction]
        [Route("GenerateReport", Name = "GenerateReportACT2")]
        public ActionResult GenerateReport(GenerateReportVM ObjVM)
        {
            Response ret = new Response();
            try
            {
                if (ModelState.IsValid)
                {
                   
                    ret.Data = "";
                    ret.IsSuccess = true;
                    User UBo = new Admin.Models.User();
                    UBo = (User)Session["uBo"];
                    GenerateReportRepo objReportRepo = new GenerateReportRepo();
                    ret.Message=   objReportRepo.GenerateReport(ObjVM, UBo);
                     
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    ret.Data = "Please fill all required fileds.";
                    ret.IsSuccess = false;
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
            }
            catch
            {
                throw;
            }
        }



        
    }
}