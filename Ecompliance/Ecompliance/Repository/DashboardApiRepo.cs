using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Ecompliance.Repository
{
    public class DashboardApiRepo
    {
        public DataTable GetDashBoardHomeCount(int UID)
        {

            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Type","HomeDet"),
                    new SqlParameter("@uid",UID)

                };

                dt = DataLib.ExecuteDataTable("[GetClientDashboard_API_01092017_1_1]", CommandType.StoredProcedure, parameters); //GetClientDashboard

                return dt;
            }

            catch
            {

            }

            return dt;

        }
        public DataTable GetDashBoardHomeCount(int UID, string CompanyID, string SMonth, string SYear, string TMonth, string TYear)
        {

            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Type","HomeDet"),
                    new SqlParameter("@CompanyId",CompanyID),
                    new SqlParameter("@SMonth",SMonth),
                    new SqlParameter("@SYear",SYear),
                    new SqlParameter("@TMonth",TMonth),
                    new SqlParameter("@TYear",TYear),
                    new SqlParameter("@uid",UID)

                };

                dt = DataLib.ExecuteDataTable("[GetClientDashboard_API_01092017_1_1]", CommandType.StoredProcedure, parameters); //GetClientDashboard
                //[GetClientDashboard]
                return dt;
            }

            catch
            {

            }

            return dt;

        }



        public DataTable GetDashBoardCompanyTot(string CompanyID, string SMonth, string SYear, string TMonth, string TYear, int UID = 0)
        {

            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Type","CompanyTot"),
                    new SqlParameter("@CompanyId",CompanyID),
                    new SqlParameter("@SMonth",SMonth),
                    new SqlParameter("@SYear",SYear),
                    new SqlParameter("@TMonth",TMonth),
                    new SqlParameter("@TYear",TYear),
                      new SqlParameter("@UID",UID)


                };

                dt = DataLib.ExecuteDataTable("[GetClientDashboard_API_01092017_1_1]", CommandType.StoredProcedure, parameters); //GetClientDashboard

                return dt;
            }

            catch
            {

            }

            return dt;

        }
        public static DataTable GetMappedCompany(int UID)
        {
            try
            {
                SqlParameter[] p = { new SqlParameter("@UID", UID) };

                return DataLib.ExecuteDataTable("GetMappedCompany00", CommandType.StoredProcedure, p); //GetMappedCompany00
            }
            catch(Exception ex) { throw; }
        }

        public DataTable GetDashBoardSiteWise(string CompanyID, string SMonth, string SYear, string TMonth, string TYear, int UID = 0)
        {

            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Type","SiteWise"),
                    new SqlParameter("@CompanyId",CompanyID),
                    new SqlParameter("@SMonth",SMonth),
                    new SqlParameter("@SYear",SYear),
                    new SqlParameter("@TMonth",TMonth),
                    new SqlParameter("@TYear",TYear),
                      new SqlParameter("@UID",UID)

                };

                dt = DataLib.ExecuteDataTable("[GetClientDashboard_API_01092017_1_1]", CommandType.StoredProcedure, parameters); //GetClientDashboard

                return dt;
            }

            catch(Exception ex)
            {

            }

            return dt;

        }
        //ActClick

        public DataTable GetDashBoardActClick(string CompanyID, string ActID, string Status, string SMonth, string SYear, string TMonth, string TYear, int UID = 0)
        {

            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Type","ActClick"),
                     new SqlParameter("@CompanyId",CompanyID),
                    new SqlParameter("@SMonth",SMonth),
                    new SqlParameter("@SYear",SYear),
                    new SqlParameter("@TMonth",TMonth),
                    new SqlParameter("@TYear",TYear),
                    new SqlParameter("@ActID",ActID),
                    new SqlParameter("@Status",Status),
                      new SqlParameter("@UID",UID)

                };

                dt = DataLib.ExecuteDataTable("[GetClientDashboard_API_01092017_1_1]", CommandType.StoredProcedure, parameters); //GetClientDashboard

                return dt;
            }

            catch(Exception ex)
            {

            }

            return dt;

        }

        public DataTable GetDashBoardActWise(string CompanyID, string SMonth, string SYear, string TMonth, string TYear, int UID = 0)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Type","ActWise"),
                    new SqlParameter("@CompanyId",CompanyID),
                    new SqlParameter("@SMonth",SMonth),
                    new SqlParameter("@SYear",SYear),
                    new SqlParameter("@TMonth",TMonth),
                    new SqlParameter("@TYear",TYear),
                    new SqlParameter("@UID",UID)
                };
                dt = DataLib.ExecuteDataTable("[GetClientDashboard_API_01092017_1_1]", CommandType.StoredProcedure, parameters); //GetClientDashboard
                return dt;
            }

            catch(Exception ex)
            {
                throw;
            }

        }
        public ecompdashboard1cl GetDashBoardActWise1(string CompanyID, string SMonth, string SYear, string TMonth, string TYear, int UID = 0)
        {
            ecompdashboard1cl objdashbrd = new ecompdashboard1cl();
            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Type","ActWise"),
                    new SqlParameter("@CompanyId",CompanyID),
                    new SqlParameter("@SMonth",SMonth),
                    new SqlParameter("@SYear",SYear),
                    new SqlParameter("@TMonth",TMonth),
                    new SqlParameter("@TYear",TYear),
                      new SqlParameter("@UID",UID)


                };

                dt = DataLib.ExecuteDataTable("[GetClientDashboard_API_01092017_1_1]", CommandType.StoredProcedure, parameters); //GetClientDashboard



                List<string> lstcataxis = new List<string>();

                ecompseries1cl objseriesperformed = new ecompseries1cl();
                objseriesperformed.name = "Compliance";
                objseriesperformed.color = "green";
                List<double> performeddata = new List<double>();

                ecompseries1cl objseriesperfaftrdt = new ecompseries1cl();
                objseriesperfaftrdt.name = "Non Compliance";
                objseriesperfaftrdt.color = "red";
                List<double> performdaftrdtdata = new List<double>();

                ecompseries1cl objserieInprocess = new ecompseries1cl();
                objserieInprocess.name = "In Process";
                objserieInprocess.color = "#FF9900";
                List<double> InProcessdata = new List<double>();



                for (int i = 0; i <= dt.Rows.Count - 1; i++)
                {
                    Int32 performededcount = Convert.ToInt32(dt.Rows[i]["Compliance"]);
                    Int32 peraftrdtdcount = Convert.ToInt32(dt.Rows[i]["Non Compliance"]);
                    Int32 InProcesscount = Convert.ToInt32(dt.Rows[i]["InProcess"]);

                    performeddata.Add(Convert.ToDouble(performededcount));
                    performdaftrdtdata.Add(Convert.ToDouble(peraftrdtdcount));
                    InProcessdata.Add(InProcesscount);
                    int cattot = performededcount + peraftrdtdcount + InProcesscount;

                    //delayeddata.Add(Math.Round(((Convert.ToInt32(dt.Rows(i).Item("Delayed")) / (delayedcount + performededcount + peraftrdtdcount + InProcesscount)) * 100), 2))
                    //performeddata.Add(Math.Round(((Convert.ToInt32(dt.Rows(i).Item("Performed")) / (delayedcount + performededcount + peraftrdtdcount + InProcesscount)) * 100), 2))
                    //performdaftrdtdata.Add(Math.Round(((Convert.ToInt32(dt.Rows(i).Item("Performed After Due Date")) / (delayedcount + performededcount + peraftrdtdcount + InProcesscount)) * 100), 2))
                    //InProcessdata.Add(Math.Round(((Convert.ToInt32(dt.Rows(i).Item("InProcess")) / (delayedcount + performededcount + peraftrdtdcount + InProcesscount)) * 100), 2))
                    lstcataxis.Add(dt.Rows[i]["Act"].ToString() + ":," + dt.Rows[i]["ActID"].ToString() + ":," + cattot.ToString());
                }


                objseriesperformed.data = performeddata;

                objseriesperfaftrdt.data = performdaftrdtdata;
                objserieInprocess.data = InProcessdata;

                List<ecompseries1cl> lstseries = new List<ecompseries1cl>();

                lstseries.Add(objseriesperformed);
                lstseries.Add(objseriesperfaftrdt);
                lstseries.Add(objserieInprocess);


                objdashbrd.categoryAxis = lstcataxis;
                objdashbrd.series1 = lstseries;
            }

            catch
            {

            }

            return objdashbrd;

        }
    }
}