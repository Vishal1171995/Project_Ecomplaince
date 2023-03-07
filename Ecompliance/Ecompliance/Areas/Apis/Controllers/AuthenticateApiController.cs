using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Ecompliance.Utils;
using Ecompliance.Areas.Admin;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.Repository;
using Ecompliance.ViewModel;
using Ecompliance.ActionFilters;

namespace Ecompliance.Areas.Apis.Controllers
{

    public class AuthenticateApiController : ApiController
    {
        // GET: api/AuthenticateApi
        [ValidateModel]
        public Response Get([FromUri] LoginVM ObjUVM)
        {
            Response res = new Response();
            try
            {
                UserRepo ObjURep = new UserRepo();
                User ObjU = new User();
                String Message = "";
                ObjU = ObjURep.Authenticate(ObjUVM, ref Message);
                if (Message == "success")
                {

                    res.Message = "Authenticated";
                    res.IsSuccess = true;
                    return res;
                }
                else
                {
                    res.Message = Message;
                    res.IsSuccess = false;
                    return res;
                }
            }
            catch { throw; }
        }

    }
}
