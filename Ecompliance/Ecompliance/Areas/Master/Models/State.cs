using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Ecompliance.Areas.Master.Models
{
    public class State
    {
        [Required]
        public int StateID { get; set; }
        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "Please select a country.")]
        public int Country { get; set; }
        [Required(ErrorMessage = "Please enter state name.")]
        public string Name { get; set; }
        public string Geofence { get; set; }
        public bool IsAct { get; set; }
        public int CreatedBy { get; set; }
        public  SelectList  CountyList
        {
            get;
            set;
        }
        public int CountryID { get; set; }
        public string CountryName { get; set; }

        public bool IsActCountry { get; set; }

        public int UID { get; set; }
    }
}