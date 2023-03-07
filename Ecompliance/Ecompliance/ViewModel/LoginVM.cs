using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Ecompliance.ViewModel
{
    public class LoginVM
    {

        
        [Required(ErrorMessage = "Please enter your user name.")]
        //[RegularExpression("^[A-Za-z0-9\\d@_.]{5,15}$", ErrorMessage = "Invalid UserName.")]
        public string UserName { get; set; }

        [Required(ErrorMessage = "Please enter password.")]
        //[RegularExpression("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}", ErrorMessage = "Invalid Password.")]
        [DisplayName("Password")]
        public string Password { get; set; }
    }

    public class ForgetPasswordVM
    {
        [Required(ErrorMessage = "Please enter your user name.")]
        [RegularExpression("^[A-Za-z0-9\\d@_.]{5,15}$", ErrorMessage = "Invalid UserName.")]
        public string UserName { get; set; }
    }

}