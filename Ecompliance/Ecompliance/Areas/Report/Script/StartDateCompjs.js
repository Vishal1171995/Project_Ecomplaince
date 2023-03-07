$(document).ready(function () {
    $("#btnSearch").click(BindStartDateCompGrid);
});

function BindStartDateCompGrid() {
    var Comp = $("#ddlCompany").val();
    if (Comp == 0) {
        alert("Please select Company");
        return;
    }
    else {
        $("#dvReport").show();
        BindGrid(Comp);
    }
}
var kgrid = "";
function BindGrid(Comp) {
    $.ajax({
        type: "GET",
        url: GetStartDatCompUrl,
        contentType: "application/json; charset=utf-8",
        data: { "CompanyID": Comp },
        success: function (response) {
            if (response.IsSuccess) {
                if (kgrid != "") {
                    $('#kgrid').kendoGrid('destroy').empty();
                }
                kgrid = $("#kgrid").kendoGrid({
                    dataSource: {
                        pageSize: 15,
                        data: JSON.parse(response.Data)
                    },
                    columns: [

                               { field: "Company", title: "Company", width: 200 },
                               { field: "Act", title: "Act", width: 200 },
                               { field: "Activity", title: "Activity", widht:200 },
                               { field: "EffectiveDate", title: "EffectiveDate", widht: 200 },
                               { field: "frequency", title: "frequency", width: 100 },
                               { field: "MappingStartDate", title: "Mapping Start Date", widht:200 },
                               { field: "ActivityStartDate", title: "Activity Start Date", widht:200 },
                    ],
                    dataBound: changeColor,
                    height: 400,
                    noRecords: true,
                    pageable: true,
                    filterable: true,
                    sortable: true,
                    resizable: true,
                    reorderable: true
                });
            }
            else {
                FailResponse(response);
            }
        },
        error: function (data) {
        }
    });
}
function changeColor() {
    var grid = $("#kgrid").data("kendoGrid");
    var data = grid.dataSource.data();
    $.each(data, function (i, row) {
        var StartDateComp = row.StartDateComp;
        var FreqComp = row.FreqComp;
        if (StartDateComp == 0 || FreqComp == 0) {
            $('tr[data-uid="' + row.uid + '"]').css("background-color", "red");
        }

    });
}