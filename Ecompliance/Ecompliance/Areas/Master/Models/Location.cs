using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;
namespace Ecompliance.Areas.Master.Models
{
    public class Location
    {
        public int LocationID { get; set; }
        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "Please select a state.")]
        public int State { get; set; }
        [Required(ErrorMessage = "Please enter location name.")]
        public string Name { get; set; }
        public bool IsAct { get; set; }
        public int CreatedBy { get; set; }
        public SelectList StateList { get; set; }
        public int StateID { get; set; }
        public string StateName { get; set; }

        public bool IsActState { get; set; }

        public int UID { get; set; }
    }
}