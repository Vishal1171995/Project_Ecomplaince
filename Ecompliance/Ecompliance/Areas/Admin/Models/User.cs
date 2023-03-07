using Ecompliance.CustomValidation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Ecompliance.Areas.Admin.Models
{
    public class User
    {
        public int UID { set; get; }

        [Required(ErrorMessage = "Please enter user name.")]
        [RegularExpression("^[A-Za-z0-9\\d@_.]{5,25}$", ErrorMessage = "Invalid UserName.")]
        public string User_Name { set; get; }



        [Required(ErrorMessage = "Please enter First name.")]
        public string First_Name { set; get; }


        [Required(ErrorMessage = "Please enter Last name.")]
        public string Last_Name { set; get; }


        [Required(ErrorMessage = "Please enter email.")]
        [EmailAddress(ErrorMessage = "Invalid Email Address.")]
        public string Email { set; get; }

        public int PassChangeDays { set; get; }

        [RoleValidation]
        public int Role { set; get; }

        public int UserID { set; get; }
        public string UserRole { set; get; }
        public string Contact_Number { set; get; }
        public int Company { set; get; }
        public int Contractor { set; get; }
        public int Customer { set; get; }
        public string skey { set; get; }
        public string Passkey { set; get; }

        [RegularExpression("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}",ErrorMessage="Password must be minimum 8 characters long having  at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character.")]
        public string Password { set; get; }   
        public int IsAuth { set; get; }
        public int PassTry { set; get; }
        public int CreatedBy { set; get; }
        public SelectList RoleList
        {
            get;
            set;
        }
        public SelectList ContractorList
        {
            get;
            set;
        }
        public SelectList CompanyList
        {
            get;
            set;
        }

        public SelectList CustomerList
        {
            get;
            set;
        }

        public string Logo { set; get; }
    }


    public class UserVM1
    {
        public int UID { set; get; }

        [Required(ErrorMessage = "Please enter user name.")]
        public string User_Name { set; get; }



        [Required(ErrorMessage = "Please enter First name.")]
        public string First_Name { set; get; }


        [Required(ErrorMessage = "Please enter Last name.")]
        public string Last_Name { set; get; }


        [Required(ErrorMessage = "Please enter email.")]
        [EmailAddress(ErrorMessage = "Invalid Email Address.")]
        public string Email { set; get; }

        [Required(ErrorMessage = "Please select a role.")]
        [Range(1, int.MaxValue, ErrorMessage = "Please select a role.")]
        [RoleValidation]
        public string Role { set; get; }
        public string Contact_Number { set; get; }
        public string Company { set; get; }
        public string Contractor { set; get; }
        public int Customer { set; get; }
        public string skey { set; get; }
        public string Passkey { set; get; }
           [RegularExpression("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}", ErrorMessage = "Password must be minimum 8 characters long having  at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character.")]
        public string Password { set; get; }
        public int IsAuth { set; get; }
        public int PassTry { set; get; }
        public int CreatedBy { set; get; }
       
    }
}