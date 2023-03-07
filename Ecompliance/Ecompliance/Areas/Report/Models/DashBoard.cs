using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Ecompliance.Areas.Report.Models
{
    public class DashBoard
    {
        public int Company { get; set; }
        public SelectList CompanyList
        {
            get;
            set;
        }

        public string companydefault { get; set; }

    }
}