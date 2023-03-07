using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;
using Ecompliance.Repository;
using Ecompliance.ViewModel;
using System.Data.SqlClient;
using Ecompliance.Areas.Master.Models;
using System.ComponentModel.DataAnnotations;
using Ecompliance.Utils;

namespace Ecompliance.Controllers
{
    [RoutePrefix("document")]
    public class DataMigrationController : Controller
    {
        // GET: DataMigration
        [Route("DataMigration", Name = "DataMigration")]
        public ActionResult DataMigration()
        {
            return View();
        }
        [HttpPost]
        [Route("ExecteMigration", Name = "ExecteMigration")]
        public ActionResult ExecteMigration()
        {
            DataMigrationRepo objTaskrepo = new DataMigrationRepo();
            TaskVM objVM = new TaskVM();
            TaskVerifyVM TaskVerifyVM = new TaskVerifyVM();
            DataTable dt = new DataTable();
            string result = "";
            Response ret = new Response();
            SqlTransaction trans = null;
            SqlConnection con = null;
            try
            {
                dt = objTaskrepo.GetDataMigration();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    try
                    {
                        con = new SqlConnection(Ecompliance.Utils.DataLib.GetConnectionString());
                        if (!(con.State == ConnectionState.Open))
                        {
                            con.Open();
                        }
                        trans = con.BeginTransaction();
                        objVM.DOCID = 0;
                        objVM.ActID = Convert.ToInt32(dt.Rows[i]["ACTID"].ToString());
                        objVM.ActivityID = Convert.ToInt32(dt.Rows[i]["ACTIVITYID"].ToString());
                        objVM.ActivityType = dt.Rows[i]["ActivityType"].ToString();
                        objVM.CompanyID = Convert.ToInt32(dt.Rows[i]["CompID"].ToString());
                        objVM.ContractorID = 0;
                        objVM.CreatedBy = 26;
                        objVM.Creation_Desc = "Migrated From BPM";
                        objVM.SiteID = Convert.ToInt32(dt.Rows[i]["SiteID"].ToString());
                        objVM.Creation_Remarks = dt.Rows[i]["Remarks"].ToString();
                        objVM.ExpiryDate = Convert.ToDateTime(dt.Rows[i]["ExpiryDate"].ToString());
                        objVM.TaskCreationDate = dt.Rows[i]["Createdon"].ToString();
                        objVM.Freq = "";
                        int oldTid = Convert.ToInt32(dt.Rows[i]["DOCID"].ToString());
                        var results = new List<ValidationResult>();
                        var vc = new ValidationContext(objVM, null, null);
                        var isValid = Validator.TryValidateObject(objVM, vc, results, true);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                        string strerr = string.Join(" ", errors);
                        if (isValid)
                        {
                          string   Myresult = objTaskrepo.AddDataMigrationTask(objVM, con, trans, oldTid);
                          string[] arr = Myresult.Split(':');
                            int DOCID = 0;
                            int Maker = 0;
                            DOCID = Convert.ToInt32(arr[1]);
                            Maker = Convert.ToInt32(arr[0]);
                            DataTable dtDtl = new DataTable();
                            string strQry = "";
                            if (DOCID > 0)
                            {
                                if (dt.Rows[i]["CurStatus"].ToString() == "ARCHIVE")
                                {
                                    // Send To verify call-------------
                                    TaskVerifyVM.UID = Maker;
                                    TaskVerifyVM.DocID = DOCID;
                                    TaskVerifyVM.Remark = dt.Rows[i]["MakerRemarks"].ToString();
                                    strQry = "select top 1 CONVERT(char(10), fdate,102) AS fdate from Car24DTL where aprStatus='Pending Action From Maker' and DOCID=" + oldTid + " order by tid desc";
                                    dtDtl = DataLib.ExecuteDataTable(strQry, CommandType.Text, null);
                                    string ActivityCompDate = dtDtl.Rows[0]["fdate"].ToString();

                                    string cheker = objTaskrepo.SendToVarifyForMigration(TaskVerifyVM, ActivityCompDate,con,trans);

                                    if (Convert.ToInt32(cheker) > 0)
                                    {
                                        dtDtl = new DataTable();
                                        strQry = "select top 1 CONVERT(char(10), fdate,102) AS fdate,Atat from Car24DTL where aprStatus='Pending For Verifier' and DOCID=" + oldTid + " order by tid desc";
                                        dtDtl = DataLib.ExecuteDataTable(strQry, CommandType.Text, null);
                                        string CheckerRemark = Convert.ToString(dt.Rows[i]["CheckerRemarks"].ToString());
                                        string ActivityCompDate1 = dtDtl.Rows[0]["fdate"].ToString();
                                        string Atat = dtDtl.Rows[0]["Atat"].ToString();

                                        string Arc = objTaskrepo.ApproveForMigration(Convert.ToInt32(cheker), DOCID, CheckerRemark, ActivityCompDate1, Atat, con, trans);
                                        if (Arc == "1")
                                            trans.Commit();
                                        else
                                            trans.Rollback();
                                        continue;

                                    }
                                    else
                                    {
                                        trans.Rollback();
                                        continue;
                                    }

                                    //SendToVarifyForMigration
                                }
                                else if (dt.Rows[i]["CurStatus"].ToString() == "Pending For Verifier")
                                {
                                    // Send To verify call-------------
                                    TaskVerifyVM.UID = Maker;
                                    TaskVerifyVM.DocID = DOCID;
                                    TaskVerifyVM.Remark = dt.Rows[i]["MakerRemarks"].ToString();
                                    strQry = "select top 1 CONVERT(char(10), fdate,102) AS fdate from Car24DTL where aprStatus='Pending Action From Maker' and DOCID=" + oldTid + " order by tid desc";
                                    dtDtl = DataLib.ExecuteDataTable(strQry, CommandType.Text, null);
                                    string ActivityCompDate1 = dtDtl.Rows[0]["fdate"].ToString();

                                    string cheker1 = objTaskrepo.SendToVarifyForMigration(TaskVerifyVM, ActivityCompDate1, con, trans);
                                    if (Convert.ToInt32(cheker1) > 0)
                                    {
                                        trans.Commit();
                                    }
                                    else
                                        trans.Rollback();
                                    continue;

                                    //SendToVarifyForMigration
                                }
                                else if (dt.Rows[i]["CurStatus"].ToString() == "Pending Action From Maker")
                                {
                                    trans.Commit();
                                    continue;
                                }
                                else
                                {
                                    trans.Commit();
                                    ret.IsSuccess = false;
                                }
                            }
                            
                        }
                    }
                    catch(Exception Ex)
                    {
                        ret.IsSuccess = false;
                        string strMsg = Ex.Message;
                        if (trans != null)
                        {
                            trans.Rollback();
                        }
                        continue;
                    }
                    //Catch Start
                }
                
            }
            catch
            {
                throw;
            }
            finally
            {
                if (con != null)
                {
                    con.Close();
                    trans.Dispose();
                }
            }
            return Json(ret, JsonRequestBehavior.AllowGet);
        }

        [Route("MoveAttachment", Name = "MoveAttachment")]
        public ActionResult MoveAttachment()
        {
            DataMigrationRepo objTaskrepo = new DataMigrationRepo();
            DataTable dt = new DataTable();
            int result = 0;
            try
            {
                dt = objTaskrepo.GetAttachment();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    try
                    {
                        if (!string.IsNullOrEmpty(dt.Rows[i]["Attachment1"].ToString()))
                        {
                            if (MoveAtt(dt.Rows[i]["Attachment1"].ToString()) == "success")
                            {
                                result = objTaskrepo.InsertTaskFile_Migration(dt.Rows[i]["TID"].ToString(), dt.Rows[i]["Att1Desc"].ToString(), dt.Rows[i]["Attachment1"].ToString().Replace("98/", ""));
                            }
                        }
                    }
                    catch { }
                    try
                    {
                        if (!string.IsNullOrEmpty(dt.Rows[i]["Attachment2"].ToString()))
                        {
                            if (MoveAtt(dt.Rows[i]["Attachment2"].ToString()) == "success")
                            {
                                result = objTaskrepo.InsertTaskFile_Migration(dt.Rows[i]["TID"].ToString(), dt.Rows[i]["Att2Desc"].ToString(), dt.Rows[i]["Attachment2"].ToString().Replace("98/", ""));
                            }
                        }
                    }
                    catch { }
                    try
                    {
                        if (!string.IsNullOrEmpty(dt.Rows[i]["Attachment3"].ToString()))
                        {
                            if (MoveAtt(dt.Rows[i]["Attachment3"].ToString()) == "success")
                            {
                                result = objTaskrepo.InsertTaskFile_Migration(dt.Rows[i]["TID"].ToString(), dt.Rows[i]["Att3Desc"].ToString(), dt.Rows[i]["Attachment3"].ToString().Replace("98/", ""));
                            }
                        }
                    }
                    catch { }
                    try
                    {
                        if (!string.IsNullOrEmpty(dt.Rows[i]["Attachment4"].ToString()))
                        {
                            if (MoveAtt(dt.Rows[i]["Attachment4"].ToString()) == "success")
                            {
                                result = objTaskrepo.InsertTaskFile_Migration(dt.Rows[i]["TID"].ToString(), dt.Rows[i]["Att4Desc"].ToString(), dt.Rows[i]["Attachment4"].ToString().Replace("98/", ""));
                            }
                        }
                    }
                    catch { }
                    try
                    {
                        if (!string.IsNullOrEmpty(dt.Rows[i]["Attachment5"].ToString()))
                        {
                            if (MoveAtt(dt.Rows[i]["Attachment5"].ToString()) == "success")
                            {
                                result = objTaskrepo.InsertTaskFile_Migration(dt.Rows[i]["TID"].ToString(), dt.Rows[i]["Att5Desc"].ToString(), dt.Rows[i]["Attachment5"].ToString().Replace("98/", ""));
                            }
                        }
                    }
                    catch { }
                }
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch
            { throw; }
        }

        public string MoveAtt(string Attachment)
        {
            string result = "";
            string OlddirectoryPath1 = "";
            string NewDirectoryPath1 = "";
            try
            {
                if (!string.IsNullOrEmpty(Attachment))
                {
                    OlddirectoryPath1 = Server.MapPath("~/DOCS/" + Attachment + "");
                    NewDirectoryPath1 = Server.MapPath("~/Docs/Task/" + Attachment.Replace("98/", "") + "");
                    if (System.IO.File.Exists(OlddirectoryPath1))
                    {
                        System.IO.File.Copy(OlddirectoryPath1, NewDirectoryPath1);
                        result = "success";
                    }
                }
            }
            catch
            {
                result = "fail";
            }
            return result;
        }

    }
}