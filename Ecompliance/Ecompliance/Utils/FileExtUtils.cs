using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Ecompliance.Utils
{
    public static class FileExtUtils
    { 
        public static bool checkFileExt(string ext)
        {
            List<string> lstExt = new List<string> { ".jpg", ".jpeg", ".pdf", ".csv", ".bmp", ".icon", ".png", ".dbx", ".pps", ".pub", ".doc", ".docx", ".dot", "", ".text", ".txt", ".xls", ".xlsx", ".xlsm", ".zip", ".rar" };
            try
            {
                if (lstExt.Exists(p => p.Equals(ext)))
                    return true;
                else
                    return false;
            }
            catch
            { throw; }
        }
    }
}