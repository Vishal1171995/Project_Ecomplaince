using Ecompliance.Areas.Master.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Ecompliance.CustomValidation
{
    public class MappingStartDateValPE : ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            SiteActivityMappingPE objMappingPE = (SiteActivityMappingPE)validationContext.ObjectInstance;
            if (objMappingPE.Frequency!=9 && Convert.ToString( objMappingPE.StartDate) == "")
            {
                return new ValidationResult("Due Date is required.");
            }
            else
            {
                return ValidationResult.Success;
            }
        }
    }

    public class MappingStartDateValPEVE : ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            SiteActivityMappingPEVM objMappingPE = (SiteActivityMappingPEVM)validationContext.ObjectInstance;
            if (objMappingPE.Frequency.ToUpper().Trim() != "AS NEEDED" && Convert.ToString(objMappingPE.StartDate) == "")
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