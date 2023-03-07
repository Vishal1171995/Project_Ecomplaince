using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Ecompliance.Areas.Report.Models
{
    public class MyTaskSortDescription
    {
        public string field { get; set; }
        public string dir { get; set; }
    }
    public class MyTaskFilterContainer
    {
        public List<MyTaskFilterDescription> filters { get; set; }
        public string logic { get; set; }
    }
    public class MyTaskFilterDescription
    {
        public string @operator { get; set; }
        public string field { get; set; }
        public string value { get; set; }
    }


}