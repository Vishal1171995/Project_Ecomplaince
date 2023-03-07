using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Ecompliance.Areas.Master.Models;
using Ecompliance.Repository;
using System.Data;
using System.Security.Principal;
using System.Threading;
using Ecompliance.Utils;

namespace Ecompliance.Areas.Apis.Controllers
{
    public class CompanyController : ApiController
    {
        // GET: api/Company
        [AuthenticateApi]
        public Response Get()
        {
            Response res = new Response();
            try
            {
                IPrincipal threadPrincipal = Thread.CurrentPrincipal;
                string UID = threadPrincipal.Identity.Name;
                DataTable dt = new DataTable();
                //CompanyRepo CRepo = new CompanyRepo();
                //Company ObjM = new Company();
                //ObjM.CompanyID = 0;
                //ObjM.IsAct = true;
                //ObjM.UID = Convert.ToInt32(UID);
                dt = DashBoardRepo.GetMappedCompany(Convert.ToInt32(UID)); //CRepo.GetCompanyList(ObjM);
                string JsonResult = JsonSerializer.SerializeTable(dt);
                res.IsSuccess = true;
                res.Data = JsonResult;
                //List<Company> LstComp = new List<Company>();
                //for (int i = 0; i < dt.Rows.Count;i++ )
                //{
                //    ObjM = new Company();
                //    ObjM.Name =Convert.ToString(dt.Rows[i]["Name"]);
                //    ObjM.CompanyID = Convert.ToInt32(dt.Rows[i]["CompID"]);
                //    LstComp.Add(ObjM);
                //}
                return res;
            }
            catch
            { throw; }
            
        }

    }
}
