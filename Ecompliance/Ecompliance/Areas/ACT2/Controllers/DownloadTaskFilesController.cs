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
using Ecompliance.Areas.ACT2.Repository;
using System.IO;
using Ionic.Zip;



namespace Ecompliance.Areas.ACT2.Controllers
{
    [RouteArea("ACT2")]
//    [CustomAuthActionFilter(Order = 0)]
  //  [CustomAuthrizationActionFilter(Order = 1)]
    public class DownloadTaskFilesController : Controller
    {
      //  [ViewAction]
        [Route("ViewDownloadTaskFiles", Name = "ViewDownloadTaskFiles")]
        public ActionResult ViewDownloadTaskFiles()
        {
            DownloadTaskFilesRepo Downloadrepo = new DownloadTaskFilesRepo();
            Customer Custmdl = new Customer();
            Custmdl.UID = ((User)Session["uBo"]).UID;
            ViewBag.Company = DropdownUtils.ToSelectList(TaskRepo.GetMappedCompany(((User)Session["uBo"]).UID), "CompID", "Name");
            ViewBag.Customer = DropdownUtils.ToSelectList(Downloadrepo.GetCustomerACT2(Custmdl).Tables[0],"CustID","Name");
            return View();
        }
        [HttpGet]
        [ViewAction]
        [Route("GetCompanyFile", Name = "GetCompanyFile")]
        public ActionResult GetCompanyFile(int CompanyID, int CustID)
        {
            CompanyRepo repcompany = new CompanyRepo();
            Company mdlCompany = new Company();
            mdlCompany.CompanyID = CompanyID;
            mdlCompany.Customer = CustID;
            mdlCompany.IsAct = false;
            mdlCompany.Name = "";
            mdlCompany.UID = ((User)Session["uBo"]).UID;
            Response res = new Response();
            try
            {
                DataTable dt = repcompany.GetCompanyList(mdlCompany);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                res = res.GetResponse("Company", "", -2);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
        }
        [HttpGet]
        [ViewAction]
        [Route("GetTaskFilesForDownload", Name = "GetTaskFilesForDownload")]
        public ActionResult GetTaskFilesForDownload(int Month,int Year, int CustID, int CompID, int SiteID)
        {
           
            Response ret = new Response();
            try
            {
                TaskFileRepo repo = new TaskFileRepo();
                string SessionID = Session.SessionID;
                ret = repo.GetTaskFileForDownload(Month,Year,CustID,CompID,SiteID, ((User)Session["uBo"]).UID,SessionID);
             

                string ZipPath = Server.MapPath("~/Docs/TaskFileDownload/");
                if (System.IO.File.Exists(ZipPath + "/" + Month + "-" + Year + ".zip"))
                { System.IO.File.Delete(ZipPath + "/" + Month + "-" + Year + ".zip"); }

                ZipFile zipfile = new ZipFile();

                zipfile.AddDirectory(ZipPath + SessionID);//, ZipPath + SessionID  + ".zip");

                zipfile.Save(ZipPath + SessionID + Month + "-" + Year + ".zip");


                string[] Filenames = Directory.GetFiles(ZipPath);
                using (ZipFile zip = new ZipFile())
                {
                    zip.Password = ret.Data;
                    zip.Encryption = EncryptionAlgorithm.PkzipWeak;
                    zip.AddFiles(Filenames, SessionID);//Zip file inside filename  
                    zip.Save(ZipPath  + SessionID + ".zip");//location and name for creating zip file  

                }                               
                byte[] fileBytes = System.IO.File.ReadAllBytes(ZipPath + SessionID + ".zip");
                System.IO.File.Delete(ZipPath + SessionID + ".zip");
                System.IO.File.Delete(ZipPath + SessionID + Month + "-" + Year + ".zip");
                System.IO.Directory.Delete(ZipPath + SessionID, true);
                return File(fileBytes, "application/zip", SessionID+ Month + "-" + Year + ".zip");

               
            }
            catch (Exception ex)
            {
                ret.IsSuccess = false;
                ret.Message = ex.Message;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
        }
    }
}