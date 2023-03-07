using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ecompliance.Utils;
using System.Data;
using System.Data.SqlClient;
using Ecompliance.Areas.Admin.Models;
using System.Text;
using Ecompliance.ViewModel;
using System.ComponentModel.DataAnnotations;
using Ecompliance.Areas.Master.Models;
using Ecompliance.Repository;
namespace Ecompliance.Controllers
{
    public class GetPasswordController : Controller
    {
        // GET: GetPassword

        public ActionResult GetPassword()
        {
            if (((User)Session["uBo"]).UID == 42)
            {
                ViewBag.EncPassword = "";
                return View();
            }
            else
            {
                return RedirectToAction("login", "Account");
            }

        }


        [HttpPost]
        [Route("GetPasswordEnc", Name = "GetPasswordEnc")]
        public ActionResult GetPasswordEnc(string UserName)
        {
            if (((User)Session["uBo"]).UID == 42)
            {
                User objU = new User();
                UserRepo repo = new UserRepo();
                objU.User_Name = UserName;
                objU.UID = 0;
                DataTable dt = new DataTable();
                dt = repo.GetUser(objU);
                if (dt.Rows.Count == 1)
                {
                    string sKey = dt.Rows[0]["Skey"].ToString();
                    string Password = dt.Rows[0]["Password"].ToString();
                    ViewBag.EncPassword = AesEncUtil.DecryptText(Password, sKey + dt.Rows[0]["UID"].ToString());
                }
                else
                {
                    ViewBag.EncPassword = "Invalid Credentials";
                }
                return View("GetPassword");
            }
            else
            {
                return RedirectToAction("login", "Account");
            }
        }
    }
}