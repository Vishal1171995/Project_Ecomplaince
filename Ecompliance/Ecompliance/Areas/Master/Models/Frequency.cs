using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Ecompliance.Areas.Master.Models
{
    public class Frequency
    {
        [Required]
        public int FrequencyID { get; set; }

        [Required]
        [StringLength(100, ErrorMessage = "The {0} must  be within  {2} characters long.")]
        public string Name { get; set; }
        [Required]
        public bool IsAct { get; set; }
        public int CreatedBy { get; set; }
        public int UID { get; set; }
    }
}