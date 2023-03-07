using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Ecompliance.Areas.Master.Controllers
{
    [RouteArea("Master")]
    [RoutePrefix("Master")]
    public class MasterUtilsController : Controller
    {
        // GET: Master/MasterUtils
        [Route("RenderButton", Name = "RenderButton")]
        public ActionResult RenderButton(string ControllerName)
        {
            ViewBag.ControllerName = ControllerName;
            return View();
        }
    }
}