using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.ComponentModel.DataAnnotations;
namespace Ecompliance.ViewModel
{
    public class TaskVerifyVM
    {
        public int DocID { get; set; }
        public int UID { get; set; }
        [Required(ErrorMessage = "Please enter maker remarks.")]
        public string Remark { get; set; }
        [Required(ErrorMessage = "Please enter activity completion date.")]
        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}")]
        public DateTime ActivityCompDate { get; set; }
        [Required(ErrorMessage = "Please select a delay reason.")]
        public string DelayReason { get; set; }
    }
}