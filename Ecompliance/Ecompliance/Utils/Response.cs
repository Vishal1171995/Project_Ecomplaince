using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Ecompliance.Utils
{
    public class Response
    {
        public bool IsSuccess { set; get; }
        public string  Data { set; get; }

        public string Message { set; get; }

        public Response GetResponse(string subject,string operation,int response,string Fields="",string Data="",string Message="")
        {

            Response objRes = new Response();
            string res=response.ToString();

            try
            {
                if (operation == "0")
                    operation = "creation";
                if (Convert.ToInt32(operation) > 0)
                    operation = "Updation";
            }
            catch { }
            if(response>0)
            {
                res="success";
            }

            switch (res)
            {
                case "success":
                    {
                        objRes.IsSuccess = true;
                        objRes.Message = subject + " created. Your transaction-id is "+ response ;
                        objRes.Data = response.ToString();
                        break;
                    }
                case "-1000":
                    {
                        objRes.IsSuccess = true;
                        objRes.Message = Message;
                        objRes.Data = Data;
                        break;
                    }
                case "-2000":
                    {
                        //Validation case
                        objRes.IsSuccess = false;
                        objRes.Message = subject + " " + operation + " failed." + Fields + " must be unique.";
                        objRes.Data = Data;
                        break;
                    }
                case "0":
                    {
                        objRes.IsSuccess = true;
                        objRes.Message = subject + " Updated sucessfully.";
                        objRes.Data = response.ToString();
                        break;
                    }
                case "-1":
                    {
                        objRes.IsSuccess = false;
                        objRes.Message = subject + " " + operation + " failed." + Fields + " must be unique.";
                        objRes.Data = response.ToString();
                        break;
                    }
                case "-2":
                    {
                        objRes.IsSuccess = false;
                        objRes.Message = "Sorry!!! Something went wrong. Please try again later";
                        objRes.Data = response.ToString();
                        break;
                    }
                case "-3":
                    {
                        objRes.IsSuccess = false;
                        objRes.Message = "Sorry!!!Your login session has expired. Please log-in again.";
                        objRes.Data = response.ToString();
                        break;
                    }
                case "-4":
                    {
                        objRes.IsSuccess = false;
                        objRes.Message = "Sorry!!!You do not have sufficient previlage for this action.";
                        objRes.Data = response.ToString();
                        break;
                    }

               
            }
            return objRes;
        }

       
    }
}