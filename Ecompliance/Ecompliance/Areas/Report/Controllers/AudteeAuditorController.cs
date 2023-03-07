using Ecompliance.ActionFilters;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.Areas.Report.Models;
using Ecompliance.CustomAttribute;
using Ecompliance.Repository;
using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Ecompliance.Areas.Report.Controllers
{
    //[CustomAuthrizationActionFilter(Order = 1)]
    //[CustomAuthActionFilter(Order = 0)]
    public class AudteeAuditorController : Controller
    {
        // GET: Report/AudteeAuditor
       

        [HttpGet]
        [Route("GetConversation", Name = "GetConversation")]
        public PartialViewResult Conversation(int DocID)
        {
            Response res = new Response();
            SendToAuditorRepo sendToRepo = new SendToAuditorRepo();
            try
            {
                DataSet DsData = sendToRepo.GetCRMMSGData(DocID);
                return PartialView("~/Areas/Report/Views/AudteeAuditor/Conversation.cshtml", DsData);
            }
            catch
            {
                throw;
            }
        }
    }
}