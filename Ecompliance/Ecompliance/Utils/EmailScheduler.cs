using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Ecompliance.Utils;
using System.Data;
using Ecompliance.Repository;
using Ecompliance.ViewModel;
using System.Data.SqlClient;
using Ecompliance.Areas.Master.Models;
using System.ComponentModel.DataAnnotations;
using Quartz;
using System.Threading.Tasks;
using System.Threading;
using System.Text;

namespace Ecompliance.Utils
{
    public class EmailScheduler
    {
        private static int InsertEmailAlertLog(string Date, int TotalAlert = 0, string ToEmails = "", string CCEmail = "",string BCCEmail="", int Tid = 0, string AlertType = "Daly Maker Checker Alert")
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@TID", Tid),
                    new SqlParameter("@AlertType", AlertType),
                    new SqlParameter("@Date", Date),
                    new SqlParameter("@TotalAlert", TotalAlert),
                    new SqlParameter("@ToEmails", ToEmails),
                    new SqlParameter("@CCEmail", CCEmail),
                    new SqlParameter("@BCCEmail", BCCEmail),
                    //new SqlParameter("@SchedulerName", SchedulerName)
                };
                int tid = Convert.ToInt32(DataLib.ExecuteScaler("[AddUpdateEmailAlertLog]", CommandType.StoredProcedure, p));

                return tid;

            }
            catch { return 0; }
        }
        private static DataTable GetEmailAlert(string AlertType = "Daly Maker Checker Alert")
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@AlertType", AlertType),
                };
                return DataLib.ExecuteDataTable("[GetEmailAlert]", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }
        public static void DailylyMailScheduler()
        {

            SqlConnection con = null;
            int TotalAlert = 0;
            string ToEmails = "";
            string ccEmails = "";
            string bccEmails = "";
            int LogID = 0;
            string date = "";
            DataTable Dt = new DataTable();
            try
            {
                Dt = GetEmailAlert();
                if (Dt.Rows.Count == 0)
                {
                    date = DateTime.Now.Date.Day.ToString() + "/" + DateTime.Now.Month.ToString() + "/" + DateTime.Now.Year.ToString();
                    Task<int> LogTask = Task.Factory.StartNew<int>(() => InsertEmailAlertLog(date, 0, "", "", "", 0));

                    SqlParameter p = null;

                    DataSet ds = DataLib.ExecuteDataSet("GetLogForWeeklyMail", CommandType.StoredProcedure, null);

                    //Proceeding with Maker

                    string MailHeader = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">" +
                            "<html xmlns=\"http://www.w3.org/1999/xhtml\">" +
                            "<head>" +
                            "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />" +
                            "<title>Myndact Mailer</title>" +
                            "</head>" +
                            "<body>";
                    string MailFooter = "<footer style=\"width:996px; margin:auto;\">" +
                    "<div style=\"font-size:14px;font-family:arial;padding:5px 0px;font-family:arial;text-shadow: 1px 1px 8px #f6f6f4;color:#7a7556;\">Regards <br> MyndAct Team <div><img src=\"https://www.myndact.com/Content/images/a8.png\" /></div></div>" +
                    "</footer>";

                    DataTable dtMaker = ds.Tables[0];

                    DataTable dtPWithMaker = ds.Tables[2];

                    DataView dvCompl;
                    DataView dvNonCompl;
                    DataTable dtComp;
                    DataTable dtNonComp;
                    //Proceeding with Maker
                    for (int i = 0; i < dtMaker.Rows.Count; i++)
                    {
                        try
                        {
                            //Getting Complience count Task
                            dvCompl = new DataView(dtPWithMaker);
                            dvCompl.RowFilter = "UserID=" + dtMaker.Rows[i]["UID"] + " AND  ComStatus='Compliance'";

                            //Getting NonComplience count Task
                            dvNonCompl = new DataView(dtPWithMaker);
                            dvNonCompl.RowFilter = "UserID=" + dtMaker.Rows[i]["UID"] + " AND  ComStatus='NonCompliance'";

                            dtComp = new DataTable();
                            dtNonComp = new DataTable();
                            dtComp = dvCompl.ToTable();
                            dtNonComp = dvNonCompl.ToTable();
                            if (dtComp.Rows.Count > 0 || dtNonComp.Rows.Count > 0)
                            {
                                StringBuilder Sb = new StringBuilder();

                                Sb.Append("<header style=\"width:996px; margin:auto;\">");
                                Sb.Append("<div style=\"font-family:arial; color:#444; font-size:17px;\">");
                                Sb.Append("Dear Maker " + dtMaker.Rows[i]["First_Name"] + ",");
                                Sb.Append("</div>");
                                Sb.Append("</header>");

                                Sb.Append("<section style=\"width:996px; margin:auto;\">");
                                Sb.Append("<div style=\"color:#7a7556;font-size:14px;font-family:arial;text-shadow: 1px 1px 8px #f6f6f4;\"><p>Please find enclosed the daily status update from MyndAct. The summary of the same is as below :</p></div>");
                                Sb.Append("<div>");
                                Sb.Append("<ul>");
                                if (dtNonComp.Rows.Count > 0)
                                {
                                    Sb.Append("<li style=\"margin:5px 0px\">You have <span style=\"color:#FF0000;\">" + dtNonComp.Rows[0]["Total"] + "</span> Non Compliance task(s)</li>");
                                }
                                if (dtComp.Rows.Count > 0)
                                {
                                    Sb.Append("<li style=\"margin:5px 0px\">You have <span style=\"color:#FF0000;\">" + dtComp.Rows[0]["Total"] + "</span> task(s) which have become due for compliance.</li>");
                                }
                                Sb.Append("</ul>");
                                Sb.Append("</div>");
                                Sb.Append("<div style=\"color:#7a7556;font-size:14px;font-family:arial;text-shadow: 1px 1px 8px #f6f6f4;\"><p>Request you to take the necessary action, if any, so that the compliance task can be completed within stipulated time period.</p></div>");
                                Sb.Append("<div><a style=\"background-color:#54b9cd; color:#fff; border-radius:5px;text-align:center;padding:5px;text-decoration:none;\" href=\"http://myndact.com/?AspxAutoDetectCookieSupport=1\" target=\"_blank\">Click here to login to MyndAct </a></div>");
                                Sb.Append("<div style=\"color:#7a7556;font-size:14px;font-family:arial;text-shadow: 1px 1px 8px #f6f6f4;\"><p>Kindly also provide the details of show cause/ demand/ prosecution/ penalty notices, if any, received by you.</p></div>	");
                                Sb.Append("</section>");
                                string Bcc = "amit.nehra@myndsol.com,ajeet.kumar@myndsol.com,vinod.tiwary@myndsol.com,manoj.prasad@myndsol.com";
                                string Subject = "Daily status update from MyndAct";
                                string ToEmail = dtMaker.Rows[i]["Email"].ToString().Trim();
                                StringBuilder Mailbody = new StringBuilder();
                                Mailbody.Append(MailHeader).Append(Sb.ToString()).Append(MailFooter).Append("</body></html>");
                                MailUtill.SendMail(ToEmail, Subject, Mailbody.ToString(), "", "", Bcc);
                                TotalAlert++;
                                if (ToEmails == "")
                                    ToEmails = ToEmail;
                                else
                                    ToEmails = ToEmails + "," + ToEmail;
                                bccEmails = Bcc;
                            }

                        }
                        catch { }
                    }


                    DataTable dtChecker = ds.Tables[1];

                    DataTable dtPWithChecker = ds.Tables[3];

                    //Proceeding with Maker
                    for (int i = 0; i < dtChecker.Rows.Count; i++)
                    {
                        try
                        {
                            //Getting Complience count Task
                            dvCompl = new DataView(dtPWithChecker);
                            dvCompl.RowFilter = "UserID=" + dtChecker.Rows[i]["UID"] + " AND  ComStatus='Compliance'";

                            //Getting NonComplience count Task
                            dvNonCompl = new DataView(dtPWithChecker);
                            dvNonCompl.RowFilter = "UserID=" + dtChecker.Rows[i]["UID"] + " AND  ComStatus='NonCompliance'";

                            dtComp = new DataTable();
                            dtNonComp = new DataTable();
                            dtComp = dvCompl.ToTable();
                            dtNonComp = dvNonCompl.ToTable();
                            if (dtComp.Rows.Count > 0 || dtNonComp.Rows.Count > 0)
                            {
                                StringBuilder Sb = new StringBuilder();

                                Sb.Append("<header style=\"width:996px; margin:auto;\">");
                                Sb.Append("<div style=\"font-family:arial; color:#444; font-size:17px;\">");
                                Sb.Append("Dear Checker " + dtChecker.Rows[i]["First_Name"] + ",");
                                Sb.Append("</div>");
                                Sb.Append("</header>");

                                Sb.Append("<section style=\"width:996px; margin:auto;\">");
                                Sb.Append("<div style=\"color:#7a7556;font-size:14px;font-family:arial;text-shadow: 1px 1px 8px #f6f6f4;\"><p>Please find enclosed the daily status update from MyndAct. The summary of the same is as below :</p></div>");
                                Sb.Append("<div>");
                                Sb.Append("<ul>");
                                if (dtNonComp.Rows.Count > 0)
                                {
                                    Sb.Append("<li style=\"margin:5px 0px\">You have <span style=\"color:#FF0000;\">" + dtNonComp.Rows[0]["Total"] + "</span> Non Compliance task(s)</li>");
                                }
                                if (dtComp.Rows.Count > 0)
                                {
                                    Sb.Append("<li style=\"margin:5px 0px\">You have <span style=\"color:#FF0000;\">" + dtComp.Rows[0]["Total"] + "</span> task(s) which have become due for compliance.</li>");
                                }
                                Sb.Append("</ul>");
                                Sb.Append("</div>");
                                Sb.Append("<div style=\"color:#7a7556;font-size:14px;font-family:arial;text-shadow: 1px 1px 8px #f6f6f4;\"><p>Request you to take the necessary action, if any, so that the compliance task can be completed within stipulated time period.</p></div>");
                                Sb.Append("<div><a style=\"background-color:#54b9cd; color:#fff; border-radius:5px;text-align:center;padding:5px;text-decoration:none;\" href=\"http://myndact.com/?AspxAutoDetectCookieSupport=1\" target=\"_blank\">Click here to login to MyndAct </a></div>");
                                Sb.Append("<div style=\"color:#7a7556;font-size:14px;font-family:arial;text-shadow: 1px 1px 8px #f6f6f4;\"><p>Kindly also provide the details of show cause/ demand/ prosecution/ penalty notices, if any, received by you.</p></div>	");
                                Sb.Append("</section>");
                                string Bcc = "amit.nehra@myndsol.com,ajeet.kumar@myndsol.com,vinod.tiwary@myndsol.com,manoj.prasad@myndsol.com";
                                string Subject = "Daily status update from MyndAct";
                                string ToEmail = dtChecker.Rows[i]["Email"].ToString().Trim();
                                StringBuilder Mailbody = new StringBuilder();
                                Mailbody.Append(MailHeader).Append(Sb.ToString()).Append(MailFooter).Append("</body></html>");
                                MailUtill.SendMail(ToEmail, Subject, Mailbody.ToString(), "", "", Bcc);
                                TotalAlert++;
                                if (ToEmails == "")
                                    ToEmails = ToEmail;
                                else
                                    ToEmails = ToEmails + "," + ToEmail;
                                bccEmails = Bcc;
                            }

                        }
                        catch { }
                    }
                    Task.WhenAll(LogTask);
                    LogID = LogTask.Result;
                    InsertEmailAlertLog(date, TotalAlert, ToEmails, ccEmails, bccEmails, LogID);
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
                }
            }

        }
    }
}