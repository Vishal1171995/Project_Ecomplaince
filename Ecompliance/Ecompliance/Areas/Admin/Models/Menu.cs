using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Ecompliance.Areas.Admin.Models
{
    public class Menu
    {
        public int MenuID { get; set; }
        public string Name { get; set; }
        public bool IsAct { get; set; }
        public string Role { get; set; }
    }
}