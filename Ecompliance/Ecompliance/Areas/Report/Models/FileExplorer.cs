using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Ecompliance.Areas.Report.Models
{
    public class CustomerFileExplorer
    {
        public string text { get; set; }
        public int CustID { get; set; }
        public string type = "customer";
        public bool expanded { get; set; }
        public List<CompanyFileExplorer> items { get; set; }
    }
    public class CompanyFileExplorer
    {
        public string text { get; set; }
        public int CompID { get; set; }
        public int SiteID { get; set; }
        public int ActID { get; set; }
        public int ActivityID { get; set; }
        public int Year { get; set; }
        public string type = "";
        public string Month { get; set; }
        public bool expanded { get; set; }
        public List<SiteFileExplorer> items { get; set; }
    }
    public class SiteFileExplorer
    {
        public string text { get; set; }
        public int Siteid { get; set; }
        public int CompID { get; set; }
        public int SiteID { get; set; }
        public int ActID { get; set; }
        public int ActivityID { get; set; }
        public int Year { get; set; }
        public string Month { get; set; }
        public string type = "";
        public bool expanded { get; set; }
        public List<ActFileExplorer> items { get; set; }
    }

    public class ActFileExplorer
    {
        public string text { get; set; }
        public int ActID { get; set; }
        public int Siteid { get; set; }
        public int CompID { get; set; }
        public int SiteID { get; set; }
        public int ActivityID { get; set; }
        public int Year { get; set; }
        public string Month { get; set; }
        public string type = "";
        public bool expanded { get; set; }
        public List<ActivityFileExplorer> items { get; set; }
    }
    public class ActivityFileExplorer
    {
        public string text { get; set; }
        public int ActivityID { get; set; }
        public int ActID { get; set; }
        public int SiteID { get; set; }
        public int CompID { get; set; }
        public int Year { get; set; }
        public string Month { get; set; }
        public string type = "";
        public bool expanded { get; set; }
        public List<YearFileExplorer> items { get; set; }
    }
    public class YearFileExplorer
    {
        public string text { get; set; }
        public int ActivityID { get; set; }
        public int ActID { get; set; }
        public int SiteID { get; set; }
        public int CompID { get; set; }
        public int Year { get; set; }
        public string Month { get; set; }
        public string type = "";
        public bool expanded { get; set; }
        public List<MonthFileExplorer> items { get; set; }
    }
    public class MonthFileExplorer
    {
        public string text { get; set; }
        public int ActivityID { get; set; }
        public int ActID { get; set; }
        public int SiteID { get; set; }
        public int CompID { get; set; }
        public int Year { get; set; }
        public string Month { get; set; }
        public string type = "";
        public bool expanded { get; set; }
        public MonthFileExplorer(string text,string Month,int CompID,int SiteID,int ActID,int ActivityID,int Year,bool expanded)
        {
            this.text = text;
            this.Month = Month;
            this.CompID = CompID;
            this.SiteID = SiteID;
            this.ActID = ActID;
            this.ActivityID = ActivityID;
            this.Year = Year;
            this.expanded = expanded;
        }
    }
    public class TreeList
    {
        public List<CustomerFileExplorer> Data { get; set; }
    }
}