using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ecompliance.Repository;
using System.Web.Routing;
using Ecompliance.Utils;

namespace Ecompliance.Exception1
{
    public  class ExceptionHandlerAttribute : HandleErrorAttribute
    {
        public override void OnException(ExceptionContext filterContext)
        {
            LogErrorRepo objRepo = new LogErrorRepo();
            filterContext.ExceptionHandled = true;
            var controllerName = (string)filterContext.RouteData.Values["controller"];
                var actionName = (string)filterContext.RouteData.Values["action"];
                var model = new HandleErrorInfo(filterContext.Exception, controllerName, actionName);
                //filterContext.Result = new ViewResult
                //{
                //    ViewName = View,
                //    MasterName = Master,
                //    ViewData = new ViewDataDictionary(model),
                //    TempData = filterContext.Controller.TempData
                //};
            //}

            // log the error by using your own method
            objRepo.LogError(controllerName,actionName,filterContext.Exception.Message);
            if (filterContext.HttpContext.Request.IsAjaxRequest())
            {
                var res = new Response();
                res = res.GetResponse("Exception throw", "", -5);
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
                    { "action", "exceptionhandler" } ,
                    {"area",string.Empty }
                });
            return;

            //HttpContext httpContext = HttpContext.Current;
            //RequestContext requestContext = ((MvcHandler)httpContext.CurrentHandler).RequestContext;
            //if (requestContext.HttpContext.Request.IsAjaxRequest())
            //{
            //    IControllerFactory factory = ControllerBuilder.Current.GetControllerFactory();
            //    IController controller = factory.CreateController(requestContext, controllerName);
            //    ControllerContext controllerContext = new ControllerContext(requestContext, (ControllerBase)controller);

            //    JsonResult jsonResult = new JsonResult();
            //    jsonResult.Data = new { success = false, serverError = "500" };
            //    jsonResult.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            //    jsonResult.ExecuteResult(controllerContext);
            //    httpContext.Response.End();
            //    //string Error = httpContext.Error.ToString();
            //}
            //filterContext.ExceptionHandled = true;
            //filterContext.HttpContext.Response.Clear();
            //filterContext.HttpContext.Response.StatusCode = 500;
            //filterContext.HttpContext.Response.TrySkipIisCustomErrors = true;
        }

    }
}