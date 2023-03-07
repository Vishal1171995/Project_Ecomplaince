using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Ecompliance.ViewModel
{
    public class UserVM
    {
        [Required]
        [RegularExpression("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}", ErrorMessage = "Password must be minimum 8 characters long having  at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character.")]
        public string Password { set; get; }

        [Required]
        [System.Web.Mvc.Compare("Password", ErrorMessage = "Password and Confirm Password do not match!.")]
        public string ConfirmPassword { set; get; }

        public string Passkey { set; get; }    

    }
}