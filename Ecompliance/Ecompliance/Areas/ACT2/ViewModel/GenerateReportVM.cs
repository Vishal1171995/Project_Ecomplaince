using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Ecompliance.Areas.ACT2.ViewModel
{
    public class GenerateReportVM
    {
        [Required(ErrorMessage = "Please select a state.")]
        [Range(1, int.MaxValue, ErrorMessage = "Please select a state")]
        public int State { set; get; }
        public int Location { set; get; }

        public int Site { set; get; }

        public int Company { set; get; }

        [Required(ErrorMessage = "Please select a pay date.")]
        public string  PayDate { set; get; }
        public string  Groupdata { set; get; }

        public SelectList StateList { get; set; }

        public SelectList CompanyList { get; set; }

        public SelectList PayDateList { get; set; }
        public SelectList GroupList { get; set; }

    }
}