using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Filters;
using System.Web.Security;

namespace Ecompliance.Filter
{
    [AttributeUsage(AttributeTargets.Method, AllowMultiple = false, Inherited = true)]
    public class SetPermissionsAttribute : AuthorizeAttribute
    {
        /// <summary>
        /// The name of each action that must be permissible for this method, separated by a comma.
        /// </summary>
        //protected override bool AuthorizeCore(HttpContextBase httpContext)
        //{
        //    var isAuthorized = base.AuthorizeCore(httpContext);
        //    var authCookie = httpContext.Request.Cookies[FormsAuthentication.FormsCookieName];
        //    if (true)
        //    {
        //        //var authCookie = httpContext.Request.Cookies[FormsAuthentication.FormsCookieName];
        //        if (authCookie != null)
        //        {
        //            var authTicket = FormsAuthentication.Decrypt(authCookie.Value);
        //            var identity = new GenericIdentity(authTicket.Name, "Forms");
        //            var principal = new GenericPrincipal(identity, new string[] { });
        //            httpContext.User = principal;
        //        }
        //    }
        //    return isAuthorized;
        //}

        string superAdminRole = "SuperAdmin"; // can be taken from resource file or config file
        string adminRole = "Admin"; // can be taken from resource file or config file

        public void OnAuthentication(AuthenticationContext context)
        {
            if (context.HttpContext.User.Identity.IsAuthenticated &&(context.HttpContext.User.IsInRole(superAdminRole) || context.HttpContext.User.IsInRole(adminRole)))
            {
                // do nothing
            }
            else
            {
                context.Result = new HttpUnauthorizedResult(); // mark unauthorized
            }
        }

        public void OnAuthenticationChallenge(AuthenticationChallengeContext context)
        {
            if (context.Result == null || context.Result is HttpUnauthorizedResult)
            {
                context.Result = new RedirectToRouteResult("Default",
                    new System.Web.Routing.RouteValueDictionary{
                        {"controller", "Account"},
                        {"action", "Login"},
                        {"returnUrl", context.HttpContext.Request.RawUrl}
                    });
            }
        }

       
    }
}