using Ecompliance.Areas.Admin.Models;
using Ecompliance.Repository;
using Ecompliance.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Security.Claims;
using System.Security.Principal;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;


using System.Net.Http;
using System.Web.Http.Controllers;

using System.Web.Http.ModelBinding;

namespace Ecompliance
{
    public class AuthenticateApi : AuthorizationFilterAttribute
    {  

  
        public override void OnAuthorization(HttpActionContext actionContext)
        {
           
                IEnumerable<string> ApiKeyHeaderUID = null;
                IEnumerable<string> ApiKeyHeaderPWD = null;

                if (actionContext.Request.Headers.TryGetValues("UserName", out ApiKeyHeaderUID) && actionContext.Request.Headers.TryGetValues("Password", out ApiKeyHeaderPWD))
                {
                    string UserName = ApiKeyHeaderUID.First().ToString();
                    string PWD = ApiKeyHeaderPWD.First().ToString();
                    // Validating header value must have both APP ID & APP key
                    if (UserName != "" && PWD != "")
                    {

                        UserRepo userrepo = new UserRepo();
                        LoginVM model = new LoginVM();
                        model.UserName = UserName;
                        model.Password = PWD;
                        User ObjU = new User();
                        String Message = "";
                        ObjU = userrepo.Authenticate(model, ref Message);
                        if (Message == "success")
                        {
                            var userNameClaim = new Claim(ClaimTypes.Name, ObjU.UID.ToString());
                            var identity = new ClaimsIdentity(new[] { userNameClaim }, "UID");
                            var principal = new ClaimsPrincipal(identity);
                            Thread.CurrentPrincipal = principal;

                            if (System.Web.HttpContext.Current != null)
                            {
                                System.Web.HttpContext.Current.User = principal;
                            }
                        }
                        else { actionContext.Response = actionContext.Request.CreateErrorResponse(HttpStatusCode.BadRequest,"Invalid UserName or Password !"); }
                    }
                    else { actionContext.Response = actionContext.Request.CreateErrorResponse(HttpStatusCode.BadRequest, "UserName or Password Missing!."); }
                   
                }

                else { actionContext.Response = actionContext.Request.CreateErrorResponse(HttpStatusCode.BadRequest, "UserName or Password Missing!."); }
               

                base.OnAuthorization(actionContext);
            
        }
     


    }
    public class BasicAuthenticationIdentity : GenericIdentity
    {
        public BasicAuthenticationIdentity(string name, string password)
            : base(name, "Basic")
        {
            this.Password = password;
        }

        /// <summary>
        /// Basic Auth Password for custom authentication
        /// </summary>
        public string Password { get; set; }
    }
}