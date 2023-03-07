using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ecompliance.Utils;

namespace Ecompliance.Controllers
{
    public class TestController : Controller
    {
        // GET: Test
        public ActionResult CheckEmail()
        {
            //return RedirectToAction("Login", "Account");
            try
            {
                //Scheduler Obj = new Scheduler();
                ////Obj.AlertToTaskScheduler();
                ////AlertToTaskScheduler
                //string str = MailUtill.SendMail("ajeet.kumar@myndsol.com,ravi.sharma@myndsol.com", "Deployment", "Deployment", "ajeet.kumar@myndsol.com,ravi.sharma@myndsol.com", "", "ajeet.kumar@myndsol.com,ravi.sharma@myndsol.com");
                //ViewBag.Mesage = "Success:<br/>" + str;
                //try
                //{
                //    //string sKey = dt.Rows[0]["Skey"].ToString();
                //    //string Password = dt.Rows[0]["Password"].ToString();
                //    //ViewBag.EncPassword = AesEncUtil.DecryptText(Password, sKey + dt.Rows[0]["UID"].ToString());
                //    string SqlQry = "select UID,password,SKey from Ecom_MST_USER where  password is not null";
                //   DataTable dt= DataLib.ExecuteDataTable(SqlQry, CommandType.Text, null);
                //    for(int i=0;i<dt.Rows.Count;i++)
                //    {
                //        try
                //        {
                //            string sKey = dt.Rows[i]["Skey"].ToString();
                //            string Password = dt.Rows[i]["Password"].ToString();
                //            string OrgPassword = AesEncUtil.DecryptText(Password, sKey + dt.Rows[i]["UID"].ToString());
                //            var HshLib=new HashingLib();
                //            string HashedPass = HashingLib.GenerateSHA512String(OrgPassword);
                //            string UpdateString = "update Ecom_MST_USER Set PasswordHashed='" + HashedPass + "' where UID=" + dt.Rows[i]["UID"].ToString();
                //            int dbRes = DataLib.ExecuteNonQuery(UpdateString, CommandType.Text, null);
                //        }
                //        catch
                //        {

                //        }

                //    }

                //}
                //catch
                //{

                //}
                try
                {
                    //string sKey = dt.Rows[0]["Skey"].ToString();
                    //string Password = dt.Rows[0]["Password"].ToString();
                    //ViewBag.EncPassword = AesEncUtil.DecryptText(Password, sKey + dt.Rows[0]["UID"].ToString());
                    string SqlQry = "select His.TID,His.UID,His.Password,U.Skey from Ecom_mst_PasswordHistory His inner join Ecom_MST_User U ON U.UID=His.UID";
                    DataTable dt1 = DataLib.ExecuteDataTable(SqlQry, CommandType.Text, null);
                    for (int i = 0; i < dt1.Rows.Count; i++)
                    {
                        try
                        {
                            string sKey = dt1.Rows[i]["Skey"].ToString();
                            string Password = dt1.Rows[i]["Password"].ToString();
                            string OrgPassword = AesEncUtil.DecryptText(Password, sKey + dt1.Rows[i]["UID"].ToString());
                            var HshLib = new HashingLib();
                            string HashedPass = HashingLib.GenerateSHA512String(OrgPassword);
                            string UpdateString = "update Ecom_mst_PasswordHistory Set HashedPassword='" + HashedPass + "' where TID=" + dt1.Rows[i]["TID"].ToString();
                            int dbRes = DataLib.ExecuteNonQuery(UpdateString, CommandType.Text, null);
                        }
                        catch
                        {

                        }

                    }

                }
                catch
                {

                }

                //select His.TID,His.UID,His.Password from Ecom_mst_PasswordHistory His inner join Ecom_MST_User U ON U.UID=His.UID

                return View();
            }
            catch (Exception Ex)
            {
                ViewBag.Mesage = "Success:<br/>" + Ex.Message;
                return View();
            }
        }
    }
}