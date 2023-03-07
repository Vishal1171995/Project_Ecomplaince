$(document).ready(function () {
    $("#txtFromDate,#txtToDate").datepicker({
        dateFormat: 'dd/mm/yy',
        //showOn: 'button',
        //buttonText: "Choose Date",
    });
    $("#txtFromDate,#txtToDate").datepicker("setDate" , new Date());
    $("#spnfrmDate").click(function () {
        $('#txtFromDate').datepicker('show');
    });
    $("#spnToDate").click(function () {
        $('#txtToDate').datepicker('show');
    });
    BindGrid();
    $("#btnSearch").bind("click", {}, BindGrid);
});
var Kgrid = "";
function BindGrid() {
    var FromDate = $("#txtFromDate").val();
    var ToDate = $("#txtToDate").val();
    var url = GetLogUserUrl;
    var typepar = "";
    if (Kgrid != "") {
        $('#Kgrid').kendoGrid('destroy').empty();
    }
    Kgrid = $("#Kgrid").kendoGrid({
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
                        FromDate: FromDate,
                        ToDate: ToDate,
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
                        UserName: { type: "string" },
                        Email: { type: "string" },
                        //Role: { type: "string" },
                        //ContactNumber: { type: "string" },
                        CompanyName: { type: "string" },
                        Customer: { type: "string" },
                        Contractor: { type: "string" },
                        LoginTime: { type: "date" },
                        LogOutTime: { type: "date" },
                    }
                },
                data: function (data) {
                    var res = JSON.parse(data.Data)
                    //var res = $.parseJSON(data.Data);
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
                        var res = JSON.parse(data.Data)
                        //var res = $.parseJSON(data.Data);
                        if (res.Data.length > 0) {
                            return res.Total || [];
                        }
                    }
                    else {
                        FailResponse(data);
                    }
                }
            },
            pageSize: 20,
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        },
        //dataBound: ShowToolTip,
        noRecords: true,
        groupable: false,
        resizable: true,
        height: 400,
        filterable: true,
        toolbar: [{ name: "excel" }],
        excel: {
            fileName: "LogUser.xlsx",
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
            { field: "User_Name", title: "User Name", width: 120 },
                { field: "UserName", title: "User ID", width: 120 },
                { field: "Role", title: "Role", width: 120 },
                
                { field: "Email", title: "Email", width: 180 },
                //{ field: "Role", title: "Role", width: 100 },
                //{ field: "ContactNumber", title: "Contact Number", width: 100 },
                { field: "CompanyName", title: "Company Name", width: 180 },
                { field: "Customer", title: "Customer", width: 180 },
                { field: "LoginTime", title: "Login Time", width: 120,type: "date", format: "{0:dd/MM/yyyy hh:mm}" },
                { field: "LogOutTime", title: "LogOut Time", width: 120, type: "date", format: "{0:dd/MM/yyyy  hh:mm}" },
        ]

    });
}