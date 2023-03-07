using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.Repository;
using Ecompliance.Utils;
using Ecompliance.ActionFilters;
namespace Ecompliance.Areas.Admin.Controllers
{
    [CustomAuthrizationActionFilter]
    [RouteArea("Admin")]
    public class RoleController : Controller
    {
        // GET: Admin/Role
        [Route("Role", Name = "ViewRole")]
        public ActionResult Role()
        {
            try
            {
                return View();
            }
            catch { throw; }
        }

        [HttpPost]
        [Route("createRole", Name = "createRole")]
        public ActionResult createRole(Role RoleM)
        {
            //var model = db.ClientMessages.Where(x => x.Name.Contains(Vm.Name));
            //string result = "";
            RoleRepo obj = new RoleRepo();
            Response ret = new Response();
            if (ModelState.IsValid)
            {
                try
                {
                    //result = obj.AddUpdateRole(RoleM);
                    ret = ret.GetResponse("Role", RoleM.RoleID.ToString(), Convert.ToInt32(obj.AddUpdateRole(RoleM)), "Role");
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
                catch (Exception ex)
                {
                    ret = ret.GetResponse("Role", "", -2);
                    return Json(ret, JsonRequestBehavior.AllowGet);
                }
                
            }
            else
            {
                return View(RoleM);
            }

        }
        [Route("getRole", Name = "getRole")]
        public ActionResult getRole(string RoleID)
        {
            RoleRepo obj = new RoleRepo();
            Role objModel = new Role();
            Response ret = new Response();
            try
            {
                objModel.RoleID = Convert.ToInt32(RoleID);
                objModel.IsAct = false;
                ret.Data = JsonSerializer.SerializeTable(obj.GetRole(objModel).Tables[0]);
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