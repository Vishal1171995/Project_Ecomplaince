var EmptyCount = 0;
$("#ddlCompany").change(function () {
    var CompanyID = $(this).val();
    var ddlSite = $("#ddlSite");
    ddlSite.empty().append($('<option></option>').val("0").html("Please wait..."));
    if (CompanyID != "0") {
        $.get(GetMappedSiteUrl, { CompanyID: CompanyID }, function (response) {
            if (response.IsSuccess) {
                ddlSite.empty().append($('<option></option>').val("0").html("ALL"));
                var ds = $.parseJSON(response.Data);
                if (ds.length > 0) {
                    $.each(ds, function () {
                        ddlSite.append($('<option></option>').val(this.SiteID).html(this.Name));
                    });
                }
            }
        });
    }
    else {
        ddlSite.html('').append($('<option></option>').val("0").html("-- first select a company --"));
    }
});
function BindScoreCardGrid() {
    var Comp = $("#ddlCompany").val();
    var Site = $("#ddlSite").val();
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
    BindPEGrid(Comp, Site, Month, Year);
    if (EmptyCount >= 2) {
        $("#dvReport").hide();
        $("#dvNoRecord").show();
    }
    else {
        $("#dvReport").show();
        $("#dvNoRecord").hide();
    }
}
$(document).ready(function () {
    $("#menu_4").addClass("active-menu");
    $("#btnSearch").click(BindScoreCardGrid);
});
var AverageDataSet;
//FilterDataComp
function FilterData(Site, Role) {
    //var Obj = FilterFunction(Site, Role);
    var Obj = AverageDataSet.filter(function (item) {
        return item.Site == Site && item.Checker == Role;
    });//     FilterFunction(Site, Role);
    return Obj[0].Percentage;
};
function FilterDataComp(Comp, Role) {
    //var Obj = FilterFunction(Site, Role);
    var Obj = AverageDataSet.filter(function (item) {
        return item.Company == Comp && item.Checker == Role;
    });//     FilterFunction(Site, Role);
    var Total = 0;
    for (var i = 0; i < Obj.length; i++) {
        Total = Total + parseFloat(Obj[i].Percentage);
    }
    var Percent = Total / Obj.length;
    return Percent;
};

function filterG4S(item) {
    alert(item);
    return 111;
};

var FilterFunction = function (site,Res) {
    return AverageDataSet.Site == site && AverageDataSet.Checker == Res;
};


function BindPEGrid(Comp, Site, Month, Year) {
    var Maker = "";
    var Checker = "";
    var Auditor = "";

    // $("#mask").show();
    var str = { "CompanyID": Comp, "SiteID": Site, "Month": Month, "Year": Year, "Type": "PE", "Maker": Maker, "Checker": Checker, "Auditor": Auditor };
    $.ajax({
        type: "GET",
        //GetScoreCardData
        url: GetScoreCardDataUrl,
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

                var StrDataTemp = $.parseJSON(data.Data);
                var StrData = StrDataTemp.Table;
                AverageDataSet = StrDataTemp.Table1;
                if (StrData.length == 0) {
                    EmptyCount += 1;
                    if (EmptyCount >= 2) {
                        $("#dvReport").hide();
                        $("#dvNoRecord").show();
                    }
                    else {
                        $("#dvReport").show();
                        $("#dvNoRecord").hide();
                    }

                }
                $("#grid").kendoGrid({
                    dataSource: {
                        data: StrData,
                        //pageSize: 100,Checker
                        group: [
                            { field: "Company", aggregates: [{ field: "Company", aggregate: "count" }, { field: "Percentage", aggregate: "average" }] },
                            { field: "Site", aggregates: [{ field: "Site", aggregate: "count" }, { field: "Percentage", aggregate: "average" }] }

                        ],
                        aggregate: [
                            { field: "Site", aggregate: "average" }
                            , { field: "Company", aggregate: "average" }
                            , { field: "Maker", aggregate: "average" }
                        ]
                    }
                    , dataBound: function (e) {
                        var grid = e.sender;
                        if (grid.dataSource.total() == 0) {
                            var colCount = grid.columns.length;
                            $(e.sender.wrapper)
                                .find('tbody')
                                .append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data"><span style="margin-left:46%;">No data found.</span></td></tr>');
                        }
                    },
                    columns: [
                        { field: "Company", hidden: true, title: "Company", groupHeaderTemplate: "# if( aggregates.Percentage.average == null ) {# #=value #  : (Average : -)#} else {# #=value #  : (Average : #=kendo.format('{0:n}',aggregates.Percentage.average)#%)#} #<span style='color:blue;padding-left:200px;font-weight: 100;'> Mynd:(Average:  #=FilterDataComp(value,'MYND')#%)</span><span style='color:green;padding-left:200px;font-weight: 100;'> G4S:(Average:  #=FilterDataComp(value,'G4S')#%)</span>" },
                        { field: "Site", hidden: true, title: "Site", groupHeaderTemplate: "# if( aggregates.Percentage.average == null ) {# #=value #  : (Average : -)#} else {# #=value #  : (Average : #=kendo.format('{0:n}',aggregates.Percentage.average)#%)#} #<span style='color:blue;padding-right:200px;padding-left:261px;font-weight: 100;'> Mynd:(Average:  #=FilterData(value,'MYND')#%)</span><span style='color:green;padding-right:20px;font-weight: 100;'> G4S:(Average:  #=FilterData(value,'G4S')#%)</span>" },
                        { field: "Act", hidden: false, title: "Act", groupHeaderTemplate: "# if( aggregates.Percentage.average == null ) {# #=value #  : (Average : -)#} else {# #=value #  : (Average : #=kendo.format('{0:n}',aggregates.Percentage.average)#%)#} #" },
                        { field: "Activity", title: "Activity" },
                        { field: "Maker", title: "Maker"},
                        { field: "Checker", title: "Checker" },
                        { field: "ActionType", title: "Action<br/> Type", width: "80px" },
                        { field: "Applicable_To_Client", title: "Applicable<br/> To Client", width: "110px" },
                        { field: "PendingWith", title: "Pending With" },
                        { field: "Percentage", title: "%", aggregates: ["average"], type: "number" },
                        { field: "DueDate", title: "Due Date" },
                        {
                            command:
                                [
                                    { name: "View", text: "", imageClass: "k-icon k-view", click: showDetails, title: "View" }
                                ],
                            title: "Action", width: 100
                        }
                    ],
                    dataBound: ShowToolTip,
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

                    // buttons:"Expand All",

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
            // $("#mask").hide();
        }
    });
    
}

function ShowToolTip() {
    $(".k-icon.k-view").parent().attr("title", "View");

    $(".k-icon.k-view").parent().kendoTooltip({
        width: 60,
        position: "top"
    }).data("kendoTooltip");
}
function showDetails(e) {
    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    $("#lblCompany").html(dataItem.Company);
    $("#lblSite").html(dataItem.Site);
    $("#lblAct").html(dataItem.Act);
    $("#lblActivity").html(dataItem.Activity);
    GetTaskFiles(dataItem.DocID);
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
            alert("Something went wrong please try again later!.");
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
                ], title: "Action"
            }
        ],
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
    
    var UploadedAction = dataItem.UploadedAction;
    if (UploadedAction == 'INTEGRATION') {
        var Name = dataItem.Name;
        var Integration_TID = dataItem.Integration_TID;
        $.get(GetHashCodeUrl, { Hash: Name }, function (Data) {
            console.log();
            window.location = 'http://g4sact.myndsolution.com/getfile.aspx?hash=' + JSON.stringify(Data) + '&tid=' + Integration_TID;
        });
    }
    else {
        var data = { DOCID: DocID, FileID: FileID };
        var URL = DownloadTaskFileUrl + '?DOCID=' + DocID + '&FileID=' + FileID;
        window.location = URL;
    }
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
    grid.pageable = true;
    grid.dataSource.pageSize(100);

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