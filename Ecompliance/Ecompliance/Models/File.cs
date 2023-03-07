using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.ComponentModel.DataAnnotations;
namespace Ecompliance.Models
{
    public class File
    {
        public int FileID { get; set; }
        [Required(ErrorMessage = "Please select a activity type.")]
        //[Range(1, int.MaxValue, ErrorMessage = "Please select a activity type.")]
        public string ActivityType { get; set; }

        [Required(ErrorMessage = "Please select a company.")]
        public string CompanyID { get; set; }
        [Required(ErrorMessage = "Please select a company.")]
        public string CompanyText { get; set; }

        [Required(ErrorMessage = "Please select a site.")]
        [Range(1, int.MaxValue, ErrorMessage = "Please select a site.")]
        public int SiteID { get; set; }

        [Required(ErrorMessage = "Please select a act.")]
        [Range(1, int.MaxValue, ErrorMessage = "Please select a act.")]
        public int ActID { get; set; }
        [Required(ErrorMessage = "Please select a activity.")]
        [Range(1, int.MaxValue, ErrorMessage = "Please select a activity.")]
        public int ActivityID { get; set; }
        [Required(ErrorMessage = "Please select a Year.")]
        public int Year { get; set; }
        public int ContractorID { get; set; }
        [Required(ErrorMessage = "Please select a Year.")]
        public string Month { get; set; }
        public string Attachment1 { get; set; }
        public string Attachment1_FileName { get; set; }
        public string Attachment2 { get; set; }
        public string Attachment2_FileName { get; set; }
        public string Attachment3 { get; set; }
        public string Attachment3_FileName { get; set; }
        public string Attachment4 { get; set; }
        public string Attachment4_FileName { get; set; }
        public string Attachment5 { get; set; }
        public string Attachment5_FileName { get; set; }
        public string IsAuth { get; set; }
        public int CreatedBy { get; set; }
        public int CurrUser { get; set; }

        public SelectList CompanyList { get; set; }
        public SelectList SiteList { get; set; }
        public SelectList ActList { get; set; }
        public SelectList YearList { get; set; }
    }
}