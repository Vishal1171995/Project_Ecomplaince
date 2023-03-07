using Ecompliance.Areas.Report.Models;
using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Ecompliance.Repository
{
    public class CLRAMyTaskRepo
    {
        public DataTable GetMyTaskGridData(string Type, int UID)
        {

            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Type",Type),
                    new SqlParameter("@UID",UID)

                };

                dt = DataLib.ExecuteDataTable("[GetNeedToAct]", CommandType.StoredProcedure, parameters);

                return dt;
            }

            catch
            {

            }

            return dt;

        }

        public DataSet GetMyTask(string Type, int UID, int From, int To, string SortingStr, string FilterStr)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Type",Type),
                    new SqlParameter("@UID",UID),
                    new SqlParameter("@FromNumber",From),
                    new SqlParameter("@ToNumber",To),
                    new SqlParameter("@SQLSortString",SortingStr),
                    new SqlParameter("@SQLFilterString",FilterStr)
                };
                return DataLib.ExecuteDataSet("GetMyTask", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }
        public DataSet GetCLRAMyTask(string Type, int CompID, int SMonth, int TMonth, int Syear, int Tyear, int UID, int From, int To, string SortingStr, string FilterStr)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Type",Type),
                    new SqlParameter("@CompID",CompID),
                    new SqlParameter("@SMonth",SMonth),
                    new SqlParameter("@TMonth",TMonth),
                    new SqlParameter("@Syear",Syear),
                    new SqlParameter("@Tyear",Tyear),
                    new SqlParameter("@UID",UID),
                    new SqlParameter("@FromNumber",From),
                    new SqlParameter("@ToNumber",To),
                    new SqlParameter("@SQLSortString",SortingStr),
                    new SqlParameter("@SQLFilterString",FilterStr)
                };
                return DataLib.ExecuteDataSet("GetCLRAMyTask", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }
        public string sortMyTask(List<MyTaskSortDescription> sorting)
        {
            string sortingStr = "";
            try
            {
                if (sorting != null)
                {
                    if (sorting.Count != 0)
                    {
                        for (int i = 0; i < sorting.Count; i++)
                        {
                            if (sorting[i].field == "DOCID") sorting[i].field = "T.DOCID";
                            if (sorting[i].field == "CompName") sorting[i].field = "C.Name";
                            if (sorting[i].field == "SiteName") sorting[i].field = "S.Name";
                            if (sorting[i].field == "ActName") sorting[i].field = "Act.Short_Name";
                            if (sorting[i].field == "ActivityName") sorting[i].field = "A.Name";
                            if (sorting[i].field == "ContName") sorting[i].field = "Cont.Name";
                            if (sorting[i].field == "Expiry_Date") sorting[i].field = "T.Expiry_Date";
                            if (sorting[i].field == "CurrStatus") sorting[i].field = "T.CurrStatus";
                            if (sorting[i].field == "PendingDays") sorting[i].field = "DATEDIFF(day,Tdtl.InDate,GETDATE())";
                            if (sorting[i].field == "Recievedon") sorting[i].field = "Tdtl.InDate";
                            sortingStr += ", " + sorting[i].field + " " + sorting[i].dir;
                        }
                    }
                }
                return sortingStr;
            }
            catch
            {
                throw;
            }
        }
        public string FilterMyTask(MyTaskFilterContainer filter)
        {
            string filters = "";
            string logic;
            string condition = "";
            try
            {

                int c = 1;
                if (filter != null)
                {
                    for (int i = 0; i < filter.filters.Count; i++)
                    {
                        logic = filter.logic;

                        //filter.filters[i].field
                        if (filter.filters[i].field == "DOCID") filter.filters[i].field = "T.DOCID";
                        if (filter.filters[i].field == "CompName") filter.filters[i].field = "C.Name";
                        if (filter.filters[i].field == "SiteName") filter.filters[i].field = "S.Name";
                        if (filter.filters[i].field == "ActName") filter.filters[i].field = "Act.Short_Name";
                        if (filter.filters[i].field == "ActivityName") filter.filters[i].field = "A.Name";
                        if (filter.filters[i].field == "ContName") filter.filters[i].field = "Cont.Name";
                        //if (filter.filters[i].field == "Expiry_Date") filter.filters[i].field = "T.Expiry_Date";
                        if (filter.filters[i].field == "CurrStatus") filter.filters[i].field = "T.CurrStatus";
                        if (filter.filters[i].field == "PendingDays") filter.filters[i].field = "DATEDIFF(day,Tdtl.InDate,GETDATE())";
                        //if (filter.filters[i].field == "Recievedon") filter.filters[i].field = "Tdtl.InDate";
                        if (filter.filters[i].field == "Expiry_Date")
                        {
                            filter.filters[i].field = "CAST(T.Expiry_Date AS DATE)";
                            string date = Convert.ToDateTime(filter.filters[i].value).Date.ToString();
                            string[] arr = date.Split(' ');
                            string[] arr1 = arr[0].Split('/');
                            filter.filters[i].value = arr1[2] + "-" + arr1[1] + "-" + arr1[0];
                        }
                        if (filter.filters[i].field == "Recievedon")
                        {
                            filter.filters[i].field = "CAST(Tdtl.InDate AS DATE)";
                            string date = Convert.ToDateTime(filter.filters[i].value).Date.ToString();
                            string[] arr = date.Split(' ');
                            string[] arr1 = arr[0].Split('/');
                            filter.filters[i].value = arr1[2] + "-" + arr1[1] + "-" + arr1[0];
                        }

                        if (filter.filters[i].@operator == "eq")
                        {
                            condition = " = '" + filter.filters[i].value + "' ";
                        }
                        if (filter.filters[i].@operator == "neq")
                        {
                            condition = " != '" + filter.filters[i].value + "' ";
                        }
                        if (filter.filters[i].@operator == "startswith")
                        {
                            condition = " Like '" + filter.filters[i].value + "%' ";
                        }
                        if (filter.filters[i].@operator == "contains")
                        {
                            condition = " Like '%" + filter.filters[i].value + "%' ";
                        }
                        if (filter.filters[i].@operator == "doesnotcontains")
                        {
                            condition = " Not Like '%" + filter.filters[i].value + "%' ";
                        }
                        if (filter.filters[i].@operator == "endswith")
                        {
                            condition = " Like '%" + filter.filters[i].value + "' ";
                        }
                        if (filter.filters[i].@operator == "gte")
                        {
                            condition = " >= '" + filter.filters[i].value + "' ";
                        }
                        if (filter.filters[i].@operator == "gt")
                        {
                            condition = " > '" + filter.filters[i].value + "' ";
                        }
                        if (filter.filters[i].@operator == "lte")
                        {
                            condition = " <= '" + filter.filters[i].value + "' ";
                        }
                        if (filter.filters[i].@operator == "lt")
                        {
                            condition = "< '" + filter.filters[i].value + "' ";
                        }
                        filters += filter.filters[i].field + condition;
                        if (filter.filters.Count > c)
                        {
                            filters += logic;
                            filters += " ";
                        }
                        c++;
                    }
                }
                return filters;
            }
            catch
            {
                throw;
            }
        }
    }
}