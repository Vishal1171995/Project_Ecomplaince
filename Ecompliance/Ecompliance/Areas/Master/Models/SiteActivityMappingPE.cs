using Ecompliance.CustomValidation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Ecompliance.Areas.Master.Models
{
    public class SiteActivityMappingPE
    {
        public int MappingID { set; get; }

        [Required]
        [Range(1, 1000000, ErrorMessage = "Company required")]
        public int CompanyID { set; get; }

        [Required]
        [Range(1, 1000000, ErrorMessage = "Site required")]
        public int SiteID { set; get; }

        [Required]
        [Range(1, 1000000, ErrorMessage = "Act required")]
        public int ActID { set; get; }

        [Required]
        [Range(1, 1000000, ErrorMessage = "Activity required")]
        public int ActivityID { set; get; }

        [MappingStartDateValPE]
        [DisplayFormat(DataFormatString = "{0:dd/MM/yy}")]
        public DateTime? StartDate { set; get; }
        [Required]
        [Range(1, 1000000, ErrorMessage = "Frequency required")]
        public int  Frequency { set; get; }
       
        [DisplayFormat(DataFormatString = "{0:dd/MM/yy}")]
        public DateTime EffectiveDate { get; set; }

        [Required]
        [RemindDaysValPE]
        public int RemindDays { set; get; }
        [Required]
        public int CreatedBy { set; get; }

        public string IsAct { set; get; }

        [Range(0, 1000000, ErrorMessage = "Invalid maker")]
        public int Maker { set; get; }

        [Range(0, 1000000, ErrorMessage = "Invalid checker")]
        public int Checker { set; get; }
        public int Maker2 { get; set; }
        [Range(0, 1000000, ErrorMessage = "Invalid checker2.")]
        public int Checker2 { get; set; }

        [Range(0, 1000000, ErrorMessage = "Invalid Auditor1.")]
        public int Auditor1 { get; set; }
        [Range(0, 1000000, ErrorMessage = "Invalid Auditor2.")]
        public int Auditor2 { get; set; }
        public string ActionType { get; set; }
        public int Applicable_To_Client { get; set; }
        public int UID { get; set; }
    }


    public class SiteActivityMappingPEVM
    {
        public int MappingID { set; get; }

        [Required]
        public string CompanyID { set; get; }
        [Required]
        public string SiteID { set; get; }

        [Required]
        public string ActID { set; get; }

        [Required]
        public string ActivityID { set; get; }

        [Required]
        public string Frequency { set; get; }


        [MappingStartDateValPEVE]
        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}")]
        public DateTime? StartDate { set; get; }


       
        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}")]
        public DateTime EffectiveDate { get; set; }

        [Required]
        [RemindDaysValVMPE]
        public int RemindDays { set; get; }
        [Required]
        public int CreatedBy { set; get; }

        public string IsAct { set; get; }

        public string Maker { set; get; }
        public string Checker { set; get; }
        public string Maker2 { get; set; }
        public string Checker2 { get; set; }
        public string Auditor1 { get; set; }
        public string Auditor2 { get; set; }
        public string ActionType { get; set; }
        public string Applicable_To_Client { get; set; }
        public int UID { get; set; }
    }
}