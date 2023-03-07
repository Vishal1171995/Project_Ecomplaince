using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.ComponentModel.DataAnnotations;
namespace Ecompliance.Areas.Master.Models
{
    public class Contractor
    {
        public int ContractorID { get; set; }
        [Required(ErrorMessage ="Please enter contractor name.")]
        [Display(Name = "Name")]
        public string Name { get; set; }
        [Required]
        [Display(Name = "Company")]
        [Range(1, int.MaxValue, ErrorMessage = "Please select a company.")]
        public int Company { get; set; }

        public string Address { get; set; }
        [Required(ErrorMessage ="Please enter contact person.")]
        [Display(Name = "Contact Person")]
        public string Contact_Person { get; set; }
        [DataType(DataType.PhoneNumber)]
        [RegularExpression(@"^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$", ErrorMessage = "Entered contact number format is not valid.")]
        [Display(Name = "Contact Number")]
        public string Contact_Number { get; set; }
        [EmailAddress]
        public string Email { get; set; }
        [Display(Name = "PF Code")]
        public string PF_Code { get; set; }
        [Display(Name = "ESI Code")]
        public string ESI_Code { get; set; }
        public bool IsAct { get; set; }
        public int CreatedBy { get; set; }
        public int UID { get; set; }
        public SelectList CompanyList { get; set; }

        [Required]
        [Display(Name = "Company")]
        public string CompanyText { set; get; }
    }

  
}