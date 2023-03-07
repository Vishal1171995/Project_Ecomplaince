using System;
using System.Collections.Generic;
using System.Linq;
using System.ComponentModel.DataAnnotations;
using System.Web;
using System.Web.Mvc;

namespace Ecompliance.Areas.ACT2.ViewModel
{
    public class FileManagerVM
    {
        [Required(ErrorMessage ="Please Select a State.")]
        public int State { get; set; }
        public string text { get; set; }
        public int Location { get; set; }
        [Required(ErrorMessage ="Please Select a Paydate.")]
        public string PayDate { get; set; }
        public bool hasChildren { get; set; }
        public bool expanded { get; set; }
        public SelectList StateList { get; set; }
        public SelectList LocationList { get; set; }
        public SelectList PayDateList { get; set; }
        public List<FiLeManagerClild> Child { get; set; }
    }

    public class FiLeManagerClild
    {
        public string Text;
        public bool hasChildren { get; set; }
        public bool expanded { get; set; }
    }
}