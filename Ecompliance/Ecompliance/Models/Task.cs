using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.ComponentModel.DataAnnotations;
namespace Ecompliance.Models
{
    public class Task
    {
        public int DOCID { get; set; }

        public string ActivityType { get; set; }
        public int CompanyID { get; set; }
        public int SiteID { get; set; }
        public int ActID { get; set; }
        public int ActivityID { get; set; }
        public int ContractorID { get; set; }
        public string Creation_Desc { get; set; }
        public string Creation_Remarks { get; set; }

        public int CreatedBy { get; set; }
        public int CurrUser { get; set; }

        public string Company { get; set; }
        public string Site { get; set; }
        public string Act { get; set; }
        public string Activity { get; set; }
        public string Contractor { get; set; }
        public string MakerRemarks { get; set; }
        public string Checker { get; set; }
        public string CreatedByText { get; set; }
        public string CreatedDate { get; set; }
        public string CurrentStatus { get; set; }
        public string ActivityCompDate { get; set; }
        public string ExpiryDate { get; set; }

        public int ExtendebleExpDate { get; set; }
        public string ExtendebleExpDate_Remarks { get; set; }

        public SelectList CompanyList { get; set; }
        public SelectList ActivityList { get; set; }
        public SelectList SiteList { get; set; }
        public SelectList ActList { get; set; }
        public SelectList ContractorList { get; set; }

        public string  Frequency { get; set; }
    }
}