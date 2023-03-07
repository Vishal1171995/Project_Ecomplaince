using Ecompliance.Areas.Master.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;


namespace Ecompliance.CustomValidation
{
    public class RemindDaysVal : ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            SiteActivityMapping objSiteActiMapping = (SiteActivityMapping)validationContext.ObjectInstance;
          //  double diff =  (objSiteActiMapping.StartDate - objSiteActiMapping.StartDate.Value.AddDays(-objSiteActiMapping.RemindDays)).Value.TotalDays;
            if (objSiteActiMapping.Frequency == 8 && (objSiteActiMapping.StartDate.Value.Day - objSiteActiMapping.RemindDays) <= 0)
            {
                return new ValidationResult("RemindDays cannot be greater than or equal to date in case of monthly frequency.!");
            }
                
            
          
            else
            {

                return ValidationResult.Success;
            }
        }

    }
    public class RemindDaysValVM : ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            SiteActivityMappingVM objSiteActiMapping = (SiteActivityMappingVM)validationContext.ObjectInstance;
          
           // double diff = (objSiteActiMapping.StartDate - objSiteActiMapping.StartDate.Value.AddDays(-objSiteActiMapping.RemindDays)).Value.TotalDays;
            if (objSiteActiMapping.Frequency.ToUpper().Trim() == "MONTHLY" && (objSiteActiMapping.StartDate.Value.Day - objSiteActiMapping.RemindDays) <= 0)
            {
                return new ValidationResult("RemindDays cannot be greater than or equal to date in case of monthly frequency.!");
            }



            else
            {

                return ValidationResult.Success;
            }
        }
    }

    public class RemindDaysValPE : ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            SiteActivityMappingPE objSiteActiMapping = (SiteActivityMappingPE)validationContext.ObjectInstance;
          //  double diff = (objSiteActiMapping.StartDate - objSiteActiMapping.StartDate.Value.AddDays(-objSiteActiMapping.RemindDays)).Value.TotalDays;
            if (objSiteActiMapping.Frequency == 8 && (objSiteActiMapping.StartDate.Value.Day - objSiteActiMapping.RemindDays) <= 0)
            {
                return new ValidationResult("RemindDays cannot be greater than or equal to date in case of monthly frequency.!");
            }



            else
            {

                return ValidationResult.Success;
            }
        }

    }
    public class RemindDaysValVMPE : ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            SiteActivityMappingPEVM objSiteActiMapping = (SiteActivityMappingPEVM)validationContext.ObjectInstance;
            if (objSiteActiMapping.StartDate != null || objSiteActiMapping.StartDate.ToString() != "")
            {
              //  double diff = (objSiteActiMapping.StartDate - objSiteActiMapping.StartDate.Value.AddDays(-objSiteActiMapping.RemindDays)).Value.TotalDays;
                if (objSiteActiMapping.Frequency.ToUpper().Trim() == "MONTHLY" && (objSiteActiMapping.StartDate.Value.Day - objSiteActiMapping.RemindDays) <= 0)
                {
                    return new ValidationResult("RemindDays cannot be greater than or equal to date in case of monthly frequency.!");
                }



                else
                {

                    return ValidationResult.Success;
                }
            }
            else
            {

                return ValidationResult.Success;
            }
        
    }
    }
}