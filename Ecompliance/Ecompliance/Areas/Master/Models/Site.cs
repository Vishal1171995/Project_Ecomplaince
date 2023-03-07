using System;
using System.Collections.Generic;
using System.Web.Mvc;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace Ecompliance.Areas.Master.Models
{
    public class Site
    {
        public int SiteID { get; set; }
        [Required]
        [Display(Name = "Company")]
        [Range(1, int.MaxValue, ErrorMessage = "Please select a company.")]
        public string Company { get; set; }
        [Required]
        [Display(Name = "Customer")]
        [Range(1, int.MaxValue, ErrorMessage = "Please select a customer.")]
        public string Customer { get; set; }
        [Required(ErrorMessage ="Please enter site name.")]
        [Display(Name = "Name")]
        public string Name { get; set; }

        [Display(Name = "Site Code")]
        public string SiteCode { get; set; }

        [Required]
        [Display(Name = "State")]
        [Range(1, int.MaxValue, ErrorMessage = "Please select a state.")]
        public string State { get; set; }
        [Required]
        [Display(Name = "Location")]
        //[Range(1, int.MaxValue, ErrorMessage = "Please select a location.")]
        public string Location { get; set; }
        public string Contact_Person { get; set; }
        public string Contact_Number { get; set; }
        public string Address { get; set; }
        public string LatLong { get; set; }
        public string PlaceID { get; set; }
        [Range(0, 1000000, ErrorMessage = "Invalid maker.")]
        public int Maker { get; set; }
        [Range(0, 1000000, ErrorMessage = "Invalid checker.")]
        public int Checker { get; set; }

        [Range(0, 1000000, ErrorMessage = "Invalid maker2.")]
        public int Maker2 { get; set; }
        [Range(0, 1000000, ErrorMessage = "Invalid checker2.")]
        public int Checker2 { get; set; }

        [Range(0, 1000000, ErrorMessage = "Invalid Auditor1.")]
        public int Auditor1 { get; set; }
        [Range(0, 1000000, ErrorMessage = "Invalid Auditor2.")]
        public int Auditor2 { get; set; }
        public bool IsAct { get; set; }
        public int CreatedBy { get; set; }
        public int UID { get; set; }
        public SelectList CompanyList { get; set; }
        public SelectList CustomerList { get; set; }
        public SelectList StateList { get; set; }
        public SelectList UserList { get; set; }
        public SelectList AuditorList { get; set; }
    }


    public class SiteVM
    {
        public int SiteID { get; set; }
        [Required]
        [Display(Name = "Company")]
        public string Company { get; set; }

        [Required]
        [Display(Name = "Customer")]
        public string Customer { get; set; }

        [Required]
        [Display(Name = "Name")]
        public string Name { get; set; }

        [Display(Name = "Site Code")]
        public string SiteCode { get; set; }

        [Required]
        [Display(Name = "State")]
        public string State { get; set; }
        public string Location { get; set; }
        public string Contact_Person { get; set; }
        public string Contact_Number { get; set; }
        public string Address { get; set; }
        public string LatLong { get; set; }
        public string PlaceID { get; set; }
        public string Maker { get; set; }
        public string Checker { get; set; }
        public string Maker2 { get; set; }
        public string Checker2 { get; set; }
        public string Auditor1 { get; set; }
        public string Auditor2 { get; set; }
        [Required]
        [Display(Name = "IsAct")]
        public bool IsAct { get; set; }
        public int CreatedBy { get; set; }
        public int UID { get; set; }
      
    }
}