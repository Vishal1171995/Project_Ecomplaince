using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.Repository;
using System.Data;
using System.Data.SqlClient;
using System.Net;

namespace Ecompliance.Utils
{
    public static class CommanUtills
    {
        public static bool IsValidAction(string ControllerName,string ActionType)
        {
            try
            {
                bool IsValid = false;
                User uBo = new User();
                uBo = (User)HttpContext.Current.Session["uBo"];
                DataTable dt = new DataTable();
                dt = (DataTable)HttpContext.Current.Session["uMenu"];
                DataView dv = new DataView(dt);
                dv.RowFilter = "Controller='" + ControllerName + "' AND ROLES like '%{"+uBo.UserRole+":%'";
                DataTable dtMenu = dv.ToTable();
                //no any menu exists for this user hence it is not authrized
                if (dtMenu.Rows.Count == 0)
                    return false;
                string Roles = dtMenu.Rows[0]["ROLES"].ToString();
                string [] arrRoles=Roles.Split(',');
                for (int i = 0; i < arrRoles.Length;i++ )
                {
                    String Str = arrRoles[i].Replace("{", string.Empty).Replace("}", string.Empty);
                    string [] arrRight = Str.Split(':');
                    string Right = arrRight[1].Trim();
                    string Role = arrRight[0].Trim().ToUpper();
                    if(uBo.UserRole.ToUpper().Trim()==Role)
                    {
                        if(ActionType.Trim().ToUpper()=="ADDUPDATE")
                        {
                            if (Right == "2" || Right == "3" || Right == "6" || Right == "7")
                            {
                                IsValid = true;
                                break;
                            }
                        }
                        else if(ActionType.Trim().ToUpper()=="VIEW")
                        {
                            if (Right == "1" || Right == "3" || Right == "5" || Right == "7")
                            {
                                IsValid = true;
                                break;
                            }
                        }
                    }

                }
                    return IsValid;
            }
            catch { throw; }
        }
        public static bool IsValidIpAddress(int UID)
        {
            DataTable dt = new DataTable();
            bool IsValid = false;
            try
            {
                //If IP Exists Get it from Session
                if (HttpContext.Current.Session["IpRange"] == null)
                {
                    SqlParameter[] parameters = new SqlParameter[]
                    {
                        new SqlParameter("@UID",UID)
                    };
                    dt = DataLib.ExecuteDataTable("[GetCustomerIPAdress]", CommandType.StoredProcedure, parameters);
                    HttpContext.Current.Session["IpRange"] = dt;
                    
                }
                else
                    dt = (DataTable)(HttpContext.Current.Session["IpRange"]);
                if (dt.Rows.Count == 0)
                {
                    IsValid = true;
                    return IsValid;
                }
                string hostName = Dns.GetHostName();
                string clientIP = GetIPAddress();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    string ValidIP = dt.Rows[i]["IPRange"].ToString();
                    int EndIPAdd = Convert.ToInt32(dt.Rows[i]["EndIPAddress"]);
                    if (EndIPAdd == 0)
                    {
                        if (clientIP == ValidIP)
                        {
                            IsValid = true;
                            break;
                        }
                    }
                    else
                    {
                        string[] arrIpRange = ValidIP.Split('.');
                        int lastdigit = Convert.ToInt32(arrIpRange[3]);
                        int loopIndex = (lastdigit + EndIPAdd);
                        for (int j = lastdigit; j <= loopIndex; j++)
                        {
                            string NewIP = arrIpRange[0] + "." + arrIpRange[1] + "." + arrIpRange[2] + "." + j;
                            if(clientIP == NewIP)
                            {
                                IsValid = true;
                                break;
                            }
                        }
                        if (IsValid == true)
                            break;
                    }
                }
                return IsValid;

            }
            catch (Exception ex) { throw; }
        }

        public static string GetIPAddress()
        {
            try
            {
                string IP = HttpContext.Current.Request.Params["HTTP_CLIENT_IP"] ?? HttpContext.Current.Request.UserHostAddress;
                return IP;
            }
            catch
            {
                return "";
            }
        }
    }

    public class SortDescription
    {
        public string field { get; set; }
        public string dir { get; set; }
    }
    public class FilterContainer
    {
        public List<FilterDescription> filters { get; set; }
        public string logic { get; set; }
    }
    public class FilterDescription
    {
        public string @operator { get; set; }
        public string field { get; set; }
        public string value { get; set; }
    }
}