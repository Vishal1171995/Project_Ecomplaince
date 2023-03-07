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
using System.Collections.Generic;
using System.Linq;
using System.Web;



namespace Ecompliance.Repository
{
    public class TaskReconsilationRepo
    {
        public DataSet GetTaskReconsilationData(string Type, int UID, string ActivityType, string CompIDs, string SiteIDs,  string ActIDs, string ActivityIDs, string FromDate, string ToDate, string DocID, int From, int To, string SortingStr, string FilterStr)
        {
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Type",Type),
                    new SqlParameter("@UID",UID),
                    new SqlParameter("@ActivityType",ActivityType),
                    new SqlParameter("@CompIDs",CompIDs),
                    //new SqlParameter("@SiteIDs",SiteIDs),
                    
                    //new SqlParameter("@ActIDs",ActIDs),
                    //new SqlParameter("@ActivityIDs",ActivityIDs),
                    
                    new SqlParameter("@FromDate",FromDate),
                    new SqlParameter("@ToDate",ToDate),
                    //new SqlParameter("@DocID",DocID),
                    new SqlParameter("@FromNumber",From),
                    new SqlParameter("@ToNumber",To),
                    new SqlParameter("@SQLSortString",SortingStr),
                    new SqlParameter("@SQLFilterString",FilterStr)
                };
                return DataLib.ExecuteDataSet("GetDocTaskReport_1", CommandType.StoredProcedure, parameters);
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
                            if (sorting[i].field == "DOCID") sorting[i].field = "Task.DOCID";
                            if (sorting[i].field == "Company") sorting[i].field = "Comp.Name";
                            if (sorting[i].field == "Site") sorting[i].field = "Site.Name";
                            if (sorting[i].field == "Act") sorting[i].field = "Act.Short_Name";
                            if (sorting[i].field == "Activity") sorting[i].field = "Acti.Name";                           
                            if (sorting[i].field == "CurrStatus") sorting[i].field = "Task.CurrStatus";
                            if (sorting[i].field == "Delay_Region") sorting[i].field = "Task.Delay_Region";
                            if (sorting[i].field == "Maker") sorting[i].field = "Maker.User_Name";
                            if (sorting[i].field == "Checker") sorting[i].field = "Checker.User_Name";
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
                        if (filter.filters[i].field == "DOCID") filter.filters[i].field = "Task.DOCID";
                        if (filter.filters[i].field == "Company") filter.filters[i].field = "Comp.Name";
                        if (filter.filters[i].field == "Site") filter.filters[i].field = "Site.Name";
                        if (filter.filters[i].field == "Act") filter.filters[i].field = "Act.Short_Name";
                        if (filter.filters[i].field == "Activity") filter.filters[i].field = "Acti.Name";                   
                        if (filter.filters[i].field == "CurrStatus") filter.filters[i].field = "Task.CurrStatus";
                        if (filter.filters[i].field == "Creation_Remarks") filter.filters[i].field = "Task.Creation_Remarks";                        
                        if (filter.filters[i].field == "Delay_Region") filter.filters[i].field = "Task.Delay_Region";
                        if (filter.filters[i].field == "Maker") filter.filters[i].field = "Maker.User_Name";
                        if (filter.filters[i].field == "Checker") filter.filters[i].field = "Checker.User_Name";
                        if (filter.filters[i].field == "Action_CompletionDate")
                        {
                            filter.filters[i].field = "CAST(Task.Action_CompletionDate AS DATE)";
                            string date = Convert.ToDateTime(filter.filters[i].value).Date.ToString();
                            string[] arr = date.Split(' ');
                            string[] arr1 = arr[0].Split('/');
                            filter.filters[i].value = arr1[2] + "-" + arr1[1] + "-" + arr1[0];
                        }
                        if (filter.filters[i].field == "TaskCreationDate")
                        {
                            filter.filters[i].field = "CAST(Task.TaskCreationDate AS DATE)";
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