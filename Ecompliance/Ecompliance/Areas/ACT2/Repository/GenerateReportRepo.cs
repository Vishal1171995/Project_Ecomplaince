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
    public class GenerateReportRepo
    {

        public string GenerateReport(GenerateReportVM ObjVM,User uBo)
        {
            
            try
            {
                CreateFolder(ObjVM.PayDate);
                CreateFolder(ObjVM.PayDate + "\\" + ObjVM.State);
                string MQRY = "";
                DataSet dsdata = new DataSet();
                DataSet dsSendType=new DataSet();
                if (ObjVM.Location  == 0)
                {
                    MQRY = "SELECT distinct  s.state[Sid], st.Name [State], s.location [locationid], l.Name [Location], s.company [companyid], c.Code, c.Name, s.site_code, s.Name [Site Name], s.Address , REPLACE(RIGHT(CONVERT(VARCHAR(11), m.paydate , 106), 8), ' ', ', ') [Month] from Ecom_Mst_Site s with(nolock) inner join Ecom_Mst_State st with(nolock) on s.State = st.StateID  inner join Ecom_Mst_Company c with(nolock) on s.Company = c.CompID  inner join Ecom_Mst_Location l with(nolock) on s.Location = l.LocationID inner join Ecom_muster_rolldata m with(nolock) on s.Site_Code = m.Site_Code and m.Company_Code = c.Code where st.StateID = " + ObjVM.State + " and m.paydate='" + ObjVM.PayDate + "' and s.eff_date_fr <='" + ObjVM.PayDate + "' and s.eff_date_to >='" + ObjVM.PayDate + "' order by st.name, Location, c.Name ";
                }
                else if (ObjVM.Company == 0)
                {
                    MQRY = "SELECT distinct  s.state[Sid], st.Name [State], s.location [locationid], l.Name [Location], s.company [companyid], c.Code, c.Name, s.site_code, s.Name [Site Name], s.Address , REPLACE(RIGHT(CONVERT(VARCHAR(11), m.paydate , 106), 8), ' ', ', ') [Month] from Ecom_Mst_Site s with(nolock) inner join Ecom_Mst_State st with(nolock) on s.State = st.StateID  inner join Ecom_Mst_Company c with(nolock) on s.Company = c.CompID  inner join Ecom_Mst_Location l with(nolock) on s.Location = l.LocationID inner join Ecom_muster_rolldata m with(nolock) on s.Site_Code = m.Site_Code and m.Company_Code = c.Code where st.StateID = " + ObjVM.State + " and s.location = " + ObjVM.Location + " and m.paydate='" + ObjVM.PayDate + "'  and s.eff_date_fr <='" + ObjVM.PayDate + "' and s.eff_date_to >='" + ObjVM.PayDate + "' order by st.name, Location, c.Name ";
                }
                else if (ObjVM.Site == 0)
                {
                    MQRY = "SELECT distinct  s.state[Sid], st.Name [State], s.location [locationid], l.Name [Location], s.company [companyid], c.Code, c.Name, s.site_code, s.Name [Site Name], s.Address , REPLACE(RIGHT(CONVERT(VARCHAR(11), m.paydate , 106), 8), ' ', ', ') [Month] from Ecom_Mst_Site s with(nolock) inner join Ecom_Mst_State st with(nolock) on s.State = st.StateID  inner join Ecom_Mst_Company c with(nolock) on s.Company = c.CompID  inner join Ecom_Mst_Location l with(nolock) on s.Location = l.LocationID inner join Ecom_muster_rolldata m with(nolock) on s.Site_Code = m.Site_Code and m.Company_Code = c.Code where st.StateID = " + ObjVM.State + " and s.location = " + ObjVM.Location + " and s.company =  " + ObjVM.Company + " and m.paydate='" + ObjVM.PayDate + "'  and s.eff_date_fr <='" + ObjVM.PayDate + "' and s.eff_date_to >='" + ObjVM.PayDate + "' order by st.name, Location, c.Name ";
                }
                else if (ObjVM.Site != 0)
                {
                    MQRY = "SELECT distinct  s.state[Sid], st.Name [State], s.location [locationid], l.Name [Location], s.company [companyid], c.Code, c.Name, s.site_code, s.Name [Site Name], s.Address , REPLACE(RIGHT(CONVERT(VARCHAR(11), m.paydate , 106), 8), ' ', ', ') [Month] from Ecom_Mst_Site s with(nolock) inner join Ecom_Mst_State st with(nolock) on s.State = st.StateID  inner join Ecom_Mst_Company c with(nolock) on s.Company = c.CompID  inner join Ecom_Mst_Location l with(nolock) on s.Location = l.LocationID inner join Ecom_muster_rolldata m with(nolock) on s.Site_Code = m.Site_Code and m.Company_Code = c.Code where st.StateID = " + ObjVM.State + " and s.location = " + ObjVM.Location + " and s.company =  " + ObjVM.Company + " and s.siteid = " + ObjVM.Site + " and m.paydate='" + ObjVM.PayDate + "'  and s.eff_date_fr <='" + ObjVM.PayDate + "' and s.eff_date_to >='" + ObjVM.PayDate + "' order by st.name, Location, c.Name ";
                }
                //da.SelectCommand.CommandText = MQRY;
                //da.SelectCommand.CommandTimeout = 3000;
                //da.Fill(ds1, "data");
                dsdata=DataLib.ExecuteDataSet(MQRY,CommandType.Text,null);
                string Pdffile = "";
             
               for (int q = 0; q <= dsdata.Tables[0].Rows.Count - 1; q++)
                {
                    string StrQry = "";
                     StrQry="select tid,template_name[Rcode],report_desc[Rdesc],format,qry from ecom_Print_Template with(nolock) where  HUB  =" + dsdata.Tables[0].Rows[q][0].ToString();
                    if (ObjVM.Groupdata == "0")
                    {
                        StrQry = "select tid,template_name[Rcode],report_desc[Rdesc],format,qry,SQL_CHILDITEM from ecom_Print_Template with(nolock) where  HUB  =" + dsdata.Tables[0].Rows[q][0].ToString()+" and format='0'";
                    }
                    else {
                        StrQry = "select tid,template_name[Rcode],report_desc[Rdesc],format,qry,SQL_CHILDITEM from ecom_Print_Template with(nolock) where  HUB  =" + dsdata.Tables[0].Rows[q][0].ToString() + " and format='1'";
                    }
                    //da.SelectCommand.CommandText = "select tid,template_name[Rcode],report_desc[Rdesc],format,qry from ecom_Print_Template with(nolock) where  HUB  =" + ds1.Tables("data").Rows(q).Item(0).ToString;
                    DataTable dt = new DataTable();
                    dt.Rows.Clear();
                    dt=DataLib.ExecuteDataTable(StrQry,CommandType.Text,null);
                    //da.Fill(dt);

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
                            string Sqry = "";
                            Sqry = "SELECT distinct l.Name [Location], s.company [companyid], c.Code, c.Name,s.site_code, s.Name [Site Name] from Ecom_Mst_Site s with(nolock) inner join Ecom_Mst_State st with(nolock) on s.State = st.StateID inner join Ecom_Mst_Company c with(nolock) on s.Company = c.CompID inner join Ecom_Mst_Location l with(nolock) on s.Location = l.LocationID inner join Ecom_muster_rolldata m with(nolock) on s.Site_Code = m.Site_Code and m.Company_Code = c.Code where l.name ='" + dsdata.Tables[0].Rows[q]["Location"].ToString() +"' and m.site_code ='"
                                        + dsdata.Tables[0].Rows[q]["site_code"].ToString() + "' and m.company_code = '"
                                        + dsdata.Tables[0].Rows[q]["Code"].ToString() + "' and m.paydate='"
                                        + ObjVM.PayDate.ToString()+"'";
                            dsEdata = DataLib.ExecuteDataSet(Sqry, CommandType.Text, null);
                           for(int k=0; k <= dsEdata.Tables[0].Rows.Count - 1; k++)
                            {
                                Document document = new Document(new iTextSharp.text.Rectangle(850.0F, 1100.0F));
                                string parameterName = dsdata.Tables[0].Rows[q]["name"].ToString().Replace("/", "").Replace("\\", "");
                                string path = CreateFolder(ObjVM.PayDate + "\\" + dsdata.Tables[0].Rows[q]["state"].ToString() + "\\" + dsdata.Tables[0].Rows[q]["Location"].ToString() + "\\" + parameterName + "\\" + dsdata.Tables[0].Rows[q]["Site Name"].ToString() + "_" + dsdata.Tables[0].Rows[q]["site_code"].ToString());
                                if (dsTdata.Tables[0].Rows[0]["view_type"].ToString() == "L") {
                                    document.SetPageSize(iTextSharp.text.PageSize.LEGAL_LANDSCAPE.Rotate());
                                   }
                                PdfWriter.GetInstance(document, new FileStream(path + "/" + dt.Rows[r]["Rdesc"].ToString() + ".pdf", FileMode.Create));
                             
                                CreateFolder(ObjVM.PayDate + "\\" + dsdata.Tables[0].Rows[q]["state"].ToString() + "\\" + dsdata.Tables[0].Rows[q]["Location"].ToString());
                                CreateFolder(ObjVM.PayDate + "\\" + dsdata.Tables[0].Rows[q]["state"].ToString() + "\\" + dsdata.Tables[0].Rows[q]["Location"].ToString() + "\\" + parameterName);
                                CreateFolder(ObjVM.PayDate + "\\" + dsdata.Tables[0].Rows[q]["state"].ToString() + "\\" + dsdata.Tables[0].Rows[q]["Location"].ToString() + "\\" + parameterName + "\\" + dsdata.Tables[0].Rows[q]["Site Name"].ToString() + "_" + dsdata.Tables[0].Rows[q]["site_code"].ToString());
                                DataSet dsNqry = new DataSet();
                                string MainQry = "";
                                string ChildQry = "";
                                string Rqry = "";
                                MainQry = dt.Rows[r]["qry"].ToString();
                                ChildQry = dt.Rows[r]["SQL_CHILDITEM"].ToString();
                                string Nqry = "select distinct company_code[CustCode],site_code[SiteCode],employee_code[ecode] from ecom_muster_roll" +
                                "data with(nolock) where site_code='"
                                            + dsEdata.Tables[0].Rows[k]["site_code"].ToString() + "' and Company_Code ='"
                                            + dsEdata.Tables[0].Rows[k]["Code"].ToString() + "' and paydate = '"
                                            + ObjVM.PayDate + "'";
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
                                    {   new SqlParameter("@companycode",dsEdata.Tables[0].Rows[k]["Code"].ToString()),
                                    new SqlParameter("@sitecode", dsNqry.Tables[0].Rows[m]["SiteCode"].ToString()),
                                    new SqlParameter("@ecode",dsNqry.Tables[0].Rows[m]["ecode"].ToString()),
                                    new SqlParameter("@PayDate", ObjVM.PayDate)
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
                                        //OutputStream stream = new OutputStream();
                                        //PdfWriter.getInstance(document, stream);
                                        //return stream.toByteArray();
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
                                    {   new SqlParameter("@companycode",dsEdata.Tables[0].Rows[k]["Code"].ToString()),
                                    new SqlParameter("@sitecode", dsNqry.Tables[0].Rows[m]["SiteCode"].ToString()),
                                    new SqlParameter("@ecode",dsNqry.Tables[0].Rows[m]["ecode"].ToString()),
                                    new SqlParameter("@PayDate", ObjVM.PayDate)
                                     };
                                        Qry = DataLib.ExecuteScaler(ChildQry.Trim(), CommandType.StoredProcedure, ChildP);
                                        dschild = DataLib.ExecuteDataSet(Qry, CommandType.Text, null);
                                        //if ((dschild.Tables[0].Rows.Count == 0))
                                        //{
                                        //    // TODO: Continue For... Warning!!! not translated
                                        //}
                                        if (dschild.Tables[0].Rows.Count > 0) { 
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
                                string parameter = dsdata.Tables[0].Rows[q]["name"].ToString().Replace("/", "").Replace("\\", "");
                                CreateCSVR(dt.Rows[r]["tid"].ToString(), dt.Rows[r]["Rcode"].ToString() + "_" + dt.Rows[r]["Rdesc"].ToString(), q,
                                dsdata.Tables[0].Rows[q]["state"].ToString(), dsdata.Tables[0].Rows[q]["Location"].ToString(), dsdata.Tables[0].Rows[q]["code"].ToString(),
                                parameter,
                                dsdata.Tables[0].Rows[q]["site_code"].ToString(), dsdata.Tables[0].Rows[q]["site name"].ToString(), ObjVM.PayDate,
                                dt.Rows[r]["format"].ToString());
                            }
                            else
                            {
                                string parameter1 = dsdata.Tables[0].Rows[q]["name"].ToString().Replace("/", "").Replace("\\", "");
                                Pdffile = GenerateMailPdf(dt.Rows[r]["tid"].ToString(), dt.Rows[r]["Rcode"].ToString() + "_" + dt.Rows[r]["Rdesc"].ToString(), q,
                                    dsdata.Tables[0].Rows[q]["state"].ToString(), dsdata.Tables[0].Rows[q]["Location"].ToString(),
                                    dsdata.Tables[0].Rows[q]["code"].ToString(),
                                   parameter1,
                                    dsdata.Tables[0].Rows[q]["site_code"].ToString(), dsdata.Tables[0].Rows[q]["site name"].ToString(), ObjVM.PayDate,
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
            return "Action Completed";
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
            //string ff = System.IO.Path.GetFullPath("E:\\ACT2\\") + path;
            string ff = System.IO.Path.GetFullPath("D:\\ACT\\") + path;
            if (!Directory.Exists(ff))
            {
                Directory.CreateDirectory(ff);
            }
            return ff;
        }
        private void WritePdf(string mBody, string filename, string  tid, string path, string format)
        {
            try
            {
                DataTable dt = new DataTable();
                StringBuilder _strRepeater = new StringBuilder(mBody);
                Html32TextWriter _ObjHtm = new Html32TextWriter(new System.IO.StringWriter(_strRepeater));
                string _str = _strRepeater.ToString();
                Document document = new Document(new iTextSharp.text.Rectangle(850f, 1100f));
                string strQry = "select view_type from ecom_Print_Template where tid=@tid";
                SqlParameter[] parameters = new SqlParameter[] { new SqlParameter("@tid", tid) };
                dt = DataLib.ExecuteDataTable(strQry, CommandType.Text, parameters);
                if (dt.Rows[0][0].ToString() != "P")
                {
                    document.SetPageSize(iTextSharp.text.PageSize.LEGAL_LANDSCAPE.Rotate());
                }
                PdfWriter.GetInstance(document, new FileStream((path + "/" + filename + ".pdf"), FileMode.Create));

                document.Open();
                List<IElement> htmlarraylist = iTextSharp.text.html.simpleparser.HTMLWorker.ParseToList(new StringReader(_str), null);
                for (int k = 0; k <= htmlarraylist.Count - 1; k++)
                {
                    document.Add((IElement)htmlarraylist[k]);
                }
                document.Close();
            }
            catch { }
        }


        private string CreateCSVR(string tid, string filename, int k, string state, string Loc, string clientcode, string client, string sitecode, string site, string paydate,
        string Format)
        {
            string functionReturnValue = null;
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
                CreateFolder(paydate + "\\" + state + "\\" + Loc);
                CreateFolder(paydate + "\\" + state + "\\" + Loc + "\\" + client);
                CreateFolder(paydate + "\\" + state + "\\" + Loc + "\\" + client + "\\" + site + "_" + sitecode);
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
                        //da.SelectCommand.Parameters.Clear();
                        //da.SelectCommand.CommandText = childQry;
                        //da.SelectCommand.CommandType = CommandType.StoredProcedure;
                        //da.SelectCommand.Parameters.AddWithValue("@companycode", clientcode);
                        //da.SelectCommand.Parameters.AddWithValue("@sitecode", sitecode);
                        //da.SelectCommand.Parameters.AddWithValue("@PayDate", paydate);
                        //if (con.State != ConnectionState.Open)
                        //{
                        //    con.Open();
                        //}
                        Qry = DataLib.ExecuteScaler(childQry.Trim(),CommandType.StoredProcedure,p);
                        //Else
                        //    Dim STR As String = ""
                        //    STR = childQry.Replace("@assgn_code", sitecode)
                        //    da.SelectCommand.CommandText = STR
                    }
                    //da.SelectCommand.CommandType = CommandType.Text;
                    //da.SelectCommand.CommandText = Qry;
                    //da.SelectCommand.CommandTimeout = 300;
                    //if (con.State != ConnectionState.Open)
                    //{
                    //    con.Open();
                    //}

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
                    // Dim Location As String = Trim(ds.Tables("main").Rows(0).Item("Location").ToString())
                    //Dim Code As String = Trim(ds.Tables("main").Rows(0).Item("Code").ToString())
                    // For Month
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
                    // Exl_body = Replace(Exl_body, "[Location]", Location)
                    //Exl_body = Replace(Exl_body, "[Code]", Code)
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
                    //Report_Log(state, LocationName, CompanyName, AssignCode, paydate)
                    return path + "/" + filename + ".xls";
                }
                else
                {
                    //Report_Log(state, LocationName, CompanyName, AssignCode, paydate)
                    return path + "/" + filename + ".xls";
                }



            }
            catch (Exception ex)
            {
            }
            return functionReturnValue;

        }

        public string GenerateMailPdf(string tid, string filename, int k, string state, string Loc, string clientcode, string client, string sitecode, string site, string paydate,
        string Format)
        {
            string functionReturnValue = null;
            //string conStr = ConfigurationManager.ConnectionStrings("conStr").ConnectionString;
            //SqlConnection con = new SqlConnection(conStr);
            //SqlDataAdapter da = new SqlDataAdapter("", con);
            DataSet dsdata1 = new DataSet();
            DataSet dsdmain = new DataSet();
            DataSet dschild = new DataSet();
            try
            {
                //da.SelectCommand.CommandText = "select * from Ecom_Print_Template with(nolock) where tid = '" + tid + "'";
                CreateFolder(paydate + "\\" + state + "\\" + Loc);
                CreateFolder(paydate + "\\" + state + "\\" + Loc + "\\" + client);
                CreateFolder(paydate + "\\" + state + "\\" + Loc + "\\" + client + "\\" + site + "_" + sitecode);
                string path = CreateFolder(paydate + "\\" + state + "\\" + Loc + "\\" + client + "\\" + site + "_" + sitecode);

                if (File.Exists(path + "/" + filename + ".xls"))
                {
                    File.Delete(path + "/" + filename + ".xls");
                }
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
                            //da.SelectCommand.Parameters.Clear();
                            //da.SelectCommand.CommandText = childQry;
                            //da.SelectCommand.CommandType = CommandType.StoredProcedure;
                            //da.SelectCommand.Parameters.AddWithValue("@companycode", clientcode);
                            //da.SelectCommand.Parameters.AddWithValue("@sitecode", sitecode);
                            //da.SelectCommand.Parameters.AddWithValue("@PayDate", paydate);
                            //if (con.State != ConnectionState.Open)
                            //{
                            //    con.Open();
                            //}
                            //Qry = da.SelectCommand.ExecuteScalar();
                            Qry = DataLib.ExecuteScaler(childQry, CommandType.StoredProcedure, p);
                            //Else
                            //Dim STR As String = ""
                            //STR = childQry.Replace("@assgn_code", AssignCode)
                            //STR = STR.Replace("@job_code", JobCode)
                            //da.SelectCommand.CommandText = STR
                        }
                    }
                    //da.SelectCommand.CommandType = CommandType.Text;
                    //da.SelectCommand.CommandText = Qry;
                    //da.SelectCommand.CommandTimeout = 300;
                    //if (con.State != ConnectionState.Open)
                    //{
                    //    con.Open();
                    //}
                    //da.Fill(ds, "child");
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
                WritePdf(body, filename, tid, path, Format);


                return filename;
                //Report_Log(ddlHub.SelectedItem.Text, LocationName, CompanyName, AssignCode, paydate)

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



   




    }
}