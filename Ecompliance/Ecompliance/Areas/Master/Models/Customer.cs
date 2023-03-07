using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
namespace Ecompliance.Areas.Master.Models
{
    public class Customer
    {
        public int CustID { get; set; }
        [Required(ErrorMessage ="Please enter customer name.")]
        [Display(Name = "Name")]
        public string Name { get; set; }

        public string Code { get; set; }
        public int CreatedBy { get; set; }

        [Display(Name = "Status")]
        public bool IsAct { get; set; }
        public bool EableIPAddress { get; set; }
        public int UID { get; set; }
        [Required]
        [RegularExpression("^[a-zA-Z]+$", ErrorMessage = "SubDomain can consist of only alphabets with no space.")]
        public string SubDomain { get; set; }
    }
}