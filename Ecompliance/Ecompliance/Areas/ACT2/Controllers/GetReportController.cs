using Ecompliance.Areas.ACT2.Repository;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Mvc;

namespace Ecompliance.Areas.ACT2.Controllers
{
    
    public class GetReportController : ApiController
    {
          
        [System.Web.Http.HttpGet]
        public Response Get(string PayDate,int StateID,int CompanyID,int SiteID,int ActID,int ActivityID )
        {
            string EncodBase64 = "";
            Response ret = new Response();
            try
            {
                    ret.Data = "";
                    ret.IsSuccess = true;
                    User UBo = new Admin.Models.User();
                    //UBo = (User)Session["uBo"];
                    GenerateRepRepo objReportRepo = new GenerateRepRepo();
                    //EncodBase64 = objReportRepo.GenerateReport(PayDate,StateID,CompanyID,SiteID,ActID,ActivityID);
                    if (EncodBase64 == "")
                    {
                    ret.IsSuccess = false;
                    ret.Data = EncodBase64;
                    ret.Message = "Failed";
                    return ret;
                    }
                ret.IsSuccess = true;
                ret.Data = EncodBase64;
                ret.Message = "success";
                return ret;

            }
            catch
            {
                throw;
            }
        }

    }
}
