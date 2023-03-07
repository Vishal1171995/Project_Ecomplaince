using Ecompliance.Areas.Admin.Models;
using Ecompliance.Areas.Master.Models;
using Ecompliance.Repository;
using Ecompliance.Utils;
using Ecompliance.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CaptchaMvc.HtmlHelpers;
using System.Globalization;  

namespace Ecompliance.Controllers
{
    public class RegistrationController : Controller
    {
        // GET: SignUp
        [Route("Registration", Name = "Registration")]
        public ActionResult Registration()
        {
            try
            {
                return View();
            }
            catch
            {
                throw;

            }
        }
        public ActionResult RegistrationSuccess()
        {
            return View("RegistrationSuccess");
        }

        [HttpPost]
        [ValidateAntiForgeryToken()]
        [Route("Registration", Name = "Signup")]
        public ActionResult Registration(SignUpVM Signup)
        {
            
            try
            
            {
                Response res = new Response();
                ModelState["ObjCutomer.Name"] = new ModelState { Value = new ValueProviderResult("", Signup.ObjCutomer.SubDomain, CultureInfo.CurrentUICulture) };
                ModelState["ObjUser.User_Name"] = new ModelState { Value = new ValueProviderResult("", Signup.ObjUser.User_Name, CultureInfo.CurrentUICulture) };

                ModelState["ObjUser.Role"] = new ModelState { Value = new ValueProviderResult("", "18", CultureInfo.CurrentUICulture) };
                ModelState["ObjUser.Custome"] = new ModelState { Value = new ValueProviderResult("", "10", CultureInfo.CurrentUICulture) };
                ModelState["ObjUser.Last_Name"] = new ModelState { Value = new ValueProviderResult("", "N/A", CultureInfo.CurrentUICulture) };
                Signup.ObjCutomer.Name = Signup.ObjCutomer.SubDomain;
                Signup.ObjUser.User_Name = Signup.ObjUser.Email;
                Signup.ObjUser.Role = 18;
                Signup.ObjUser.Customer = 10;
                Signup.ObjUser.Last_Name = "NA";
                if (ModelState.IsValid)
                {
                    Signup.ObjCutomer.CreatedBy = 0;
                  
                    Signup.ObjCutomer.IsAct = true;
                    Signup.ObjUser.Password = Signup.Password;
                    SignUpRepo repo = new SignUpRepo();

                    if (this.IsCaptchaValid("Captcha is not valid"))
                    {

                        int result = repo.SignupCreate(Signup);
                        if (result == -2001)
                        {

                            ModelState.AddModelError(string.Empty, "This Company Already Registered With Us!.");
                            return View(Signup);
                        }
                        else if (result == -2002)
                        {
                            ModelState.AddModelError(string.Empty, "UserName must be Unique!.");
                            return View(Signup);
                        }
                        else if (result == 1)
                        {
                         
                            return View("RegistrationSuccess");
                        }
                        else
                        {
                            ModelState.AddModelError(string.Empty, "Something went wrong please try agian later.");
                         
                            return View(Signup);
                        }
                    }
                    else
                    {
                        
                        ModelState.AddModelError(string.Empty, "Invalid Captcha");
                        return View(Signup);
                    }
               
                   
                }
                else
                {
                    
                    ModelState.AddModelError("",string.Empty);
                    return View(Signup);
                }
            }
            catch
            {
                throw;
            }
        }
    }
}