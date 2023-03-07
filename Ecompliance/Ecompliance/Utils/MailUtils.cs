
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Net;
using System.Net.Mail;
public static class MailUtill
{
    static string UserName;
    static string Password;
    static string SMTP;


     static MailUtill()
    {

        UserName = Convert.ToString("no-reply@myndsol.com");
        Password = Convert.ToString("vc79aK123AJ&$kL0");
        SMTP = Convert.ToString("mail.myndsol.com");
    }


    public static string SendMail(string ToMail, string Subject, string MailBody, string CC = "", string Attachments = "", string BCC = "")
    {
        string  ret = "fail";
        Array arrToArray = default(Array);
        Array arrCC = default(Array);
        Array arrBCC = default(Array);
        Array arrAtch = default(Array);
        char[] splitter = { ',' };
        //When multiple recepient seperated by ';'

        try
        {
            arrToArray = ToMail.Split(splitter);
            arrCC = CC.Split(splitter);
            arrBCC = BCC.Split(splitter);
            arrAtch = Attachments.Split(splitter);
            MailMessage message = new MailMessage();
            message.From = new MailAddress(UserName);
            message.Subject = Subject;
            message.Body = MailBody;
            message.IsBodyHtml = true;
            //message.SubjectEncoding = System.Text.Encoding.UTF8
            //message.BodyEncoding = System.Text.Encoding.UTF8
            //Adding To Mail 
            try
            {
                foreach (string s in arrToArray)
                {
                    if (!string.IsNullOrEmpty(s.Trim()))
                    {
                        message.To.Add(new MailAddress(s));
                    }
                }
            }
            catch (Exception ex)
            {
            }

            //Adding CC Mail 
            try
            {
                foreach (string s in arrCC)
                {
                    if (!string.IsNullOrEmpty(s.Trim()))
                    {
                        message.CC.Add(new MailAddress(s));
                    }
                }
            }
            catch (Exception ex)
            {
            }

            //Adding BCC Mail 
            try
            {
                foreach (string s in arrBCC)
                {
                    if (!string.IsNullOrEmpty(s.Trim()))
                    {
                        message.Bcc.Add(new MailAddress(s));
                    }
                }
            }
            catch (Exception ex)
            {
            }

            //Adding BCC Mail 
            try
            {
                foreach (string s in arrAtch)
                {
                    if (!string.IsNullOrEmpty(s.Trim()))
                    {
                        message.Attachments.Add(new Attachment(s));
                    }
                }
            }
            catch (Exception ex)
            {
            }
            //Adding SMTP details
            NetworkCredential nCred = new NetworkCredential();
            nCred.UserName = UserName;
            nCred.Password = Password;
            
            SmtpClient client = new SmtpClient();
            client.Host = "mail.myndsol.com";
            client.Port = 587;
            client.EnableSsl = true;
            client.Credentials = nCred;
            client.Send(message);
            ret = "Mail Sent";
        }
        catch (Exception ex)
        {
            return ex.InnerException.Message;
        }

        return ret;
    }

    public static string SendMailSSL(string ToMail, string Subject, string MailBody, string CC = "", string Attachments = "", string BCC = "")
    {
        string ret = "fail";
        Array arrToArray = default(Array);
        Array arrCC = default(Array);
        Array arrBCC = default(Array);
        Array arrAtch = default(Array);
        char[] splitter = { ',' };
        //When multiple recepient seperated by ';'

        try
        {
            arrToArray = ToMail.Split(splitter);
            arrCC = CC.Split(splitter);
            arrBCC = BCC.Split(splitter);
            arrAtch = Attachments.Split(splitter);
            System.Web.Mail.MailMessage message = new System.Web.Mail.MailMessage();
            message.Fields.Add("http://schemas.microsoft.com/cdo/configuration/smtpserver",SMTP);
            message.Fields.Add("http://schemas.microsoft.com/cdo/configuration/smtpserverport","465");
            message.Fields.Add("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate","1");

            message.Fields.Add("http://schemas.microsoft.com/cdo/configuration/sendusername", UserName);
            message.Fields.Add("http://schemas.microsoft.com/cdo/configuration/sendpassword", Password);
            message.Fields.Add("http://schemas.microsoft.com/cdo/configuration/smtpusessl", "true");
            
            message.Subject = Subject;
            message.Body = MailBody;
            message.From = UserName;

            //Adding To Mail 
            try
            {
                foreach (string s in arrToArray)
                {
                    if (!string.IsNullOrEmpty(s.Trim()))
                    {
                        message.To=s;
                    }
                }
            }
            catch (Exception ex)
            {
            }

            //Adding CC Mail 
            try
            {
                foreach (string s in arrCC)
                {
                    if (!string.IsNullOrEmpty(s.Trim()))
                    {
                        message.Cc = s;
                    }
                }
            }
            catch (Exception ex)
            {
            }

            //Adding BCC Mail 
            try
            {
                foreach (string s in arrBCC)
                {
                    if (!string.IsNullOrEmpty(s.Trim()))
                    {
                        message.Bcc = s;
                    }
                }
            }
            catch (Exception ex)
            {
            }

            //Adding BCC Mail 
            try
            {
                foreach (string s in arrAtch)
                {
                    if (!string.IsNullOrEmpty(s.Trim()))
                    {
                        message.Attachments.Add(new Attachment(s));
                    }
                }
            }
            catch (Exception ex)
            {
            }
            //Adding SMTP details
            //NetworkCredential nCred = new NetworkCredential();
            //nCred.UserName = UserName;
            //nCred.Password = Password;

            //SmtpClient client = new SmtpClient();
            //client.Host = "mail.myndsol.com";
            ////client.Port = 25;
            //client.UseDefaultCredentials = true;
            //client.Credentials = nCred;
            System.Web.Mail.SmtpMail.SmtpServer = SMTP + ":465";
            System.Web.Mail.SmtpMail.Send(message);

            ret = "Mail Sent";
        }
        catch (Exception ex)
        {
            return ex.InnerException.Message;
        }

        return ret;
    }
}


