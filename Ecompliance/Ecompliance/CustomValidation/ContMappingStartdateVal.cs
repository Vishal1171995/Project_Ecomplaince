using Ecompliance.Areas.Master.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;


namespace Ecompliance.CustomValidation
{
    public class ContMappingStartdateVal : ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            SiteActivityMapping objMapping= (SiteActivityMapping)validationContext.ObjectInstance;
            if (objMapping.Frequency != 9 && Convert.ToString(objMapping.StartDate) == "")
            {
                return new ValidationResult("Due Date is required.");
            }
            else
            {
                return ValidationResult.Success;
            }
        }
    }



    public class ContMappingStartdateValVM : ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            SiteActivityMappingVM objMapping = (SiteActivityMappingVM)validationContext.ObjectInstance;
            if (objMapping.Frequency.ToUpper().Trim() != "AS NEEDED" && Convert.ToString(objMapping.StartDate) == "")
            {
                return new ValidationResult("Due Date is required.");
            }
            else
            {
                return ValidationResult.Success;
            }
        }
    }
}