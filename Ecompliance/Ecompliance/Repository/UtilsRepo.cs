using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using Newtonsoft.Json.Linq;

namespace Ecompliance.Repository
{
    public static class UtilsRepo
    {
        public static Dictionary<int, DataTable> GetGridData(string TableName, string ID, int CreatedBy, int FromNumber, int ToNumber, string OrderByStr, string FilterStr)
        {
            string connString = WebConfigurationManager.AppSettings["ConnectionString"];
            SqlDataReader rdr = null;
            if (OrderByStr == "")
            {
                OrderByStr = null;
            }
            if (FilterStr == "")
            {
                FilterStr = null;
            }
            try
            {
                using (SqlConnection con = new SqlConnection(connString))
                {
                    if (con.State == ConnectionState.Closed)
                        con.Open();
                    using (SqlCommand cmd = new SqlCommand("GetGridData", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@TableName", TableName);
                        cmd.Parameters.AddWithValue("@SqlID", ID);
                        cmd.Parameters.AddWithValue("@FromNumber", FromNumber);
                        cmd.Parameters.AddWithValue("@ToNumber", ToNumber);
                        if (OrderByStr != "")
                        {
                            cmd.Parameters.AddWithValue("@SQLSortString", OrderByStr);
                        }
                        if (FilterStr != "")
                        {
                            cmd.Parameters.AddWithValue("@SQLFilterString", FilterStr);
                        }

                        cmd.Parameters.AddWithValue("@CreatedBy", CreatedBy);

                        cmd.Parameters.Add("@TotalCount", SqlDbType.Int);
                        cmd.Parameters["@TotalCount"].Direction = ParameterDirection.Output;
                        //con.Open();
                        // get query results
                        rdr = cmd.ExecuteReader();
                        DataTable dt = new DataTable();
                        dt.Load(rdr);
                        int total = Convert.ToInt32(cmd.Parameters["@TotalCount"].Value);
                        Dictionary<int, DataTable> dictionary = new Dictionary<int, DataTable>();
                        dictionary.Add(total, dt);
                        return dictionary;
                    }
                }
            }
            catch (Exception ex)
            {
                return new Dictionary<int, DataTable>();
            }
        }
    }

    public static class ConvertJson
    {
        public static string ConvertTable(DataTable table)
        {
            JsonSerializerSettings serializerSettings = new JsonSerializerSettings();
            serializerSettings.Converters.Add(new DataTableConverter());
            string jsonData = JsonConvert.SerializeObject(table, Formatting.None, serializerSettings);
            return jsonData;
        }
        public static string ConvertToJson(object data)
        {
            JObject o = JObject.FromObject(new
            {
                Table = data
            });
            JsonSerializerSettings serializerSettings = new JsonSerializerSettings();
            //serializerSettings.ReferenceLoopHandling = ReferenceLoopHandling.Ignore;
            string jsonData = JsonConvert.SerializeObject(data);
            return jsonData;
        }
        public static string SerializeObject(object data)
        {
            return JsonConvert.SerializeObject(data);
        }
    }
}