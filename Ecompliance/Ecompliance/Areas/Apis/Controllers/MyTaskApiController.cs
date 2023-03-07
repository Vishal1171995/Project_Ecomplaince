using Ecompliance.Repository;
using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Security.Principal;
using System.Threading;
using System.Threading.Tasks;
using Ecompliance.Models;
using Ecompliance.ViewModel;
//using System.Web.Mvc;

namespace Ecompliance.Areas.Apis.Controllers
{
    [RoutePrefix("SecureApis/MyTask")]
    public class MyTaskApiController : ApiController
    {
        [AuthenticateApi]
        [Route("GetMyTask")]
        public Response GetMyTask(string Type,int CompID)
        {
            Response res = new Response();
            MyTaskApiRepo objRepo = new MyTaskApiRepo();
            DataTable Dt = new DataTable();
            try
            {
                IPrincipal threadPrincipal = Thread.CurrentPrincipal;
                string UID = threadPrincipal.Identity.Name;
                Dt = objRepo.GetMyTask(Type, CompID, 0, 0, 0, 0, Convert.ToInt32(UID), 0, 0, null, null);
                string data = JsonSerializer.SerializeTable(Dt);
                res.IsSuccess = true;
                res.Data = data; //"{\"Data\":" + data + ",\"Total\":" + Ds.Tables[1].Rows[0]["Total"] + "}";
                res.Message = "success";
                return res;
            }
            catch(Exception ex)
            {
                throw;
            }
        }

        [AuthenticateApi]
        [Route("GetDocDtl")]
        public Response GetDocDtl(int DocID)
        {
            Response res = new Response();
            MyTaskApiRepo objRepo = new MyTaskApiRepo();
            TaskRepo TReop = new TaskRepo();
            Ecompliance.Models.Task TModel = new Ecompliance.Models.Task();
            DataSet Ds = new DataSet();
            
            try
            {
                IPrincipal threadPrincipal = Thread.CurrentPrincipal;
                string UID = threadPrincipal.Identity.Name;
                Ds = objRepo.GetDocDtlForAPI(DocID);
                string strDashboardwrapper = "{";
                strDashboardwrapper += "Details:" + JsonSerializer.SerializeTable(Ds.Tables[0]);
                strDashboardwrapper += ",Movement:" + JsonSerializer.SerializeTable(Ds.Tables[1]);
                strDashboardwrapper += ",Attachment:" + JsonSerializer.SerializeTable(Ds.Tables[2]);
                strDashboardwrapper += "}";
                //string data = JsonSerializer.SerializeObject(TModel);
                res.IsSuccess = true;
                res.Data = strDashboardwrapper; //"{\"Data\":" + data + ",\"Total\":" + Ds.Tables[1].Rows[0]["Total"] + "}";
                res.Message = "success";
                return res;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        [AuthenticateApi]
        [Route("TaskSendToVerify")]
        [HttpPost]
        public Response TaskSendToVerify([FromBody] TaskVerifyVM TaskVerifyVM)
        {
            Response ret = new Response();
            TaskRepo TReop = new TaskRepo();
            Ecompliance.Models.Task TModel = new Ecompliance.Models.Task();
            DataTable Dt = new DataTable();
            try
            {
                IPrincipal threadPrincipal = Thread.CurrentPrincipal;
                string UID = threadPrincipal.Identity.Name;
                TaskVerifyVM.UID = Convert.ToInt32(UID);
                ret.Data = TReop.SendToVarify(TaskVerifyVM); //ret.GetResponse("Task", TaskM.DOCID.ToString(), Convert.ToInt32(obj.AddTask(TaskM)), "Task");
                ret.IsSuccess = true;
                return ret;
            }
            catch (Exception ex)
            {
                ret.Data = "-2";
                ret.IsSuccess = false;
                return ret;
            }
        }

        [AuthenticateApi]
        [Route("TaskReconsider")]
        [HttpPost]
        public Response TaskReconsider(string Remarks, int DocID)
        {
            Response ret = new Response();
            TaskRepo TReop = new TaskRepo();
            try
            {
                IPrincipal threadPrincipal = Thread.CurrentPrincipal;
                string UID = threadPrincipal.Identity.Name;
                if (Remarks != "")
                    ret.Data = TReop.Reconsider(Convert.ToInt32(UID), DocID, Remarks); //ret.GetResponse("Task", TaskM.DOCID.ToString(), Convert.ToInt32(obj.AddTask(TaskM)), "Task");
                else
                    ret.Data = "-3";

                ret.IsSuccess = true;
                return ret;
            }
            catch (Exception ex)
            {
                ret.Data = "-2";
                ret.IsSuccess = false;
                return ret;
            }
        }
    }
}