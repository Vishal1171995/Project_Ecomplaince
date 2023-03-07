using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ecompliance.Utils;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using Ecompliance.Repository;
using Ecompliance.Models;
using System.ComponentModel.DataAnnotations;
using Ecompliance.Areas.Admin.Models;
using Ecompliance.ActionFilters;
using Ecompliance.Utils;

namespace Ecompliance.Controllers
{
    [CustomAuthActionFilter]
    public class TaskFileController : Controller
    {
        // GET: TaskFile
        
        [Route("UploadTaskFile", Name = "UploadTaskFile")]
        [ValidateAntiForgeryToken]
        [HttpPost]
        public ActionResult FilesUpload(HttpPostedFileBase fileToUpload, int DOCID)
        {
            string path = "";
            Response ret = new Response();
            //FileExtUtils fileext = new FileExtUtils();
            if (fileToUpload != null && fileToUpload.ContentLength > 0)
                try
                {
                    if (fileToUpload.ContentLength <= 20971520) //20MB {1048576 *20}
                    {
                        string fileExt = "";
                        fileExt = Path.GetExtension(fileToUpload.FileName);
                        //if ((fileExt.ToLower() != ".exe") || (fileExt.ToUpper() != ".vb") || (fileExt.ToUpper() != ".js") || (fileExt.ToUpper() != ".cs"))
                        if (FileExtUtils.checkFileExt(fileExt.ToLower()))
                        {
                            string FileName = DateTime.Now.Year.ToString() + DateTime.Now.Month + DateTime.Now.Date.DayOfYear + DateTime.Now.Hour + DateTime.Now.Minute + DateTime.Now.Second + DateTime.Now.Millisecond;
                            FileName = FileName.Replace(fileExt, string.Empty);
                            FileName = FileName + fileExt;
                            path = Server.MapPath("~/Docs/Task/") + FileName;
                            fileToUpload.SaveAs(path);
                            //Now Saving File Into DataBase
                            TaskFile Model = new TaskFile();
                            Model.FileID = 0;
                            Model.DOCID = DOCID;
                            Model.Name = FileName;
                            Model.Desc = fileToUpload.FileName;
                            Model.UAction = "Movement";
                            Model.UID = ((User)Session["uBo"]).UID;
                            var results = new List<ValidationResult>();
                            var vc = new ValidationContext(Model, null, null);
                            var isValid = Validator.TryValidateObject(Model, vc, results);
                            var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                            if (isValid)
                            {
                                TaskFileRepo ObjRep = new TaskFileRepo();
                                int FileID = ObjRep.InsertTaskFile(Model);
                                ret.IsSuccess = true;
                                //ret.FileName = FileName;
                                //ret.Data = FileID.ToString();
                                ret.Data = "{\"FileName\":\"" + FileName + "\",\"FileID\":\"" + FileID.ToString() + "\"}";
                            }
                            else
                            {
                                ret.IsSuccess = false;
                                ret.Data = "Upload failed";
                                ret.Message = "Upload failed";
                            }
                            ret.IsSuccess = true;
                            ret.Message = "Uploaded";
                        }
                        else
                        {
                            ret.IsSuccess = false;
                            ret.Data = "File type not supported.";
                            ret.Message = "File type not supported";
                        }
                    }
                    else
                    {
                        ret.IsSuccess = false;
                        ret.Data = "File size must be less than 20mb.";
                        ret.Message = "File size must be less than 20mb.";
                    }
                }
                catch (Exception ex)
                {
                    ret.IsSuccess = false;
                    ret.Data = "Sorry!!!Something went wrong.Please try again later.";
                    ret.Message = "Sorry!!!Something went wrong.Please try again later.";
                }
            else
            {
                ret.IsSuccess = false;
                ret.Data = "Invalid File.";
                ret.Message = "Invalid File.";
            }
            return Json(ret);
        }


        [HttpGet]
        [Route("GetTaskFiles", Name = "GetTaskFiles")]
        public ActionResult GetTaskFiles(int DOCID,int FileID)
        {
            TaskFile Model = new TaskFile();
            Model.FileID = FileID;
            Model.DOCID = DOCID;
            TaskFileRepo ObjRepo = new TaskFileRepo();
            Response res = new Response();
            try
            {
                DataTable dt = ObjRepo.GetTaskFile(Model);
                res.IsSuccess = true;
                res.Data = JsonSerializer.SerializeTable(dt);
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                res.IsSuccess = false;
                res.Message = ex.Message;
                return Json(res, JsonRequestBehavior.AllowGet);
            }
        }
        [HttpGet]
        [Route("DownloadTaskFile", Name = "DownloadTaskFile")]
        public ActionResult DownloadTaskFile(int DOCID, int FileID)
        {
            TaskFile Model = new TaskFile();
            Model.FileID = FileID;
            Model.DOCID = DOCID;
            TaskFileRepo ObjRepo = new TaskFileRepo();
            Response res = new Response();
            try
            {
                DataTable dt = ObjRepo.GetTaskFile(Model);
                string FileName = Server.MapPath("~/Docs/Task/") +dt.Rows[0]["Name"].ToString();
                byte[] fileBytes = System.IO.File.ReadAllBytes(FileName);
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, dt.Rows[0]["Desc"].ToString());
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Route("RemoveTaskFile", Name = "RemoveTaskFile")]
        public ActionResult RemoveTaskFile(int DOCID, int FileID)
        {
            TaskFile Model = new TaskFile();
            Model.FileID = FileID;
            Model.DOCID = DOCID;
            TaskFileRepo ObjRepo = new TaskFileRepo();
            Response res = new Response();
            try
            {
                int ret = ObjRepo.DeleteTaskFile(Model);
                res.IsSuccess = true;
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                res.IsSuccess = false;
                res.Message = ex.Message;
                return Json(res, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [Route("RemoveMultiTaskFile", Name = "RemoveMultiTaskFile")]
        public ActionResult RemoveMultiTaskFile(string[] fileNames, int DOCID, int FileID,string System_FileName)
        {
            TaskFile Model = new TaskFile();
            Model.FileID = FileID;
            Model.DOCID = DOCID;
            TaskFileRepo ObjRepo = new TaskFileRepo();
            Response res = new Response();
            string path = "";
            try
            {
                if (fileNames != null)
                {
                    foreach (var fullName in fileNames)
                    {
                        var fileName = Path.GetFileName(fullName);
                        bool exists = System.IO.Directory.Exists(Server.MapPath("~/Docs/Task/" + System_FileName));
                        path = Server.MapPath("~/Docs/Task/") + System_FileName;
                        System.IO.File.Delete(path);
                    }

                    int ret = ObjRepo.DeleteTaskFile(Model);
                    res.IsSuccess = true;
                }
                return Json(res, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                res.IsSuccess = false;
                res.Message = ex.Message;
                return Json(res, JsonRequestBehavior.AllowGet);
            }
        }

        [Route("BindAttachment", Name = "BindAttachment")]
        public ActionResult BindAttachment(int DOCID)
        {
            TaskFile Model = new TaskFile();
            Model.FileID = 0;
            Model.DOCID = DOCID;
            TaskFileRepo ObjRepo = new TaskFileRepo();
            try
            {
                DataTable dt = ObjRepo.GetTaskFile(Model);
                return View(dt);
            }
            catch (Exception ex)
            {

                throw;
            }
        }
        [HttpGet]
        [Route("GenerateSHASH", Name = "GenerateSHASH")]
        public ActionResult GenerateSHASH(string Hash)
        {
            HashingLib HashLib = new HashingLib();

            Response res = new Response();
            try
            {
                string HashString = HashLib.GenerateSHA256String(Hash);

                return Json(HashString, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

    }
}