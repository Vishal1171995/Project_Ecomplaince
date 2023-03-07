using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using Ecompliance.Utils;
using Ecompliance.Areas.Master.Models;
using Ecompliance.Areas.Admin.Models;
using System.ComponentModel.DataAnnotations;
using System.IO;
using System.Net;
using System.Text;
namespace Ecompliance.Repository
{
    public class SiteRepo
    {
        public DataSet GetSite(Site obj, int From=1, int To=1299, string SortingStr="", string FilterStr="")
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@SiteID", obj.SiteID),
                    new SqlParameter("@IsAct", obj.IsAct),
                    new SqlParameter("@CompanyID", obj.Company),
                    new SqlParameter("@CustID", obj.Customer),
                    new SqlParameter("@StateID", obj.State),
                    new SqlParameter("@LocationID", obj.Location),
                    new SqlParameter("@Name", obj.Name),
                     new SqlParameter("@UID",obj.UID ),
                       new SqlParameter("@FromNumber",From),
                    new SqlParameter("@ToNumber",To),
                    new SqlParameter("@SQLSortString",SortingStr),
                    new SqlParameter("@SQLFilterString",FilterStr)

                };
                return DataLib.ExecuteDataSet("GetSite13", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }


        public DataSet GetSiteHistory(Site obj)
        {
            try
            {
                SqlParameter[] p ={new SqlParameter("@SiteID", obj.SiteID)};
                return DataLib.ExecuteDataSet("GetSiteHistory", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }
        public DataSet GetState(int StateID, int IsAct = 0, string Name = "")
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@StateID", StateID),
                    new SqlParameter("@IsAct", IsAct),
                    new SqlParameter("@Name", Name),
                };
                return DataLib.ExecuteDataSet("GetState", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }

        public DataSet GetUser()
        {
            try
            {
                SqlParameter[] p = null;
                return DataLib.ExecuteDataSet("SELECT UID,User_Name FROM Ecom_Mst_User", CommandType.Text, p);
            }
            catch { throw; }
        }
        public string AddUpdateSite(Site obj)
        {
            try
            {
                SqlParameter[] p =
                {
                    new SqlParameter("@SiteID", obj.SiteID),
                    new SqlParameter("@Company", obj.Company),
                    new SqlParameter("@Customer", obj.Customer),
                    new SqlParameter("@Name", obj.Name) ,
                    new SqlParameter("@Site_Code", obj.SiteCode) ,
                    new SqlParameter("@State", obj.State),
                    new SqlParameter("@Location", obj.Location),
                     new SqlParameter("@Contact_Person", obj.Contact_Person),
                    new SqlParameter("@Contact_Number", obj.Contact_Number),
                    new SqlParameter("@Address", obj.Address),
                    new SqlParameter("@Maker", obj.Maker),
                    new SqlParameter("@Checker", obj.Checker),
                     new SqlParameter("@Maker2", obj.Maker2),
                    new SqlParameter("@Checker2", obj.Checker2),
                     new SqlParameter("@Auditor1", obj.Auditor1),
                    new SqlParameter("@Auditor2", obj.Auditor2),
                    new SqlParameter("@LatLong", obj.LatLong),
                    new SqlParameter("@PlaceID", obj.PlaceID),
                    new SqlParameter("@IsAct", obj.IsAct),
                    new SqlParameter("@UID", obj.CreatedBy)
                };
                return DataLib.ExecuteScaler("AddUpdateSite12", CommandType.StoredProcedure, p);
            }
            catch{ throw; }
        }

        public string DownLoadSite(Site model)
        {
            DataTable dt = new DataTable();
            string filename = "";
            try
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@SiteID", model.SiteID),
                    new SqlParameter("@IsAct", model.IsAct),
                    new SqlParameter("@CompanyID", model.Company),
                    new SqlParameter("@CustID", model.Customer),
                    new SqlParameter("@StateID", model.State)
                };

                dt = DataLib.ExecuteDataTable("[GetSite]", CommandType.StoredProcedure, parameters);
                filename = CSVUtills.DataTableToCSV(dt, ",");
                return filename;
            }
            catch { throw; }

        }
        public bool CheckColumnFormatSite(string FilePath, string SampleFilePath)
        {
            bool ret = true;
            try
            {
                DataTable dt = CSVUtills.CSVToDataTable(SampleFilePath, ',');
                DataTable dt2 = CSVUtills.CSVHeaderToDataTable(FilePath, ',');

                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    if (!(dt2.Columns.Contains(dt.Columns[i].ColumnName)))
                    {
                        ret = false;
                        return ret;
                    }
                }
            }
            catch { throw; }
            return ret;
        }

        public DataSet GetSiteSnapShort()
        {
            try
            {
                SqlParameter[] p = null;
                return DataLib.ExecuteDataSet("GetSiteSnapShort", CommandType.StoredProcedure, p);
            }
            catch { throw; }
        }


        public string UploadSite(string FilePath, string SampleFilePath, int CreatedBy, ref int SuccessCount, ref int FailCount)
        {
            try
            {
                //string FilePath = HostingEnvironment.MapPath("~/Docs/Temp/") + filename;  
                //Convert csv file into DataTable
                DataTable dt = null;
                try
                {
                    dt = CSVUtills.CSVToDataTable(FilePath, ',');
                }
                catch (Exception Ex)
                {
                    return Ex.Message;
                }

                if (!CheckColumnFormatSite(FilePath, SampleFilePath))
                {
                    return "Invalid File Format";
                }
                dt.Columns.Add("Response");
                dt.Columns.Add("Message");
                SiteRepo objsiterep = new SiteRepo();
                Site Model;
                SiteVM VM;
                string strerr = "";
                CustomerRepo objCustomerRep = new CustomerRepo();
                Customer MdlCustomer;
                CompanyRepo objCompanyRep = new CompanyRepo();
                Company MdlCompany;
                UserRepo objuserrepo = new UserRepo();
                User MdlUser;

                LocationRepo LocRepo = new LocationRepo();
                Location MdlLoc = new Location();
 
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    //Only checking Required validation using View Model
                    try
                    {
                        VM = new SiteVM();
                        var vartest=dt.Rows[i]["SiteID"].ToString().Replace("\"", "");
                        VM.SiteID = Convert.ToInt32((dt.Rows[i]["SiteID"]).ToString().Replace("\"", ""));
                        //   VM.Month = GetMonthfromMonthNm(Convert.ToString(dt.Rows[i]["Month"]).Replace("\"", ""));
                        VM.Company = Convert.ToString(dt.Rows[i]["Company"]).Replace("\"", "").Trim();
                        VM.Customer = Convert.ToString(dt.Rows[i]["Customer"]).Replace("\"", "").Trim();

                        VM.Address = Convert.ToString(dt.Rows[i]["Address"]).Replace("\"", "").Trim();
                        VM.Name = Convert.ToString(dt.Rows[i]["Name"]).Replace("\"", "").Trim();
                        VM.State = Convert.ToString(dt.Rows[i]["State"]).Replace("\"", "").Trim();
                        VM.Location = Convert.ToString(dt.Rows[i]["Location"]).Replace("\"", "").Trim();
                        VM.Customer = dt.Rows[i]["Customer"].ToString().Replace("\"", "").Trim();
                        VM.Contact_Person = dt.Rows[i]["Contact_Person"].ToString().Replace("\"", "").Trim();
                        VM.Contact_Number = (dt.Rows[i]["Contact_Number"]).ToString().Replace("\"", "").Trim();
                        VM.SiteCode = (dt.Rows[i]["SiteCode"]).ToString().Replace("\"", "").Trim();
                       
                        VM.Maker = (dt.Rows[i]["Maker1"]).ToString().Replace("\"", "").Trim();
                        VM.Checker = (dt.Rows[i]["Checker1"]).ToString().Replace("\"", "").Trim();
                        VM.Maker2 = (dt.Rows[i]["Maker2"]).ToString().Replace("\"", "").Trim();
                        VM.Checker2 = (dt.Rows[i]["Checker2"]).ToString().Replace("\"", "").Trim();
                        VM.Auditor1 = (dt.Rows[i]["Auditor1"]).ToString().Replace("\"", "").Trim();
                        VM.Auditor2 = (dt.Rows[i]["Auditor2"]).ToString().Replace("\"", "").Trim();
                        VM.IsAct = Convert.ToBoolean(dt.Rows[i]["Status"].ToString().Replace("\"", "") == "1" ? true : false);
                        VM.CreatedBy = CreatedBy;

                        var results = new List<ValidationResult>();
                        var vc = new ValidationContext(VM, null, null);
                        var isValid = Validator.TryValidateObject(VM, vc, results,true);
                        var errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                        strerr = string.Join(" ", errors);
                        if (isValid)
                        {
                            Model = new Site();
                            Model.SiteID = Convert.ToInt32((dt.Rows[i]["SiteID"]).ToString().Replace("\"", ""));

                            //Getting CustomerId from DataBase
                            MdlCustomer = new Customer();
                            MdlCustomer.Name = VM.Customer.Trim().Replace("''","'");
                            MdlCustomer.IsAct = true;
                            MdlCustomer.CustID = 0;
                            MdlCustomer.UID = CreatedBy;
                            DataTable dtCustomer = (objCustomerRep.GetCustomer(MdlCustomer)).Tables[0];
                            if (dtCustomer.Rows.Count > 0)
                            {
                                Model.Customer = dtCustomer.Rows[0]["CustID"].ToString().Replace("\"", "");
                            }
                            else
                            {
                                Model.Customer = "-1";
                            }
                            //Getting CompanyId from DataBase
                            MdlCompany = new Company();
                            MdlCompany.Name = VM.Company.Replace("''", "'"); ;
                            MdlCompany.IsAct = true;
                            MdlCompany.CompanyID = 0;
                            MdlCompany.UID = CreatedBy;
                            MdlCompany.Customer = Convert.ToInt32(Model.Customer);
                            DataTable dtCompany = (objCompanyRep.GetCompanyList(MdlCompany));
                            if (dtCompany.Rows.Count > 0)
                            {
                                Model.Company = dtCompany.Rows[0]["CompID"].ToString().Replace("\"", "");
                            }
                            else
                            {
                                Model.Company = "-1";
                            }
                            //Getting StateID from Db
                            string State = (dt.Rows[i]["State"]).ToString().Replace("\"", "").Trim().Replace("''", "'"); ;
                            DataTable dtState = (objsiterep.GetState(0, 1, State)).Tables[0];
                            if (dtState.Rows.Count > 0)
                            {
                                Model.State = dtState.Rows[0]["StateID"].ToString().Replace("\"", "");
                            }
                            else
                            {
                                Model.State = "-1";
                            }

                            //Getting Location from db
                            if (!string.IsNullOrEmpty(VM.Location))
                            {
                                MdlLoc = new Location();

                                MdlLoc.LocationID = 0;
                                MdlLoc.IsAct = true;
                                MdlLoc.State = Convert.ToInt32(Model.State);
                                MdlLoc.Name = VM.Location.Replace("''", "'"); ;
                                MdlLoc.UID = ((User)HttpContext.Current.Session["uBo"]).UID;
                                DataTable dtLocation = LocRepo.GetLocation(MdlLoc).Tables[0];
                                if (dtLocation.Rows.Count > 0)
                                {
                                    Model.Location = dtLocation.Rows[0]["LocationID"].ToString();
                                }
                                else
                                {
                                    Model.Location = "-1";
                                }
                            }
                            else
                            {
                                Model.Location = "0";
                            }
                            MdlUser = new User();
                            //MdlUser.User_Name = VM.Maker;
                            MdlUser.Company = 0;
                            MdlUser.Contractor = 0;
                            MdlUser.IsAuth = 1;
                            MdlUser.UID = 0;
                            MdlUser.UserID = CreatedBy;
                            //Now Getting MakerID1 (UID) From DataBase
                            if (!string.IsNullOrEmpty(VM.Maker))
                            {
                                MdlUser.User_Name = VM.Maker;

                                DataTable dtUser = (objuserrepo.GetUser(MdlUser));
                                if (dtUser.Rows.Count > 0)
                                {
                                    Model.Maker = Convert.ToInt32(dtUser.Rows[0]["UID"].ToString().Replace("\"", ""));
                                }
                                else
                                {
                                    Model.Maker = -1;
                                }
                            }
                            else
                            {
                                Model.Maker = 0;
                            }


                            //Now Getting MakerID2 (UID) From DataBase
                            if (!string.IsNullOrEmpty(VM.Maker2))
                            {
                                MdlUser.User_Name = VM.Maker2;

                                DataTable dtUser = (objuserrepo.GetUser(MdlUser));
                                if (dtUser.Rows.Count > 0)
                                {
                                    Model.Maker2 = Convert.ToInt32(dtUser.Rows[0]["UID"].ToString().Replace("\"", ""));
                                }
                                else
                                {
                                    Model.Maker2 = -1;
                                }
                            }
                            else
                            {
                                Model.Maker2 = 0;
                            }

                            //Now Getting CheckerID (UID) From DataBase
                            if (!string.IsNullOrEmpty(VM.Checker))
                            {
                                MdlUser.User_Name = VM.Checker;
                               
                                DataTable dtchecker = (objuserrepo.GetUser(MdlUser));
                                if (dtchecker.Rows.Count > 0)
                                {
                                    Model.Checker =  Convert.ToInt32(dtchecker.Rows[0]["UID"].ToString().Replace("\"", ""));
                                }
                                else
                                {
                                    Model.Checker = -1;
                                }
                            }
                            else
                            {
                                Model.Checker = 0;
                            }


                            //Now Getting CheckerID2 (UID) From DataBase
                            if (!string.IsNullOrEmpty(VM.Checker2))
                            {
                                MdlUser.User_Name = VM.Checker2;

                                DataTable dtchecker2 = (objuserrepo.GetUser(MdlUser));
                                if (dtchecker2.Rows.Count > 0)
                                {
                                    Model.Checker2 = Convert.ToInt32(dtchecker2.Rows[0]["UID"].ToString().Replace("\"", ""));
                                }
                                else
                                {
                                    Model.Checker2 = -1;
                                }
                            }
                            else
                            {
                                Model.Checker2 = 0;
                            }



                            //Now Getting AuditorID1 (UID) From DataBase
                            if (!string.IsNullOrEmpty(VM.Auditor1))
                            {
                                MdlUser.User_Name = VM.Auditor1;

                                DataTable dtAuditor1 = (objuserrepo.GetUser(MdlUser));
                                if (dtAuditor1.Rows.Count > 0)
                                {
                                    Model.Auditor1 = Convert.ToInt32(dtAuditor1.Rows[0]["UID"].ToString().Replace("\"", ""));
                                }
                                else
                                {
                                    Model.Auditor1 = -1;
                                }
                            }
                            else
                            {
                                Model.Auditor1 = 0;
                            }

                            //Now Getting AuditorID2 (UID) From DataBase
                            if (!string.IsNullOrEmpty(VM.Auditor2))
                            {
                                MdlUser.User_Name = VM.Auditor2;

                                DataTable dtAuditor2 = (objuserrepo.GetUser(MdlUser));
                                if (dtAuditor2.Rows.Count > 0)
                                {
                                    Model.Auditor2 = Convert.ToInt32(dtAuditor2.Rows[0]["UID"].ToString().Replace("\"", ""));
                                }
                                else
                                {
                                    Model.Auditor2 = -1;
                                }
                            }
                            else
                            {
                                Model.Auditor2 = 0;
                            }
                            Model.Name = VM.Name;
                            Model.SiteCode = VM.SiteCode;
                           
                            Model.Address = VM.Address;
                            Model.Contact_Person = VM.Contact_Person;
                            Model.Contact_Number = VM.Contact_Number;
                          
                            Model.IsAct = VM.IsAct;
                            Model.CreatedBy = VM.CreatedBy;

                            results = new List<ValidationResult>();
                            vc = new ValidationContext(Model, null, null);
                            isValid = Validator.TryValidateObject(Model, vc, results,true);
                            errors = Array.ConvertAll(results.ToArray(), o => o.ErrorMessage);
                            strerr = string.Join(" ", errors);
                            if (isValid)
                            {
                                if (Model.Address != "")
                                {
                                    DataTable dtLatLong = new DataTable();
                                    try
                                    {
                                        dtLatLong = GetdtLatLong(Model.Address);
                                        if (dtLatLong.Rows.Count > 0)
                                        {
                                            Model.LatLong = dtLatLong.Rows[0]["Latitude"].ToString() + " ," + dtLatLong.Rows[0]["Longitude"].ToString();
                                            Model.PlaceID = dtLatLong.Rows[0]["PlaceID"].ToString();
                                        }
                                    }
                                    catch
                                    {
                                        Model.LatLong = "";
                                        Model.PlaceID = "";
                                    }
                                }
                                int Result = Convert.ToInt32(AddUpdateSite(Model));
                                if (Result >= 0)
                                {
                                    SuccessCount += 1;
                                    dt.Rows[i]["Response"] = "Success";
                                }
                                else
                                {
                                    FailCount += 1;
                                    if (Result == -1)
                                    {
                                        dt.Rows[i]["Message"] = "Duplicate";
                                    }
                                    dt.Rows[i]["Response"] = "Failed";
                                }
                            }
                            else
                            {
                                FailCount += 1;
                                dt.Rows[i]["Response"] = strerr;
                            }
                        }
                        else
                        {
                            FailCount += 1;
                            dt.Rows[i]["Response"] = "Failed";
                            dt.Rows[i]["Message"] = strerr;
                            //Message
                        }
                    }
                    catch
                    {
                        FailCount += 1;
                        dt.Rows[i]["Response"] = "Failed";
                        dt.Rows[i]["Message"] = "Invalid Data Format";
                        continue;
                    }
                }
                //Converting dt into csv FIle
                FilePath = CSVUtills.DataTableToCSV(dt, ",");
                return FilePath;
            }
            catch
            {
                throw;
            }
        }
        public DataTable GetdtLatLong(string strAddress)
        {
            DataTable dtGMap = null;
            String url = "http://maps.google.com/maps/api/geocode/xml?address=" + strAddress + "&sensor=false";
            try
            {
                WebRequest request = WebRequest.Create(url);
                using (WebResponse response = (HttpWebResponse)request.GetResponse())
                {
                    using (StreamReader reader = new StreamReader(response.GetResponseStream(), Encoding.UTF8))
                    {
                        DataSet dsResult = new DataSet();
                        dsResult.ReadXml(reader);
                        DataTable dtCoordinates = new DataTable();
                        dtCoordinates.Columns.AddRange(new DataColumn[5] { new DataColumn("Id", typeof(int)),
                    new DataColumn("Address", typeof(string)),
                    new DataColumn("Latitude",typeof(string)),
                    new DataColumn("Longitude",typeof(string)),
                    new DataColumn("PlaceID",typeof(string)) 
                    });
                        if (dsResult.Tables["GeocodeResponse"].Rows[0]["status"].ToString().ToUpper().Trim() != "ZERO_RESULTS")
                        {
                            foreach (DataRow row in dsResult.Tables["result"].Rows)
                            {
                                string geometry_id = dsResult.Tables["geometry"].Select("result_id = " + row["result_id"].ToString())[0]["geometry_id"].ToString();
                                DataRow location = dsResult.Tables["location"].Select("geometry_id = " + geometry_id)[0];
                                dtCoordinates.Rows.Add(row["result_id"], row["formatted_address"], location["lat"], location["lng"], row["place_id"]);
                            }
                        }
                        dtGMap = dtCoordinates;
                        return dtGMap;
                    }
                }
            }
            catch { throw; }
        }

        #region Grid Sort And Filter
        public string sortGrid(List<SortDescription> sorting)
        {
            string sortingStr = "";
            try
            {
                if (sorting != null)
                {
                    if (sorting.Count != 0)
                    {
                        for (int i = 0; i < sorting.Count; i++)
                        {
                            if (sorting[i].field == "Name") sorting[i].field = "MS.Name";
                            if (sorting[i].field == "CompanyText") sorting[i].field = "MC.Name";
                            if (sorting[i].field == "CustomerText") sorting[i].field = "MCust.Name";
                            if (sorting[i].field == "MakerText") sorting[i].field = "MU.User_Name";
                            if (sorting[i].field == "Checker") sorting[i].field = "Chekcer.User_Name";

                          

                            sortingStr += ", " + sorting[i].field + " " + sorting[i].dir;
                        }
                    }
                }
                return sortingStr;
            }
            catch
            {
                throw;
            }
        }

        public string FilterGrid(FilterContainer filter)
        {
            string filters = "";
            string logic;
            string condition = "";
            try
            {

                int c = 1;
                if (filter != null)
                {
                    for (int i = 0; i < filter.filters.Count; i++)
                    {
                        logic = filter.logic;

                        //filter.filters[i].field
                        if (filter.filters[i].field == "Name") filter.filters[i].field = "MS.Name";
                        if (filter.filters[i].field == "CompanyText") filter.filters[i].field = "MC.Name";
                        if (filter.filters[i].field == "CustomerText") filter.filters[i].field = "MCust.Name";
                        if (filter.filters[i].field == "MakerText") filter.filters[i].field = "MU.User_Name";
                        if (filter.filters[i].field == "CheckerText") filter.filters[i].field = "Checker.User_Name";
                        if (filter.filters[i].field == "IsActText") filter.filters[i].field = "(CASE WHEN MS.IsAct =1 THEN 'Active' ELSE 'IN Active' END)";



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
                return filters;
            }
            catch
            {
                throw;
            }
        }

        #endregion
        //vivek
        public DataTable GetSiteByCompany(int StateID, int LocationID, int CompanyID)
        {

            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]{
                    new SqlParameter("@StateID",StateID),
                    new SqlParameter("@LocationID",LocationID ),
                    new SqlParameter("@CompanyID",CompanyID)
                };

                return DataLib.ExecuteDataTable("[GetSiteByCompany]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }

        }

        //Vishal
        public DataTable GetBindSite(int CompanyID)
        {

            DataTable dt = new DataTable();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]{
                    new SqlParameter("@CompanyID",CompanyID),
                };

                return DataLib.ExecuteDataTable("[GetSiteForMaster_new]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }

        }

        public DataSet GetBindSiteForMaster(int SiteId,int NewSiteID)
        {

            DataSet ds = new DataSet();
            try
            {
                SqlParameter[] parameters = new SqlParameter[]{
                    new SqlParameter("@SiteID",SiteId),
                    new SqlParameter("@NewSiteID",NewSiteID),

                };

                return DataLib.ExecuteDataSet("[GetSiteForMasterOnChange]", CommandType.StoredProcedure, parameters);
            }
            catch
            {
                throw;
            }

        }
        //AddMappingSite
        public Response AddMappingSite(string MappingID, int SiteID, int CompanyID, int MappingCount)
        {
            int Result = 0;
            IEnumerable<string> MappingList =
      !string.IsNullOrEmpty(MappingID) ? MappingID.Split(',') : Enumerable.Empty<string>();
           
            DataTable dt = new DataTable();
            Response res = new Response();
            try
            {
                int Flag = 1;
                if (MappingCount > 0)
                {
                    foreach (var item in MappingList)
                    {
                        SqlParameter[] parameters = new SqlParameter[]{
                    new SqlParameter("@MappingID",item),
                     new SqlParameter("@SiteID",SiteID),
                     new SqlParameter("@CompanyID",CompanyID),
                      new SqlParameter("@Flag",Flag),

                };
                        Result= Convert.ToInt32(DataLib.ExecuteScaler("AddMappingAndSiteID", CommandType.StoredProcedure, parameters));
                        Flag++;
                    }
                    
                }
                else
                {
                    SqlParameter[] parameters = new SqlParameter[]{
                    new SqlParameter("@MappingID",MappingID),
                     new SqlParameter("@CompanyID",CompanyID),
                     new SqlParameter("@SiteID",SiteID),
                      new SqlParameter("@Flag",Flag),

                };
                    Result= Convert.ToInt32(DataLib.ExecuteScaler("AddMappingAndSiteID", CommandType.StoredProcedure, parameters));
                }
                if (Result >= 1)
                {
                    res.IsSuccess = true;
                }
                else
                {
                    res.IsSuccess = false;
                }
                return res;
            }
            catch
            {
                throw;
            }

        }
    }
}