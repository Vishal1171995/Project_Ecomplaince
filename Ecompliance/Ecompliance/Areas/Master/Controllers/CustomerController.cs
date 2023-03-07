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
    public class CustomerController : Controller
    {
        // GET: Master/Customer
        [ViewAction]
        [Route("Customer", Name = "Viewcustomer")]
        public ActionResult customer()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken()]
        [ADDUpdateAction]
        [Route("CreateCustomer", Name = "CreateCustomer")]
        public ActionResult createCustomer(Customer CustM)
        {
            CustomerRepo obj = new CustomerRepo();
            Response ret = new Response();
            if (ModelState.IsValid)
            {
                try
                {
                    CustM.CreatedBy = ((User)Session["uBo"]).UID;
                    ret = ret.GetResponse("Customer", CustM.CustID.ToString(), Convert.ToInt32(obj.AddUpdateCustomer(CustM)), "Customer name");
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
                catch (Exception ex)
                {
                    ret = ret.GetResponse("Customer", "", -2);
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
            }
            else
            {
                return View(CustM);
            }

        }
        [ViewAction]
        [HttpGet]
        [Route("GetCustomer", Name = "GetCustomer")]
        public ActionResult getCustomer(string CustID)
        {
            CustomerRepo obj = new CustomerRepo();
            Customer objModel = new Customer();
            Response ret = new Response();
            try
            {
                objModel.CustID = Convert.ToInt32(CustID);
                objModel.IsAct = false;
                objModel.Name = "";
                objModel.UID = ((User)Session["uBo"]).UID;
                ret.Data = JsonSerializer.SerializeTable(obj.GetCustomer(objModel).Tables[0]);
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
        [Route("GetIPRangeGrid", Name = "GetIPRangeGrid")]
        public ActionResult GetIPRangeGrid(string CustID,string IPRangeTID)
        {
            Response res = new Response();
            DataTable dt = new DataTable();
            CustomerRepo obj = new CustomerRepo();
            try {
                dt = obj.GetIPRange(CustID, IPRangeTID);
                res.Data = JsonSerializer.SerializeTable(dt);
                res.IsSuccess = true;
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                res.IsSuccess = false;
               // res.Message = ex.Message;
                return Json(res, JsonRequestBehavior.AllowGet);
            }
        }


        [ViewAction]
        [HttpGet]
        [Route("AddUpdateIPRange", Name = "AddUpdateIPRange")]
        public ActionResult AddUpdateIPRange(int TID, int CustID, string IPRange, string EndIPAddress, int IsAct)
        {
            int CreatedBy = ((User)Session["uBo"]).UID;
            CustomerRepo obj = new CustomerRepo();
            Response ret = new Response();
            try
            {
                ret.Message = obj.AddUpdateIPRange(TID, CustID, IPRange, EndIPAddress, IsAct, CreatedBy);
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

        [HttpPost]
        [ValidateAntiForgeryToken()]
        [ADDUpdateAction]
        [Route("DeleteIPRange", Name = "DeleteIPRange")]
        public ActionResult DeleteIPRange(int DeleteTID, int DeleteCustID)
        {
            CustomerRepo obj = new CustomerRepo();
            Response ret = new Response();
            try
            {
                ret.Message = obj.AddUpdateIPRange(DeleteTID, DeleteCustID, "", "", 0, 0, "Delete");
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
        [Route("GetCustomerHistory", Name = "GetCustomerHistory")]
        public ActionResult GetCustomerHistory(string CustID)
        {
            CustomerRepo obj = new CustomerRepo();
            Customer objModel = new Customer();
            Response ret = new Response();
            try
            {
                objModel.CustID = Convert.ToInt32(CustID);
                objModel.IsAct = false;
                ret.Data = JsonSerializer.SerializeTable(obj.GetCustomerHistory(objModel).Tables[0]);
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
        [Route("DownloadAllMapppingCustomer", Name = "DownloadAllMapppingCustomer")]
        public ActionResult DownloadAllMapppingCustomer()
        {
            Response ret = new Response();
            try
            {
                CustomerRepo repact = new CustomerRepo();
                Customer model = new Customer();
                model.CustID = 0;
                // model.Act = 0;
                model.IsAct = false;
                model.UID = ((User)Session["uBo"]).UID;
                DataTable dt = (repact.GetCustomer(model)).Tables[0];
                DataTable dtCustomer = dt.DefaultView.ToTable(false, "CustID", "Name", "IsActText", "EnableIPRangText");

                dtCustomer.Columns["IsActText"].ColumnName = "Status";
                dtCustomer.Columns["EnableIPRangText"].ColumnName = "IP Address Status";
                // string FileName= repact.DownLoadActivity(model);
                string FileName = CSVUtills.DataTableToCSV(dtCustomer, ",");
                //  string FileName = repact.DownLoadCustomer(model);
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "CustomerMaster.csv");
            }
            catch
            {
                throw;
            }
        }

        [ADDUpdateAction]
        [HttpGet]
        [Route("DownloadSampleCustomer", Name = "DownloadSampleCustomer")]
        public ActionResult DownloadSampleCustomer()
        {
            Response ret = new Response();
            try
            {
                string FileName = Server.MapPath("~/Docs/Sample/Customer.csv");
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "SampleCustomer.csv");
            }
            catch
            {
                throw;
            }
        }
        [ValidateAntiForgeryToken]
        [ADDUpdateAction]
        [HttpPost]
        [Route("UploadCustomer", Name = "UploadCustomer")]
        public ActionResult UploadCustomer(string FileName)
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

                CustomerRepo repCustomer = new CustomerRepo();

                string FilePath = Server.MapPath("~/Docs/Temp/" + FileName);
                string SampleFileName = Server.MapPath("~/Docs/Sample/Customer.csv");
                int SuccessCount = 0;
                int FailCount = 0;
                string ResultFileName = repCustomer.ProcessMappingCustomer(FilePath, SampleFileName, 3, ref  SuccessCount, ref FailCount);
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