using Ecompliance.CustomValidation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Ecompliance.Areas.Master.Models
{
    public class SiteActivityMapping
    {
        public int MappingID { set; get; }

        [Required]
        [Range(1, 1000000,ErrorMessage = "Company required")]
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
        [Required]
        [Range(1, 1000000, ErrorMessage = "Contractor required")]
        public int ContractorID { set; get; }


        [ContMappingStartdateVal]
        [DisplayFormat(DataFormatString = "{0:dd/MM/yy}")]
        public DateTime? StartDate { set; get; }
        [Required]
        [Range(1, 1000000, ErrorMessage = "Frequency required")]
        public int Frequency { set; get; }

         [DisplayFormat(DataFormatString = "{0:dd/MM/yy}")]
         public DateTime EffectiveDate { get; set; }


        [Required]
        [RemindDaysVal]
        public int RemindDays { set; get; }

        [Required]
        public int CreatedBy { set; get; }

        public string IsAct { set; get; }
        [Range(0, 1000000, ErrorMessage = "Invalid maker")]
        public int Maker { set; get; }

         [Range(0, 1000000, ErrorMessage = "Invalid checker")]
        public int Checker { set; get; }
        public int UID { get; set; }
    }

    public class SiteActivityMappingVM
    {
        public int MappingID { set; get; }

        [Required]
        public string  CompanyID { set; get; }
         [Required]
        public string  SiteID { set; get; }

        [Required]
        public string  ActID { set; get; }

        [Required]
        public string  ActivityID { set; get; }

        [Required]
        public string  ContractorID { set; get; }

        [ContMappingStartdateValVM]
        [DisplayFormat(DataFormatString = "{0:dd/MM/yy}")]
        public DateTime? StartDate { set; get; }
        [Required]
        public string Frequency { set; get; }
        public DateTime EffectiveDate { get; set; }

        [Required]
        [RemindDaysValVM]
        public int RemindDays { set; get; }
        [Required]
        public int CreatedBy { set; get; }

        public string IsAct { set; get; }

        public string Maker { set; get; }

        public string Checker { set; get; }
        public int UID { get; set; }
    }

    public class SiteActivityMappingSchedulerLog
    {
        public string  MappingID { set; get; }

        public string CompanyID { set; get; }


        public string SiteID { set; get; }


        public string ActID { set; get; }


        public string ActivityID { set; get; }

        public string ContractorID { set; get; }



        public string StartDate { set; get; }


        public string Frequency { set; get; }


        public string EffectiveDate { get; set; }



        public string RemindDays { set; get; }

        public string Maker { set; get; }

        public string Checker { set; get; }
    }
}