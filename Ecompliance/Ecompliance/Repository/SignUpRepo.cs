using Ecompliance.Areas.Master.Models;
using Ecompliance.ViewModel;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Ecompliance.Repository
{
    public class SignUpRepo
    {
        public int SignupCreate(SignUpVM Signup)
        {
            SqlTransaction trans=null;
            SqlConnection con=null;
               
            try
            {
                con = new SqlConnection(Ecompliance.Utils.DataLib.GetConnectionString());
                if (con.State == ConnectionState.Closed)
                { con.Open(); }
                trans = con.BeginTransaction();
                int custresult = -1;
                CustomerRepo custRepo = new CustomerRepo();                          
               
                    custresult = Convert.ToInt32( custRepo.AddUpdateCustomer(Signup.ObjCutomer,trans,con ));

                    if (custresult != -1)
                    {
                        Signup.ObjUser.UID = 0;
                        Signup.ObjUser.Customer = custresult;
                        Signup.ObjUser.CreatedBy = 0;
                        UserRepo Userrepo = new UserRepo();
                        int uresult =   Userrepo.CreateUpdateUser(Signup.ObjUser,trans,con );
                        if (uresult != -1)
                        {
                            trans.Commit();
                            return 1;
                        }
                        else {
                            trans.Rollback();
                            return -2002;
                        }
                    }
                    else
                    {
                        trans.Rollback();
                        return -2001;
                    }
               
            }
            catch
            {
                throw;
            }
            finally
            {
                if (con != null)
                    con.Dispose();
                if (trans != null)
                    trans.Dispose();
            }
        }


    }
}