using Ecompliance.ActionFilters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;
using Ecompliance.Utils;
using Ecompliance.Repository;
using Ecompliance.Areas.Admin.Models;

namespace Ecompliance.Controllers
{
    [CustomAuthActionFilter(Order = 0)]
    public class QuickStartController : Controller
    {
        // GET: QuickStart
        [Route("QuickStart", Name = "QuickStart")]
        public ActionResult QuickStart()
        {
            try
            {
                DataTable dt = new DataTable();
                QuickStartRepo ObjQRepo = new QuickStartRepo();
                dt = ObjQRepo.GetQuickStartStatus(((User)Session["uBo"]).UID);
                return View(dt);
            }
            catch { throw; }
        }
    }
}