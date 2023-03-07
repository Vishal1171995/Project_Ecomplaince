using Ecompliance.Areas.Master.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Ecompliance.CustomValidation
{
    public class ActivityFrequencyVal : ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
           Activity objActivity = (Activity)validationContext.ObjectInstance;
           if (objActivity.Frequency == 8 && (Convert.ToDateTime(value).Date.Day > 28 ))
            {
                return new ValidationResult("Date cannot be greater than 28 in case of Monthly Frequency !");
            }
            else
            {
              
                return ValidationResult.Success;
            }
        }
    }
}