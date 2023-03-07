using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.Repository;
using Ecompliance.Utils;
using Ecompliance.ActionFilters;
using Ecompliance.CustomAttribute;
namespace Ecompliance.Areas.Admin.Controllers
{

    [CustomAuthActionFilter(Order = 0)]
    [CustomAuthrizationActionFilter(Order = 1)]
    [RouteArea("Admin")]
    public class ViewMenuController : Controller
    {
        // GET: Admin/Menu
         [ViewAction]
        [Route("ViewMenu", Name = "ViewMenu")]
        public ActionResult ViewMenu()
        {
            Role RoleM = new Role();
            RoleRepo RRepo = new RoleRepo();
            try
            {
                RoleM.RoleID = 0;
                RoleM.IsAct = true;
                RoleM.UID = ((User)Session["uBo"]).UID;
                ViewBag.DsRole = RRepo.GetRole(RoleM);
                return View();
            }
            catch
            { return View(); }
        }
         [ViewAction]
         [HttpGet]
        [Route("getMenu", Name = "getMenu")]
        public ActionResult getMenu(string MenuID)
        {
            MenuRepo obj = new MenuRepo();
            Response ret = new Response();
            try
            {
                ret.Data = JsonSerializer.SerializeTable(obj.GetMenu("0", Convert.ToInt32(MenuID)));
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
        [ADDUpdateAction]
        [ValidateAntiForgeryToken]
        [HttpPost]
        [Route("UpdatemenuRole", Name = "UpdatemenuRole")]
        public ActionResult UpdateMenuRole(string TID,string Role)
        {
            MenuRepo obj = new MenuRepo();
            Response ret = new Response();
            Menu objM = new Menu();
            try
            {
                objM.MenuID = Convert.ToInt32(TID);
                objM.Role = Role.Replace('-', ' ');
                ret = ret.GetResponse("Menu Role", objM.MenuID.ToString(), Convert.ToInt32(obj.UpdateMenuRoles(objM)));
                if (ret.IsSuccess)
                {
                    //Session["uMenu"] = null;
                }
            }
            catch (Exception ex)
            {
                ret.Message = ex.Message.ToString();
                ret.IsSuccess = false;
            }
            return Json(ret, JsonRequestBehavior.AllowGet);
        }
    }
}