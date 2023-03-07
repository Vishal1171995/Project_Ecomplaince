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
    public class SiteController : Controller
    {
        [ViewAction]
        [Route("Site", Name = "ViewSite")]
        public ActionResult Site()
            {
            CustomerRepo objCustomerRepo = new CustomerRepo();
            Customer objCustomer = new Customer();
            SiteRepo objSiteRepo = new SiteRepo();
            Site Model = new Site();
            Company objComp = new Company();
            CompanyRepo objCompRepo = new CompanyRepo();
            try
            {
                objCustomer.CustID = 0;
                objCustomer.UID = ((User)Session["uBo"]).UID;
                Model.CustomerList = DropdownUtils.ToSelectList(objCustomerRepo.GetCustomer(objCustomer).Tables[0], "CustID", "Name");
                
                Model.StateList = DropdownUtils.ToSelectList(objSiteRepo.GetState(0).Tables[0], "StateID", "Name");
                User UMdl = new User();
                UMdl.UserID = ((User)Session["uBo"]).UID;
                UserRepo RepU = new UserRepo();
                UMdl.UID = 0;
                UMdl.IsAuth = 1;
                Model.UserList = DropdownUtils.ToSelectList(RepU.GetUser(UMdl), "UID", "User_Name");
                Model.AuditorList = DropdownUtils.ToSelectList(RepU.GetAuditor(UMdl), "UID", "User_Name");

                objComp.CompanyID = 0;
                objComp.IsAct = true;
                objComp.UID = ((User)Session["uBo"]).UID;
                ViewBag.Ds = objCompRepo.GetCompanyList(objComp);//objSiteRepo.GetSiteSnapShort();

                ///
                //int UID = ((User)Session["uBo"]).UID;
                //int Role = ((User)Session["uBo"]).Role;
                //DataTable dt = objSiteRepo.GetBindSite(UID, Role);
                //DataTable dtRole = dt.DefaultView.ToTable(false, "Customer", "SiteID", "Name");
                //ViewBag.SelMaster = dtRole.Rows[0]["SiteID"];
                //ViewBag.SiteData = dtRole.AsEnumerable();

                ///



                return View(Model);
            }
            catch { return View(); }
        }
        ///Vishal
        /// <summary>
        [ViewAction]
        [Route("BindSite", Name = "BindSite")]
        public ActionResult BindSite(int SiteId,int NewSiteID)
        {
            SiteRepo objSiteRepo = new SiteRepo();
            Response ret = new Response();
            try
            {
                DataSet ds = new DataSet();
                ds = objSiteRepo.GetBindSiteForMaster(SiteId, NewSiteID);
                string data = JsonSerializer.SerializeTable(ds.Tables[0]);
                ret.Data = "{\"Data\":" + data + ",\"Total\":" + ds.Tables[1].Rows[0]["siteCount"] + "}";
                ret.IsSuccess = true;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
           catch(Exception ex)
            {
                ret.IsSuccess = false;
                ret.Message = ex.Message;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
           
        }
        /// </summary>
        /// <returns></returns>
        [ADDUpdateAction]
        [ValidateAntiForgeryToken]
        [HttpPost]
        [Route("AddMappingSite", Name = "AddMappingSite")]
        public ActionResult AddMappingSite(string MappingID,int SiteID,int CompanyID, int MappingCount)
        {
            SiteRepo objSiteRepo = new SiteRepo();
            Response ret = new Response();
            try
            {
                string s = MappingID.ToString();
                ret = objSiteRepo.AddMappingSite(MappingID, SiteID, CompanyID, MappingCount);

                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch(Exception ex)
            {
                ret.IsSuccess = false;
                ret.Message = ex.Message;
                return Json(ret, JsonRequestBehavior.AllowGet);

            }

        }

        //Vishal

        [ViewAction]
        [Route("NewSite", Name = "NewSite")]
        public ActionResult NewSite()
        {
            return View();
        }
        [ViewAction]
        [HttpGet]
        [Route("GetMappedCompany", Name = "GetMappedCompany")]
        public ActionResult GetMappedCompany(int CustID)
        {
            CompanyRepo obj = new CompanyRepo();
            Company objModel = new Company();
            Response ret = new Response();
            try
            {
                objModel.CompanyID = 0;
                objModel.Customer = CustID;
                objModel.Name = "";
                objModel.UID = ((User)Session["uBo"]).UID;
                ret.Data = JsonSerializer.SerializeTable(obj.GetCompanyList(objModel));
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
        [HttpPost]
        [Route("getSite", Name = "getSite")]
        public ActionResult getSite(string SiteID, int CompID, int page, int pageSize, int skip, int take, List<SortDescription> sorting = null, FilterContainer filter=null )
        {
            SiteRepo obj = new SiteRepo();
            Site objModel = new Site();
            Response ret = new Response();
            try
            {
                objModel.SiteID = Convert.ToInt32(SiteID);
                objModel.IsAct = false;
                objModel.Company = CompID.ToString();
                objModel.Customer = "0";
                objModel.State = "0";
                objModel.Location = "0";
                objModel.Name = "";
                objModel.UID = ((User)Session["uBo"]).UID;
                DataTable newDt = new DataTable();
                int from = skip + 1; //(page - 1) * pageSize + 1;
                int to = take * page; // page * pageSize;
                string sortingStr = "";
                #region Sorting
                if (sorting != null)
                {
                    sortingStr = obj.sortGrid(sorting);
                }
                #endregion
                #region filtering
                string filters = "";
                if (filter != null)
                {
                    if(filter.filters!= null)
                         filters = obj.FilterGrid(filter);
                }
                #endregion
                sortingStr = sortingStr.TrimStart(',');
                int UID = ((User)Session["uBo"]).UID;
                if (sortingStr == "") sortingStr = null;
                if (filters == "") filters = null;
                DataSet ds = obj.GetSite(objModel, from, to, sortingStr, filters);
                string data = JsonSerializer.SerializeTable(ds.Tables[0]);
                ret.IsSuccess = true;
                ret.Data = "{\"Data\":" + data + ",\"Total\":" + ds.Tables[1].Rows[0]["TotalCount"] + "}";
                ret.Message = "success";

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
        [Route("GetLocationForSite", Name = "GetLocationForSite")]
        public ActionResult GetLocationForSite(int StateID)
        {
            LocationRepo objRepo = new LocationRepo();
            Location objModel = new Location();
            Response ret = new Response();
            try
            {
                objModel.LocationID = 0;
                objModel.IsAct = true;
                objModel.State = StateID;
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
        [Route("getSiteHistory", Name = "getSiteHistory")]
        public ActionResult getSiteHistory(string SiteID)
        {
            SiteRepo obj = new SiteRepo();
            Site objModel = new Site();
            Response ret = new Response();
            try
            {
                objModel.SiteID = Convert.ToInt32(SiteID);
                ret.Data = JsonSerializer.SerializeTable(obj.GetSiteHistory(objModel).Tables[0]);
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
        [Route("createSite", Name = "createSite")]
        public ActionResult createSite(Site SiteM)
        {
            SiteRepo obj = new SiteRepo();
            Response ret = new Response();
            User ObjU = new User();
            if (ModelState.IsValid)
            {
                try
                {
                    SiteM.CreatedBy = ((User)Session["uBo"]).UID;
                    ret = ret.GetResponse("Site", SiteM.SiteID.ToString(), Convert.ToInt32(obj.AddUpdateSite(SiteM)), "Site name");
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
                catch (Exception ex)
                {
                    ret = ret.GetResponse("Site", "", -2);
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
            }
            else
            {
                return Json(ret, JsonRequestBehavior.AllowGet);
            }

        }
        [ViewAction]
        [HttpGet]
        [Route("DownloadAllMapppingSite", Name = "DownloadAllMapppingSite")]
        public ActionResult DownloadAllMapppingSite(string CompID)
        {
            Response ret = new Response();
            try
            {
                SiteRepo repact = new SiteRepo();
                Site model = new Site();

                model.SiteID = 0;
                model.Company = CompID;
                model.Customer = "0";
                model.State = "0";
                model.IsAct = false;
                model.UID = ((User)Session["uBo"]).UID;
                DataTable dt = (repact.GetSite(model)).Tables[0];
                DataTable dtSite = dt.DefaultView.ToTable(false, "SiteID", "Name","Site_Code", "CompanyText", "CustomerText", "StateText","Location", "Contact_Person", "Contact_Number", "Address", "MakerText", "ChekcerText", "MakerText2", "ChekcerText2", "AuditorText1", "AuditorText2", "IsActText");
                dtSite.Columns["Name"].ColumnName = "Site";
                dtSite.Columns["Site_Code"].ColumnName = "Site_Code";
                dtSite.Columns["CompanyText"].ColumnName = "Company";
                dtSite.Columns["CustomerText"].ColumnName = "Customer";
                dtSite.Columns["StateText"].ColumnName = "State";
                dtSite.Columns["MakerText"].ColumnName = "Maker1";
                dtSite.Columns["ChekcerText"].ColumnName = "Checker1";
                dtSite.Columns["ChekcerText2"].ColumnName = "Checker2";
                dtSite.Columns["MakerText2"].ColumnName = "Maker2";
                dtSite.Columns["AuditorText1"].ColumnName = "Auditor1";
                dtSite.Columns["AuditorText2"].ColumnName = "Auditor2";
                dtSite.Columns["IsActText"].ColumnName = "Status";


                string FileName = CSVUtills.DataTableToCSV(dtSite, ",");

                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "SiteMaster.csv");
            }
            catch
            {
                throw;
            }
        }

        [ADDUpdateAction]
        [HttpGet]
        [Route("DownloadSampleSite", Name = "DownloadSampleSite")]
        public ActionResult DownloadSampleSite()
        {
            Response ret = new Response();
            try
            {
                string FileName = Server.MapPath("~/Docs/Sample/Site.csv");
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "SampleSite.csv");
            }
            catch
            {
                throw;
            }
        }


        [ViewAction]
        [HttpGet]
        [Route("DownLoadSiteResultFile", Name = "DownLoadSiteResultFile")]
        public ActionResult DownLoadSiteResultFile(string FileName)
        {
            Response ret = new Response();
            try
            {
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, "ResultFile.csv");
            }
            catch
            {
                throw;
            }
        }
        [ADDUpdateAction]
        [ValidateAntiForgeryToken]
        [HttpPost]
        [Route("UploadSite", Name = "UploadSite")]
        public ActionResult UploadSite(string FileName)
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

                SiteRepo repSite = new SiteRepo();

                string FilePath = Server.MapPath("~/Docs/Temp/" + FileName);
                string SampleFileName = Server.MapPath("~/Docs/Sample/Site.csv");
                int SuccessCount = 0;
                int FailCount = 0;
                string ResultFileName = repSite.UploadSite(FilePath, SampleFileName, ((User)Session["uBo"]).UID, ref  SuccessCount, ref FailCount);
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
        [Route("GetMappingSite", Name = "GetMappingSite")]
        public ActionResult GetMappingSite(int CompanyID)
        {
            SiteRepo objSiteRepo = new SiteRepo();
            int UID = ((User)Session["uBo"]).UID;
            int Role = ((User)Session["uBo"]).Role;
            Response res = new Response();
            try
            {
                DataTable dt = objSiteRepo.GetBindSite(CompanyID);
                DataTable dtRole = dt.DefaultView.ToTable(false, "SiteID", "Name");
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dtRole);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                throw;
            }
        }
    }
}