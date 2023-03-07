using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Ecompliance.Areas.FileExplorer.Models
{
    public class FileMetaData
    {
       
            public int? FileMetaID { get; set; }
            [Required]
            [Range(1, int.MaxValue, ErrorMessage = "Please select Customer")]
            public int CustomerID { get; set; }
            public string Description { get; set; }
            public string MetaData { get; set; }
            [Required(ErrorMessage = "Please Enter File type.")]
            public string FileTypeName { get; set; }

            [Required]
            public int CreatedBy { set; get; }
            public SelectList CustomerList
            {
                get;
                set;
            }
        
    }
}