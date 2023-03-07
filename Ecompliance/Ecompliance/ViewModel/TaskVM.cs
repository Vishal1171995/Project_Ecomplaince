using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.ComponentModel.DataAnnotations;
using Ecompliance.CustomValidation;
namespace Ecompliance.ViewModel
{
    public class TaskVM
    {
        public int DOCID { get; set; }
        public int TaskID { get; set; }

        [Required(ErrorMessage = "Please select a activity type.")]
        //[Range(1, int.MaxValue, ErrorMessage = "Please select a activity type.")]
        public string ActivityType { get; set; }

        [Required(ErrorMessage = "Please select a company.")]
        [Range(1, int.MaxValue, ErrorMessage = "Please select a company.")]
        public int CompanyID { get; set; }

        [Required(ErrorMessage = "Please select a site.")]
        [Range(1, int.MaxValue, ErrorMessage = "Please select a site.")]
        public int SiteID { get; set; }

        [Required(ErrorMessage = "Please select a act.")]
        [Range(1, int.MaxValue, ErrorMessage = "Please select a act.")]
        public int ActID { get; set; }

        [Required(ErrorMessage = "Please select a activity.")]
        [Range(1, int.MaxValue, ErrorMessage = "Please select a activity.")]
        public int ActivityID { get; set; }
        //[Required(ErrorMessage = "Please select a contractor.")]
        //[Range(1, int.MaxValue, ErrorMessage = "Please select a contractor.")]
        
        [Required(ErrorMessage = "Please enter expiry date.")]
        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}")]
        public DateTime ExpiryDate { get; set; }
        [Required(ErrorMessage = "Please enter remind days.")]
        public int RemindDays { get; set; }

        public string Freq = "AsNeeded";

        [ContractorValidation]
        public int ContractorID { get; set; }
        public string Creation_Desc { get; set; }
        public string Creation_Remarks { get; set; }
        
        public int CreatedBy { get; set; }
        public int CurrUser { get; set; }

        public SelectList CompanyList { get; set; }

        public string TaskCreationDate { get; set; }
        public string ActionType { get; set; }
        public int Applicable_To_Client { get; set; }

        public int MappingID { get; set; }
    }
}