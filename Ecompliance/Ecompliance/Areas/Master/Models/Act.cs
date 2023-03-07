using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Ecompliance.Areas.Master.Models
{
    public class Act
    {
        
        public int? ActID { get; set; }
        [Display(Name="Full Name")]
        [Required(ErrorMessage="Please enter full name.")]
        [StringLength(250, ErrorMessage = "The {0} must  be within  {2} characters long.")]
        public string Full_Name { get; set; }

        [Display(Name = "Short Name")]
        [Required(ErrorMessage = "Please enter short name.")]
        [StringLength(50, ErrorMessage = "The {0} must  be within  {2} characters long.")]
        public string Short_Name { get; set; }

         [Display(Name = "Is Active")]
        public bool IsAct { get; set; }

        public int CreatedBy { get; set; }
        public int UID { get; set; }
    }


   
}