using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Ecompliance.Models
{
    public class TaskFile
    {

        public int ?FileID { set; get; }
        [Required]
        public int DOCID { set; get; }

        [Required]
        public string  Name { set; get; }

        [Required]
        public string UAction { set; get; }

        [Required]
        public int UID{ set; get; }

        [Required]
        public string Desc { set; get; }
    }
}