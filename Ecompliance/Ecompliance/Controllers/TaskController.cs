using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ecompliance.ViewModel;
using Ecompliance.Repository;
using Ecompliance.Areas.Master.Models;
using Ecompliance.Utils;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.ActionFilters;
using Ecompliance.Models;
using System.Data;
using System.Data.SqlClient;
using Ecompliance.Exception1;
using Ecompliance.CustomAttribute;

namespace Ecompliance.Controllers
{
    [CustomAuthrizationActionFilter(Order = 1)]
    [CustomAuthActionFilter]
    [RoutePrefix("document")]
    public class TaskController : Controller
    {

        // GET: Task
        [ViewAction]
        [Route("Task", Name = "Task")]
        public ActionResult Task(string DocID)
        {
            CompanyRepo objCompRepo = new CompanyRepo();
            ActRepo objActRepo = new ActRepo();
            ContractorRepo objContRepo = new ContractorRepo();
            Act actModel = new Act();
            Contractor ContModel = new Contractor();
            TaskVM Model = new TaskVM();
            try
            {
                actModel.ActID = 0;
                actModel.IsAct = true;
                ContModel.ContractorID = 0;
                ContModel.IsAct = true;
                Model.CompanyList = DropdownUtils.ToSelectList(TaskRepo.GetMappedCompany(((User)Session["uBo"]).UID), "CompID", "Name");
                if (DocID != null)
                    ViewBag.DocID = DocID;
                else
                    ViewBag.DocID = "0";
                return View(Model);
            }
            catch { throw; }
        }
        
        [ViewAction]
        [Route("ViewTask/{Type?}", Name = "ViewTask")]
        public ActionResult ViewTask(string Type,string Company,string Syear,string SMonth,string Tyear, string TMonth)
        {
            ViewBag.Type = Type;
            return View();
        }
        [ViewAction]
        [Route("AllAlerts", Name = "AllAlerts")]
        public ActionResult AllAlerts()
        {
            Company ObjComp = new Company();
            ObjComp.CompanyID = 0;
            ObjComp.IsAct = true;
            ObjComp.UID = ((User)Session["uBo"]).UID;
            CompanyRepo ObjCompRep = new CompanyRepo();
            SelectList objlist = DropdownUtils.ToSelectList(TaskRepo.GetMappedCompany(((User)Session["uBo"]).UID), "CompID", "Name");

            ViewBag.CompList = objlist;//DropdownUtils.ToSelectList(ObjCompRep.GetCompanyList(ObjComp), "CompID", "Name");

            Act ObjAct = new Act();
            ObjAct.ActID = 0;
            ObjAct.IsAct = true;
            ObjAct.UID = ((User)Session["uBo"]).UID;
            ActRepo ObjActRepo = new ActRepo();
            ViewBag.ActList = DropdownUtils.ToMultiSelectList(ObjActRepo.GetActList(ObjAct), "ActID", "Short_Name");

            Activity ObjActivity = new Activity();
            ObjActivity.Act = 0;
            ObjActivity.ActivityID = 0;
            ObjActivity.IsAct = true;
            ObjActivity.UID = ((User)Session["uBo"]).UID;
            ActivityRepo ObjActivityRepo = new ActivityRepo();
            ViewBag.ActivityList = DropdownUtils.ToMultiSelectList(ObjActivityRepo.GetActivityList(ObjActivity), "ActivityID", "Name");
            return View();
        }
        [ViewAction]
        [HttpPost]
        [Route("GetDocTaskGrid", Name = "GetDocTaskGrid")]
        public ActionResult GetDocTaskGrid(string Type,int CompID,int SMonth,int TMonth,int Syear,int Tyear, int page, int pageSize, int skip, int take, List<SortDescription> sorting, FilterContainer filter)
        {
            Response ret = new Response();
            TaskRepo objRepo = new TaskRepo();
            DataSet Ds = new DataSet();
            try
            {
                DataTable newDt = new DataTable();
                int from = skip + 1; //(page - 1) * pageSize + 1;
                int to = take * page; // page * pageSize;
                string sortingStr = "";
                #region Sorting
                if (sorting != null)
                {
                    sortingStr = objRepo.sortGrid(sorting);
                }
                #endregion
                #region filtering
                string filters = "";
                if (filter != null)
                {
                    filters = objRepo.FilterGrid(filter);
                }
                #endregion
                sortingStr = sortingStr.TrimStart(',');
                int UID = ((User)Session["uBo"]).UID;
                if (sortingStr == "") sortingStr = null;
                if (filters == "") filters = null;
                Ds = objRepo.GetDocTaskGrid(Type, CompID, SMonth, TMonth, Syear, Tyear, UID, from, to, sortingStr, filters);

                string data = JsonSerializer.SerializeTable(Ds.Tables[0]);
                ret.IsSuccess = true;
                ret.Data = "{\"Data\":" + data + ",\"Total\":" + Ds.Tables[1].Rows[0]["TotalCount"] + "}";
                ret.Message = "success";
                var jsonResult = Json(ret, JsonRequestBehavior.AllowGet);
                
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
                
            }
            catch (Exception ex)
            {
                ret.IsSuccess = true;
                ret.Data = "{\"Data\":[],\"Total\":" + 0 + "}";
            }
            return Json(ret);
        }
        [ViewAction]
        [HttpPost]
        [Route("GetDocTaskSearchGrid", Name = "GetDocTaskSearchGrid")]
        public ActionResult GetDocTaskSearchGrid(string Type, string ActivityType, string CompIDs, string SiteIDs, string ContractorIDs, string ActIDs, string ActivityIDs, string ExpDate, string Month, string Year, string FromDate, string ToDate,string DocID,string Compliance_Nature, int page, int pageSize, int skip, int take, List<SortDescription> sorting, FilterContainer filter)
        {
            Response ret = new Response();
            TaskRepo objRepo = new TaskRepo();
            DataSet Ds = new DataSet();
            try
            {
                if (ExpDate != "")
                {
                    string[] arrDate = ExpDate.Split('/');
                    ExpDate = arrDate[2] + "-" + arrDate[1] + "-" + arrDate[0];
                }
                DataTable newDt = new DataTable();
                int from = skip + 1; //(page - 1) * pageSize + 1;
                int to = take * page; // page * pageSize;
                string sortingStr = "";
                #region Sorting
                if (sorting != null)
                {
                    sortingStr = objRepo.sortGrid(sorting);
                }
                #endregion
                #region filtering
                string filters = "";
                if (filter != null)
                {
                    filters = objRepo.FilterGrid(filter);
                }
                #endregion
                sortingStr = sortingStr.TrimStart(',');
                int UID = ((User)Session["uBo"]).UID;
                if (sortingStr == "") sortingStr = null;
                if (filters == "") filters = null;
                if (FromDate != "")
                {
                    string[] arrFromDate = FromDate.Split('/');
                    FromDate = arrFromDate[2] + "-" + arrFromDate[1] + "-" + arrFromDate[0];
                }
                if (ToDate != "")
                {
                    string[] arrToDate = ToDate.Split('/');
                    ToDate = arrToDate[2] + "-" + arrToDate[1] + "-" + arrToDate[0];
                }
                Ds = objRepo.GetDocTaskSearchGrid(Type, UID, ActivityType, CompIDs, SiteIDs, ContractorIDs, ActIDs, ActivityIDs, ExpDate, Month, Year, FromDate, ToDate, DocID,Compliance_Nature, from, to, sortingStr, filters);
                string data = JsonSerializer.SerializeTable(Ds.Tables[0]);
                ret.IsSuccess = true;
                ret.Data = "{\"Data\":" + data + ",\"Total\":" + Ds.Tables[1].Rows[0]["TotalCount"] + "}";
                ret.Message = "success";
            }
            catch (Exception ex)
            {
                ret.IsSuccess = true;
                ret.Data = "{\"Data\":[],\"Total\":" + 0 + "}";
            }
            var jsonResult = Json(ret, JsonRequestBehavior.AllowGet);
            jsonResult.MaxJsonLength = int.MaxValue;
            return jsonResult;
        }
        [ViewAction]
        [HttpGet]
        [Route("GetActivityForAllAerts", Name = "GetActivityForAllAerts")]
        public ActionResult GetActivityForAllAerts(string ActIds)
        {
            Response ret = new Response();
            TaskRepo objRepo = new TaskRepo();
            try
            {
                DataSet ds = new DataSet();
                string jsonData = JsonSerializer.SerializeTable(objRepo.GetActivityForAllAerts(ActIds).Tables[0]);
              //ds.Tables[0], Newtonsoft.Json.Formatting.None, serializerSettings);
                ret.IsSuccess = true;
                ret.Message = "";
                ret.Data = jsonData;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch { throw; }
        }
        [ViewAction]
        [HttpGet]
        [Route("GetMappedActsForMultipleSite", Name = "GetMappedActsForMultipleSite")]
        public ActionResult GetMappedActsForMultipleSite(string SiteIDs)
        {
            Response ret = new Response();
            TaskRepo objRepo = new TaskRepo();
            try
            {
                DataSet ds = new DataSet();
                string jsonData = JsonSerializer.SerializeTable(objRepo.GetMappedActsForMultipleSite(SiteIDs).Tables[0]);
                //ds.Tables[0], Newtonsoft.Json.Formatting.None, serializerSettings);
                ret.IsSuccess = true;
                ret.Message = "";
                ret.Data = jsonData;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch { throw; }
        }
        [ViewAction]
        [Route("ViewAsNeeded", Name = "ViewAsNeeded")]
        public ActionResult ViewAsNeeded()
        {
            return View();
        }

        [ViewAction]
        [Route("MyAsNeeded", Name = "MyAsNeeded")]
        public ActionResult MyAsNeeded()
        {
            return View();
        }
        [ViewAction]
        [HttpPost]
        [Route("GetMyAsNeeded", Name = "GetMyAsNeeded")]
        public ActionResult GetMyAsNeeded(int CompID,int SMonth,int TMonth,int Syear, int Tyear, int page, int pageSize, int skip, int take, List<SortDescription> sorting, FilterContainer filter)
        {
            Response ret = new Response();
            TaskRepo objRepo = new TaskRepo();
            DataSet Ds = new DataSet();
            try
            {
                DataTable newDt = new DataTable();
                int from = skip + 1; //(page - 1) * pageSize + 1;
                int to = take * page; // page * pageSize;
                string sortingStr = "";
                #region Sorting
                if (sorting != null)
                {
                    sortingStr = objRepo.sortGrid(sorting);
                }
                #endregion
                #region filtering
                string filters = "";
                if (filter != null)
                {
                    filters = objRepo.FilterGrid(filter);
                }
                #endregion
                sortingStr = sortingStr.TrimStart(',');
                int UID = ((User)Session["uBo"]).UID;
                if (sortingStr == "") sortingStr = null;
                if (filters == "") filters = null;
                Ds = objRepo.GetMyAsNeeded(CompID, SMonth, TMonth, Syear, Tyear, UID, from, to, sortingStr, filters);
                string data = JsonSerializer.SerializeTable(Ds.Tables[0]);
                ret.IsSuccess = true;
                ret.Data = "{\"Data\":" + data + ",\"Total\":" + Ds.Tables[1].Rows[0]["TotalCount"] + "}";
                ret.Message = "success";
            }
            catch (Exception ex)
            {
                ret.IsSuccess = true;
                ret.Data = "{\"Data\":[],\"Total\":" + 0 + "}";
            }
            return Json(ret);
        }

        [ViewAction]
        [Route("ViewTaskServer", Name = "ViewTaskServer")]
        public ActionResult ViewTaskServer()
        {
            return View();
        }
        [ViewAction]
        [HttpGet]
        [Route("GetMappedSite", Name = "GetMappedSite")]
        public ActionResult GetMappedSite(string CompanyID)
        {
            //TaskRepo obj = new TaskRepo();
            Response ret = new Response();
            try
            {
                ret.Data = JsonSerializer.SerializeTable(TaskRepo.GetMappedSite(Convert.ToInt32(CompanyID), ((User)Session["uBo"]).UID));
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
        [Route("GetMappedActs", Name = "GetMappedActs")]
        public ActionResult GetMappedActs(string CompID,string ContractorID,string SiteID)
        {
            //TaskRepo obj = new TaskRepo();
            Response ret = new Response();
            try
            {
                ret.Data = JsonSerializer.SerializeTable(TaskRepo.GetMappedActs(Convert.ToInt32(CompID), Convert.ToInt32(ContractorID), Convert.ToInt32(SiteID)));
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
        [Route("GetMappedContractor", Name = "GetMappedContractor")]
        public ActionResult GetMappedContractor(string CompID, string SiteID)
        {
            //TaskRepo obj = new TaskRepo();
            Response ret = new Response();
            try
            {
                ret.Data = JsonSerializer.SerializeTable(TaskRepo.GetMappedContractor(Convert.ToInt32(CompID), Convert.ToInt32(SiteID), ((User)Session["uBo"]).UID));
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
        [Route("GetMappedActivity", Name = "GetMappedActivity")]
        public ActionResult GetMappedActivity(int CompanyID, int ContractorID,int SiteID,int ActID)
        {
            //TaskRepo obj = new TaskRepo();
            Response ret = new Response();
            try
            {
                ret.Data = JsonSerializer.SerializeTable(TaskRepo.GetMappedActivity(CompanyID, ContractorID, SiteID, ActID));
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
        [Route("getActivityByAct", Name = "getActivityByAct")]
        public ActionResult getActivityByAct(string ActID)
        {
            ActivityRepo obj = new ActivityRepo();
            Activity objModel = new Activity();
            Response ret = new Response();
            try
            {
                objModel.ActivityID = 0;
                objModel.IsAct = true;
                objModel.Act = Convert.ToInt32(ActID);
                ret.Data = JsonSerializer.SerializeTable(obj.GetActivityList(objModel));
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

        [ADDUpdateAction]
        [HttpPost]
        [ValidateAntiForgeryToken()]
        [Route("Task", Name = "createTask")]
        public ActionResult Task(TaskVM TaskM)
        {
            TaskRepo obj = new TaskRepo();
            Response ret = new Response();
            User ObjU = new User();
            if (ModelState.IsValid)
            {
                try
                {
                    TaskM.TaskID = 0;
                    TaskM.CreatedBy = ((User)Session["uBo"]).UID;
                    TaskM.CurrUser = ((User)Session["uBo"]).UID;
                    TaskM.ActionType = "Manual";
                    TaskM.Applicable_To_Client = 0;
                    string Datet = System.DateTime.Now.Date.ToShortDateString();
                    DataTable Dt = obj.GetActivityActionType(TaskM);
                    if (Dt.Rows.Count > 0)
                    {
                        TaskM.MappingID = Convert.ToInt32(Dt.Rows[0]["MappingID"].ToString());
                        TaskM.ActionType = Dt.Rows[0]["ActionType"].ToString();
                        TaskM.Applicable_To_Client = Convert.ToInt32(Dt.Rows[0]["Applicable_To_Client"]);
                    }
                    if (DateTime.Now.Day == TaskM.ExpiryDate.Day && DateTime.Now.Month == TaskM.ExpiryDate.Month && DateTime.Now.Year == TaskM.ExpiryDate.Year && TaskM.DOCID == 0)
                    {
                        SqlTransaction trans;
                        SqlConnection con;
                        con = new SqlConnection(Ecompliance.Utils.DataLib.GetConnectionString());
                        con.Open();
                        //trans = new SqlTransaction();
                        trans = con.BeginTransaction();
                        try
                        {
                            ret.Data = obj.AddTask(TaskM, con, trans);
                            trans.Commit();
                        }
                        catch (Exception ex)
                        {
                            
                            trans.Rollback();
                            throw;
                        }
                        finally
                        {
                            con.Close();
                            trans.Dispose();
                        }
                    }
                    else
                    ret.Data = obj.CreateDocAsNeeded(TaskM);
                    ret.IsSuccess = true;
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
                catch (Exception ex)
                {
                    throw new Exception(ex.Message.ToString(), ex);
                }
            }
            else
            {
                //return View(TaskM);
                return Json(ret, JsonRequestBehavior.AllowGet);
            }

        }
        [ViewAction]
        [Route("GetTaskDocument", Name = "GetTaskDocument")]
        public ActionResult GetTaskDocument(string DOCID)
        {
            TaskRepo obj = new TaskRepo();
            Task objModel = new Task();
            Response ret = new Response();
            try
            {
                objModel.DOCID = Convert.ToInt32(DOCID);
                ret.Data = JsonSerializer.SerializeTable(obj.GetTaskDocument(objModel));
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
        [Route("GetAsneededDocument", Name = "GetAsneededDocument")]
        public ActionResult GetAsneededDocument(string DocID)
        {
            TaskRepo obj = new TaskRepo();
            Task objModel = new Task();
            Response ret = new Response();
            try
            {
                objModel.DOCID = Convert.ToInt32(DocID);
                objModel.CreatedBy = ((User)Session["uBo"]).UID;
                ret.Data = JsonSerializer.SerializeTable(obj.GetAsneededDocument(objModel));
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
        [Route("GetSiteOfTaskFilter", Name = "GetSiteOfTaskFilter")]
        public ActionResult GetSiteOfTaskFilter(string CompID)
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
        [HttpGet]
        [Route("GetContractorOfTaskFilter", Name = "GetContractorOfTaskFilter")]
        public ActionResult GetContractorOfTaskFilter(int CompID)
        {
            Response ret = new Response();
            try
            {
                DataSet ds = new DataSet();
                Contractor ObjMContractor = new Contractor();
                ObjMContractor.IsAct = true;
                ObjMContractor.Company = CompID;
                ObjMContractor.UID = ((User)Session["uBo"]).UID;
                ContractorRepo ObjSRep = new ContractorRepo();
                string jsonData = JsonSerializer.SerializeTable(ObjSRep.GetContractor(ObjMContractor).Tables[0]); //ds.Tables[0], Newtonsoft.Json.Formatting.None, serializerSettings);
                ret.IsSuccess = true;
                ret.Message = "";
                ret.Data = jsonData;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch { throw; }
        }



        #region TaskDetails

        [SkipAuthrization]
        [Route("Task/{docid}", Name = "TaskDetails")]
        public ActionResult TaskDetails(string docid)
        {
            Task TModel = new Task();
            TaskRepo TReop = new TaskRepo();
            TaskVerifyVM TVerifyVM = new TaskVerifyVM();
            DataTable Dt = new DataTable();
            try
            {
                TVerifyVM.DocID = Convert.ToInt32(docid);
                TModel = TReop.GetTaskobject(docid);
                var tuple = new Tuple<Task, TaskVerifyVM>(TModel, TVerifyVM);
                return View(tuple);
            }
            catch
            {
                return View();
            }
            
        }

        [SkipAuthrization]
        [HttpPost]
        [ValidateAntiForgeryToken()]
        [Route("TaskVerify", Name = "TaskVerify")]
        public ActionResult TaskVerify(TaskVerifyVM TaskVerifyVM)
        {
            TaskRepo obj = new TaskRepo();
            Response ret = new Response();
            User ObjU = new User();
            if (ModelState.IsValid)
            {
                try
                {
                    //TaskVerifyVM.DocID = 20;
                    TaskVerifyVM.UID = ((User)Session["uBo"]).UID;
                    //result = obj.AddUpdateSite(SiteM);
                    ret.Data = obj.SendToVarify(TaskVerifyVM); //ret.GetResponse("Task", TaskM.DOCID.ToString(), Convert.ToInt32(obj.AddTask(TaskM)), "Task");
                    ret.IsSuccess = true;
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
                catch (Exception ex)
                {
                    ret.Data = "-2"; //ret.GetResponse("Task", "", -2);
                    ret.IsSuccess = false;
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
            }
            else
            {
                return View("TaskDetails", TaskVerifyVM);
                //return Json(ret, JsonRequestBehavior.AllowGet);
            }
        }
        [SkipAuthrization]
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Route("Approve", Name = "Approve")]
        public ActionResult Approve(string Remarks, int DocID, int Repeat, string StrNextDueDate, string StrRemindDays)
        {
            TaskRepo obj = new TaskRepo();
            Response ret = new Response();
            User ObjU = new User();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                int RemindDays = 0;
                DateTime NextDueDate = System.DateTime.Now; ;
                //Validate mandatory fields

                if (Repeat == 1)
                {
                    if ((StrNextDueDate.Trim() == "") || (StrRemindDays.Trim() == ""))
                    {
                        ret.Data = "-2";
                        ret.IsSuccess = false;
                        ret.Message = "Please fill all mandatory fields.";
                        return Json(ret, JsonRequestBehavior.AllowGet);
                    }
                    //Validate Reminddays data Type
                    if (int.TryParse(StrRemindDays, out  RemindDays) == false)
                    {
                        ret.Data = "-2";
                        ret.IsSuccess = false;
                        ret.Message = "Remind Days must be integer only.";
                        return Json(ret, JsonRequestBehavior.AllowGet);
                    }
                    if(RemindDays<0)
                    {
                        ret.Data = "-2";
                        ret.IsSuccess = false;
                        ret.Message = "Remind Days must be non negetive integer only.";
                        return Json(ret, JsonRequestBehavior.AllowGet);
                    }
                    try
                    {
                        NextDueDate = DateUtils.GetFDate(StrNextDueDate);
                    }
                    catch
                    {
                        ret.Data = "-2";
                        ret.IsSuccess = false;
                        ret.Message = "Expiry Date must be date only.";
                        return Json(ret, JsonRequestBehavior.AllowGet);
                    }
                    DateTime NextDate = NextDueDate.AddDays(-RemindDays);
                    DateTime CurrDate = new DateTime(System.DateTime.Now.Year, System.DateTime.Now.Month, System.DateTime.Now.Day, 0, 0, 0);
                    int Datediff = DateTime.Compare(NextDate,CurrDate);

                    if (Datediff < 0)
                    {
                        ret.Data = "-2";
                        ret.IsSuccess = false;
                        ret.Message = "Expiry Date must be future date only.";
                        return Json(ret, JsonRequestBehavior.AllowGet);
                    }
                }

                //result = obj.AddUpdateSite(SiteM);
                ret = obj.Approve(UID, DocID, Remarks, Repeat, NextDueDate, RemindDays); //ret.GetResponse("Task", TaskM.DOCID.ToString(), Convert.ToInt32(obj.AddTask(TaskM)), "Task");
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ret.Data = "-2"; //ret.GetResponse("Task", "", -2);
                ret.IsSuccess = false;
                ret.Message = "Something went wrong. Please try again later.";
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
        }
        [SkipAuthrization]
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Route("Reconsider", Name = "Reconsider")]
        public ActionResult Reconsider(string Remarks, int DocID)
        {
            TaskRepo obj = new TaskRepo();
            Response ret = new Response();
            User ObjU = new User();
            try
            {
                int UID = ((User)Session["uBo"]).UID;
                if (Remarks != "")
                    ret.Data = obj.Reconsider(UID, DocID, Remarks); //ret.GetResponse("Task", TaskM.DOCID.ToString(), Convert.ToInt32(obj.AddTask(TaskM)), "Task");
                else
                    ret.Data = "-3";
                ret.IsSuccess = true;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ret.Data = "-2"; //ret.GetResponse("Task", "", -2);
                ret.IsSuccess = false;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
        }
        [SkipAuthrization]
        [HttpGet]
        [Route("GetExtExPDate", Name = "GetExtExPDate")]
        public ActionResult GetExtExPDate(int DocID)
        {
            TaskRepo obj = new TaskRepo();
            Response ret = new Response();
            DataTable Dt = new DataTable();
            try
            {
                Dt = obj.GetExtExPDate(DocID);
                ret.Data = JsonSerializer.SerializeTable(Dt);
                ret.IsSuccess = true;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        [SkipAuthrization]
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Route("SetExtExpDate", Name = "SetExtExpDate")]
        public ActionResult SetExtExpDate(string ExtendedExpDate,string Remarks, int DocID)
        {
            TaskRepo obj = new TaskRepo();
            Response ret = new Response();
            TaskVM objVM = new TaskVM();
            User ObjU = new User();
            try
            {
                DateTime ExpDate = Convert.ToDateTime(ExtendedExpDate);
                DateTime currentDateTime = DateTime.Now.Date;
                if(ExpDate < currentDateTime)
                {
                    ret.Data = "-1";
                    ret.IsSuccess = false;
                    ret.Message = "Expiry date shuld be greater than current date.";
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
                int UID = ((User)Session["uBo"]).UID;
                if (Remarks != "")
                    ret.Data = obj.SetExtExpDate(DocID, ExtendedExpDate, UID, Remarks); //ret.GetResponse("Task", TaskM.DOCID.ToString(), Convert.ToInt32(obj.AddTask(TaskM)), "Task");
                else
                    ret.Data = "-3";

                ret.IsSuccess = true;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ret.Data = "-2";
                ret.IsSuccess = false;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
        }
        [SkipAuthrization]
        [HttpGet]
        [Route("GETExtendedExpDateHis", Name = "GETExtendedExpDateHis")]
        public ActionResult GETExtendedExpDateHis(int DocID)
        {
            TaskRepo obj = new TaskRepo();
            Response ret = new Response();
            DataTable Dt = new DataTable();
            try
            {
                Dt = obj.GETExtendedExpDateHis(DocID);
                ret.Data = JsonSerializer.SerializeTable(Dt);
                ret.IsSuccess = true;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        [SkipAuthrization]
        [Route("BindMovement", Name = "BindMovement")]
        public ActionResult BindMovement(int DOCID)
        {
            TaskRepo ObjRepo = new TaskRepo();
            try
            {
                DataSet ds = ObjRepo.GetDocMovement(DOCID);
                return View(ds);
            }
            catch (Exception ex)
            {

                throw;
            }
        }
        #endregion



        #region AsneededDetails
        [ViewAction]
        [Route("MyAsNeeded/{docid}", Name = "AsneededDetails")]
        public ActionResult AsneededDetails(string docid)
        {
            Task TModel = new Task();
            TaskRepo TReop = new TaskRepo();
            TaskVM TVM = new TaskVM();
            DataTable Dt = new DataTable();
            try
            {
                //TVerifyVM.DocID = Convert.ToInt32(docid);
                TVM.CompanyList = DropdownUtils.ToSelectList(TaskRepo.GetMappedCompany(((User)Session["uBo"]).UID), "CompID", "Name");
                TModel = TReop.GetAsneededForDetailsObject(docid);
                var tuple1 = new Tuple<Task, TaskVM>(TModel, TVM);
                return View(tuple1);
            }
            catch
            {
                return View();
            }

        }
        [ViewAction]
        [HttpGet]
        [Route("GetAsNeeded_His", Name = "GetAsNeeded_His")]
        public ActionResult GetAsNeeded_His(string DocID)
        {
            TaskRepo TReop = new TaskRepo();
            Response ret = new Response();
            try
            {
                DataTable dt = new DataTable();
                dt = TReop.GetAsNeeded_His(DocID);
                string jsonData = JsonSerializer.SerializeTable(dt);
                ret.IsSuccess = true;
                ret.Message = "";
                ret.Data = jsonData;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch { throw; }
        }
        #endregion

    }
}