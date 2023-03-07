using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Ecompliance.Utils;
using System.Data;
using System.Data.SqlClient;
namespace Ecompliance.Repository
{
    public class LogUserRepo
    {
        public DataSet GetLogUser(string FromDate, string ToDate, int From, int To, string SortingStr, string FilterStr)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@FromDate",FromDate),
                    new SqlParameter("@ToDate",ToDate),
                    new SqlParameter("@FromNumber",From),
                    new SqlParameter("@ToNumber",To),
                    new SqlParameter("@SQLSortString",SortingStr),
                    new SqlParameter("@SQLFilterString",FilterStr)
                };
                return DataLib.ExecuteDataSet("GetUserLoginLog", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }
        }

        #region Grid Sort And Filter
        public string sortGrid(List<SortDescription> sorting)
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
                            if (sorting[i].field == "UserName") sorting[i].field = "U.User_Name";
                            if (sorting[i].field == "Email") sorting[i].field = "U.Email";
                            if (sorting[i].field == "Role") sorting[i].field = "R.Name";
                            if (sorting[i].field == "ContactNumber") sorting[i].field = "U.Contact_Number";
                            if (sorting[i].field == "CompanyName") sorting[i].field = "C.Name";
                            if (sorting[i].field == "Customer") sorting[i].field = "Cust.Name";
                            if (sorting[i].field == "Contractor") sorting[i].field = "Cont.Name";
                            if (sorting[i].field == "LoginTime") sorting[i].field = "LU.LoginTime";
                            if (sorting[i].field == "LogOutTime") sorting[i].field = "LU.LogOutTime";

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

        public string FilterGrid(FilterContainer filter)
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
                        if (filter.filters[i].field == "UserName") filter.filters[i].field = "U.User_Name";
                        if (filter.filters[i].field == "Email") filter.filters[i].field = "U.Email";
                        if (filter.filters[i].field == "Role") filter.filters[i].field = "R.Role";
                        if (filter.filters[i].field == "ContactNumber") filter.filters[i].field = "U.Contact_Number";
                        if (filter.filters[i].field == "CompanyName") filter.filters[i].field = "C.Name";
                        if (filter.filters[i].field == "Customer") filter.filters[i].field = "Cust.Name";
                        if (filter.filters[i].field == "Contractor") filter.filters[i].field = "Cont.Name";
                        if (filter.filters[i].field == "LoginTime") filter.filters[i].field = "LU.LoginTime";
                        if (filter.filters[i].field == "LogOutTime") filter.filters[i].field = "LU.LogOutTime";
                        if (filter.filters[i].field == "LU.LoginTime")
                        {
                            filter.filters[i].field = "CAST(LU.LoginTime AS DATE)";
                            string date = Convert.ToDateTime(filter.filters[i].value).Date.ToString();
                            string[] arr = date.Split(' ');
                            string[] arr1 = arr[0].Split('/');
                            filter.filters[i].value = arr1[2] + "-" + arr1[1] + "-" + arr1[0];
                        }
                        if (filter.filters[i].field == "LU.LogOutTime")
                        {
                            filter.filters[i].field = "CAST(LU.LogOutTime AS DATE)";
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

        #endregion
    }


}