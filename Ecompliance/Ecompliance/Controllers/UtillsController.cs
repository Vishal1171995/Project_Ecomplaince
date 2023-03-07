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
using Ecompliance.Areas.Admin.Models;
using Ecompliance.ActionFilters;
namespace Ecompliance.Controllers
{
    [CustomAuthActionFilter]
    public class UtillsController : Controller
    {

        // GET: Utills
        [Route("FilesUpload", Name = "FilesUpload")]
        [ValidateAntiForgeryToken]
        [HttpPost]
        public ActionResult FilesUpload(HttpPostedFileBase files, string Folder)
        {
            string path = "";
            Response ret = new Response();
            if (files != null && files.ContentLength > 0)
                try
                {
                    if (files.ContentLength <= 20971520) //20MB {1048576 *20}
                    {
                        string fileExt = "";
                        fileExt = Path.GetExtension(files.FileName);
                        //if ((fileExt.ToLower() != ".exe") || (fileExt.ToUpper() != ".vb") || (fileExt.ToUpper() != ".js") || (fileExt.ToUpper() != ".cs"))
                        if (fileExt.ToLower() == ".csv")
                        {
                            string FileName = DateTime.Now.Year.ToString() + DateTime.Now.Month + DateTime.Now.Date.DayOfYear + DateTime.Now.Hour + DateTime.Now.Minute + DateTime.Now.Second + DateTime.Now.Millisecond;
                            FileName = FileName.Replace(fileExt, string.Empty);
                            FileName = FileName + fileExt;
                            path = Server.MapPath("~/Docs/" + Folder + "/") + FileName;
                            files.SaveAs(path);
                            ret.IsSuccess = true;
                            ret.Data = "{\"original\":\"" + files.FileName + "\",\"new\":\"" + FileName + "\"}";
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
                    ret.Data = "Sorry!!!Smoething went wrong.Please try again later.";
                    ret.Message = "Sorry!!!Smoething went wrong.Please try again later.";
                }
            else
            {
                ret.IsSuccess = false;
                ret.Data = "Invalid File.";
                ret.Message = "Invalid File.";
            }
            return Json(ret);
        }
        [Route("GetGridData", Name = "GetGridData")]
        [HttpPost]
        public ActionResult GetGridData(string tableName, string ID, bool UID, int page, int pageSize, int skip, int take, List<SortDescription> sorting, FilterContainer filter)
        {
            Response ret = new Response();
            try
            {
                DataTable newDt = new DataTable();
                int from = skip + 1; //(page - 1) * pageSize + 1;
                int to = take * page; // page * pageSize;
                string sortingStr = "";
                int CreatedBy = 0;
                if (UID == true)
                    CreatedBy = ((User)Session["uBo"]).UID;

                #region Sorting
                if (sorting != null)
                {
                    if (sorting.Count != 0)
                    {
                        for (int i = 0; i < sorting.Count; i++)
                        {
                            sortingStr += ", " + sorting[i].field + " " + sorting[i].dir;
                        }
                    }
                }
                #endregion
                #region filtering
                string filters = "";
                string logic;
                string condition = "";
                int c = 1;
                if (filter != null)
                {
                    for (int i = 0; i < filter.filters.Count; i++)
                    {
                        logic = filter.logic;
                        if (filter.filters[i].@operator == "eq")
                        {
                            condition = " = '" + filter.filters[i].value + "' ";
                        }
                        if (filter.filters[i].@operator == "neq")
                        {
                            condition = " != '" + filter.filters[i].value + "' ";
                        }
                        if (filter.filters[i].@operator == "startswith")
                        {
                            condition = " Like '" + filter.filters[i].value + "%' ";
                        }
                        if (filter.filters[i].@operator == "contains")
                        {
                            condition = " Like '%" + filter.filters[i].value + "%' ";
                        }
                        if (filter.filters[i].@operator == "doesnotcontains")
                        {
                            condition = " Not Like '%" + filter.filters[i].value + "%' ";
                        }
                        if (filter.filters[i].@operator == "endswith")
                        {
                            condition = " Like '%" + filter.filters[i].value + "' ";
                        }
                        if (filter.filters[i].@operator == "gte")
                        {
                            condition = " >= '" + filter.filters[i].value + "' ";
                        }
                        if (filter.filters[i].@operator == "gt")
                        {
                            condition = " > '" + filter.filters[i].value + "' ";
                        }
                        if (filter.filters[i].@operator == "lte")
                        {
                            condition = " <= '" + filter.filters[i].value + "' ";
                        }
                        if (filter.filters[i].@operator == "lt")
                        {
                            condition = "< '" + filter.filters[i].value + "' ";
                        }
                        filters += filter.filters[i].field + condition;
                        if (filter.filters.Count > c)
                        {
                            filters += logic;
                            filters += " ";
                        }
                        c++;
                    }


                }
                #endregion
                sortingStr = sortingStr.TrimStart(',');
                Dictionary<int, DataTable> dt = UtilsRepo.GetGridData(tableName, ID, CreatedBy, from, to, sortingStr, filters);
                newDt = dt.First().Value;

                string data = ConvertJson.ConvertTable(newDt);

                ret.IsSuccess = true;
                ret.Data = "{\"Data\":" + data + ",\"Total\":" + dt.First().Key + "}";
                ret.Message = "success";

            }
            catch (Exception ex)
            {
                ret.IsSuccess = true;
                ret.Data = "{\"Data\":[],\"Total\":" + 0 + "}";
            }
            return Json(ret);
        }
    }
    
}