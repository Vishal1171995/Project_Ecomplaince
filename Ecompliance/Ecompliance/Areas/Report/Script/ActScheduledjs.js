var EmptyCount = 0;

$(document).ready(function () {
    $("#menu_4").addClass("active-menu");
    $("#tabstrip").kendoTabStrip();
    $("#btnSearch").click(BindActScheduledGrid);

});


function BindActScheduledGrid() {
    var Comp = $("#ddlCompany").val();
    var Month = $("#ddlMonth").val();
    var Year = $("#ddlYear").val();
    if (Comp == 0) {
        alert("Please select Company");
        return;
    }
    if (Month == 0) {
        alert("Please select Month");
        return;
    }
    if (Year == 0) {
        alert("Please select Year");
        return;
    }
    EmptyCount = 0;
    BindPEGrid(Comp, Month, Year);
    BindContractorGrid(Comp, Month, Year);
    if (EmptyCount >= 2) {
        $("#dvReport").hide();
        $("#dvNoRecord").show();
    }
    else {
        $("#dvReport").show();
        $("#dvNoRecord").hide();
    }
}


function BindPEGrid(Comp, Month, Year) {


    $("#liCompany").show();
    // $("#mask").show();
    var str = { "CompanyID": Comp, "Month": Month, "Year": Year, "Type": "Company" };
    $.ajax({
        type: "GET",
        //GetScoreCardData
        url:GetActScheduledDataUrl,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: str,
        success: function (data) {
            if (data.IsSuccess == true) {
                var grid = $("#grid").data("kendoGrid");
                // detach events
                if (grid != undefined) {
                    grid.destroy(); // destroy the Grid
                    $("#grid").empty();
                }
                if (data.Data.length == 0) {
                    EmptyCount += 1;
                    return;

                }
                var StrData = $.parseJSON(data.Data);
                if (StrData.length == 0) {
                    $("#liCompany").hide();
                    $("#dvcomp").hide();
                    var tabToActivate = $("#liContractors");
                    $("#tabstrip").kendoTabStrip().data("kendoTabStrip").activateTab(tabToActivate);
                }
                else {

                    $("#liCompany").show();
                    $("#dvcomp").show();
                    var tabToActivate = $("#liCompany");
                    $("#tabstrip").kendoTabStrip().data("kendoTabStrip").activateTab(tabToActivate);
                }
                $("#grid").kendoGrid({
                    dataSource: {
                        data: StrData,
                        //pageSize: 100,
                        group: [{
                            field: "Company", aggregates: [
                              { field: "TotScheduled", aggregate: "sum" }, { field: "TotCreated", aggregate: "sum" }
                            ]
                        }, {
                            field: "Act", aggregates: [{ field: "TotScheduled", aggregate: "sum" },
                                { field: "TotCreated", aggregate: "sum" }
                            ]
                        }],
                        aggregate: [{ field: "TotScheduled", aggregate: "sum" },
                                 { field: "TotCreated", aggregate: "sum" },
                        ]
                    }
                ,
                    columns: [{
                        field: "Company",
                        title: "Company Name",
                        groupHeaderTemplate: "#= value#  :  (Total Scheduled on Company : #= aggregates.TotScheduled.sum# )  (Total Created : #=aggregates.TotCreated.sum#  )"

                    },

                           {
                               field: "Site",
                               title: "Site Name",

                           }
                           ,
                           {
                               field: "Act",
                               title: "Act",
                               groupHeaderTemplate: "Act: #= value# :  ( Total Scheduled on Act : #= aggregates.TotScheduled.sum# )   (Created : #=aggregates.TotCreated.sum# ) "

                           },

                           {
                               field: "TotScheduled",
                               title: "Total Scheduled",
                               template: '<span title="Click here to get details" style="text-decoration:underline;cursor:pointer;" onclick="ShowDetailsToBeCreated(\'#=CompanyID#\',\'#=SiteID#\',\'#=ActID#\',\'Scheduled\',\'#=Company#\',\'#=Site#\',\'#=Act#\');return false;" >#=TotScheduled#</span>'

                           },
                           {
                               field: "TotCreated",
                               title: "Created Till Date",
                               template: '<span title="Click here to get details" style="text-decoration:underline;cursor:pointer;" onclick="ShowDetails(\'#=CompanyID#\',\'#=SiteID#\',\'#=ActID#\',\'ScheduledCreated\',\'#=Company#\',\'#=Site#\',\'#=Act#\');return false;" >#=TotCreated#</span>'

                           }
                    ], dataBound: function (e) {
                        var grid = e.sender;
                        if (grid.dataSource.total() == 0) {
                            var colCount = grid.columns.length;
                            $(e.sender.wrapper)
                                .find('tbody')
                                .append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data"><span style="margin-left:46%;">No data found.</span></td></tr>');
                        }
                    },
                    height: 700,
                    scrollable: true,
                    resizable: true,
                    reorderable: true,
                    groupable: false,
                    filterable: true,
                    sortable: true,
                    toolbar: [{ name: "excel" }, { template: kendo.template($("#template").html()) },
                        { template: kendo.template($("#template1").html()) }
                    ],

                    excel: {
                        fileName: "Report_Company.xlsx",
                        filterable: true,
                        pageable: true,
                        allPages: true
                    },
                    ExpandAll: {},

                });


                collapseAll();
            }
            else { FailResponse(data); }
        },
        error: function (data) {
            alert("Something went wrong please try again later!.");
        }

    });




}

function BindContractorGrid(Comp, Month, Year) {



    //  $("#mask").show();
    var str = { "CompanyID": Comp, "Month": Month, "Year": Year, "Type": "As Needed" };
    $.ajax({
        type: "GET",
        url: GetActScheduledDataUrl,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: str,
        success: function (data) {
            if (data.IsSuccess == true) {
                var grid = $("#gridcontarctor").data("kendoGrid");
                // detach events
                if (grid != undefined) {
                    grid.destroy(); // destroy the Grid
                    $("#gridcontarctor").empty();
                }
                if (data.Data.length = 0)
                { EmptyCount += 1; }

                var StrData = $.parseJSON(data.Data);

                $("#gridcontarctor").kendoGrid({
                    dataSource: {
                        data: StrData,

                        group: [{
                            field: "Company", aggregates: [
                                { field: "TotCreated", aggregate: "sum" }
                            ]
                        }, {
                            field: "Act", aggregates: [
                                { field: "TotCreated", aggregate: "sum" }
                            ]
                        }],

                        aggregate: [
                            { field: "TotCreated", aggregate: "sum" },
                        ]
                    }
                , columns: [{
                    field: "Company",
                    title: "Company Name",
                    groupHeaderTemplate: "#= value# , Total Created : #=aggregates.TotCreated.sum#  "

                },

                           {
                               field: "Site",
                               title: "Site Name",

                           }
                           ,
                           {
                               field: "Act",
                               title: "Act",
                               groupHeaderTemplate: "Act: #= value# ,Created : #=aggregates.TotCreated.sum#  "

                           },

                           {
                               field: "TotCreated",
                               title: "Created",
                               template: '<span title="Click here to get details" style="text-decoration:underline;cursor:pointer;" onclick="ShowDetails(\'#=CompanyID#\',\'#=SiteID#\',\'#=ActID#\',\'As Needed\',\'#=Company#\',\'#=Site#\',\'#=Act#\');return false;" >#=TotCreated#</span>'

                           }
                ], dataBound: function (e) {
                    var grid = e.sender;
                    if (grid.dataSource.total() == 0) {
                        var colCount = grid.columns.length;
                        $(e.sender.wrapper)
                            .find('tbody')
                            .append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data"><span style="margin-left:46%;">No data found.</span></td></tr>');
                    }
                },
                    height: 700,
                    scrollable: true,
                    resizable: true,
                    reorderable: true,
                    groupable: false,
                    sortable: true,
                    filterable: true,
                    toolbar: [{ name: "excel", text: "Export Contractor" }, { template: kendo.template($("#expandallcont").html()) },
                        { template: kendo.template($("#collapseallcont").html()) }

                    ],



                    excel: {
                        fileName: "Report_Contractor.xlsx",
                        filterable: true,
                        pageable: true,
                        allPages: true
                    },



                });


                collapseAllcont();
            }
            else { FailResponse(data); }
        },
        error: function (data) {
            alert("Something went wrong please try again later!.");
        }

    });



}
function ShowDetails(CompanyID, SiteID, ActID, Type, CompanyNm, SiteNm, Act) {
    $("#ldrdvcreated").show();

    var Month = $("#ddlMonth").val();
    var Year = $("#ddlYear").val();
    $("#spnCompany1").html("<b> Company :  " + CompanyNm + "  </b>");
    $("#spnSite1").html("<b>  Site :  " + SiteNm + "  </b>");
    $("#spnAct1").html("<b> Act :  " + Act + "  </b>");

    var dialog = $("#popupdivCreated").dialog({
        autoOpen: false,
        modal: true,
        title: "Created Document Details:",
        width: 909,
        closeText: ""
    });
    dialog.dialog("open");
    CreatedDocsFillGrid(CompanyID, SiteID, ActID, Type, Month, Year, CompanyNm, SiteNm, Act);

    $("#ldrdvcreated").hide();
    return false;
}
function ShowDetailsToBeCreated(CompanyID, SiteID, ActID, Type, CompanyNm, SiteNm, Act) {
    $("#ldrdvtobecreated").show();
    var Month = $("#ddlMonth").val();
    var Year = $("#ddlYear").val();

    $("#spnCompany2").html("<b> Company :  " + CompanyNm + "  </b>");
    $("#spnSite2").html("<b>  Site :  " + SiteNm + "  </b>");
    $("#spnAct2").html("<b> Act :  " + Act + "  </b>");
    var dialog = $("#popupdivToBeCreated").dialog({
        autoOpen: false,
        modal: true,
        title: "Created Document Details:",
        width: 909,
        closeText: ""
    });
    dialog.dialog("open");
    ToBeCreatedDocsFillGrid(CompanyID, SiteID, ActID, Type, Month, Year, CompanyNm, SiteNm, Act);

    $("#ldrdvtobecreated").hide();
    return false;
}

function CreatedDocsFillGrid(CompanyID, SiteID, ActID, Type, Month, Year, CompanyNm, SiteNm, Act) {
    var str = { "CompanyID": CompanyID, "SiteID": SiteID, "ActID": ActID, "Type": Type, "Month": Month, "Year": Year };
    ////dvTeam spnProjectTeam gvTeamDtl
    $.ajax({
        type: "GET",
        //GetActScheduledDataDetails
        url:GetActScheduledDataDetailsUrl,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: str,
        success: function (data) {
            if (data.IsSuccess == true) {

                $("#gvCreatedDocDet").html("");
                var grid1 = $("#gvCreatedDocDet").data("kendoGrid");
                if (grid1 != undefined) {
                    grid1.destroy();
                    // destroy the Grid

                }


                var StrData = $.parseJSON(data.Data);

                $("#gvCreatedDocDet").kendoGrid({
                    dataSource: {
                        data: StrData
                    },
                    height: 450,
                    scrollable: true,
                    resizable: true,
                    sortable: true,
                    reorderable: true,
                    groupable: false,
                    filterable: true,
                    toolbar: [{ name: "excel", text: "Export to Excel" }],
                    excel: {
                        fileName: "CreatedDocsDet.xlsx",
                        filterable: true
                    },

                    columns:
                        [
                        {

                            field: "Activity",
                            title: "Activity",


                        }
                    ,
                    {
                        field: "DueDate",
                        title: "Due Date",

                    }
                            ,
                    {
                        field: "FirstAlert",
                        title: "First Alert Date",

                    }, {
                        field: "Type",
                        title: "Type",

                    },
                    {
                        field: "Contractor",
                        title: "Contractor",

                    }
                   ,
                    {
                        field: "In_Bucket_OF",
                        title: "In Bucket OF",

                    },
                    //{
                    //    field: "PendingDays",
                    //    title: "Pending Days",

                    //},
                    {
                        field: "Status",
                        title: "Status",

                    }
                    //{
                    //    field: "Source",
                    //    title: "Source",

                    //}

                        ], dataBound: function (e) {
                            var grid = e.sender;
                            if (grid.dataSource.total() == 0) {
                                var colCount = grid.columns.length;
                                $(e.sender.wrapper)
                                    .find('tbody')
                                    .append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data"><span style="margin-left:46%;">No data found.</span></td></tr>');
                            }
                        },

                });
            }
            else { FailResponse(data);}
        },
        error: function (data) {
            alert("Something went wrong please try again later!.");

        }

    });
}
function ToBeCreatedDocsFillGrid(CompanyID, SiteID, ActID, Type, Month, Year, CompanyNm, SiteNm, Act) {

    var str = { "CompanyID": CompanyID, "SiteID": SiteID, "ActID": ActID, "Type": Type, "Month": Month, "Year": Year };

    $.ajax({
        type: "GET",
        url:GetActScheduledDataDetailsUrl,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: str,
        success: function (data) {
            if (data.IsSuccess == true) {
                $("#gvToBeCreatedDocDet").html("");
                var grid1 = $("#gvToBeCreatedDocDet").data("kendoGrid");
                if (grid1 != undefined) {
                    grid1.destroy();

                }

                if (data.Data.length == 0) {
                    alert("No Record Found!");
                    return;
                }
                var StrData = $.parseJSON(data.Data);

                $("#gvToBeCreatedDocDet").kendoGrid({
                    dataSource: {
                        data: StrData
                    },
                    height: 450,
                    scrollable: true,
                    resizable: true,
                    sortable: true,
                    reorderable: true,
                    groupable: false,
                    filterable: true,
                    toolbar: [{ name: "excel", text: "Export to Excel" }],
                    excel: {
                        fileName: "ToBeCreatedDocsDet.xlsx",
                        filterable: true
                    },

                    columns:
                        [
                        {

                            field: "Activity",
                            title: "Activity",


                        }
                    ,
                    {
                        field: "DueDate",
                        title: "Due Date",

                    }
                            ,
                    {
                        field: "FirstAlert",
                        title: "First Alert Date",

                    }, {
                        field: "Type",
                        title: "Type",

                    },
                    {
                        field: "Contractor",
                        title: "Contractor",

                    }

                        ], dataBound: function (e) {
                            var grid = e.sender;
                            if (grid.dataSource.total() == 0) {
                                var colCount = grid.columns.length;
                                $(e.sender.wrapper)
                                    .find('tbody')
                                    .append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data"><span style="margin-left:46%;">No data found.</span></td></tr>');
                            }
                        },

                });
            }
            else { FailResponse(data);}
        },
        error: function (data) {
            alert("Something went wrong please try again later!.!");

        }

    });

}

function GetTaskFiles(DocID) {
    var data = { DOCID: DocID, FileID: 0 };
    $.ajax({
        type: "GET",
        url: GetTaskFilesUrl,
        contentType: "application/json; charset=utf-8",
        data: data,
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess == true) {
                if (kgrid != "") {
                    $('#dvAttachGrd').kendoGrid('destroy').empty();
                }
                BindAttachGrid(response.Data);
                $("#DetailPopup").dialog({
                    autoOpen: false,
                    width: 700,
                    title: "Document Details",
                    closeText: ""

                });
                $("#DetailPopup").dialog("open");
            }
            else { FailResponse(response); }
        },
        error: function (data) {
            alert('Something went wrong please try again later!.');
        }
    });
}
var kgrid = "";
function BindAttachGrid(Data1) {
    kgrid = $("#dvAttachGrd").kendoGrid({
        dataSource: {
            data: JSON.parse(Data1)
        },
        dataBound: function (e) {
            var grid = e.sender;
            if (grid.dataSource.total() == 0) {
                var colCount = grid.columns.length;
                $(e.sender.wrapper)
                    .find('tbody')
                    .append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data"><span style="margin-left:46%;">No data found.</span></td></tr>');
            }
        },
        columns: [
                   { field: "Desc", title: "File Description" },
                   { field: "UserName", title: "Uploaded By" },
                   { field: "UploadedOn", title: " Uploaded On" },
                    {
                        command: [
                    { name: "Delete", text: "", imageClass: "k-icon k-filedownload", click: Download, title: "Download" }
                        ], title: "Action", width: 100
                    }
        ], dataBound: function (e) {
            var grid = e.sender;
            if (grid.dataSource.total() == 0) {
                var colCount = grid.columns.length;
                $(e.sender.wrapper)
                    .find('tbody')
                    .append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data"><span style="margin-left:46%;">No data found.</span></td></tr>');
            }
        },
        height: 200,
        pageable: false,
        filterable: false,
        sortable: true,
        resizable: true
    });
}
function Download(e) {
    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var FileID = dataItem.FileID;
    var DocID = dataItem.DOCID;
    var data = { DOCID: DocID, FileID: FileID };
    var URL = DownloadTaskFileUrl + '?DOCID=' + DocID + '&FileID=' + FileID;
    window.location = URL;
}
function collapseAll() {
    var grid = $("#grid").data("kendoGrid");
    grid.tbody.find("tr.k-grouping-row").each(function (index) {
        grid.collapseGroup(this);
    });
    grid.pageable = false;
    return false;
}


function expandAll() {
    var grid = $("#grid").data("kendoGrid");
    grid.tbody.find("tr.k-grouping-row").each(function (index) {
        grid.expandGroup(this);
    });
    //grid.pageable = true;
    //grid.dataSource.pageSize(100);
    return false;
}
function collapseAllcont() {
    var grid = $("#gridcontarctor").data("kendoGrid");
    grid.tbody.find("tr.k-grouping-row").each(function (index) {
        grid.collapseGroup(this);
    });
    grid.pageable = false;
    return false;
}
function expandAllcont() {
    var grid = $("#gridcontarctor").data("kendoGrid");
    grid.tbody.find("tr.k-grouping-row").each(function (index) {
        grid.expandGroup(this);
    });
    grid.pageable = true;
    return false;
}
