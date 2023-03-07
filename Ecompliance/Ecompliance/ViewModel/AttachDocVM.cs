using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Ecompliance.ViewModel
{
    public class AttachDocVM
    {
        [Required]
        public int DOCID { get; set; }

        [Required]
        public int UID { get; set; }

        public int Remarks { get; set; }

        public string ActivityType { get; set; }

        public string Company { get; set; }

        public string Site { get; set; }

        public string Act { get; set; }

        public string Activity { get; set; }

        public string Attach1 { get; set; }
        public string Attach1_FileName { get; set; }
        public string Attach2 { get; set; }
        public string Attach2_FileName { get; set; }
        public string Attach3 { get; set; }
        public string Attach3_FileName { get; set; }

        public string Attach4 { get; set; }
        public string Attach4_FileName { get; set; }

        public string Attach5 { get; set; }
        public string Attach5_FileName { get; set; }
    }
}