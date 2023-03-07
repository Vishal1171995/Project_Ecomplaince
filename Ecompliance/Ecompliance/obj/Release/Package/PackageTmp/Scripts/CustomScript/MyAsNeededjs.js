$(document).ready(function () {
    //BindGrid("VEcom_Doc_AsNeeded", "DOCID");
    BindGrid();
});

var Kgrid;
function BindGrid() {
    var CompID = GetParameterValues('compID');
    var SMonth = GetParameterValues('SMonth');
    var TMonth = GetParameterValues('TMonth');
    var Syear = GetParameterValues('Syear');
    var Tyear = GetParameterValues('Tyear');
    if (CompID == undefined) CompID = 0;
    if (SMonth == undefined) SMonth = 0;
    if (TMonth == undefined) TMonth = 0;
    if (Syear == undefined) Syear = 0;
    if (Tyear == undefined) Tyear = 0;
    var url = GetMyAsNeededUrl;
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
                        DOCID: { type: "int" },
                        ActivityType: { type: "string" },
                        CompName: { type: "string" },
                        SiteName: { type: "string" },
                        Short_Name: { type: "string" },
                        ContName: { type: "string" },
                        User_Name: { type: "string" },
                        CurrStatus: { type: "string" },
                        Creation_Desc: { type: "string" },
                        Creation_Remarks: { type: "string" },
                        ExpiryDate: { type: "date" },
                        RemindDays: { type: "number" }
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
            { field: "DOCID", title: "DocID", width: 80 },
            { field: "ActivityType", title: "Activity Type", width: 120 },
            { field: "CompName", title: "Company Name", width: 200 },
            { field: "SiteName", title: "Site Name", width: 150 },
            { field: "Short_Name", title: "Act Name", width: 150 },
            { field: "ContName", title: "Contractor Name", width: 150 },
            { field: "Creation_Desc", title: "Creation Desc", width: 200 },
            { field: "Creation_Remarks", title: "Creation Remarks", width: 150 },
            { field: "ExpiryDate", title: "Expiry Date", width: 150, type: "date", format: "{0:dd/MM/yyyy}" },
            { field: "RemindDays", title: "Remind Days", width: 100, type: "number" },
        ]

    });
}
var ViewHandler = function ViewHandler(e) {
    //alert("ViewDet");
    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var DocID = dataItem.DOCID;
    var URL = '../../document/MyAsNeeded/' + DocID;
    OpenWindow(URL);
}
var EditHandler = function EditHandler(e) {
    //alert("ViewDet");
    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var DocID = dataItem.DOCID;
    var URL = '../../document/Task?DocID=' + DocID;
    window.location.href = URL;
}
var new_window;
function OpenWindow(url) {
    var new_window = window.open(url, "List", "scrollbars=yes,resizable=yes,width=800,height=480");
    return false;
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