using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ecompliance.Areas.Admin.Models;
using System.Web.Routing;
using Ecompliance.Utils;

namespace Ecompliance.ActionFilters
{
    public class CustomAuthrizationActionFilter : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {

            User uBo=new User();
            //var AType=filterContext.ActionDescriptor.GetCustomAttributes()
            //This line of code  is for skiping filter logic for the action method that is addorn with SkipFilter
            if (filterContext.ActionDescriptor.GetCustomAttributes(typeof(Ecompliance.CustomAttribute.SkipAuthrization), false).Any())
                return;

            //Now Getting Action Type...Action Type Might be ADD UPDATE OR VIEW
            string ActionType = "";

            if (filterContext.ActionDescriptor.GetCustomAttributes(typeof(Ecompliance.CustomAttribute.ADDUpdateAction), false).Any())
                ActionType = "ADDUPDATE";

            if (filterContext.ActionDescriptor.GetCustomAttributes(typeof(Ecompliance.CustomAttribute.ViewAction), false).Any())
                ActionType = "VIEW";

            //Lets check its Authrization 
           if( HttpContext.Current.Session["Ubo"]!=null)
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

                var descriptor = filterContext.ActionDescriptor;
               var controllerName = descriptor.ControllerDescriptor.ControllerName;
               //Its Authenticated user now lets check its Authrisation
                IsAuthorized= CommanUtills.IsValidAction(controllerName, ActionType);
                if (IsAuthorized)
                    return;
               if (filterContext.HttpContext.Request.IsAjaxRequest())
               {

                   var res = new Response();
                   res = res.GetResponse("Authrization failed", "", -4);
                   var result = new JsonResult();
                   var json = res;
                   result.Data = json;
                   filterContext.Result = result;
                   return;
               }
               filterContext.Result = new RedirectToRouteResult(
                new RouteValueDictionary 
                { 
                    { "controller", "Error" }, 
                    { "action", "unauthorised" } ,
                    {"area",string.Empty }
                });
               return;
           }
           else
           {
             if (filterContext.HttpContext.Request.IsAjaxRequest())
                {
                    var  res = new Response();
                    res= res.GetResponse("Authentication failed", "", -3);
                    var result = new JsonResult();
                    
                    var json = res;
                    result.Data = json;
                    filterContext.Result = result;
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