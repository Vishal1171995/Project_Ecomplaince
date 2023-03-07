$(document).ready(function () {
    BindGrid();
    //$('.k-button').href( 'javascript:void(0)');
});
var Kgrid = "";
function BindGrid() {
    var url = GetMyTaskUrl;
    //var typepar = '@ViewBag.Type';
    var type1 = GetParameterValues('Type');
    var CompID = GetParameterValues('compID');
    var SMonth = GetParameterValues('SMonth');
    var TMonth = GetParameterValues('TMonth');
    var Syear = GetParameterValues('Syear');
    var Tyear = GetParameterValues('Tyear');
    if (CompID == null) CompID = 0;
    if (SMonth == null) SMonth = 0;
    if (TMonth == null) TMonth = 0;
    if (Syear == null) Syear = 0;
    if (Tyear == null) Tyear = 0;
    if (Kgrid != "") {
        $('#dvgrid').kendoGrid('destroy').empty();
    }
    Kgrid = $("#dvgrid").kendoGrid({
        dataSource: {
            type: "json",
            transport: {
                read: {
                    url: url,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                },
                parameterMap: function (data, type) {
                    return JSON.stringify({
                        Type: typepar,
                        CompID: CompID,
                        SMonth: SMonth,
                        TMonth: TMonth,
                        Syear: Syear,
                        Tyear: Tyear,
                        page: data.page,
                        pageSize: data.pageSize,
                        skip: data.skip,
                        take: data.take,
                        sorting: data.sort === undefined ? null : data.sort,
                        filter: data.filter === undefined ? null : data.filter
                    });
                }
            },
            schema: {
                model: {
                    fields: {
                        CompName: { type: "string" },
                        SiteName: { type: "string" },
                        ActName: { type: "string" },
                        ActivityName: { type: "string" },
                        ActivityType: { type: "string" },
                        FileCount: { type: "number" },
                        ContName: { type: "string" },
                        CurrStatus: { type: "string" },
                        Recievedon: { type: "date" },
                        Expiry_Date: { type: "date" },
                        PendingDays: { type: "number" }

                    }
                },
                data: function (data) {
                    var res = $.parseJSON(data.Data);
                    if (data.IsSuccess) {
                        if (res.Data.length > 0) {
                            return res.Data || [];
                        }
                    }
                    else {
                        FailResponse(data);
                    }
                },

                total: function (data) {
                    if (data.IsSuccess) {
                        var res = $.parseJSON(data.Data);
                        if (res.Data.length > 0) {
                            return res.Total || [];
                        }
                    }
                    else {
                        FailResponse(data);
                    }
                }
            },
            pageSize: 10,
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        },
        dataBound: ShowToolTip,
        noRecords: true,
        groupable: false,
        resizable: true,
        height: 400,
        filterable: true,
        toolbar: [{ name: "excel" }],
        excel: {
            fileName: "MyTask.xlsx",
            filterable: true,
            pageable: true,
            allPages: true
        },
        sortable: {
            mode: "multiple"
        },
        pageable: {
            pageSizes: true,
            refresh: true
        },
        columns: [
            { command: [{ name: "View", text: "", imageClass: "k-icon k-view", click: ViewHandler, title: "View" }], title: "View", width: 60 },
            { field: "DOCID", title: "DocID", width: 80 },
            { field: "CompName", title: "Company", width: 200 },
            { field: "SiteName", title: "Site", width: 100 },
            { field: "ActName", title: "Act", width: 100 },
            { field: "ActivityName", title: "Activity", width: 200 },
            { field: "ActivityType", title: "Type", width: 100 },
            { field: "FileCount", title: "Attached", width: 100 },
            { field: "ContName", title: "Contractor", width: 150 },
            { field: "CurrStatus", title: "Status", width: 150 },
            { field: "Recievedon", title: "Received On", width: 150, type: "date", format: "{0:dd/MM/yyyy HH.mm.ss}" },
            { field: "Expiry_Date", title: "Expiry Date", width: 150, type: "date", format: "{0:dd/MM/yyyy}" },
            { field: "PendingDays", title: "Pending Days", width: 150 }

        ]

    });
    if (Kgrid != "") {
        if (filtersNeedToAct != null) {
            $("#dvgrid").data("kendoGrid").refresh();
            $("#dvgrid").data("kendoGrid").dataSource.filter(filtersNeedToAct);
        }
    }

}
function ShowToolTip() {
    $(".k-icon.k-view").parent().attr("title", "View");

    $(".k-icon.k-view").parent().kendoTooltip({
        width: 60,
        position: "top"
    }).data("kendoTooltip");
}
var ViewHandler = function ViewHandler(e) {
    //alert("ViewDet");
    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var DocID = dataItem.DOCID;
    var URL = '../../document/Task/' + DocID;
    OpenWindow(URL);
}
var new_window;
function OpenWindow(url) {
    var new_window = window.open(url, "List", "scrollbars=yes,resizable=yes,width=800,height=480");
    return false;
}
var filtersNeedToAct;
function childClose() {
    if ($('#dvgrid').length > 0)
        filtersNeedToAct = $("#dvgrid").data("kendoGrid").dataSource.filter();
    BindGrid();
}
function GetParameterValues(name, url) {
    if (!url) {
        url = window.location.href;
    }
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

function GetParameterValues11(param) {
    var url = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for (var i = 0; i < url.length; i++) {
        var urlparam = url[i].split('=');
        if (urlparam[0] == param) {
            return urlparam[1];
        }
    }
}