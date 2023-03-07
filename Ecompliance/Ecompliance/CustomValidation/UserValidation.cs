using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using Ecompliance.ViewModel;
using Ecompliance.Areas.Admin.Models;

namespace Ecompliance.CustomValidation
{
    public class RoleValidation:ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            User ObjUser = (User)validationContext.ObjectInstance;

            if ((Convert.ToInt32(value) == 19))
            {
                ObjUser.Contractor = 0; ObjUser.Customer = 0;
                if (ObjUser.Company == 0)
                { return new ValidationResult("Please select a Company for Admin !"); }
                else
                { return ValidationResult.Success; }
               
            }
            else if ( (Convert.ToInt32(value) == 20))
            {
                ObjUser.Company = 0; ObjUser.Customer = 0;
                if (ObjUser.Contractor == 0 )
                { return new ValidationResult("Please select a Contractor for Admin !"); }
                else
                { return ValidationResult.Success; }
               
            }
            else if ((Convert.ToInt32(value) == 18) || (Convert.ToInt32(value) == 23)|| (Convert.ToInt32(value)==24))
            {
                ObjUser.Company = 0; ObjUser.Contractor = 0;
                if (ObjUser.Customer == 0)
                { return new ValidationResult("Please select a Customer for Admin !"); }
                else
                { return ValidationResult.Success; }
               
            }
            else
            {
                ObjUser.Company = 0; ObjUser.Contractor = 0; ObjUser.Customer = 0;
                return ValidationResult.Success;
            }
        }
    }
}