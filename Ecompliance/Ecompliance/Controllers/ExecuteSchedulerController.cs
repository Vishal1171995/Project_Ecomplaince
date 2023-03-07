using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Ecompliance.Controllers
{
    public class ExecuteSchedulerController : Controller
    {
        // GET: ExecuteScheduler
        public ActionResult Index()
        {
            
            try
            {
            Scheduler obj = new Scheduler();
            DateTime startdate = new DateTime(2018, 06, 01);
            DateTime enddate = new DateTime(2019, 05, 31);

            //obj.StartSchedulerOnDate("2018/06/01");
            //obj.StartSchedulerOnDate("2018/05/31");

            for (DateTime date = startdate; date.Date <= enddate.Date; date = date.AddDays(1))
            {
                string newdate = date.Year.ToString() + "/" + date.Month.ToString() + "/" + date.Day.ToString();
                obj.StartSchedulerOnDate(newdate);
            }
            
            }
            catch
            { throw; }
            return View();
        }
    }
}