using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Ecompliance.Areas.ACT2.Models
{
    public class FileManager
    {
        //public string text { get; set; }
        //public string Child { get; set; }
        //public string type = "customer";
        //public bool hasChildren { get; set; }
        //public string LocationName { get; set; }
        //public string ParentId { get; set; }
        //public bool expanded { get; set; }
        //public string spriteCssClass = "folder";

      
    }
    public class DirModel
    {
        public string DirName { get; set; }
        public DateTime DirAccessed { get; set; }
    }

    public class FileModel
    {
        public string FileName { get; set; }
        public string FileSizeText { get; set; }
        public DateTime FileAccessed { get; set; }
    }

    public class ChildDirModel
    {
        public string ChildDirName { get; set; }
        public string ParentDirName { get; set; }
        public string DirPath { get; set; }
    }

    public class ExplorerModel
    {
        public List<DirModel> dirModelList;
      //  public List<FileModel> fileModelList;
        public List<ChildDirModel> ChildDirList;

        public ExplorerModel(List<DirModel> _dirModelList, List<ChildDirModel> _ChildDirList)
        {
            dirModelList = _dirModelList;
            ChildDirList = _ChildDirList;
        }
    }
}