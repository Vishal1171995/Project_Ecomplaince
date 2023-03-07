using Ecompliance.Areas.Admin.Models;
using Ecompliance.Areas.Master.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Ecompliance.ViewModel
{
    public class SignUpVM
    {
        public Customer ObjCutomer
        { get; set; }

        public User ObjUser
        { get; set; }

       [Required]
       [Range(typeof(bool), "true", "true", ErrorMessage = "Please Check Terms and Conditions")]        
        public bool  IsTNC { get; set; }

       [Required]
       [RegularExpression("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}", ErrorMessage = "Password must be minimum 8 characters long having  at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character.")]
       public string Password { get; set; }

       [Compare("Password", ErrorMessage = "Password and Confirm Password do not match!.")]
       public string ConfirmPassword { get; set; }
    }
}