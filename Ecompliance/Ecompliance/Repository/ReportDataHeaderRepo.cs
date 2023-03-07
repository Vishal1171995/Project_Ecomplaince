using Ecompliance.Utils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Ecompliance.Repository
{
    public class ReportDataHeaderRepo
    {


        public DataSet GetDocTaskSearchGrid(string Type, int UID, string ActivityType, string CompIDs, string SiteIDs, string ContractorIDs, string ActIDs, string ActivityIDs, string ExpDate, string Month, string Year, string FromDate, string ToDate, string DocID, int From, int To, string SortingStr, string FilterStr,string SQlGroupby, string Compliance_Nature, string Compliance_Status)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Type",Type),
                    new SqlParameter("@UID",UID),
                    new SqlParameter("@ActivityType",ActivityType),
                    new SqlParameter("@CompIDs",CompIDs),
                    new SqlParameter("@SiteIDs",SiteIDs),
                    new SqlParameter("@ContractorIDs",ContractorIDs),
                    new SqlParameter("@ActIDs",ActIDs),
                    new SqlParameter("@ActivityIDs",ActivityIDs),
                    new SqlParameter("@ExpDate",ExpDate),
                    new SqlParameter("@Month",Month),
                    new SqlParameter("@Year",Year),
                    new SqlParameter("@FromDate",FromDate),
                    new SqlParameter("@ToDate",ToDate),
                    new SqlParameter("@DocID",DocID),
                    new SqlParameter("@FromNumber",From),
                    new SqlParameter("@ToNumber",To),
                    new SqlParameter("@SQLSortString",SortingStr),
                    new SqlParameter("@SQLFilterString",FilterStr),
                    new SqlParameter("@Compliance_Nature",Compliance_Nature),
                    new SqlParameter("@Compliance_Status",Compliance_Status),
                    new SqlParameter("@SQLGroupby",SQlGroupby),
                };
                return DataLib.ExecuteDataSet("GetReportDataCount_1", CommandType.StoredProcedure, parameters);
            }
            catch(Exception ex)
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
                            if (sorting[i].field == "DOCID") sorting[i].field = "T.DOCID";
                            if (sorting[i].field == "CompName") sorting[i].field = "C.Name";
                            if (sorting[i].field == "SiteName") sorting[i].field = "S.Name";
                            if (sorting[i].field == "ActName") sorting[i].field = "Act.Short_Name";
                            if (sorting[i].field == "ActivityName") sorting[i].field = "A.Name";
                            if (sorting[i].field == "ContName") sorting[i].field = "Cont.Name";
                            if (sorting[i].field == "Creation_Desc") sorting[i].field = "T.Creation_Desc";
                            if (sorting[i].field == "CurrStatus") sorting[i].field = "T.CurrStatus";
                            if (sorting[i].field == "Creation_Remarks") sorting[i].field = "T.Creation_Remarks";
                            if (sorting[i].field == "User_Name") sorting[i].field = "U.User_Name";
                            if (sorting[i].field == "ExpiryDate") sorting[i].field = "T.Expiry_Date";
                            if (sorting[i].field == "TaskCreationDate") sorting[i].field = "T.TaskCreationDate";

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
                        if (filter.filters[i].field == "DOCID") filter.filters[i].field = "T.DOCID";
                        if (filter.filters[i].field == "CompName") filter.filters[i].field = "C.Name";
                        if (filter.filters[i].field == "SiteName") filter.filters[i].field = "S.Name";
                        if (filter.filters[i].field == "ActName") filter.filters[i].field = "Act.Short_Name";
                        if (filter.filters[i].field == "ActivityName") filter.filters[i].field = "A.Name";
                        if (filter.filters[i].field == "ContName") filter.filters[i].field = "Cont.Name";
                        if (filter.filters[i].field == "Creation_Desc") filter.filters[i].field = "T.Creation_Desc";
                        if (filter.filters[i].field == "CurrStatus") filter.filters[i].field = "T.CurrStatus";
                        if (filter.filters[i].field == "Creation_Remarks") filter.filters[i].field = "T.Creation_Remarks";
                        if (filter.filters[i].field == "User_Name") filter.filters[i].field = "U.User_Name";
                        if (filter.filters[i].field == "Delay_Region") filter.filters[i].field = "T.Delay_Region";
                        if (filter.filters[i].field == "ExpiryDate")
                        {
                            filter.filters[i].field = "CAST(T.Expiry_Date AS DATE)";
                            string date = Convert.ToDateTime(filter.filters[i].value).Date.ToString();
                            string[] arr = date.Split(' ');
                            string[] arr1 = arr[0].Split('/');
                            filter.filters[i].value = arr1[2] + "-" + arr1[1] + "-" + arr1[0];
                        }
                        if (filter.filters[i].field == "Action_CompletionDate")
                        {
                            filter.filters[i].field = "CAST(T.Action_CompletionDate AS DATE)";
                            string date = Convert.ToDateTime(filter.filters[i].value).Date.ToString();
                            string[] arr = date.Split(' ');
                            string[] arr1 = arr[0].Split('/');
                            filter.filters[i].value = arr1[2] + "-" + arr1[1] + "-" + arr1[0];
                        }
                        if (filter.filters[i].field == "TaskCreationDate")
                        {
                            filter.filters[i].field = "CAST(T.TaskCreationDate AS DATE)";
                            string date = Convert.ToDateTime(filter.filters[i].value).Date.ToString();
                            string[] arr = date.Split(' ');
                            string[] arr1 = arr[0].Split('/');
                            filter.filters[i].value = arr1[2] + "-" + arr1[1] + "-" + arr1[0];
                        }

                        if (filter.filters[i].field == "RemindDays") filter.filters[i].field = "T.RemindDays";

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