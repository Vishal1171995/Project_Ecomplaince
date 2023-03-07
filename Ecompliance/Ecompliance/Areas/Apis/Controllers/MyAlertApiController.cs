using Ecompliance.Repository;
using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Ecompliance.ActionFilters;
using System.Security.Principal;
using System.Threading;

namespace Ecompliance.Areas.Apis.Controllers
{
    public class MyAlertApiController : ApiController
    {
        // GET: Apis/MyAlertApi
        [AuthenticateApi]
        public Response Get(string Type)
        {
            Response res = new Response();
            TaskRepo objRepo = new TaskRepo();
            DataSet Ds = new DataSet();
            try
            {
                IPrincipal threadPrincipal = Thread.CurrentPrincipal;
                string UID = threadPrincipal.Identity.Name;
                if (Type != "AsNeeded")
                {
                    Ds = objRepo.GetDocTaskGrid(Type, Convert.ToInt32(UID), 0, 0, null, null);
                }
                else
                {
                    Ds = objRepo.GetMyAsNeeded(Convert.ToInt32(UID), 0, 0, null, null);
                }
                string data = JsonSerializer.SerializeTable(Ds.Tables[0]);
                res.IsSuccess = true;
                res.Data = "{\"Data\":" + data + ",\"Total\":" + Ds.Tables[1].Rows[0]["TotalCount"] + "}";
                res.Message = "success";
                return res;
            }
            catch (Exception ex)
            {
                throw;
            }
        }
    }
}