var EmptyCount = 0;
$(document).ready(function () {
    $("#menu_4").addClass("active-menu");
    $("#tabstrip").kendoTabStrip();
    $("#btnSearch").click(BindMonthlyScheduledGrid);
});

function BindMonthlyScheduledGrid() {
    var Company = $("#ddlCompany").val();
    var Month = $("#ddlMonth").val();
    var Year = $("#ddlYear").val();
    if (Company == 0) {
        alert("Please select company");
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
    BindPEGrid(Company, Month, Year);
    BindContractorGrid(Company, Month, Year);
    if (EmptyCount >= 2) {
        $("#dvReport").hide();
        $("#dvNoRecord").show();
    }
    else {
        $("#dvReport").show();
        $("#dvNoRecord").hide();
    }
}

function BindPEGrid(Company, Month, Year) {
    $("#liCompany").show();

    var str = { "CompanyID": Company, "Month": Month, "Year": Year, "Type": "Company" };
    $.ajax({
        type: "GET",
        url: GetMonthlyScheudledDataUrl,
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

                        group: [{
                            field: "DueDate",
                            type: "date",
                            format: "{0:yyyy-MM-dd }",
                            aggregates: [
                              { field: "TotScheduled", aggregate: "sum" }, { field: "TotCreated", aggregate: "sum" }
                            ]
                        }, {
                            field: "Company", aggregates: [
                              { field: "TotScheduled", aggregate: "sum" }, { field: "TotCreated", aggregate: "sum" }
                            ]
                        }, {
                            field: "Act", aggregates: [{ field: "TotScheduled", aggregate: "sum" },
                                { field: "TotCreated", aggregate: "sum" }
                            ]
                        },
                        {
                            field: "Activity", aggregates: [{ field: "TotScheduled", aggregate: "sum" },
                                { field: "TotCreated", aggregate: "sum" }
                            ]
                        }],

                        aggregate: [{ field: "TotScheduled", aggregate: "sum" },
                            { field: "TotCreated", aggregate: "sum" },
                        ]
                    }
                ,
                    columns: [{
                        field: "DueDate",
                        title: "Due Date",
                        type: "date",
                        format: "{0:dd/MM/yyyy }",
                        groupHeaderTemplate: "#= kendo.toString(value,'dd/MM/yyyy') #  :  (Total Scheduled on Date : #= aggregates.TotScheduled.sum# )  (Total Created : #=aggregates.TotCreated.sum#  )"

                    }, {
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
                                                       field: "Activity",
                                                       title: "Activity",
                                                       groupHeaderTemplate: "Activity: #= value# :  ( Total Scheduled on Activity : #= aggregates.TotScheduled.sum# )   (Created : #=aggregates.TotCreated.sum# ) "

                                                   },

                                                   {
                                                       field: "TotScheduled",
                                                       title: "Total Scheduled",


                                                   },
                                                   {
                                                       field: "TotCreated",
                                                       title: "Created Till Date",


                                                   }
                    ],
                    dataBound: function (e) {
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

                    // buttons:"Expand All",

                    excel: {
                        fileName: "Report_Company.xlsx",
                        filterable: true,
                        pageable: true,
                        allPages: true
                    },
                    ExpandAll: {},

                    //pageable: {
                    //    buttonCount: 5
                    //},

                });
                // $("#mask").hide();

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

function BindContractorGrid(Company, Month, Year) {
    var Month = $("#ddlMonth").val();
    var Year = $("#ddlYear").val();

    var str = { "CompanyID": Company, "Month": Month, "Year": Year, "Type": "Contractor" };
    $.ajax({
        type: "GET",
        url: GetMonthlyScheudledDataUrl,
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
                if (data.Data.length == 0) {
                    EmptyCount += 1;
                    return;

                }
                var StrData = $.parseJSON(data.Data);

                $("#gridcontarctor").kendoGrid({
                    dataSource: {
                        data: StrData,

                        group: [{
                            field: "DueDate",
                            type: "date",
                            format: "{0:yyyy-MM-dd }",
                            aggregates: [
                              { field: "TotScheduled", aggregate: "sum" }, { field: "TotCreated", aggregate: "sum" }
                            ]
                        }, {
                            field: "Company", aggregates: [
                              { field: "TotScheduled", aggregate: "sum" }, { field: "TotCreated", aggregate: "sum" }
                            ]
                        }, {
                            field: "Act", aggregates: [{ field: "TotScheduled", aggregate: "sum" },
                                { field: "TotCreated", aggregate: "sum" }
                            ]
                        },
                       {
                           field: "Activity", aggregates: [{ field: "TotScheduled", aggregate: "sum" },
                               { field: "TotCreated", aggregate: "sum" }
                           ]
                       },
                          {
                              field: "Contractor", aggregates: [{ field: "TotScheduled", aggregate: "sum" },
                                  { field: "TotCreated", aggregate: "sum" }
                              ]
                          }]
                        ,

                        aggregate: [{ field: "TotScheduled", aggregate: "sum" },
                            { field: "TotCreated", aggregate: "sum" },
                        ]

                    }
                , columns: [{
                    field: "DueDate",
                    title: "Due Date",
                    type: "date",
                    format: "{0:dd/MM/yyyy }",
                    groupHeaderTemplate: "#= kendo.toString(value,'dd/MM/yyyy') #  :  (Total Scheduled on Date : #= aggregates.TotScheduled.sum# )  (Total Created : #=aggregates.TotCreated.sum#  )"

                }, {
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
                            field: "Activity",
                            title: "Activity",
                            groupHeaderTemplate: "Activity: #= value# :  ( Total Scheduled on Activity : #= aggregates.TotScheduled.sum# )   (Created : #=aggregates.TotCreated.sum# ) "

                        },
                         {
                             field: "Contractor",
                             title: "Contractor",
                             groupHeaderTemplate: "Contractor: #= value# :  ( Total Scheduled on Contractor : #= aggregates.TotScheduled.sum# )   (Created : #=aggregates.TotCreated.sum# ) "

                         },
                        {
                            field: "TotScheduled",
                            title: "Total Scheduled",


                        },
                        {
                            field: "TotCreated",
                            title: "Created Till Date",


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
