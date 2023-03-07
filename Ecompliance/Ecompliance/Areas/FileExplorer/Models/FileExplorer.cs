using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Ecompliance.Areas.FileExplorer.Models
{
    public class FileExplorer
    {
        public string text { get; set; }
        public int id { get; set; }
        public string type = "customer";
        public bool hasChildren { get; set; }
        public int CustomerID { get; set; }
        public int ParentId { get; set; }
        public bool expanded { get; set; }
        public string spriteCssClass = "folder";
    }
}