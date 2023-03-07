$(document).ready(function () {
    BindGrid("VEcom_Doc_AsNeeded", "DOCID");
});

var Kgrid;
function BindGrid(tableName, ID) {
    var url = GetGridDataUrl;
    $("#Kgrid").kendoGrid({
        dataSource: {
            type: "json",
            transport: {
                read: {
                    url: url, //'testKgrid.aspx/GetData',
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8"
                },
                parameterMap: function (data, type) {
                    return JSON.stringify({
                        tableName: tableName,
                        ID: ID,
                        UID: true,
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
                        Short_Name: { type: "string" },
                        ContName: { type: "string" },
                        Creation_Desc: { type: "string" },
                        Creation_Remarks: { type: "string" },
                        ExpiryDate: { type: "date" },
                        RemindDays: { type: "number" }
                    }
                },
                data: function (data) {
                    //                    return $.parseJSON(data.d).Data || [];
                    //alert(data.IsSuccess);
                    var res = $.parseJSON(data.Data);
                    if (res.Data.length > 0) {
                        return res.Data || [];
                    }
                },
                total: function (data) {
                    var res = $.parseJSON(data.Data);
                    if (res.Data.length > 0) {
                        return res.Total || [];
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
        filterable: true,
        toolbar: [{ name: "excel" }],
        excel: {
            fileName: "AsNeeded.xlsx",
            filterable: true,
            pageable: true,
            allPages: true
        },
        resizable: true,
        height: 400,
        sortable: {
            mode: "multiple"
        },
        pageable: {
            pageSizes: true,
            refresh: true
        },
        columns: [
             {
                 command: [{ name: "Edit", text: "", imageClass: "k-icon k-edit", click: EditHandler, title: "Edit" }

                 ], title: "Edit", width: 60
             },
             { field: "DOCID", title: "DocID", width: 120 },
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
function ShowToolTip() {
    $(".k-icon.k-edit").parent().attr("title", "View");

    $(".k-icon.k-edit").parent().kendoTooltip({
        width: 60,
        position: "top"
    }).data("kendoTooltip");
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