using Ecompliance.CustomValidation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;
using System.Web.Mvc;
namespace Ecompliance.Areas.Master.Models
{
    public class Activity
    {
        public int? ActivityID { get; set; }

        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "Please select act.")]
        public int Act { get; set; }

        [Required(ErrorMessage ="Please enter activity name.")]
        public string Name { get; set; }
        public string Activity_Desc { get; set; }
        public bool Extendable_Exp_Date { get; set; }

        [Required]
        [Range(1,int.MaxValue,ErrorMessage="Please select frequency.")]
        public int Frequency { get; set; }
        public int Date_Of_Month { get; set; }
        public int Month { get; set; }
        public int Year { get; set; }
        [Required(ErrorMessage ="Please enter remind days.")]
        public int RemindDays { get; set; }

        [Required(ErrorMessage ="Please enter start date.")]
        [ActivityFrequencyVal]
        public DateTime StartDate { get; set; }
        public bool IsAct { get; set; }

        [Required]
        public int CreatedBy { set; get; }

        [Required(ErrorMessage = "Compliance Nature Required.")]
        public string Compliance_Nature
        {
            set;
            get;
        }
        public SelectList ActList
        {
            get;
            set;
        }

        public SelectList FrequencyList
        {
            get;
            set;

        }
        public int UID { get; set; }
    }

    public class ActivityVM
    {
        
        public int ActivityID { get; set; }

        [Required]
        public string Act { get; set; }

        [Required]
        public string Name { get; set; }
        public string Activity_Desc { get; set; }
        public bool Extendable_Exp_Date { get; set; }

        [Required]
        
        public string Frequency { get; set; }
        [Required]
        public string Compliance_Nature
        {
            set;
            get;
        }
        public int Date_Of_Month { get; set; }
      
      
        public int Month { get; set; }

       
        public int Year { get; set; }
        [Required]
        public int RemindDays { get; set; }


        [Required]
        public bool IsAct { get; set; }
        [Required]
        public int CreatedBy { set; get; }

        [Required]
        public DateTime StartDate { get; set; }

       

        public int UID { get; set; }



    }
}