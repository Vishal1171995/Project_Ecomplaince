using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Ecompliance.Repository
{
    public class CLRADashBoardRepo
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

                dt = DataLib.ExecuteDataTable("[GetCLRAClientDashboard]", CommandType.StoredProcedure, parameters); //GetClientDashboard

                return dt;
            }
            catch(Exception ex)
            {
            }
            return dt;
        }
        public DataTable GetCLRADashBoardHomeCount(int UID, string CompanyID, string SMonth, string SYear, string TMonth, string TYear)
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
                dt = DataLib.ExecuteDataTable("[GetCLRAClientDashboard]", CommandType.StoredProcedure, parameters); //GetClientDashboard
                return dt;
            }
            catch(Exception ex)
            {

            }
            return dt;
        }
        public DataTable GetCLRADashBoardCompanyTot(string CompanyID, string SMonth, string SYear, string TMonth, string TYear, int UID = 0)
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
                dt = DataLib.ExecuteDataTable("[GetCLRAClientDashboard]", CommandType.StoredProcedure, parameters); //GetClientDashboard
                return dt;
            }
            catch (Exception ex)
            {
            }
            return dt;
        }
        public static DataTable GetMappedCompany(int UID)
        {
            try
            {
                SqlParameter[] p = { new SqlParameter("@UID", UID) };
                return DataLib.ExecuteDataTable("GetMappedCompany", CommandType.StoredProcedure, p);
            }
            catch (Exception ex) { throw; }
        }
        public DataTable GetCLRADashBoardSiteWise(string CompanyID, string SMonth, string SYear, string TMonth, string TYear, int UID = 0)
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
                dt = DataLib.ExecuteDataTable("[GetCLRAClientDashboard]", CommandType.StoredProcedure, parameters); //GetClientDashboard
                return dt;
            }
            catch (Exception ex)
            {

            }
            return dt;
        }
        //ActClick

        public DataTable GetCLRADashBoardActClick(string CompanyID, string ActID, string Status, string SMonth, string SYear, string TMonth, string TYear, int UID = 0)
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
                dt = DataLib.ExecuteDataTable("[GetCLRAClientDashboard]", CommandType.StoredProcedure, parameters); //GetClientDashboard
                return dt;
            }
            catch (Exception ex)
            {

            }
            return dt;
        }
        public ecompdashboard1cl GetCLRADashBoardActWise(string CompanyID, string SMonth, string SYear, string TMonth, string TYear, int UID = 0)
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
                dt = DataLib.ExecuteDataTable("[GetCLRAClientDashboard]", CommandType.StoredProcedure, parameters); //GetClientDashboard
                List<string> lstcataxis = new List<string>();
                ecompseries1cl objseriesperformed = new ecompseries1cl();
                objseriesperformed.name = "Monthly Pending";
                objseriesperformed.color = "green";
                List<double> performeddata = new List<double>();

                ecompseries1cl objseriesperfaftrdt = new ecompseries1cl();
                objseriesperfaftrdt.name = "Periodic Pending";
                objseriesperfaftrdt.color = "#60bcff";
                List<double> performdaftrdtdata = new List<double>();

                ecompseries1cl objserieInprocess = new ecompseries1cl();
                objserieInprocess.name = "Complited";
                objserieInprocess.color = "#4a366d";
                List<double> InProcessdata = new List<double>();

                for (int i = 0; i <= dt.Rows.Count - 1; i++)
                {
                    Int32 performededcount = Convert.ToInt32(dt.Rows[i]["ManthlyPending"]);
                    Int32 peraftrdtdcount = Convert.ToInt32(dt.Rows[i]["PeriodicPending"]);
                    Int32 InProcesscount = Convert.ToInt32(dt.Rows[i]["Complited"]);

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
            catch (Exception ex)
            {

            }
            return objdashbrd;
        }
    }
}