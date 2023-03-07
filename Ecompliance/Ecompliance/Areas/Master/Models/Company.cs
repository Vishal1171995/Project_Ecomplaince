using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using System.Xml.Serialization;

namespace Ecompliance.Areas.Master.Models
{
    public class Company
    {
        public int? CompanyID { get; set; }

        [Required(ErrorMessage = "Please enter company name.")]
        [StringLength(500, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 3)]
        public string Name { get; set; }

        public string CompanyCode { get; set; }
         
        public string Address { get; set; }
        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "Please select customer.")]
        public int Customer { get; set; }
        [Required(ErrorMessage = "Please enter contact person name.")]
        public string Contact_Person { get; set; }

        public string Phone_Number { get; set; }

        [DataType(DataType.EmailAddress)]

        [EmailAddress(ErrorMessage="Please enter valid email.")]
        public string Email { get; set; }

        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "Please select maker.")]
        public int Maker { get; set; }

        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "Please select checker.")]
        public int Checker { get; set; }
        [Range(0, 1000000, ErrorMessage = "Invalid maker2.")]
        public int Maker2 { get; set; }
        [Range(0, 1000000, ErrorMessage = "Invalid checker2.")]
        public int Checker2 { get; set; }

        [Range(0, 1000000, ErrorMessage = "Invalid Auditor1.")]
        public int Auditor1 { get; set; }
        [Range(0, 1000000, ErrorMessage = "Invalid Auditor2.")]
        public int Auditor2 { get; set; }
        public bool  IsAct { get; set; }


        [JsonIgnore]
        [XmlIgnore]
        [Required]
        public int createdby { get; set; }
        [JsonIgnore]
        [XmlIgnore]
        public int UID { get; set; }
        [JsonIgnore]
        [XmlIgnore]
        public SelectList CustomerList
        {
            get;
            set;
        }
        [JsonIgnore]
        [XmlIgnore]
        public SelectList UserList
        {
            get;
            set;

        }
        [JsonIgnore]
        [XmlIgnore]
        public SelectList AuditorList { get; set; }
    }



    public class CompanyVM
    {
        public int CompanyID { get; set; }

        [Required]
        public string Name { get; set; }

        public string CompanyCode { get; set; }
        
        public string Address { get; set; }
        [Required]
        public string Customer { get; set; }
        [Required]
        public string Contact_Person { get; set; }

        
        public string Phone_Number { get; set; }

        [EmailAddress(ErrorMessage = "Invalid Email Address")]
        public string Email { get; set; }

        [Required]
        public string Maker { get; set; }

        [Required]
        public string Checker { get; set; }
        public string Maker2 { get; set; }
        public string Checker2 { get; set; }
        public string Auditor1 { get; set; }
        public string Auditor2 { get; set; }

        [Required]
        public bool IsAct { get; set; }

        [Required]
        public int createdby { get; set; }
        public int UID { get; set; }
      
    }
}