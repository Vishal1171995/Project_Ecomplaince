using Ecompliance.Repository;
using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Principal;
using System.Threading;
using System.Web.Http;

namespace Ecompliance.Areas.Apis.Controllers
{
    [RoutePrefix("SecureApis/Dashboard")]
    public class DashBoardApiController : ApiController
    {
         [AuthenticateApi]
        [Route("GetNeedToAct")]
        public Response GetNeedToAct(string CompanyID)
        {
            Response res = new Response();
            try
            {
                IPrincipal threadPrincipal = Thread.CurrentPrincipal;
                string UID1 = threadPrincipal.Identity.Name;
                DashboardApiRepo repo = new DashboardApiRepo();
                int UID = Convert.ToInt32(UID1);
                DataTable dt = repo.GetDashBoardHomeCount(UID, CompanyID, "", "", "", "");
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return res;

                // DataSet ds = new DataSet();
                //string strDashboardwrapper = "{";
                //strDashboardwrapper += "ProgressBar:" + JsonSerializer.SerializeTable(repo.GetDashBoardCompanyTot(CompanyID, SMonth, SYear, TMonth, TYear, UID));
                //strDashboardwrapper += ",NeedToAct:" + JsonSerializer.SerializeTable(repo.GetDashBoardHomeCount(UID));
                //strDashboardwrapper += ",SiteWise:" + JsonSerializer.SerializeTable(repo.GetDashBoardSiteWise(CompanyID, SMonth, SYear, TMonth, TYear, UID));
                //strDashboardwrapper += ",ColumnChart:" + JsonSerializer.SerializeObject(repo.GetDashBoardActWise(CompanyID, SMonth, SYear, TMonth, TYear, UID));
                //strDashboardwrapper += "}";

                    //res.Data = strDashboardwrapper;
                    //res.Message = "Success";
                    //res.IsSuccess = true;
                    //return res;
               
               
            }
            catch { throw; }
        }

        [AuthenticateApi]
        [Route("GetDashBoardCompanyWise")]
        public Response GetDashBoardCompanyWise(string CompanyID, string SMonth, string SYear, string TMonth, string TYear)
        {
            Response res = new Response();
            try
            {
                IPrincipal threadPrincipal = Thread.CurrentPrincipal;
                string UID1 = threadPrincipal.Identity.Name;
                DashboardApiRepo repo = new DashboardApiRepo();
                int UID = Convert.ToInt32(UID1);
                DataTable dt = repo.GetDashBoardCompanyTot(CompanyID, SMonth, SYear, TMonth, TYear, UID);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return res;


                // DataSet ds = new DataSet();
                //string strDashboardwrapper = "{";
                //strDashboardwrapper += "ProgressBar:" + JsonSerializer.SerializeTable(repo.GetDashBoardCompanyTot(CompanyID, SMonth, SYear, TMonth, TYear, UID));
                //strDashboardwrapper += ",NeedToAct:" + JsonSerializer.SerializeTable(repo.GetDashBoardHomeCount(UID));
                //strDashboardwrapper += ",SiteWise:" + JsonSerializer.SerializeTable(repo.GetDashBoardSiteWise(CompanyID, SMonth, SYear, TMonth, TYear, UID));
                //strDashboardwrapper += ",ColumnChart:" + JsonSerializer.SerializeObject(repo.GetDashBoardActWise(CompanyID, SMonth, SYear, TMonth, TYear, UID));
                //strDashboardwrapper += "}";

                //res.Data = strDashboardwrapper;
                //res.Message = "Success";
                //res.IsSuccess = true;
                //return res;


            }
            catch { throw; }
        }

        [AuthenticateApi]
        [Route("GetDashBoardSiteWise")]
        public Response GetDashBoardSiteWise(string CompanyID, string SMonth, string SYear, string TMonth, string TYear)
        {
            Response res = new Response();
            try
            {
                IPrincipal threadPrincipal = Thread.CurrentPrincipal;
                string UID1 = threadPrincipal.Identity.Name;
                DashboardApiRepo repo = new DashboardApiRepo();
                int UID = Convert.ToInt32(UID1);
                DataTable dt = repo.GetDashBoardSiteWise(CompanyID, SMonth, SYear, TMonth, TYear, UID);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return res;


                // DataSet ds = new DataSet();
                //string strDashboardwrapper = "{";
                //strDashboardwrapper += "ProgressBar:" + JsonSerializer.SerializeTable(repo.GetDashBoardCompanyTot(CompanyID, SMonth, SYear, TMonth, TYear, UID));
                //strDashboardwrapper += ",NeedToAct:" + JsonSerializer.SerializeTable(repo.GetDashBoardHomeCount(UID));
                //strDashboardwrapper += ",SiteWise:" + JsonSerializer.SerializeTable(repo.GetDashBoardSiteWise(CompanyID, SMonth, SYear, TMonth, TYear, UID));
                //strDashboardwrapper += ",ColumnChart:" + JsonSerializer.SerializeObject(repo.GetDashBoardActWise(CompanyID, SMonth, SYear, TMonth, TYear, UID));
                //strDashboardwrapper += "}";

                //res.Data = strDashboardwrapper;
                //res.Message = "Success";
                //res.IsSuccess = true;
                //return res;


            }
            catch { throw; }
        }

        [AuthenticateApi]
        [Route("GetDashBoardActWise")]
        public Response GetDashBoardActWise(string CompanyID, string SMonth, string SYear, string TMonth, string TYear)
        {
            Response res = new Response();
            try
            {
                IPrincipal threadPrincipal = Thread.CurrentPrincipal;
                string UID1 = threadPrincipal.Identity.Name;
                DashboardApiRepo repo = new DashboardApiRepo();
                int UID = Convert.ToInt32(UID1);
                DataTable dt = repo.GetDashBoardActWise(CompanyID, SMonth, SYear, TMonth, TYear, UID);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return res;


                // DataSet ds = new DataSet();
                //string strDashboardwrapper = "{";
                //strDashboardwrapper += "ProgressBar:" + JsonSerializer.SerializeTable(repo.GetDashBoardCompanyTot(CompanyID, SMonth, SYear, TMonth, TYear, UID));
                //strDashboardwrapper += ",NeedToAct:" + JsonSerializer.SerializeTable(repo.GetDashBoardHomeCount(UID));
                //strDashboardwrapper += ",SiteWise:" + JsonSerializer.SerializeTable(repo.GetDashBoardSiteWise(CompanyID, SMonth, SYear, TMonth, TYear, UID));
                //strDashboardwrapper += ",ColumnChart:" + JsonSerializer.SerializeObject(repo.GetDashBoardActWise(CompanyID, SMonth, SYear, TMonth, TYear, UID));
                //strDashboardwrapper += "}";

                //res.Data = strDashboardwrapper;
                //res.Message = "Success";
                //res.IsSuccess = true;
                //return res;


            }
            catch { throw; }
        }
    }
}