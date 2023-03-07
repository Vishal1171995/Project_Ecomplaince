using System.Web;
using System.Web.Optimization;

namespace Ecompliance
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {


            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.

            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/bndlTask").Include(
                "~/Scripts/CustomScript/Taskjs.js"
                ));
            bundles.Add(new ScriptBundle("~/bundles/bndlAllAlerts").Include(
                "~/Scripts/CustomScript/AllAlertsjs.js"
                ));

            bundles.Add(new ScriptBundle("~/bundles/bndAllReportDataHeader").Include(
               "~/Scripts/CustomScript/ReportDataHeder.js"));
            bundles.Add(new ScriptBundle("~/bundles/bndlTaskDetails").Include(
                "~/Scripts/CustomScript/TaskDetailsjs.js"
                ));
            bundles.Add(new ScriptBundle("~/bundles/bndlViewTasks").Include(
                "~/Scripts/CustomScript/ViewTaskjs.js"
                ));
            bundles.Add(new ScriptBundle("~/bundles/bndlMyAsNeeded").Include(
                "~/Scripts/CustomScript/MyAsNeededjs.js"
                ));
            bundles.Add(new ScriptBundle("~/bundles/bndlViewAsNeeded").Include(
                "~/Scripts/CustomScript/ViewAsNeededjs.js"
                ));
            bundles.Add(new ScriptBundle("~/bundles/bndlAsneededDetails").Include(
                "~/Scripts/CustomScript/AsneededDetailsjs.js"
                ));
            bundles.Add(new ScriptBundle("~/bundles/bndlMakerBulkApproval").Include(
                "~/Scripts/CustomScript/MakerBulkApprovaljs.js"
                ));

            var bundle = (new StyleBundle("~/Content/logincss")
                       .Include(
                               "~/Content/css/bootstrap.css",
                               "~/Content/css/bootstrap.min.css",
                               "~/Content/css/font-awesome.min.css",
                               "~/Content/css/style-metro.css",
                               "~/Content/css/mainstyle.css",
                               "~/Content/css/uniform.default.css",
                               "~/Content/css/login.css",
                               "~/Content/css/style.css",
                               "~/Content/css/jquery-ui.css"
                           )
                       );
            bundle.Orderer = new NonOrderingBundleOrderer();
            bundles.Add(bundle);

            var CommanCss = (new StyleBundle("~/Content/CommanCss")
                           .Include(
                                   "~/Content/css/bootstrap.min.css",
                                   "~/Content/css/jquery-ui.css",
                                   "~/Content/css/style.css",
                                   "~/MyKendu/styles/kendo.common.min.css",
                                   "~/MyKendu/styles/kendo.rtl.min.css",
                                   "~/MyKendu/styles/kendo.default.min.css",
                                   "~/MyKendu/styles/kendo.dataviz.min.css",
                                   "~/MyKendu/styles/kendo.dataviz.default.min.css",
                                   "~/Content/css/Kendu.css"
                               )
                           );
            CommanCss.Orderer = new NonOrderingBundleOrderer();
            bundles.Add(CommanCss);

            var LoginScript = (new ScriptBundle("~/Content/LoginScript")
                    .Include(
                        "~/Scripts/jquery/external/jquery/jquery.js",
                        "~/Scripts/jquery/jquery-ui.min.js",
                        "~/Scripts/jquery.unobtrusive*",
                        "~/Scripts/jquery.validate*",
                        "~/Content/js/Utils.js"
                    )
                );
            LoginScript.Orderer = new NonOrderingBundleOrderer();
            bundles.Add(LoginScript);

            var CommanScript = (new ScriptBundle("~/Content/CommanScript")
                                .Include(
                                       "~/Scripts/jquery/external/jquery/jquery.js",
                                       "~/Content/js/bootstrap.min.js",
                                       "~/Scripts/jquery/jquery-ui.min.js",
                                       "~/Scripts/jquery.unobtrusive*",
                                       "~/Scripts/jquery.validate*",
                                       "~/Content/js/Utils.js",
                                       "~/Content/js/enscroll-0.6.2.min.js",
                                       "~/MyKendu/js/jszip.min.js",
                                       "~/MyKendu/js/kendo.all.min.js",
                                       "~/MyKendu/js/kendo.window.min.js",
                                       "~/MyKendu/content/shared/js/console.js"
                                    )
                                );
            CommanScript.Orderer = new NonOrderingBundleOrderer();
            bundles.Add(CommanScript);

            bundles.Add(new ScriptBundle("~/bundles/bndlacts").Include(
                   "~/Areas/Master/script/Actjs.js"
                   ));
            bundles.Add(new ScriptBundle("~/bundles/bndlactivity").Include(
                  "~/Areas/Master/script/activityjs.js"
                  ));

            bundles.Add(new ScriptBundle("~/bundles/bndlacompany").Include(
                 "~/Areas/Master/script/Companyjs.js"
                 ));

            bundles.Add(new ScriptBundle("~/bundles/bndlContractors").Include(
                "~/Areas/Master/script/Contractorsjs.js"
                ));

            bundles.Add(new ScriptBundle("~/bundles/bndlCustomer").Include(
                "~/Areas/Master/script/Customerjs.js"
                ));

            bundles.Add(new ScriptBundle("~/bundles/bndlFrequency").Include(
                "~/Areas/Master/script/Frequencyjs.js"
                ));

            bundles.Add(new ScriptBundle("~/bundles/bndlMapping").Include(
                "~/Areas/Master/script/Mappingjs.js"
                ));

            bundles.Add(new ScriptBundle("~/bundles/bndlSite").Include(
                "~/Areas/Master/script/Sitejs.js"
                ));

            bundles.Add(new ScriptBundle("~/bundles/bndlMappingpe").Include(
                "~/Areas/Master/script/Mappingpejs.js"
                ));

            bundles.Add(new ScriptBundle("~/bundles/bndlState").Include(
               "~/Areas/Master/script/Statejs.js"
               ));
            bundles.Add(new ScriptBundle("~/bundles/bndlLocation").Include(
                "~/Areas/Master/script/Locationjs.js"
                ));

            bundles.Add(new ScriptBundle("~/bundles/bndlActScheduled").Include(
              "~/Areas/Report/script/ActScheduledjs.js"
              ));

            bundles.Add(new ScriptBundle("~/bundles/bndlMonthlyScheduled").Include(
              "~/Areas/Report/script/MonthlyScheduledjs.js"
              ));

            bundles.Add(new ScriptBundle("~/bundles/bndlMyTask").Include(
              "~/Areas/Report/script/MyTaskjs.js"
              ));

            bundles.Add(new ScriptBundle("~/bundles/bndlScoreCard").Include(
             "~/Areas/Report/script/ScoreCardjs.js"
             ));
            bundles.Add(new ScriptBundle("~/bundles/bndlLogUser").Include(
             "~/Areas/Report/script/LogUserjs.js"
             ));
            bundles.Add(new ScriptBundle("~/bundles/bndlDashBoard").Include(
             "~/Areas/Report/script/DashBoardjs.js"
             ));
            bundles.Add(new ScriptBundle("~/bundles/bndlStartDateComp").Include(
             "~/Areas/Report/script/StartDateCompjs.js"
             ));
            bundles.Add(new ScriptBundle("~/bundles/bndlSiteMapDashboard").Include(
             "~/Areas/Report/script/SiteMapDashboard.js"
             ));

            bundles.Add(new ScriptBundle("~/bundles/bndlFileMetaData").Include(
             "~/Areas/FileExplorer/script/FileMetaDatajs.js"
             ));

            bundles.Add(new ScriptBundle("~/bundles/bndlFileExplorer").Include(
            "~/Areas/FileExplorer/script/FileExplorerjs.js"
            ));
            bundles.Add(new ScriptBundle("~/bundles/bndlUser").Include(
            "~/Areas/Admin/script/Userjs.js"
            ));
            bundles.Add(new ScriptBundle("~/bundles/bndlCheckerDashboard").Include(
           "~/Areas/Report/script/CheckerDashboardjs.js"
           ));

            bundles.Add(new ScriptBundle("~/bundles/bndlTaskReconsilation").Include(
        "~/Areas/Report/script/TaskReconsilation.js"
        ));

            bundles.Add(new ScriptBundle("~/bundles/bndlUploadReport").Include(
                "~/Areas/ACT2/script/UploadReport.js"
                ));

            bundles.Add(new ScriptBundle("~/bundles/bndlScoreCard1").Include(
             "~/Areas/Report/script/ScoreCard1js.js"
             ));

            bundles.Add(new ScriptBundle("~/bundles/bndlAuditorScoreCard").Include(
             "~/Areas/Report/script/AuditorScoreCard.js"
             ));

            bundles.Add(new ScriptBundle("~/bundles/bndlSendToAuditor").Include(
             "~/Areas/Report/script/SendToAuditorjs.js"
             ));

            bundles.Add(new ScriptBundle("~/bundles/bndlAuditor").Include(
             "~/Areas/Report/script/Auditorjs.js"
             ));

            bundles.Add(new ScriptBundle("~/bundles/bndlCLRADashBoard").Include(
             "~/Areas/Report/script/CLRADashBoardjs.js"
             ));

            bundles.Add(new ScriptBundle("~/bundles/bndlCLRAMyTask").Include(
                          "~/Areas/Report/script/CLRAMyTaskjs.js"
                          ));

            bundles.Add(new ScriptBundle("~/bundles/bndlCLRASiteMapDashboard").Include(
                         "~/Areas/Report/script/CLRASiteMapDashboard.js"
                         ));


            //Mappingjs DashBoardjs AuditorScoreCard.js

        }
    }
}
