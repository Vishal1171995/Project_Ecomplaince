using Ecompliance.Areas.Master.Models;
using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Hosting;
using System.ComponentModel.DataAnnotations;
using System.IO;
using System.Web.Mvc;
using Ecompliance.Areas.ACT2.ViewModel;
using Ecompliance.Areas.Admin.Models;
using System.Text;
using System.Configuration;
using System.Web.UI;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.html.simpleparser;
using System.Globalization;
using System.Web.UI.WebControls;
using System.Drawing;
using Ecompliance.Areas.ACT2.Models;

namespace Ecompliance.Areas.ACT2.Repository
{
    public class GenerateRepRepo
    {
       public   struct Reportdata
        {
            public string Base64string;
            public string FileName;
        }
        public Reportdata GenerateReport(string PayDate, int StateID, int CompanyID, int SiteID, int ActID, int ActivityID)
        {
            Reportdata RP;
            RP.Base64string = "";
            RP.FileName = "";
            try
            {
                string MQRY = "";
                DataSet dsdata = new DataSet();
                DataSet dsSendType=new DataSet();
                 MQRY = "SELECT distinct  s.state[Sid], st.Name [State], s.location [locationid], l.Name [Location], s.company [companyid], c.Code, c.Name, s.site_code, s.Name [Site Name], s.Address , REPLACE(RIGHT(CONVERT(VARCHAR(11), m.paydate , 106), 8), ' ', ', ') [Month] from Ecom_Mst_Site s with(nolock) inner join Ecom_Mst_State st with(nolock) on s.State = st.StateID  inner join Ecom_Mst_Company c with(nolock) on s.Company = c.CompID  left join Ecom_Mst_Location l with(nolock) on s.Location = l.LocationID inner join Ecom_muster_rolldata m with(nolock) on s.Site_Code = m.Site_Code and m.Company_Code = c.Code where st.StateID = " + StateID + " and s.company =  " + CompanyID + " and s.siteid = " + SiteID + " and m.paydate='" + PayDate + "'  and s.eff_date_fr <='" + PayDate + "' and s.eff_date_to >='" + PayDate + "' order by st.name, Location, c.Name ";
                dsdata=DataLib.ExecuteDataSet(MQRY,CommandType.Text,null);
                string Pdffile = "";

                for (int q = 0; q <= dsdata.Tables[0].Rows.Count - 1; q++)
                {
                    string StrQry = "";
                                          
                    StrQry = "select tid, template_name[Rcode], report_desc[Rdesc], format, qry, SQL_CHILDITEM from ecom_Print_Template with(nolock) where HUB =" + StateID + " AND ActID =" + ActID + " AND ActivityID =" + ActivityID + "";

                    //da.SelectCommand.CommandText = "select tid,template_name[Rcode],report_desc[Rdesc],format,qry from ecom_Print_Template with(nolock) where  HUB  =" + ds1.Tables("data").Rows(q).Item(0).ToString;
                    DataTable dt = new DataTable();
                    dt.Rows.Clear();
                    dt=DataLib.ExecuteDataTable(StrQry,CommandType.Text,null);

                    for (int r = 0; r <= dt.Rows.Count - 1; r++)
                    {
                        DataSet ds = new DataSet();
                        if (dt.Rows[r]["format"].ToString() == "1") {
                            DataSet dsTdata = new DataSet();
                            DataSet dsEdata = new DataSet();
                            string TdataQuery = "select * from Ecom_Print_Template with(nolock) where tid = " + dt.Rows[r]["tid"];
                            dsTdata = DataLib.ExecuteDataSet(TdataQuery, CommandType.Text, null);
                            string ReportType = "";
                            ReportType = dsTdata.Tables[0].Rows[0]["SendType"].ToString();
                            RP.FileName = dsTdata.Tables[0].Rows[0]["report_desc"].ToString();
                            string Sqry = "";
                            Sqry = "SELECT distinct l.Name [Location], s.company [companyid], c.Code, c.Name,s.site_code, s.Name [Site Name] from Ecom_Mst_Site s with(nolock) inner join Ecom_Mst_State st with(nolock) on s.State = st.StateID inner join Ecom_Mst_Company c with(nolock) on s.Company = c.CompID left join Ecom_Mst_Location l with(nolock) on s.Location = l.LocationID inner join Ecom_muster_rolldata m with(nolock) on s.Site_Code = m.Site_Code and m.Company_Code = c.Code where  m.site_code ='"
                                        + dsdata.Tables[0].Rows[q]["site_code"].ToString() + "' and m.company_code = '"
                                        + dsdata.Tables[0].Rows[q]["Code"].ToString() + "' and m.paydate='"
                                        + PayDate + "'";
                            dsEdata = DataLib.ExecuteDataSet(Sqry, CommandType.Text, null);
                            using (MemoryStream memoryStream = new MemoryStream())
                            {

                                Document document = new Document(new iTextSharp.text.Rectangle(850.0F, 1100.0F));
                                if (dsTdata.Tables[0].Rows[0]["view_type"].ToString() == "L")
                                {
                                    document.SetPageSize(iTextSharp.text.PageSize.LEGAL_LANDSCAPE.Rotate());
                                }
                                //PdfWriter.GetInstance(document, new FileStream(path + "/" + dt.Rows[r]["Rdesc"].ToString() + ".pdf", FileMode.Create));
                                PdfWriter.GetInstance(document, memoryStream);

                                DataSet dsNqry = new DataSet();
                                string MainQry = "";
                                string ChildQry = "";
                                string Rqry = "";
                                MainQry = dt.Rows[r]["qry"].ToString();
                                ChildQry = dt.Rows[r]["SQL_CHILDITEM"].ToString();
                                string Nqry = "select distinct company_code[CustCode],site_code[SiteCode],employee_code[ecode] from ecom_muster_roll" +
                                "data with(nolock) where site_code='"
                                            + dsdata.Tables[0].Rows[q]["site_code"].ToString() + "' and Company_Code ='"
                                            + dsdata.Tables[0].Rows[q]["Code"].ToString() + "' and paydate = '"
                                            + PayDate + "'";
                                dsNqry = DataLib.ExecuteDataSet(Nqry, CommandType.Text, null);
                                if (dsNqry.Tables[0].Rows.Count == 0)
                                {
                                    // TODO: Continue For... Warning!!! not translated
                                    //continue;
                                }
                                for (int m = 0; m <= dsNqry.Tables[0].Rows.Count - 1; m++)
                                {
                                    DataSet dsmain = new DataSet();
                                    string body = dsTdata.Tables[0].Rows[0]["body"].ToString();
                                    SqlParameter[] MainP = new SqlParameter[]
                                    {   new SqlParameter("@companycode",dsdata.Tables[0].Rows[q]["Code"].ToString()),
                                    new SqlParameter("@sitecode", dsNqry.Tables[0].Rows[m]["SiteCode"].ToString()),
                                    new SqlParameter("@ecode",dsNqry.Tables[0].Rows[m]["ecode"].ToString()),
                                    new SqlParameter("@PayDate", PayDate)
                                     };
                                    Rqry = DataLib.ExecuteScaler(MainQry.Trim(), CommandType.StoredProcedure, MainP);
                                    dsmain = DataLib.ExecuteDataSet(Rqry, CommandType.Text, null);
                                    document.Open();
                                    if (dsmain.Tables[0].Rows.Count < 1)
                                    {
                                        dsmain.Tables[0].Rows.Clear();
                                        document.Add(new Paragraph("No Leave Data Found"));

                                    }
                                    //  FOR MULTIPLE ROWS 01/11/2017
                                    if (ChildQry == "")
                                    {
                                        if (dsmain.Tables[0].Rows.Count > 0)
                                        {
                                            for (int j = 0; j <= dsmain.Tables[0].Columns.Count - 1; j++)
                                            {
                                                body = body.Replace("[" + dsmain.Tables[0].Columns[j].ColumnName + "]", dsmain.Tables[0].Rows[0][j].ToString());
                                            }

                                            StringBuilder _strRepeater = new StringBuilder(body);
                                            Html32TextWriter _ObjHtm = new Html32TextWriter(new System.IO.StringWriter(_strRepeater));
                                            string _str = _strRepeater.ToString();
                                            // document.Open();
                                            List<IElement> htmlarraylist = iTextSharp.text.html.simpleparser.HTMLWorker.ParseToList(new StringReader(_str), null);
                                            for (int i = 0; i <= htmlarraylist.Count - 1; i++)
                                            {
                                                //document.Add(DirectCast, htmlarraylist(i), IElement);
                                                document.Add((IElement)htmlarraylist[i]);
                                            }

                                            document.NewPage();
                                        }
                                        dsmain.Tables[0].Rows.Clear();
                                    }
                                    else {
                                        if (dsmain.Tables[0].Rows.Count > 0)
                                        {
                                            for (int j = 0; j <= dsmain.Tables[0].Columns.Count - 1; j++)
                                            {
                                                body = body.Replace("[" + dsmain.Tables[0].Columns[j].ColumnName + "]", dsmain.Tables[0].Rows[0][j].ToString());
                                            }
                                        }
                                        DataSet dschild = new DataSet();
                                        string Qry = "";
                                        SqlParameter[] ChildP = new SqlParameter[]
                                    {   new SqlParameter("@companycode",dsdata.Tables[0].Rows[q]["Code"].ToString()),
                                    new SqlParameter("@sitecode", dsNqry.Tables[0].Rows[m]["SiteCode"].ToString()),
                                    new SqlParameter("@ecode",dsNqry.Tables[0].Rows[m]["ecode"].ToString()),
                                    new SqlParameter("@PayDate", PayDate)
                                     };
                                        Qry = DataLib.ExecuteScaler(ChildQry.Trim(), CommandType.StoredProcedure, ChildP);
                                        dschild = DataLib.ExecuteDataSet(Qry, CommandType.Text, null);
                                        //if ((dschild.Tables[0].Rows.Count == 0))
                                        //{
                                        //    // TODO: Continue For... Warning!!! not translated
                                        //}
                                        if (dschild.Tables[0].Rows.Count > 0)
                                        {
                                            string strChildItem = "";
                                            strChildItem = "<div><table width='100%' border='0.5' text-align='center'  >";
                                            for (int i = 0; i <= dschild.Tables[0].Rows.Count; i++)
                                            {
                                                strChildItem += "<tr>";
                                                for (int j = 0; j <= dschild.Tables[0].Columns.Count - 1; j++)
                                                {
                                                    if ((j == 0))
                                                    {
                                                        strChildItem += "<td width='45' style='width:10;text-align:center'>";
                                                    }
                                                    else {
                                                        strChildItem += "<td style='text-align:center'>";
                                                    }

                                                    if ((i == 0))
                                                    {
                                                        strChildItem += dschild.Tables[0].Columns[j].ColumnName;
                                                    }
                                                    else {
                                                        strChildItem += dschild.Tables[0].Rows[i - 1][j].ToString();
                                                    }

                                                    strChildItem += "</td>";
                                                }

                                                strChildItem += "</tr>";
                                            }

                                            strChildItem += "</table></div>";
                                            body = body.Replace("[child item]", strChildItem);
                                            StringBuilder _strRepeater = new StringBuilder(body);
                                            Html32TextWriter _ObjHtm = new Html32TextWriter(new System.IO.StringWriter(_strRepeater));
                                            string _str = _strRepeater.ToString();
                                            document.Open();
                                            List<IElement> htmlarraylist = iTextSharp.text.html.simpleparser.HTMLWorker.ParseToList(new StringReader(_str), null);
                                            for (int i = 0; i <= htmlarraylist.Count - 1; i++)
                                            {
                                                document.Add((IElement)htmlarraylist[i]);
                                            }

                                            document.NewPage();
                                        }
                                        dsmain.Tables[0].Rows.Clear();
                                        dschild.Tables[0].Rows.Clear();
                                    }
                                }
                                dsNqry.Tables[0].Rows.Clear();
                                document.Close();
                                var bytes = memoryStream.ToArray();
                                RP.Base64string = Convert.ToBase64String(bytes);
                                memoryStream.Close();
                              
                            }
                            dsTdata.Tables[0].Rows.Clear();
                            dsEdata.Tables[0].Rows.Clear();
                        }
                        else {
                            string strSub = "select SendType from Ecom_Print_Template with(nolock) where tid = " + dt.Rows[r]["tid"];
                            //da.SelectCommand.CommandText = "select SendType from Ecom_Print_Template with(nolock) where tid = " + dt.Rows(r).Item("tid");
                            //da.Fill(ds1, "SendType");
                            dsSendType = DataLib.ExecuteDataSet(strSub, CommandType.Text, null);
                            //string path = CreateFolder(paydate + "\\" + state + "\\" + Loc + "\\" + client + "\\" + site + "_" + sitecode);
                            string ReportType = "";
                            ReportType = dsSendType.Tables[0].Rows[0]["SendType"].ToString();
                            if (ReportType == "EXCEL")
                            {
                                RP.FileName = dt.Rows[r]["Rdesc"].ToString();
                                string parameter = dsdata.Tables[0].Rows[q]["name"].ToString().Replace("/", "").Replace("\\", "");
                                RP.Base64string= CreateCSVR(dt.Rows[r]["tid"].ToString(),dt.Rows[r]["Rdesc"].ToString(), q,
                                dsdata.Tables[0].Rows[q]["state"].ToString(), dsdata.Tables[0].Rows[q]["Location"].ToString(), dsdata.Tables[0].Rows[q]["code"].ToString(),
                                parameter,
                                dsdata.Tables[0].Rows[q]["site_code"].ToString(), dsdata.Tables[0].Rows[q]["site name"].ToString(), PayDate,
                                dt.Rows[r]["format"].ToString());
                            }
                            else
                            {
                                RP.FileName = dt.Rows[r]["Rdesc"].ToString();
                                string parameter1 = dsdata.Tables[0].Rows[q]["name"].ToString().Replace("/", "").Replace("\\", "");
                                RP.Base64string = GenerateMailPdf(dt.Rows[r]["tid"].ToString(), dt.Rows[r]["Rdesc"].ToString(), q,
                                    dsdata.Tables[0].Rows[q]["state"].ToString(), dsdata.Tables[0].Rows[q]["Location"].ToString(),
                                    dsdata.Tables[0].Rows[q]["code"].ToString(),
                                   parameter1,
                                    dsdata.Tables[0].Rows[q]["site_code"].ToString(), dsdata.Tables[0].Rows[q]["site name"].ToString(), PayDate,
                                    dt.Rows[r]["format"].ToString());
                            }
                            dsSendType.Tables[0].Rows.Clear();
                        }
                    }
               }
                
            }
            catch
            {
                throw;
            }
            //return "Action Completed";

            return RP;
        }

        public DataTable GetPayDate()
        {

            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = null;
                return DataLib.ExecuteDataTable("[GetPayDate]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }

        }


        public string CreateFolder(string path)
        {
            string ff = HttpContext.Current.Server.MapPath("~/Docs/ReadFileAct2/") + path;
            // string ff = System.IO.Path.GetFullPath("D:\\ACT\\") + path;
            if (!Directory.Exists(ff))
            {
                Directory.CreateDirectory(ff);
            }
            return ff;
        }
        private string WritePdf(string mBody, string filename, string  tid, string format)
        {
            string encodedPDF = "";
            try
            {
                DataTable dt = new DataTable();
                StringBuilder _strRepeater = new StringBuilder(mBody);
                Html32TextWriter _ObjHtm = new Html32TextWriter(new System.IO.StringWriter(_strRepeater));
                string _str = _strRepeater.ToString();
                using (MemoryStream memoryStream = new MemoryStream())
                {
                    Document document = new Document(new iTextSharp.text.Rectangle(850f, 1100f));
                    string strQry = "select view_type from ecom_Print_Template where tid=@tid";
                    SqlParameter[] parameters = new SqlParameter[] { new SqlParameter("@tid", tid) };
                    dt = DataLib.ExecuteDataTable(strQry, CommandType.Text, parameters);
                    if (dt.Rows[0][0].ToString() != "P")
                    {
                        document.SetPageSize(iTextSharp.text.PageSize.LEGAL_LANDSCAPE.Rotate());
                    }
                    // PdfWriter.GetInstance(document, new FileStream((path + "/" + filename + ".pdf"), FileMode.Create));
                    PdfWriter.GetInstance(document, memoryStream);

                    document.Open();
                    List<IElement> htmlarraylist = iTextSharp.text.html.simpleparser.HTMLWorker.ParseToList(new StringReader(_str), null);
                    for (int k = 0; k <= htmlarraylist.Count - 1; k++)
                    {
                        document.Add((IElement)htmlarraylist[k]);
                    }
                    document.Close();
                    var bytes = memoryStream.ToArray();
                    encodedPDF = Convert.ToBase64String(bytes);
                    memoryStream.Close();
                  

                }
            }
            catch { }
            return encodedPDF;
        }


        private string CreateCSVR(string tid, string filename, int k, string state, string Loc, string clientcode, string client, string sitecode, string site, string paydate,
        string Format)
        {
            string functionReturnValue = "";
            GridView gvPending = new GridView();
            //string conStr = ConfigurationManager.ConnectionStrings("conStr").ConnectionString;
            //SqlConnection con = new SqlConnection(conStr);
            //SqlDataAdapter da = new SqlDataAdapter("", con);
            DataSet dsdata1 = new DataSet();
            DataSet dsMain = new DataSet();
            DataSet dsChild = new DataSet();
            try
            {
                //da.SelectCommand.CommandText = "select * from Ecom_Print_Template with(nolock) where tid = '" + tid + "'";
                //CreateFolder(paydate + "\\" + state + "\\" + Loc);
                //CreateFolder(paydate + "\\" + state + "\\" + Loc + "\\" + client);
                //CreateFolder(paydate + "\\" + state + "\\" + Loc + "\\" + client + "\\" + site + "_" + sitecode);
                string path = CreateFolder(paydate + "\\" + state + "\\" + Loc + "\\" + client + "\\" + site + "_" + sitecode);

                if (File.Exists(path + "/" + filename + ".xls"))
                {
                    File.Delete(path + "/" + filename + ".xls");
                }

                //da.Fill(ds, "data1");
                dsdata1 = DataLib.ExecuteDataSet("select * from Ecom_Print_Template with(nolock) where tid = '" + tid + "'", CommandType.Text, null);
                string MainQry = "";
                string HeaderQry = "";
                string body = dsdata1.Tables[0].Rows[0]["body"].ToString();
                MainQry = dsdata1.Tables[0].Rows[0]["qry"].ToString();
                string childQry = dsdata1.Tables[0].Rows[0]["SQL_CHILDITEM"].ToString();
                string Exl_body = dsdata1.Tables[0].Rows[0]["Exl_body"].ToString();
                //da.SelectCommand.CommandText = MainQry;
                // for adding footer in excel
           string  Exl_footer   = dsdata1.Tables[0].Rows[0]["Exl_footer"].ToString();  
            string ReportName = dsdata1.Tables[0].Rows[0]["report_desc"].ToString();  
        
                if (Format == "0")
                {
                    SqlParameter[] HeaderP = new SqlParameter[]
                        {
                            new SqlParameter("@companycode",clientcode),
                            new SqlParameter("@sitecode", sitecode),
                            new SqlParameter("@PayDate", paydate)
                        };
                    HeaderQry = DataLib.ExecuteScaler(MainQry.Trim(), CommandType.StoredProcedure, HeaderP);
                    dsMain = DataLib.ExecuteDataSet(HeaderQry, CommandType.Text, null);
                }
                //ds.Dispose();
                string Qry = "";
                if (body.Contains("[child item]"))
                {
                    if (dsdata1.Tables[0].Rows[0]["Status"].ToString() == "P")
                    {
                        SqlParameter [] p=new SqlParameter[]
                        {
                            new SqlParameter("@companycode",clientcode),
                            new SqlParameter("@sitecode", sitecode),
                            new SqlParameter("@PayDate", paydate)
                        };
                        Qry = DataLib.ExecuteScaler(childQry.Trim(),CommandType.StoredProcedure,p);
                    }

                    dsChild=DataLib.ExecuteDataSet(Qry,CommandType.Text,null);
                    //da.Fill(ds, "child");
                }
                if (dsChild.Tables[0].Rows.Count == 0)
                {
                    return functionReturnValue;
                }

                //Response.Clear();
                //Response.Buffer = true;
                string Address = dsMain.Tables[0].Rows[0]["Address"].ToString().Trim();
                string TotalEmp = "";
                string TotalMen = "";
                string TotalWoman = "";
                if (dsMain.Tables[0].Columns.Contains("TotalEmp"))
                {
                    TotalEmp = dsMain.Tables[0].Rows[0]["TotalEmp"].ToString().Trim();
                    TotalMen = dsMain.Tables[0].Rows[0]["TotalMen"].ToString().Trim();
                    TotalWoman = dsMain.Tables[0].Rows[0]["TotalWoman"].ToString().Trim();
                }
                    string[] arr = paydate.Split('-');
                int Month = Convert.ToInt32(arr[1]);
                int Date = Convert.ToInt32(arr[2]);
                int Year = Convert.ToInt32(arr[0]);
                DateTime dateTime = new DateTime(Year, Month, Date, 0, 0, 0);
                string toReplale = "";
                toReplale = CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(dateTime.Month) + ", " + Year;
                string Mnt =toReplale;// Strings.Left(MonthName(Month(paydate).ToString), 3) + ", " + Year(paydate).ToString;

                if (dsChild.Tables[0].Rows.Count > 0)
                {
                    Exl_body = Exl_body.Replace("[Address]", Address);
                    Exl_body = Exl_body.Replace("[TotalEmp]", TotalEmp);
                    Exl_body = Exl_body.Replace("[TotalMen]", TotalMen);
                    Exl_body = Exl_body.Replace("[TotalWoman]", TotalWoman);
                    Exl_body = Exl_body.Replace("[Month]", Mnt);
                    Exl_body = Exl_body.Replace( "[CompanyName]", client);
                    Exl_footer = Exl_footer.Replace("[Address]", Address);
                    Exl_footer = Exl_footer.Replace("[Mnt]", Mnt);
                    gvPending.DataSource = dsChild.Tables[0];
                    gvPending.DataBind();
                    gvPending.HeaderRow.BackColor = Color.White;
                    gvPending.HeaderStyle.Font.Size = (FontUnit)8.0;
                    gvPending.HeaderStyle.Font.Name = "Arial Narrow";

                    gvPending.RowStyle.Font.Size = (FontUnit)8.0;
                    gvPending.RowStyle.Font.Name = "Arial Narrow";
                

                    gvPending.HeaderStyle.Font.Bold = false;

                    if (ReportName.Contains("MUSTER"))
                    {
                        foreach (TableCell cell in gvPending.HeaderRow.Cells)
                        {
                            cell.BackColor = gvPending.HeaderStyle.BackColor;

                            if(cell.Text.ToUpper().Contains("NAME"))
                            {
                                cell.Width = 90;
                            }
                            else if (cell.Text.ToUpper().Contains("DATE"))
                            {
                                cell.Width = 60;
                            }
                        }
                    }

                    else {
                        foreach (TableCell cell in gvPending.HeaderRow.Cells)
                        {
                            cell.BackColor = gvPending.HeaderStyle.BackColor;


                            if (cell.Text.ToUpper().Contains("NAME"))
                            {
                                cell.Width = 90;
                            }
                            else if (cell.Text.ToUpper().Contains("DATE"))
                            {
                                cell.Width = 60;
                            }
                            else {
                                cell.Width = 45;
                            }
                        }
                    }

                    using (StringWriter sw = new StringWriter())
                    {
                        using (HtmlTextWriter hw = new HtmlTextWriter(sw))
                        {
                            StreamWriter writer = File.AppendText(path + "/" + filename + ".xls");
                            gvPending.RenderControl(hw);
                            writer.Write(AddExcelStyling());
                            writer.Write("" + Exl_body + "");
                            writer.WriteLine(sw.ToString());
                            writer.Write("" + Exl_footer + "");
                            writer.Close();
                        }
                    }

                   
                    filename = filename.Replace(".", "");
                }
                else
                {
                    //Report_Log(state, LocationName, CompanyName, AssignCode, paydate)
                   // return  filename + ".xls";
                }

                byte[] bytes = File.ReadAllBytes(path + "/" + filename + ".xls");
               functionReturnValue = Convert.ToBase64String(bytes);
                if (Directory.Exists(path))
                {
                    DeleteDirectory(path);
                }


            }
            catch (Exception ex)
            {
            }
            return functionReturnValue;

        }
        public void DeleteDirectory(string path)
        {
            var root = HttpContext.Current.Server.MapPath("~/Docs/ReadFileAct2");
            FileInfo fi = new FileInfo(path);
            // DirectoryInfo networkDir = new DirectoryInfo(path);
            // DirectoryInfo twoLevelsUp = networkDir.Parent.Parent.Parent;
            foreach (string filename in Directory.GetFiles(path))
            {
                File.Delete(filename);
            }
            Directory.Delete(path);
            for (DirectoryInfo dir = fi.Directory; dir != null && dir.Parent != null && dir.FullName != root; dir = dir.Parent)
            {
                dir.Delete();
            }
        }
        public string GenerateMailPdf(string tid, string filename, int k, string state, string Loc, string clientcode, string client, string sitecode, string site, string paydate,
        string Format)
        {
            string functionReturnValue = null;
            DataSet dsdata1 = new DataSet();
            DataSet dsdmain = new DataSet();
            DataSet dschild = new DataSet();
            try
            {
                //da.SelectCommand.CommandText = "select * from Ecom_Print_Template with(nolock) where tid = '" + tid + "'";
                //CreateFolder(paydate + "\\" + state + "\\" + Loc);
                //CreateFolder(paydate + "\\" + state + "\\" + Loc + "\\" + client);
                //CreateFolder(paydate + "\\" + state + "\\" + Loc + "\\" + client + "\\" + site + "_" + sitecode);
                //string path = CreateFolder(paydate + "\\" + state + "\\" + Loc + "\\" + client + "\\" + site + "_" + sitecode);

                //if (File.Exists(path + "/" + filename + ".xls"))
                //{
                //    File.Delete(path + "/" + filename + ".xls");
                //}
                dsdata1 = DataLib.ExecuteDataSet("select * from Ecom_Print_Template with(nolock) where tid = '" + tid + "'", CommandType.Text, null);
                //da.Fill(ds, "data1");
                string MainQry = "";
                string mqry = "";
                string body = dsdata1.Tables[0].Rows[0]["body"].ToString();
                MainQry = dsdata1.Tables[0].Rows[0]["qry"].ToString();
                string childQry = dsdata1.Tables[0].Rows[0]["SQL_CHILDITEM"].ToString();
                //da.SelectCommand.CommandText = MainQry;
                if (Format == "0")
                {

                    SqlParameter[] SinpleP = new SqlParameter[]
                        {
                            new SqlParameter("@companycode",clientcode),
                            new SqlParameter("@sitecode", sitecode),
                            new SqlParameter("@PayDate", paydate)
                        };
                    mqry = DataLib.ExecuteScaler(MainQry.Trim(), CommandType.StoredProcedure, SinpleP);
                    dsdmain = DataLib.ExecuteDataSet(mqry, CommandType.Text, null);
                }

                string Qry = "";
                if (body.Contains("[child item]"))
                {
                    if (Format == "0")
                    {
                        if (dsdata1.Tables[0].Rows[0]["Status"].ToString() == "P")
                        {
                            SqlParameter[] p = new SqlParameter[]{
                                new SqlParameter("@companycode",clientcode),
                                new SqlParameter("@sitecode",sitecode),
                                new SqlParameter("@PayDate",paydate)
                            };
                            Qry = DataLib.ExecuteScaler(childQry, CommandType.StoredProcedure, p);
                        }
                    }
                    dschild = DataLib.ExecuteDataSet(Qry, CommandType.Text, null);
                    if (dschild.Tables[0].Rows.Count == 0)
                    {
                        return functionReturnValue;
                    }
                    string strChildItem = "";
                    string prevVal = "";

                    strChildItem = "<div><table width=\"100%\" border=\"0.5\" text-align=\"center\"  >";
                    for (int i = 0; i <= dschild.Tables[0].Rows.Count - 1; i++)
                    {
                        if (prevVal == dschild.Tables[0].Rows[i][0].ToString())
                        {
                            prevVal = dschild.Tables[0].Rows[i][0].ToString();
                            dschild.Tables[0].Rows[i][0] = "";
                        }
                        else
                        {
                            prevVal = dschild.Tables[0].Rows[i][0].ToString();
                        }
                    }

                    for (int i = 0; i <= dschild.Tables[0].Rows.Count; i++)
                    {
                        strChildItem += "<tr>";
                        for (int j = 0; j <= dschild.Tables[0].Columns.Count - 1; j++)
                        {
                            if (j == 0)
                            {
                                strChildItem += "<td width=\"45\" style=\"width:10;text-align:center\">";
                            }
                            else
                            {
                                strChildItem += "<td style=\"text-align:center\">";
                            }
                            if (i == 0)
                            {
                                strChildItem += dschild.Tables[0].Columns[j].ColumnName;
                            }
                            else
                            {
                                strChildItem += dschild.Tables[0].Rows[i - 1][j].ToString();
                            }
                            strChildItem += "</td>";
                        }
                        strChildItem += "</tr>";
                    }
                    strChildItem += "</table></div>";
                    body = body.Replace("[child item]", strChildItem);
                }
                // For Month

                string[] arr = paydate.Split('-');
                int Month = Convert.ToInt32(arr[1]);
                int Date = Convert.ToInt32(arr[2]);
                int Year = Convert.ToInt32(arr[0]);
                DateTime dateTime = new DateTime(Year, Month, Date, 0, 0, 0);
                string toReplale = "";
                toReplale = CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(dateTime.Month) + ", " + Year;
                body = body.Replace("[Month]", toReplale);

                for (int j = 0; j <= dsdmain.Tables[0].Columns.Count - 1; j++)
                {
                    body = body.Replace("[" + dsdmain.Tables[0].Columns[j].ColumnName + "]", dsdmain.Tables[0].Rows[0][j].ToString());
                }
                filename = filename.Replace(".", "");
                //WritePdf(string mBody, string filename, int tid, string path, string format)
                functionReturnValue= WritePdf(body, filename, tid, Format);

            }
            catch (Exception ex)
            {
                //Throw
            }
            return functionReturnValue;

        }

        private string AddExcelStyling()
        {

            try
            {

                StringBuilder sb = new StringBuilder();
                sb.Append(("<html xmlns:o='urn:schemas-microsoft-com:office:office'" + "\n" + ("xmlns:x='urn:schemas-microsoft-com:office:excel'" + "\n" + ("xmlns='http://www.w3.org/TR/REC-html40'>" + "\n" + "<head>" + "\n"))));
                sb.Append("<style>" + "\n");
                sb.Append("@page");
                //top right
                sb.Append("{margin:.3in .3in .3in .3in;" + "\n");
                //sb.Append("mso-header-margin:.1in;" & vbLf)
                //sb.Append("mso-footer-margin:.1in;" & vbLf)
                sb.Append("mso-data-placement:same-cell;" + "\n");
                //sb.Append("mso-page-frozen_headers : ""yes"";" & vbLf)
                //sb.Append("mso-page-frozen_rowheaders : ""yes"";" & vbLf)

                //add pageno & date
                //sb.Append("{mso-footer-data:'&L&D   &T  &RPage &P of &n ';")

                sb.Append("mso-page-Zoom:False;" + "\n");
                sb.Append("mso-page-Fit To:yes;" + "\n");
                sb.Append("mso-page-FitToPagesWide:True;" + "\n");
                sb.Append("mso-paper-source:0;" + "\n");
                sb.Append("mso-page-Scaling:Fit2Page;" + "\n");

                sb.Append("mso-page-orientation:landscape;}" + "\n");


                sb.Append("</style>" + "\n");
                sb.Append("<!--[if gte mso 9]><xml>" + "\n");
                sb.Append("<x:ExcelWorkbook>" + "\n");
                sb.Append("<x:ExcelWorksheets>" + "\n");
                sb.Append("<x:ExcelWorksheet>" + "\n");
                sb.Append("<x:Name>Sheet1</x:Name>" + "\n");
                sb.Append("<x:WorksheetOptions>" + "\n");

                sb.Append("<x:Print>" + "\n");
                sb.Append("<x:ValidPrinterInfo/>" + "\n");

                // Paper Size Index 9 – A4, 5 -Legal
                sb.Append("<x:PaperSizeIndex>9</x:PaperSizeIndex>" + "\n");

                // zoom % of page
                //sb.Append("<x:Scale>80</x:Scale>")
                sb.Append("<x:Scale>65</x:Scale>");
                sb.Append("<x:FitWidth>1</x:FitWidth>");
                sb.Append("<x:FitHeight>999</x:FitHeight>");
                sb.Append("<x:HorizontalResolution>20</x:HorizontalResolution>" + "\n");
                sb.Append("<x:VerticalResolution>20</x:VerticalResolution>" + "\n");
                sb.Append("</x:Print>" + "\n");

                sb.Append("<x:Selected/>" + "\n");
                sb.Append("<x:DoNotDisplayGridlines/>" + "\n");
                sb.Append("<x:ProtectContents>False</x:ProtectContents>" + "\n");
                sb.Append("<x:ProtectObjects>False</x:ProtectObjects>" + "\n");
                sb.Append("<x:ProtectScenarios>False</x:ProtectScenarios>" + "\n");
                sb.Append("</x:WorksheetOptions>" + "\n");
                sb.Append("</x:ExcelWorksheet>" + "\n");
                sb.Append("</x:ExcelWorksheets>" + "\n");
                sb.Append("<x:WindowHeight>12780</x:WindowHeight>" + "\n");
                sb.Append("<x:WindowWidth>19035</x:WindowWidth>" + "\n");
                sb.Append("<x:WindowTopX>0</x:WindowTopX>" + "\n");
                sb.Append("<x:WindowTopY>15</x:WindowTopY>" + "\n");
                sb.Append("<x:ProtectStructure>False</x:ProtectStructure>" + "\n");
                sb.Append("<x:ProtectWindows>False</x:ProtectWindows>" + "\n");
                sb.Append("</x:ExcelWorkbook>" + "\n");
                sb.Append("</xml><![endif]-->" + "\n");
                sb.Append("</head>" + "\n");
                sb.Append("<body>" + "\n");

                return sb.ToString();
            }
            catch
            {
                throw;
            }
            
        }



        public int AddUpdateSalaryRegister(SalaryRegister model)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                  //new SqlParameter("@tid", model.TID),
new SqlParameter("@Paydate", model.Paydate),
new SqlParameter("@Company_code", model.Company_code),
new SqlParameter("@Site_Code", model.Site_Code),
new SqlParameter("@Employee_code", model.Employee_code),
new SqlParameter("@Employee_Name", model.Employee_Name),
new SqlParameter("@F_H_Name", model.F_H_Name),
new SqlParameter("@Designation", model.Designation),
new SqlParameter("@Gender", model.Gender),
new SqlParameter("@DOB", model.DOB),
new SqlParameter("@DOJ", model.DOJ),
new SqlParameter("@DOL", model.DOL),
new SqlParameter("@EPF_No", model.EPF_No),
new SqlParameter("@UAN", model.UAN),
new SqlParameter("@Adhaar", model.Adhaar),
new SqlParameter("@ESIC", model.ESIC),
new SqlParameter("@Bank_Account_No", model.Bank_Account_No),
new SqlParameter("@Bank_Name", model.Bank_Name),
new SqlParameter("@Present_Address", model.Present_Address),
new SqlParameter("@Permanent_address", model.Permanent_address),
new SqlParameter("@Wage_Month", model.Wage_Month),
new SqlParameter("@Month_days", model.Month_days),
new SqlParameter("@Worked_Days", model.Worked_Days),
new SqlParameter("@Total_attendance_unit_of_workdone", model.Total_attendance_unit_of_workdone),
new SqlParameter("@Pay_days", model.Pay_days),
new SqlParameter("@Minimum_rate_of_wages", model.Minimum_rate_of_wages),
new SqlParameter("@Total_Hour_of_Overtime_During_Month", model.Total_Hour_of_Overtime_During_Month),
new SqlParameter("@Amount_of_Overtime", model.Amount_of_Overtime),
new SqlParameter("@Basic", model.Basic),
new SqlParameter("@DA", model.DA),
new SqlParameter("@HRA", model.HRA),
new SqlParameter("@Conv", model.Conv),
new SqlParameter("@Special_Allow", model.Special_Allow),
new SqlParameter("@Medical_Allowance", model.Medical_Allowance),
new SqlParameter("@NFH_allowance", model.NFH_allowance),
new SqlParameter("@Other_Allow", model.Other_Allow),
new SqlParameter("@Gratuity", model.Gratuity),
new SqlParameter("@Total_Bonus", model.Total_Bonus),
new SqlParameter("@Gross_Wages_Payable", model.Gross_Wages_Payable),
new SqlParameter("@PF", model.PF),
new SqlParameter("@VPF", model.VPF),
new SqlParameter("@ESI", model.ESI),
new SqlParameter("@PTAX", model.PTAX),
new SqlParameter("@LWF", model.LWF),
new SqlParameter("@INCOME_TAX", model.INCOME_TAX),
new SqlParameter("@House_Rent", model.House_Rent),
new SqlParameter("@Deductions_if_any_and_reasons_thereof", model.Deductions_if_any_and_reasons_thereof),
new SqlParameter("@Loan", model.Loan),
new SqlParameter("@Other_deduction", model.Other_deduction),
new SqlParameter("@Total_deduction", model.Total_deduction),
new SqlParameter("@NET_Wages_Payable", model.NET_Wages_Payable),
new SqlParameter("@Date_of_Payment", model.Date_of_Payment),
new SqlParameter("@Mode_of_Payment_Cash_Cheque_No", model.Mode_of_Payment_Cash_Cheque_No),
new SqlParameter("@Employee_signature_or_thumb_impression", model.Employee_signature_or_thumb_impression),
new SqlParameter("@Remarks_Salary", model.Remarks_Salary),
new SqlParameter("@Cash_value_of_concessional_supply_of_essential_commodities", model.Cash_value_of_concessional_supply_of_essential_commodities),
new SqlParameter("@Advance", model.Advance),
new SqlParameter("@Date_and_Amount_of_Advance_Made", model.Date_and_Amount_of_Advance_Made),
new SqlParameter("@Date_on_which_total_amount_is_recovered", model.Date_on_which_total_amount_is_recovered),
new SqlParameter("@Purpose_for_which_advance_made", model.Purpose_for_which_advance_made),
new SqlParameter("@Number_of_instalments_by_which_advance_tobe_repaid", model.Number_of_instalments_by_which_advance_tobe_repaid),
new SqlParameter("@Postponements_granted", model.Postponements_granted),
new SqlParameter("@Date_on_which_total_amount_repaid", model.Date_on_which_total_amount_repaid),
new SqlParameter("@Damages_Loss", model.Damages_Loss),
new SqlParameter("@Absence_from_duty_with_date", model.Absence_from_duty_with_date),
new SqlParameter("@Amount_of_deduction_imposed", model.Amount_of_deduction_imposed),
new SqlParameter("@Damage_or_loss_caused_with_date", model.Damage_or_loss_caused_with_date),
new SqlParameter("@Showed_cause_against_deduction_with_date", model.Showed_cause_against_deduction_with_date),
new SqlParameter("@Showed_cause_against_Deduction_with_date_and_person_in_presence", model.Showed_cause_against_Deduction_with_date_and_person_in_presence),
new SqlParameter("@Date_amount_of_deduction_imposed", model.Date_amount_of_deduction_imposed),
new SqlParameter("@Number_of_instalment_if_any", model.Number_of_instalment_if_any),
new SqlParameter("@Date_on_which_total_amount_realised", model.Date_on_which_total_amount_realised),
new SqlParameter("@Fine", model.Fine),
new SqlParameter("@Nature_and_date_of_the_offence_for_which_fine_imposed", model.Nature_and_date_of_the_offence_for_which_fine_imposed),
new SqlParameter("@Showed_cause_against_fine_or_not_with_date", model.Showed_cause_against_fine_or_not_with_date),
new SqlParameter("@Rate_of_Wages", model.Rate_of_Wages),
new SqlParameter("@Date_and_amount_of_fine_imposed", model.Date_and_amount_of_fine_imposed),
new SqlParameter("@Date_which_fine_realised", model.Date_which_fine_realised),
new SqlParameter("@Overtime", model.Overtime),
new SqlParameter("@Dates_on_which_overtime_worked", model.Dates_on_which_overtime_worked),
new SqlParameter("@Extent_of_overtime_on_each_occasion", model.Extent_of_overtime_on_each_occasion),
new SqlParameter("@Total_overtime_worked_or_production_in_case_of_piece_rated", model.Total_overtime_worked_or_production_in_case_of_piece_rated),
new SqlParameter("@Overtime_rate_of_wages", model.Overtime_rate_of_wages),
new SqlParameter("@Normal_hours", model.Normal_hours),
new SqlParameter("@Normal_Rate", model.Normal_Rate),
new SqlParameter("@Normal_earnings", model.Normal_earnings),
new SqlParameter("@Overtime_earnings_total_Earning", model.Overtime_earnings_total_Earning),
new SqlParameter("@Date_on_which_overtime_wages_paid", model.Date_on_which_overtime_wages_paid),
new SqlParameter("@Date_on_which_overtime_payment_made", model.Date_on_which_overtime_payment_made),
new SqlParameter("@Remarks_Other", model.Remarks_Other),
new SqlParameter("@Leave_Encahsment", model.Leave_Encahsment)

                };
                return Convert.ToInt32(DataLib.ExecuteScaler("AddUpdateSalaryRegister", CommandType.StoredProcedure, parameters));
            }
            catch
            {
                throw;
            }
        }
        public int AddUpdateMusterRolldata(MusterRolldata model)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
new SqlParameter("@Paydate ", model.Paydate),
new SqlParameter("@Company_Code ", model.Company_Code),
new SqlParameter("@Site_Code ", model.Site_Code),
new SqlParameter("@Employee_code ", model.Employee_code),
new SqlParameter("@Opening_Time ", model.Opening_Time),
new SqlParameter("@Lunch_Time ", model.Lunch_Time),
new SqlParameter("@Closing_Time ", model.Closing_Time),
new SqlParameter("@d1 ", model.d1),
new SqlParameter("@d2 ", model.d2),
new SqlParameter("@d3 ", model.d3),
new SqlParameter("@d4 ", model.d4),
new SqlParameter("@d5 ", model.d5),
new SqlParameter("@d6 ", model.d6),
new SqlParameter("@d7 ", model.d7),
new SqlParameter("@d8 ", model.d8),
new SqlParameter("@d9 ", model.d9),
new SqlParameter("@d10 ", model.d10),
new SqlParameter("@d11 ", model.d11),
new SqlParameter("@d12 ", model.d12),
new SqlParameter("@d13 ", model.d13),
new SqlParameter("@d14 ", model.d14),
new SqlParameter("@d15 ", model.d15),
new SqlParameter("@d16 ", model.d16),
new SqlParameter("@d17 ", model.d17),
new SqlParameter("@d18 ", model.d18),
new SqlParameter("@d19 ", model.d19),
new SqlParameter("@d20 ", model.d20),
new SqlParameter("@d21 ", model.d21),
new SqlParameter("@d22 ", model.d22),
new SqlParameter("@d23 ", model.d23),
new SqlParameter("@d24 ", model.d24),
new SqlParameter("@d25 ", model.d25),
new SqlParameter("@d26 ", model.d26),
new SqlParameter("@d27 ", model.d27),
new SqlParameter("@d28 ", model.d28),
new SqlParameter("@d29 ", model.d29),
new SqlParameter("@d30 ", model.d30),
new SqlParameter("@d31 ", model.d31),
new SqlParameter("@Total_Attendance ", model.Total_Attendance),
new SqlParameter("@Remarks ", model.Remarks),
new SqlParameter("@Date_overtime_extent_of_overtime_each_day ", model.Date_overtime_extent_of_overtime_each_day),
new SqlParameter("@Opening_Blance_PL ", model.Opening_Blance_PL),
new SqlParameter("@Earned_during_month_PL ", model.Earned_during_month_PL),
new SqlParameter("@Availed_during_month_PL ", model.Availed_during_month_PL),
new SqlParameter("@Closing_Blance_PL ", model.Closing_Blance_PL),
new SqlParameter("@Leave_Availed_Date_PL ", model.Leave_Availed_Date_PL),
new SqlParameter("@Date_of_Application_of_Leave_PL ", model.Date_of_Application_of_Leave_PL),
new SqlParameter("@Opening_Blance_CL ", model.Opening_Blance_CL),
new SqlParameter("@Earned_during_month_CL ", model.Earned_during_month_CL),
new SqlParameter("@Availed_during_month_CL ", model.Availed_during_month_CL),
new SqlParameter("@Closing_Blance_CL ", model.Closing_Blance_CL),
new SqlParameter("@Leave_Availed_Date_CL ", model.Leave_Availed_Date_CL),
new SqlParameter("@Date_of_Application_of_Leave_CL ", model.Date_of_Application_of_Leave_CL),
new SqlParameter("@Opening_Blance_SL ", model.Opening_Blance_SL),
new SqlParameter("@Earned_during_month_SL ", model.Earned_during_month_SL),
new SqlParameter("@Availed_during_month_SL ", model.Availed_during_month_SL),
new SqlParameter("@Closing_Blance_SL ", model.Closing_Blance_SL),
new SqlParameter("@Leave_Availed_Date_SL ", model.Leave_Availed_Date_SL),
new SqlParameter("@Date_of_Application_of_Leave_SL ", model.Date_of_Application_of_Leave_SL),
new SqlParameter("@Opening_Blance_ML ", model.Opening_Blance_ML),
new SqlParameter("@Availed_during_month_ML ", model.Availed_during_month_ML),
new SqlParameter("@Closing_Blance_ML ", model.Closing_Blance_ML),
new SqlParameter("@Leave_Availed_Date_ML ", model.Leave_Availed_Date_ML),
new SqlParameter("@Date_of_Application_of_Leave_ML ", model.Date_of_Application_of_Leave_ML),
new SqlParameter("@Weekly_Company_Holidays ", model.Weekly_Company_Holidays),
new SqlParameter("@Date_Of_Leaving ", model.Date_Of_Leaving),
new SqlParameter("@Worked_Hours ", model.Worked_Hours),
new SqlParameter("@Yearly_Company_Holidays ", model.Yearly_Company_Holidays),
                };
                return Convert.ToInt32(DataLib.ExecuteScaler("AddUpdateMusterRollData", CommandType.StoredProcedure, parameters));
            }
            catch
            {
                throw;
            }
        }

        public string DownLoadCompany(Company model)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                  new SqlParameter("@CompanyID",model.CompanyID ),
                       new SqlParameter("@Customer",model.Customer ),
                    new SqlParameter("@IsAct",model.IsAct )
                };

                dt = DataLib.ExecuteDataTable("[GetCompanyList]", CommandType.StoredProcedure, parameters);
                return CSVUtills.DataTableToCSV(dt, ",");
            }
            catch { throw; }
        }
        public bool CheckColumnFormatSalary(string FilePath, string SampleFilePath)
        {
            bool ret = true;
            DataTable dt = CSVUtills.CSVToDataTable(SampleFilePath, ',');
            DataTable dt2 = CSVUtills.CSVHeaderToDataTable(FilePath, ',');

            for (int i = 0; i < dt.Columns.Count; i++)
            {
                if (!(dt2.Columns.Contains(dt.Columns[i].ColumnName)))
                {
                    ret = false;
                    return ret;
                }
            }
            return ret;
        }

        public string UploadSalaryRegister(string FilePath, string SampleFilePath, int CreatedBy, ref int SuccessCount, ref int FailCount)
        {
            try
            {
                //Convert csv file into DataTable
                DataTable dt = null;
                try
                {
                    dt = CSVUtills.CSVToDataTable(FilePath, '|');
                }
                catch (Exception Ex)
                {
                    return Ex.Message;
                }

                if (!CheckColumnFormatSalary(FilePath, SampleFilePath))
                {
                    return "Invalid File Format";
                }
                dt.Columns.Add("Response");
                dt.Columns.Add("Message");

                SalaryRegister Model;
                GenerateRepRepo objSalaryRep = new GenerateRepRepo();
               

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    //Only checking Required validation using View Model
                    try
                    {
                        string strerr = "";
                        Model = new SalaryRegister();
                        //Model.TID = Convert.ToInt32((dt.Rows[i]["TID"]).ToString().Replace("\"", ""));
                        if(Convert.ToString(dt.Rows[i]["Paydate"]) == "" || dt.Rows[i]["Paydate"] == null)
                        {
                            Model.Paydate = null;
                        }
                        else { Model.Paydate = Convert.ToDateTime((dt.Rows[i]["Paydate"]).ToString().Replace("\"", "").Trim());
                        }
                       
                        Model.Company_code = Convert.ToString((dt.Rows[i]["Company_code"]).ToString().Replace("\"", "").Trim());
                        Model.Site_Code = Convert.ToString((dt.Rows[i]["Site_Code"]).ToString().Replace("\"", "").Trim());
                        Model.Employee_code = Convert.ToString((dt.Rows[i]["Employee_code"]).ToString().Replace("\"", "").Trim());
                        Model.Employee_Name = Convert.ToString((dt.Rows[i]["Employee_Name"]).ToString().Replace("\"", "").Trim());
                        Model.F_H_Name = Convert.ToString((dt.Rows[i]["F_H_Name"]).ToString().Replace("\"", ""));
                        Model.Designation = Convert.ToString((dt.Rows[i]["Designation"]).ToString().Replace("\"", ""));
                        Model.Gender = Convert.ToString((dt.Rows[i]["Gender"]).ToString().Replace("\"", ""));
                        if (Convert.ToString(dt.Rows[i]["DOB"]) == "" || dt.Rows[i]["DOB"] == null)
                        {
                            Model.DOB = null;
                        }
                        else { Model.DOB = Convert.ToDateTime((dt.Rows[i]["DOB"]).ToString().Replace("\"", "")); }
                         
                        if (Convert.ToString(dt.Rows[i]["DOJ"]) == "" || dt.Rows[i]["DOJ"] == null)
                        {
                            Model.DOJ = null;
                        }
                        else { Model.DOJ = Convert.ToDateTime((dt.Rows[i]["DOJ"]).ToString().Replace("\"", "")); }
                        if (Convert.ToString(dt.Rows[i]["DOL"]) == "" || dt.Rows[i]["DOL"] == null)
                        {
                            Model.DOL = null;
                        }
                        else { Model.DOL = Convert.ToDateTime((dt.Rows[i]["DOL"]).ToString().Replace("\"", "")); }
                        Model.EPF_No = Convert.ToString((dt.Rows[i]["EPF_No"]).ToString().Replace("\"", ""));
                        Model.UAN = Convert.ToString((dt.Rows[i]["UAN"]).ToString().Replace("\"", ""));
                        Model.Adhaar = Convert.ToString((dt.Rows[i]["Adhaar"]).ToString().Replace("\"", ""));
                        Model.ESIC = Convert.ToString((dt.Rows[i]["ESIC"]).ToString().Replace("\"", ""));
                        Model.Bank_Account_No = Convert.ToString((dt.Rows[i]["Bank_Account_No"]).ToString().Replace("\"", ""));
                        Model.Bank_Name = Convert.ToString((dt.Rows[i]["Bank_Name"]).ToString().Replace("\"", ""));
                        Model.Present_Address = Convert.ToString((dt.Rows[i]["Present_Address"]).ToString().Replace("\"", ""));
                        Model.Permanent_address = Convert.ToString((dt.Rows[i]["Permanent_address"]).ToString().Replace("\"", ""));
                        Model.Wage_Month = Convert.ToString((dt.Rows[i]["Wage_Month"]).ToString().Replace("\"", ""));
                        Model.Month_days = Convert.ToInt32((dt.Rows[i]["Month_days"]).ToString().Replace("\"", ""));
                        Model.Worked_Days = Convert.ToDecimal((dt.Rows[i]["Worked_Days"]).ToString().Replace("\"", ""));
                        Model.Total_attendance_unit_of_workdone = Convert.ToDecimal((dt.Rows[i]["Total_attendance_unit_of_workdone"]).ToString().Replace("\"", ""));
                        Model.Pay_days = Convert.ToDecimal((dt.Rows[i]["Pay_days"]).ToString().Replace("\"", ""));
                        Model.Minimum_rate_of_wages = Convert.ToDecimal((dt.Rows[i]["Minimum_rate_of_wages"]).ToString().Replace("\"", ""));
                        Model.Total_Hour_of_Overtime_During_Month = Convert.ToInt32((dt.Rows[i]["Total_Hour_of_Overtime_During_Month"]).ToString().Replace("\"", ""));
                        Model.Amount_of_Overtime = Convert.ToInt32((dt.Rows[i]["Amount_of_Overtime"]).ToString().Replace("\"", ""));
                        Model.Basic = Convert.ToDecimal((dt.Rows[i]["Basic"]).ToString().Replace("\"", ""));
                        Model.DA = Convert.ToDecimal((dt.Rows[i]["DA"]).ToString().Replace("\"", ""));
                        Model.HRA = Convert.ToDecimal((dt.Rows[i]["HRA"]).ToString().Replace("\"", ""));
                        Model.Conv = Convert.ToDecimal((dt.Rows[i]["Conv"]).ToString().Replace("\"", ""));
                        Model.Special_Allow = Convert.ToDecimal((dt.Rows[i]["Special_Allow"]).ToString().Replace("\"", ""));
                        Model.Medical_Allowance = Convert.ToDecimal((dt.Rows[i]["Medical_Allowance"]).ToString().Replace("\"", ""));
                        Model.NFH_allowance = Convert.ToDecimal((dt.Rows[i]["NFH_allowance"]).ToString().Replace("\"", ""));
                        Model.Other_Allow = Convert.ToDecimal((dt.Rows[i]["Other_Allow"]).ToString().Replace("\"", ""));
                        Model.Gratuity = Convert.ToDecimal((dt.Rows[i]["Gratuity"]).ToString().Replace("\"", ""));
                        Model.Total_Bonus = Convert.ToDecimal((dt.Rows[i]["Total_Bonus"]).ToString().Replace("\"", ""));
                        Model.Gross_Wages_Payable = Convert.ToDecimal((dt.Rows[i]["Gross_Wages_Payable"]).ToString().Replace("\"", ""));
                        Model.PF = Convert.ToDecimal((dt.Rows[i]["PF"]).ToString().Replace("\"", ""));
                        Model.VPF = Convert.ToDecimal((dt.Rows[i]["VPF"]).ToString().Replace("\"", ""));
                        Model.ESI = Convert.ToDecimal((dt.Rows[i]["ESI"]).ToString().Replace("\"", ""));
                        Model.PTAX = Convert.ToDecimal((dt.Rows[i]["PTAX"]).ToString().Replace("\"", ""));
                        Model.LWF = Convert.ToDecimal((dt.Rows[i]["LWF"]).ToString().Replace("\"", ""));
                        Model.INCOME_TAX = Convert.ToDecimal((dt.Rows[i]["INCOME_TAX"]).ToString().Replace("\"", ""));
                        Model.House_Rent = Convert.ToDecimal((dt.Rows[i]["House_Rent"]).ToString().Replace("\"", ""));
                        Model.Deductions_if_any_and_reasons_thereof = Convert.ToString((dt.Rows[i]["Deductions_if_any_and_reasons_thereof"]).ToString().Replace("\"", ""));
                        Model.Loan = Convert.ToDecimal((dt.Rows[i]["Loan"]).ToString().Replace("\"", ""));
                        Model.Other_deduction = Convert.ToDecimal((dt.Rows[i]["Other_deduction"]).ToString().Replace("\"", ""));
                        Model.Total_deduction = Convert.ToDecimal((dt.Rows[i]["Total_deduction"]).ToString().Replace("\"", ""));
                        Model.NET_Wages_Payable = Convert.ToDecimal((dt.Rows[i]["NET_Wages_Payable"]).ToString().Replace("\"", ""));

                        if (Convert.ToString(dt.Rows[i]["Date_of_Payment"]) == "" || dt.Rows[i]["Date_of_Payment"] == null)
                        {
                            Model.Date_of_Payment = null;
                        }
                        else { Model.Date_of_Payment = Convert.ToDateTime((dt.Rows[i]["Date_of_Payment"]).ToString().Replace("\"", "")); }
                        
                        Model.Mode_of_Payment_Cash_Cheque_No = Convert.ToString((dt.Rows[i]["Mode_of_Payment_Cash_Cheque_No"]).ToString().Replace("\"", ""));
                        Model.Employee_signature_or_thumb_impression = Convert.ToString((dt.Rows[i]["Employee_signature_or_thumb_impression"]).ToString().Replace("\"", ""));
                        Model.Remarks_Salary = Convert.ToString((dt.Rows[i]["Remarks_Salary"]).ToString().Replace("\"", ""));
                        Model.Cash_value_of_concessional_supply_of_essential_commodities = Convert.ToDecimal((dt.Rows[i]["Cash_value_of_concessional_supply_of_essential_commodities"]).ToString().Replace("\"", ""));
                        Model.Advance = Convert.ToDecimal((dt.Rows[i]["Advance"]).ToString().Replace("\"", ""));
                        Model.Date_and_Amount_of_Advance_Made = Convert.ToString((dt.Rows[i]["Date_and_Amount_of_Advance_Made"]).ToString().Replace("\"", ""));
                        Model.Date_on_which_total_amount_is_recovered = Convert.ToString((dt.Rows[i]["Date_on_which_total_amount_is_recovered"]).ToString().Replace("\"", ""));
                        Model.Purpose_for_which_advance_made = Convert.ToString((dt.Rows[i]["Purpose_for_which_advance_made"]).ToString().Replace("\"", ""));
                        Model.Number_of_instalments_by_which_advance_tobe_repaid = Convert.ToString((dt.Rows[i]["Number_of_instalments_by_which_advance_tobe_repaid"]).ToString().Replace("\"", ""));
                        Model.Postponements_granted = Convert.ToString((dt.Rows[i]["Postponements_granted"]).ToString().Replace("\"", ""));
                        Model.Date_on_which_total_amount_repaid = Convert.ToString((dt.Rows[i]["Date_on_which_total_amount_repaid"]).ToString().Replace("\"", ""));
                        Model.Damages_Loss = Convert.ToDecimal((dt.Rows[i]["Damages_Loss"]).ToString().Replace("\"", ""));
                        Model.Absence_from_duty_with_date = Convert.ToString((dt.Rows[i]["Absence_from_duty_with_date"]).ToString().Replace("\"", ""));
                        Model.Amount_of_deduction_imposed = Convert.ToDecimal((dt.Rows[i]["Amount_of_deduction_imposed"]).ToString().Replace("\"", ""));
                        Model.Damage_or_loss_caused_with_date = Convert.ToString((dt.Rows[i]["Damage_or_loss_caused_with_date"]).ToString().Replace("\"", ""));
                        Model.Showed_cause_against_deduction_with_date = Convert.ToString((dt.Rows[i]["Showed_cause_against_deduction_with_date"]).ToString().Replace("\"", ""));
                        Model.Showed_cause_against_Deduction_with_date_and_person_in_presence = Convert.ToString((dt.Rows[i]["Showed_cause_against_Deduction_with_date_and_person_in_presence"]).ToString().Replace("\"", ""));
                        Model.Date_amount_of_deduction_imposed = Convert.ToString((dt.Rows[i]["Date_amount_of_deduction_imposed"]).ToString().Replace("\"", ""));
                        Model.Number_of_instalment_if_any = Convert.ToString((dt.Rows[i]["Number_of_instalment_if_any"]).ToString().Replace("\"", ""));
                        Model.Date_on_which_total_amount_realised = Convert.ToString((dt.Rows[i]["Date_on_which_total_amount_realised"]).ToString().Replace("\"", ""));
                        Model.Fine = Convert.ToDecimal((dt.Rows[i]["Fine"]).ToString().Replace("\"", ""));
                        Model.Nature_and_date_of_the_offence_for_which_fine_imposed = Convert.ToString((dt.Rows[i]["Nature_and_date_of_the_offence_for_which_fine_imposed"]).ToString().Replace("\"", ""));
                        Model.Showed_cause_against_fine_or_not_with_date = Convert.ToString((dt.Rows[i]["Showed_cause_against_fine_or_not_with_date"]).ToString().Replace("\"", ""));
                        Model.Rate_of_Wages = Convert.ToDecimal((dt.Rows[i]["Rate_of_Wages"]).ToString().Replace("\"", ""));
                        Model.Date_and_amount_of_fine_imposed = Convert.ToString((dt.Rows[i]["Date_and_amount_of_fine_imposed"]).ToString().Replace("\"", ""));
                        Model.Date_which_fine_realised = Convert.ToString((dt.Rows[i]["Date_which_fine_realised"]).ToString().Replace("\"", ""));
                        Model.Overtime = Convert.ToDecimal((dt.Rows[i]["Overtime"]).ToString().Replace("\"", ""));
                        Model.Dates_on_which_overtime_worked = Convert.ToString((dt.Rows[i]["Dates_on_which_overtime_worked"]).ToString().Replace("\"", ""));
                        Model.Extent_of_overtime_on_each_occasion = Convert.ToString((dt.Rows[i]["Extent_of_overtime_on_each_occasion"]).ToString().Replace("\"", ""));
                        Model.Total_overtime_worked_or_production_in_case_of_piece_rated = Convert.ToDecimal((dt.Rows[i]["Total_overtime_worked_or_production_in_case_of_piece_rated"]).ToString().Replace("\"", ""));
                        Model.Overtime_rate_of_wages = Convert.ToDecimal((dt.Rows[i]["Overtime_rate_of_wages"]).ToString().Replace("\"", ""));
                        Model.Normal_hours = Convert.ToDecimal((dt.Rows[i]["Normal_hours"]).ToString().Replace("\"", ""));
                        Model.Normal_Rate = Convert.ToDecimal((dt.Rows[i]["Normal_Rate"]).ToString().Replace("\"", ""));
                        Model.Normal_earnings = Convert.ToDecimal((dt.Rows[i]["Normal_earnings"]).ToString().Replace("\"", ""));
                        Model.Overtime_earnings_total_Earning = Convert.ToDecimal((dt.Rows[i]["Overtime_earnings_total_Earning"]).ToString().Replace("\"", ""));
                        Model.Date_on_which_overtime_wages_paid = Convert.ToString((dt.Rows[i]["Date_on_which_overtime_wages_paid"]).ToString().Replace("\"", ""));
                        Model.Date_on_which_overtime_payment_made = Convert.ToString((dt.Rows[i]["Date_on_which_overtime_payment_made"]).ToString().Replace("\"", ""));
                        Model.Remarks_Other = Convert.ToString((dt.Rows[i]["Remarks_Other"]).ToString().Replace("\"", ""));
                        Model.Leave_Encahsment = Convert.ToDecimal((dt.Rows[i]["Leave_Encahsment"]).ToString().Replace("\"", ""));
                         
                        var results = new List<ValidationResult>();
                        var vc = new ValidationContext(Model, null, null);
                        var isValid = Validator.TryValidateObject(Model, vc, results, true);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                        strerr = string.Join(" ", errors);
                        if (isValid)
                        {
                            results = new List<ValidationResult>();
                            vc = new ValidationContext(Model, null, null);
                            isValid = Validator.TryValidateObject(Model, vc, results, true);
                            errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                            strerr = string.Join(" ", errors);
                            if (isValid)
                            {
                                int Result = Convert.ToInt32(AddUpdateSalaryRegister(Model));
                                if (Result >= 0)
                                {
                                    SuccessCount += 1;
                                    dt.Rows[i]["Response"] = "Success";
                                }
                                else
                                {
                                    FailCount += 1;
                                    if (Result == -1)
                                    {
                                        dt.Rows[i]["Message"] = "Duplicate";
                                    }
                                    dt.Rows[i]["Response"] = "Failed";
                                }
                            }
                            else
                            {
                                FailCount += 1;
                                dt.Rows[i]["Response"] = strerr;
                            }
                        }
                        else
                        {
                            FailCount += 1;
                            dt.Rows[i]["Response"] = "Failed";
                            dt.Rows[i]["Message"] = strerr;
                            //Message
                        }
                    }
                    catch
                    {
                        FailCount += 1;
                        dt.Rows[i]["Response"] = "Failed";
                        dt.Rows[i]["Message"] = "Invalid Data Format";
                        continue;
                    }
                }
                //Converting dt into csv FIle
                FilePath = CSVUtills.DataTableToCSV(dt, ",");
                return FilePath;
            }
            catch
            {
                throw;
            }
        }

        public string UploadMusterRolldata(string FilePath, string SampleFilePath, int CreatedBy, ref int SuccessCount, ref int FailCount)
        {
            try
            {
                //Convert csv file into DataTable
                DataTable dt = null;
                try
                {
                    dt = CSVUtills.CSVToDataTable(FilePath, '|');
                }
                catch (Exception Ex)
                {
                    return Ex.Message;
                }

                if (!CheckColumnFormatSalary(FilePath, SampleFilePath))
                {
                    return "Invalid File Format";
                }
                dt.Columns.Add("Response");
                dt.Columns.Add("Message");

                MusterRolldata Model;
                GenerateRepRepo objSalaryRep = new GenerateRepRepo();


                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    try
                    {
                        string strerr = "";
                        Model = new MusterRolldata();
                        if (Convert.ToString(dt.Rows[i]["Paydate"]) == "" || dt.Rows[i]["Paydate"] == null)
                        {
                            Model.Paydate = null;
                        }
                        else { Model.Paydate = Convert.ToDateTime((dt.Rows[i]["Paydate"]).ToString().Replace("\"", "").Trim()); }
  Model.Company_Code = Convert.ToString((dt.Rows[i]["Company_Code"]).ToString().Replace("\"","").Trim());
  Model.Site_Code = Convert.ToString((dt.Rows[i]["Site_Code"]).ToString().Replace("\"", "").Trim());
  Model.Employee_code = Convert.ToString((dt.Rows[i]["Employee_code"]).ToString().Replace("\"", "").Trim());
  Model.Opening_Time = Convert.ToString((dt.Rows[i]["Opening_Time"]).ToString().Replace("\"", ""));
  Model.Lunch_Time = Convert.ToString((dt.Rows[i]["Lunch_Time"]).ToString().Replace("\"", ""));
  Model.Closing_Time = Convert.ToString((dt.Rows[i]["Closing_Time"]).ToString().Replace("\"", ""));
  Model.d1 = Convert.ToString((dt.Rows[i]["d1"]).ToString().Replace("\"", ""));
  Model.d2 = Convert.ToString((dt.Rows[i]["d2"]).ToString().Replace("\"", ""));
  Model.d3 = Convert.ToString((dt.Rows[i]["d3"]).ToString().Replace("\"", ""));
  Model.d4 = Convert.ToString((dt.Rows[i]["d4"]).ToString().Replace("\"", ""));
  Model.d5 = Convert.ToString((dt.Rows[i]["d5"]).ToString().Replace("\"", ""));
  Model.d6 = Convert.ToString((dt.Rows[i]["d6"]).ToString().Replace("\"", ""));
  Model.d7 = Convert.ToString((dt.Rows[i]["d7"]).ToString().Replace("\"", ""));
  Model.d8 = Convert.ToString((dt.Rows[i]["d8"]).ToString().Replace("\"", ""));
  Model.d9 = Convert.ToString((dt.Rows[i]["d9"]).ToString().Replace("\"", ""));
  Model.d10 = Convert.ToString((dt.Rows[i]["d10"]).ToString().Replace("\"", ""));
  Model.d11 = Convert.ToString((dt.Rows[i]["d11"]).ToString().Replace("\"", ""));
  Model.d12 = Convert.ToString((dt.Rows[i]["d12"]).ToString().Replace("\"", ""));
  Model.d13 = Convert.ToString((dt.Rows[i]["d13"]).ToString().Replace("\"", ""));
  Model.d14 = Convert.ToString((dt.Rows[i]["d14"]).ToString().Replace("\"", ""));
  Model.d15 = Convert.ToString((dt.Rows[i]["d15"]).ToString().Replace("\"", ""));
  Model.d16 = Convert.ToString((dt.Rows[i]["d16"]).ToString().Replace("\"", ""));
  Model.d17 = Convert.ToString((dt.Rows[i]["d17"]).ToString().Replace("\"", ""));
  Model.d18 = Convert.ToString((dt.Rows[i]["d18"]).ToString().Replace("\"", ""));
  Model.d19 = Convert.ToString((dt.Rows[i]["d19"]).ToString().Replace("\"", ""));
  Model.d20 = Convert.ToString((dt.Rows[i]["d20"]).ToString().Replace("\"", ""));
  Model.d21 = Convert.ToString((dt.Rows[i]["d21"]).ToString().Replace("\"", ""));
  Model.d22 = Convert.ToString((dt.Rows[i]["d22"]).ToString().Replace("\"", ""));
  Model.d23 = Convert.ToString((dt.Rows[i]["d23"]).ToString().Replace("\"", ""));
  Model.d24 = Convert.ToString((dt.Rows[i]["d24"]).ToString().Replace("\"", ""));
  Model.d25 = Convert.ToString((dt.Rows[i]["d25"]).ToString().Replace("\"", ""));
  Model.d26 = Convert.ToString((dt.Rows[i]["d26"]).ToString().Replace("\"", ""));
  Model.d27 = Convert.ToString((dt.Rows[i]["d27"]).ToString().Replace("\"", ""));
  Model.d28 = Convert.ToString((dt.Rows[i]["d28"]).ToString().Replace("\"", ""));
  Model.d29 = Convert.ToString((dt.Rows[i]["d29"]).ToString().Replace("\"", ""));
  Model.d30 = Convert.ToString((dt.Rows[i]["d30"]).ToString().Replace("\"", ""));
  Model.d31 = Convert.ToString((dt.Rows[i]["d31"]).ToString().Replace("\"", ""));
  Model.Total_Attendance = Convert.ToDecimal((dt.Rows[i]["Total_Attendance"]).ToString().Replace("\"", ""));
  Model.Remarks = Convert.ToString((dt.Rows[i]["Remarks"]).ToString().Replace("\"",""));
  Model.Date_overtime_extent_of_overtime_each_day = Convert.ToString((dt.Rows[i]["Date_overtime_extent_of_overtime_each_day"]).ToString().Replace("\"", ""));
  Model.Opening_Blance_PL = Convert.ToDecimal((dt.Rows[i]["Opening_Blance_PL"]).ToString().Replace("\"", ""));
  Model.Earned_during_month_PL = Convert.ToDecimal((dt.Rows[i]["Earned_during_month_PL"]).ToString().Replace("\"", ""));
  Model.Availed_during_month_PL = Convert.ToDecimal((dt.Rows[i]["Availed_during_month_PL"]).ToString().Replace("\"", ""));
  Model.Closing_Blance_PL = Convert.ToDecimal((dt.Rows[i]["Closing_Blance_PL"]).ToString().Replace("\"", ""));
  Model.Leave_Availed_Date_PL = Convert.ToString((dt.Rows[i]["Leave_Availed_Date_PL"]).ToString().Replace("\"", ""));
  Model.Date_of_Application_of_Leave_PL = Convert.ToString((dt.Rows[i]["Date_of_Application_of_Leave_PL"]).ToString().Replace("\"", ""));
  Model.Opening_Blance_CL = Convert.ToDecimal((dt.Rows[i]["Opening_Blance_CL"]).ToString().Replace("\"", ""));
  Model.Earned_during_month_CL = Convert.ToDecimal((dt.Rows[i]["Earned_during_month_CL"]).ToString().Replace("\"", ""));
  Model.Availed_during_month_CL = Convert.ToDecimal((dt.Rows[i]["Availed_during_month_CL"]).ToString().Replace("\"", ""));
  Model.Closing_Blance_CL = Convert.ToDecimal((dt.Rows[i]["Closing_Blance_CL"]).ToString().Replace("\"", ""));
  Model.Leave_Availed_Date_CL = Convert.ToString((dt.Rows[i]["Leave_Availed_Date_CL"]).ToString().Replace("\"", ""));
  Model.Date_of_Application_of_Leave_CL = Convert.ToString((dt.Rows[i]["Date_of_Application_of_Leave_CL"]).ToString().Replace("\"", ""));
  Model.Opening_Blance_SL = Convert.ToDecimal((dt.Rows[i]["Opening_Blance_SL"]).ToString().Replace("\"", ""));
  Model.Earned_during_month_SL = Convert.ToDecimal((dt.Rows[i]["Earned_during_month_SL"]).ToString().Replace("\"", ""));
  Model.Availed_during_month_SL = Convert.ToDecimal((dt.Rows[i]["Availed_during_month_SL"]).ToString().Replace("\"", ""));
  Model.Closing_Blance_SL = Convert.ToDecimal((dt.Rows[i]["Closing_Blance_SL"]).ToString().Replace("\"", ""));
  Model.Leave_Availed_Date_SL = Convert.ToString((dt.Rows[i]["Leave_Availed_Date_SL"]).ToString().Replace("\"", ""));
  Model.Date_of_Application_of_Leave_SL = Convert.ToString((dt.Rows[i]["Date_of_Application_of_Leave_SL"]).ToString().Replace("\"", ""));
  Model.Opening_Blance_ML = Convert.ToDecimal((dt.Rows[i]["Opening_Blance_ML"]).ToString().Replace("\"", ""));
  Model.Availed_during_month_ML = Convert.ToDecimal((dt.Rows[i]["Availed_during_month_ML"]).ToString().Replace("\"", ""));
  Model.Closing_Blance_ML = Convert.ToDecimal((dt.Rows[i]["Closing_Blance_ML"]).ToString().Replace("\"", ""));
  Model.Leave_Availed_Date_ML = Convert.ToString((dt.Rows[i]["Leave_Availed_Date_ML"]).ToString().Replace("\"", ""));
  Model.Date_of_Application_of_Leave_ML = Convert.ToString((dt.Rows[i]["Date_of_Application_of_Leave_ML"]).ToString().Replace("\"", ""));
  Model.Weekly_Company_Holidays = Convert.ToString((dt.Rows[i]["Weekly_Company_Holidays"]).ToString().Replace("\"", ""));
  Model.Date_Of_Leaving = Convert.ToString((dt.Rows[i]["Date_Of_Leaving"]).ToString().Replace("\"", ""));
  Model.Worked_Hours = Convert.ToDecimal((dt.Rows[i]["Worked_Hours"]).ToString().Replace("\"", ""));
  Model.Yearly_Company_Holidays = Convert.ToString((dt.Rows[i]["Yearly_Company_Holidays"]).ToString().Replace("\"", ""));

                          var results = new List<ValidationResult>();
                        var vc = new ValidationContext(Model, null, null);
                        var isValid = Validator.TryValidateObject(Model, vc, results, true);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                        strerr = string.Join(" ", errors);
                        if (isValid)
                        {
                            results = new List<ValidationResult>();
                            vc = new ValidationContext(Model, null, null);
                            isValid = Validator.TryValidateObject(Model, vc, results, true);
                            errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                            strerr = string.Join(" ", errors);
                            if (isValid)
                            {
                                int Result = Convert.ToInt32(AddUpdateMusterRolldata(Model));
                                if (Result >= 0)
                                {
                                    SuccessCount += 1;
                                    dt.Rows[i]["Response"] = "Success";
                                }
                                else
                                {
                                    FailCount += 1;
                                    if (Result == -1)
                                    {
                                        dt.Rows[i]["Message"] = "Duplicate";
                                    }
                                    dt.Rows[i]["Response"] = "Failed";
                                }
                            }
                            else
                            {
                                FailCount += 1;
                                dt.Rows[i]["Response"] = strerr;
                            }
                        }
                        else
                        {
                            FailCount += 1;
                            dt.Rows[i]["Response"] = "Failed";
                            dt.Rows[i]["Message"] = strerr;
                            //Message
                        }
                    }
                    catch
                    {
                        FailCount += 1;
                        dt.Rows[i]["Response"] = "Failed";
                        dt.Rows[i]["Message"] = "Invalid Data Format";
                        continue;
                    }
                }
                //Converting dt into csv FIle
                FilePath = CSVUtills.DataTableToCSV(dt, ",");
                return FilePath;
            }
            catch
            {
                throw;
            }
        }




    }
}