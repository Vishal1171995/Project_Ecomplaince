using Ecompliance.ActionFilters;
using Ecompliance.Repository;
using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Ecompliance.Areas.Admin.Controllers
{

    [CustomAuthrizationActionFilter]
    [RouteArea("Admin")]
    public class RoleAssignmentController : Controller
    {
        // GET: Admin/RoleAssignment

        [Route("RoleAssignment", Name = "RoleAssignment")]
        public ActionResult RoleAssignment()
        {
            try
            {
                return View();
            }
            catch { throw; }
        }

        [Route("GetCustomers", Name = "GetCustomers")]
        public ActionResult GetCustomers(int UID)
        {
            Response ret = new Response();
            try
            {
                RoleAssignmentRepo ObjRoleRepo = new RoleAssignmentRepo();
                ret.Data = JsonSerializer.SerializeTable(ObjRoleRepo.GetCustomer(UID));
                ret.IsSuccess = true;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ret.IsSuccess = false;
                ret.Message = ex.Message;
                return Json(ret, JsonRequestBehavior.AllowGet);
            }
        }
    }



}