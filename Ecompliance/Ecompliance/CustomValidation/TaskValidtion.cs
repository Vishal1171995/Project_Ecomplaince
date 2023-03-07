using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using Ecompliance.ViewModel;

namespace Ecompliance.CustomValidation
{
    public class ContractorValidation : ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            TaskVM ObjT = (TaskVM)validationContext.ObjectInstance;
            DateTime expiryDate = ObjT.ExpiryDate;
            int RemindDays = ObjT.RemindDays;
            DateTime currentDate = DateTime.Now.Date;
            expiryDate = expiryDate.Date.AddDays(-RemindDays);
            if ((ObjT.ActivityType.Trim().ToUpper() == "CONTRACTOR" && (Convert.ToInt32(value) == 0)) || (expiryDate < currentDate && ObjT.Freq == "AsNeeded"))

            {
                return new ValidationResult("Please select a contractor");
            }
            else
            {
                return ValidationResult.Success;
            }
        }

    }
}