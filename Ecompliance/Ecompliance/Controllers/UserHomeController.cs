using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Ecompliance.Controllers
{
    public class UserHomeController : Controller
    {
        // GET: UserHome
        [Route("dashboard",Name="UserDashboard")]
        public ActionResult DashBoard()
        {
            try
            {
                return View();
            }
            catch 
            {
                throw;
            }
            
        }
    }
}