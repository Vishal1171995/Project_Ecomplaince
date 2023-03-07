using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Ecompliance.Controllers
{
    public class ErrorController : Controller
    {
        // GET: Error
        [Route("unauthorised", Name = "unauthorised")]
        public ActionResult unauthorised()
        {
            try
            {
                return View();
            }
            catch { throw; }
        }

        [Route("exceptionhandler", Name = "exceptionhandler")]
        public ActionResult exceptionhandler()
        {
            try
            {
                return View();
            }
            catch { throw; }
        }
        [Route("unauthorisedForIP", Name = "unauthorisedForIP")]
        public ActionResult unauthorisedForIP()
        {
            try
            {
                return View();
            }
            catch { throw; }
        }
    }
}