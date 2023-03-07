using Ecompliance.Areas.Admin.Models;
using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace Ecompliance.ActionFilters
{
    public class IPRangeActionFilter : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {

            User uBo = new User();

            //Lets check IP Range validation
            if (HttpContext.Current.Session["Ubo"] != null)
            {
                bool IsAuthorized = false;
                uBo = (User)HttpContext.Current.Session["Ubo"];
                // validate IP Address.....................................
                IsAuthorized = CommanUtills.IsValidIpAddress(uBo.UID);
                if (!IsAuthorized)
                {
                    HttpContext.Current.Session.Clear();
                    HttpContext.Current.Session.Abandon();
                    HttpContext.Current.Session.RemoveAll();

                    if (HttpContext.Current.Request.Cookies["ASP.NET_SessionId"] != null)
                    {
                        HttpContext.Current.Response.Cookies["ASP.NET_SessionId"].Value = string.Empty;
                        HttpContext.Current.Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddMonths(-20);
                    }
                    if (filterContext.HttpContext.Request.IsAjaxRequest())
                    {
                        filterContext.Result = new JsonResult
                        {
                            Data = new
                            {
                                status = "403"
                            },
                            JsonRequestBehavior = JsonRequestBehavior.AllowGet
                        };
                        filterContext.HttpContext.Response.StatusCode = 403;
                        return;
                    }
                    filterContext.Result = new RedirectToRouteResult(
                     new RouteValueDictionary
                     {
                    { "controller", "Error" },
                    { "action", "unauthorisedForIP" } ,
                    {"area",string.Empty }
                     });
                    return;
                }
                //=================End validate IP Address=========================================


            }
        }
    }
}