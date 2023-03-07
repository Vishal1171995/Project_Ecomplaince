using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Ecompliance.Controllers
{
    public class ComplianceController : Controller
    {
        // GET: Compliance
        [Route("Controldocument")]
        public ActionResult Document()
        {
            ViewBag.Title = "Activity Document";
            return View();
        }
    }
}