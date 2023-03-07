using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ecompliance.Areas.FileExplorer.Models;
using Ecompliance.Utils;
using Ecompliance.Repository;
using Ecompliance.Areas.Master.Models;
using Ecompliance.CustomAttribute;
using Ecompliance.ActionFilters;
using Ecompliance.Areas.Admin.Models;
using System.Data;
using System.IO;

namespace Ecompliance.Areas.FileExplorer.Controllers
{
    [CustomAuthrizationActionFilter(Order = 1)]
    [CustomAuthActionFilter(Order = 0)]
    [RouteArea("FileExplorer")]
    public class FileMetaDataController : System.Web.Mvc.Controller
    {
        // GET: FileExplorer/FileMetaData    
        [ViewAction]
        [Route("FileMetaData", Name = "FileMetaData")]
        public ActionResult FileMetaData()
        {
            FileMetaData Model = new FileMetaData();
            CustomerRepo RepCus = new CustomerRepo();
            Customer CusMdl = new Customer();
            Model.CustomerList = DropdownUtils.ToSelectList(RepCus.GetCustomer(CusMdl).Tables[0], "CustID", "Name");
            return View(Model);
        }


        [ValidateAntiForgeryToken]
        [HttpPost]
        [ADDUpdateAction]
        [Route("CreateFileMetaData", Name = "CreateFileMetaData")]
        public ActionResult CreateFileMetaData(FileMetaData model)
        {
            FileMetaDataRepo repMetadata = new FileMetaDataRepo();
            Response res = new Response();
            try
            {
                model.CreatedBy = ((User)Session["uBo"]).UID;
                res = res.GetResponse("FileMetaData", model.FileMetaID.ToString(), repMetadata.CreateUpdateMetaData(model), "FileMetadata");
                return Json(res);
            }
            catch
            {
                res = res.GetResponse("Company", "", -2);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
        }




        [ViewAction]
        [HttpGet]
        [Route("GetMetaData", Name = "GetMetaData")]
        public ActionResult GetMetaData(int MetaDataID, int CustID)
        {
            FileMetaDataRepo repMetadata = new FileMetaDataRepo();
            FileMetaData Model = new FileMetaData();
            Model.FileMetaID = MetaDataID;
            Model.CustomerID = CustID;

            //Model.UID = ((User)Session["uBo"]).UID;
            Response res = new Response();
            try
            {
                DataTable dt = repMetadata.GetMetaDataList(Model);
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
       
    }
}