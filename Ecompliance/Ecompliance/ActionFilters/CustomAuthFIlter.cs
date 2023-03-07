using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace Ecompliance.ActionFilters
{
    public class CustomAuthActionFilter : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {

            
            if (HttpContext.Current.Session["Ubo"] == null)
            {
                if (filterContext.HttpContext.Request.IsAjaxRequest())
                {
                    //var res = new Response();
                    //res = res.GetResponse("Authentication failed", "", -3);
                    //var result = new JsonResult();
                    //var json = res;
                    //result.Data = json;
                    //filterContext.Result = result;
                    //return;
                    filterContext.Result = new JsonResult
                    {
                        Data = new
                        {
                            status = "401"
                        },
                        JsonRequestBehavior = JsonRequestBehavior.AllowGet
                    };

                    //xhr status code 401 to redirect
                    filterContext.HttpContext.Response.StatusCode = 401;

                    return;
                }
                filterContext.Result = new RedirectToRouteResult(
                new RouteValueDictionary 
                { 
                    { "controller", "Account" }, 
                    { "action", "Login" } ,
                    {"area",string.Empty }
                });
                return;
            }
        }
    }
}