using Ecompliance.Utils;
using Ecompliance.ViewModel;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Web;

namespace Ecompliance.Repository
{
    public class MakerBulkApprovalRepo
    {
        public string MakerBulkApprove(List<TaskVerifyVM> TaskVerifyVM, int UID, ref int SuccessCount, ref int FailCount)
        {
            TaskRepo taskRep = new TaskRepo();

            string FilePath = "";
            try
            {
                string strerr = "";
                DataTable dt = ToDataTable(TaskVerifyVM);
                dt.Columns.Add("Response");
                dt.Columns.Add("Message");
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    try
                    {
                        TaskVerifyVM objVm = new TaskVerifyVM();
                        objVm.DocID = Convert.ToInt32(dt.Rows[i]["DocID"]);
                        objVm.ActivityCompDate = Convert.ToDateTime(dt.Rows[i]["ActivityCompDate"]);
                        objVm.DelayReason = dt.Rows[i]["DelayReason"].ToString();
                        objVm.Remark = dt.Rows[i]["Remark"].ToString();
                        objVm.UID = UID;
                        var results = new List<ValidationResult>();
                        var vc = new ValidationContext(objVm, null, null);
                        var isValid = Validator.TryValidateObject(objVm, vc, results, true);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                        strerr = string.Join(" ", errors);
                        if (isValid)
                        {
                            string result = taskRep.SendToVarify(objVm);
                            if (result == "1")
                            {
                                SuccessCount += 1;
                                dt.Rows[i]["Response"] = "Success";
                            }
                            else
                            {
                                FailCount += 1;
                                dt.Rows[i]["Response"] = "Failed";
                                dt.Rows[i]["Message"] = "Not a valid user";
                            }
                        }
                        else
                        {
                            FailCount += 1;
                            dt.Rows[i]["Response"] = "Failed";
                            dt.Rows[i]["Message"] = strerr;
                        }
                    }
                    catch (Exception ex)
                    {
                        FailCount += 1;
                        dt.Rows[i]["Response"] = "Failed";
                        dt.Rows[i]["Message"] = ex.Message.ToString();
                        continue;
                    }
                }
                FilePath = CSVUtills.DataTableToCSV(dt, ",");
                return FilePath;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public DataTable ToDataTable<T>(List<T> items)
        {
            DataTable dataTable = new DataTable(typeof(T).Name);
            //Get all the properties by using reflection   
            PropertyInfo[] Props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
            foreach (PropertyInfo prop in Props)
            {
                //Setting column names as Property names  
                dataTable.Columns.Add(prop.Name);
            }
            foreach (T item in items)
            {
                var values = new object[Props.Length];
                for (int i = 0; i < Props.Length; i++)
                {

                    values[i] = Props[i].GetValue(item, null);
                }
                dataTable.Rows.Add(values);
            }

            return dataTable;
        }
    }
}