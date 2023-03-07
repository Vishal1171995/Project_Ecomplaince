using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;
using Ecompliance.Repository;
using Ecompliance.ActionFilters;
using Ecompliance.Areas.Master.Models;

namespace Ecompliance.Controllers
{
    [CustomAuthActionFilter]
    public class MenuController : Controller
    {
        // GET: Menu
        [ChildActionOnly]
        public ActionResult RenderMenu()
        {
            try
            {
                DataTable dt = new DataTable();
                if(Session["uMenu"]==null)
                {
                    MenuRepo objM = new MenuRepo();
                    string userRole = ((Ecompliance.Areas.Admin.Models.User)Session["uBo"]).UserRole;
                    dt = objM.GetUserMenu(userRole);
                    Session["uMenu"] = dt;
                }
                else
                {
                    dt = (DataTable)Session["uMenu"];
                }
               
                return View(dt);
            }
            catch { throw; }
        }
    }
}