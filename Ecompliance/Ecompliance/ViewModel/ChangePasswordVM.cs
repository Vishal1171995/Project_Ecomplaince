using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Ecompliance.ViewModel
{
    public class ChangePasswordVM
    {
        [Required(ErrorMessage ="Please enter current password")]
        [RegularExpression("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}", ErrorMessage = "Password must be minimum 8 characters long having  at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character.")]
        public string Password { get; set; }

        [Required(ErrorMessage = "Please enter new password")]
        [RegularExpression("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}", ErrorMessage = "Password must be minimum 8 characters long having  at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character.")]
        public string NewPassword { get; set; }
        [Required(ErrorMessage = "Please enter confirm password")]
        [Compare("NewPassword",ErrorMessage = "Password and Confirm Password do not match!.")]
        public string ConfirmPassword { get; set; }

    }

    public class ResetPasswordVM
    {
        [Required(ErrorMessage="Please enter your User ID")]
        public string UserID { set; get; }

        [Required(ErrorMessage="Please Enter Your Current Password")]
        public string CurrentPassword { set; get; }

        [Required(ErrorMessage = "Please enter new password")]
        [RegularExpression("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}", ErrorMessage = "Password must be minimum 8 characters long having  at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character.")]
        public string NewPassword { get; set; }
        [Required(ErrorMessage = "Please enter confirm password")]
        [Compare("NewPassword", ErrorMessage = "Password and Confirm Password do not match!.")]
        public string ConfirmPassword { get; set; }

    }
}