$(document).ready(function () {
    BindGrid();
});
var Kgrid;
function BindGrid() {
    var url = GetDocTaskGridUrl;
    var typepar = typepar1;
    var type1 = GetParameterValues('Type');
    var CompID = GetParameterValues('compID');
    var SMonth = GetParameterValues('SMonth');
    var TMonth = GetParameterValues('TMonth');
    var Syear = GetParameterValues('Syear');
    var Tyear = GetParameterValues('Tyear');

    $("#Kgrid").kendoGrid({
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
                        DOCID: {
                            type: "number"
                        },
                        ActivityType: { type: "string" },
                        CompName: { type: "string" },
                        SiteName: { type: "string" },
                        ActivityName: { type: "string" },
                        Short_Name: { type: "string" },
                        ContName: { type: "string" },
                        User_Name: { type: "string" },
                        CurrStatus: { type: "string" },
                        Action_CompletionDate: { type: "date" },
                        ExpiryDate: { type: "date" },
                        Delay_Region: { type: "number" },
                        Creation_Desc: { type: "string" },
                        Creation_Remarks: { type: "string" }
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
            fileName: "Alert.xlsx",
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
                {
                    field: "DOCID", title: "DocID", width: 80, filterable: {
                        ui: function (element) {
                            element.kendoNumericTextBox({
                                format: "#"
                            });
                        }
                    }
                },
                { field: "ActivityType", title: "Activity Type", width: 150 },
                { field: "CompName", title: "Company", width: 120 },
                { field: "SiteName", title: "Site", width: 100 },
                { field: "Short_Name", title: "Act Name", width: 100 },
                { field: "ActivityName", title: "Activity Name", width: 150 },
                { field: "ContName", title: "Contractor Name", width: 120 },
                { field: "User_Name", title: "Curr User", width: 100 },
                { field: "CurrStatus", title: "Curr Status", width: 150 },
                { field: "Action_CompletionDate", title: "Completion Date", width: 150, type: "date", format: "{0:dd/MM/yyyy}" },
                { field: "ExpiryDate", title: "Expiry Date", width: 120, type: "date", format: "{0:dd/MM/yyyy}" },
                { field: "Delay_Region", title: "Delay Region", width: 100 },
                { field: "Creation_Desc", title: "Creation Desc", width: 150 },
                { field: "Creation_Remarks", title: "Creation Remarks", width: 150 }
        ]

    });
}
function GetParameterValues(param) {
    var url = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for (var i = 0; i < url.length; i++) {
        var urlparam = url[i].split('=');
        if (urlparam[0] == param) {
            return urlparam[1];
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