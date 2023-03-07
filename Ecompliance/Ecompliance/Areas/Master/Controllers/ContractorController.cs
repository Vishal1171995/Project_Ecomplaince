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
    public class ContractorController : Controller
    {
        // GET: Master/Contractor
        [Route("contractors", Name = "ViewContractor")]
        [ViewAction]
        public ActionResult Contractors()
        {
            Contractor Model = new Contractor();
            Model.UID = ((User)Session["uBo"]).UID;

            Company objComp = new Company();
            CompanyRepo objCompRepo = new CompanyRepo();
            ContractorRepo objContRepo = new ContractorRepo();
            try
            {
                objComp.CompanyID = 0;
                objComp.IsAct = true;
                objComp.UID = ((User)Session["uBo"]).UID;
                Model.CompanyList = DropdownUtils.ToSelectList(objCompRepo.GetCompanyList(objComp), "CompID", "Name");
                ViewBag.Ds = objCompRepo.GetCompanyList(objComp);//objContRepo.GetContractorSnapShot();
                return View(Model);
            }
            catch { throw; }
        }

        [HttpPost]
        [ValidateAntiForgeryToken()]
        [ADDUpdateAction]
        [Route("CreateContractor", Name = "CreateContractor")]
        public ActionResult CreateContractor(Contractor ContM)
        {
            ContractorRepo obj = new ContractorRepo();
            Response ret = new Response();
            ModelState.Remove("CompanyText");
            if (ModelState.IsValid)
            {
                try
                {
                    ContM.CreatedBy = ((User)Session["uBo"]).UID;
                    ret = ret.GetResponse("Contractor", ContM.ContractorID.ToString(), Convert.ToInt32(obj.AddUpdateContractor(ContM)), "Contractor Name");
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
                catch
                {
                    ret = ret.GetResponse("Contractor", "", -2);
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
            }
            else
            {
                return View(ContM);
            }

        }
        [ViewAction]
        [HttpGet]
        [Route("GetContractor", Name = "GetContractor")]
        public ActionResult GetContractor(string ContractorID,int CompID)
        {
            ContractorRepo obj = new ContractorRepo();
            Contractor objModel = new Contractor();
            Response ret = new Response();
            try
            {
                objModel.ContractorID = Convert.ToInt32(ContractorID);
                objModel.Name = "";
                objModel.IsAct = false;
                objModel.Company = CompID;
                objModel.UID = ((User)Session["uBo"]).UID;

                ret.Data = JsonSerializer.SerializeTable(obj.GetContractor(objModel).Tables[0]);
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
        [Route("GetContractorHistory", Name = "GetContractorHistory")]
        public ActionResult GetContractorHistory(string ContractorID)
        {
            ContractorRepo obj = new ContractorRepo();
            Contractor objModel = new Contractor();
            Response ret = new Response();
            try
            {
                objModel.ContractorID = Convert.ToInt32(ContractorID);                
                ret.Data = JsonSerializer.SerializeTable(obj.GetContractorHistory(objModel).Tables[0]);
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
        [Route("DownloadAllMapppingContractor", Name = "DownloadAllMapppingContractor")]
        public ActionResult DownloadAllMapppingContractor(string CompID)
        {
            Response ret = new Response();
            try
            {
                ContractorRepo repact = new ContractorRepo();
                Contractor model = new Contractor();
                model.ContractorID = 0;
                model.IsAct = false;
                model.Company = Convert.ToInt32(CompID);
                model.UID = ((User)Session["uBo"]).UID;
                DataTable dt = (repact.GetContractor(model)).Tables[0];
                DataTable dtContractor = dt.DefaultView.ToTable(false, "ContractorID", "Name", "Address", "Contact_Person", "Contact_Number", "Email", "PF_Code", "ESI_Code", "IsActText");
                dtContractor.Columns["Name"].ColumnName = "Contractor";
                dtContractor.Columns["IsActText"].ColumnName = "Status";


                string FileName = CSVUtills.DataTableToCSV(dtContractor, ",");
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "ContractorMaster.csv");
            }
            catch
            {
                throw;
            }
        }

        [ADDUpdateAction]
        [HttpGet]
        [Route("DownloadSampleContractor", Name = "DownloadSampleContractor")]
        [CustomAuthActionFilter]
        public ActionResult DownloadSampleContractor()
        {
            Response ret = new Response();
            try
            {
                string FileName = Server.MapPath("~/Docs/Sample/Contractor.csv");
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "SampleContractor.csv");
            }
            catch
            {
                throw;
            }
        }
        [ADDUpdateAction]
        [ValidateAntiForgeryToken]
        [HttpPost]
        [Route("UploadContractor", Name = "UploadContractor")]
        [CustomAuthActionFilter]
        public ActionResult UploadContractor(string FileName)
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

                ContractorRepo repContractor = new ContractorRepo();
                string FilePath = Server.MapPath("~/Docs/Temp/" + FileName);
                string SampleFileName = Server.MapPath("~/Docs/Sample/Contractor.csv");
                int SuccessCount = 0;
                int FailCount = 0;
                string ResultFileName = repContractor.UploadContractor(FilePath, SampleFileName, ((User)Session["uBo"]).UID, ref  SuccessCount, ref FailCount);
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