$(document).ready(function () {
    $("#dvimport").bind("click", {}, OpenUploadPopup);
    $("#dvExport").bind("click", {}, DownLoadAll);
    $("#dvAdd").bind("click", {}, OpenAddPopUp);
    $("#menu_2").addClass("active-menu");
    BindState();
    $("#tabstrip").kendoTabStrip({
    });
    $("#btnUpload").click(function (event) {
        var fileName = $("#hdnFileName").val();
        if (fileName.trim() == "") {
            alert("Please select a CSV file");
            return false;
        }
        var form = $('#__AjaxAntiForgeryForm');
        var token = $('input[name="__RequestVerificationToken"]', form).val();

        var Data = { __RequestVerificationToken: token, FileName: fileName };
        $.ajax({
            type: "POST",
            url: UploadStateUrl,
            contentType: "application/x-www-form-urlencoded",
            data: {
                __RequestVerificationToken: token,
                FileName: fileName
            },
            dataType: "json",
            success: function (response) {
                if (response.IsSuccess == true) {
                    var Data = JSON.parse(response.Data);//.split(",");
                    //    alert(Data);
                    $("#lblTotSuccess").html(Data["Success"]);
                    $("#lblTotFailed").html(Data["Failed"]);
                    $("#hdnresultFile").val(Data["FileName"]);

                    $("#dvUpload").dialog("close");
                    $("#dvlog").dialog({
                        autoOpen: false,
                        width: 500,
                        title: "Result",
                        closeText: "",
                        position: {
                            my: "center",
                            at: "center",
                            of: window,
                            collision: "none"
                        },
                        create: function (event, ui) {
                            $(event.target).parent().css('position', 'fixed');
                        }
                    });
                    $("#dvlog").dialog("open");
                }
                else {
                    FailResponse(response);
                }
                $("#dvDetails").show();
            },
            error: function (data) {
                alert("Please try again later!!! Error occured while  binding.");
            }
        });
    });
    var form = $('#__AjaxAntiForgeryForm');
    var token = $('input[name="__RequestVerificationToken"]', form).val();
    $("#files").kendoUpload({
        async: {
            saveUrl: FilesUploadUrl,
            removeUrl: "remove",
            autoUpload: true
        },
        upload: function (e) {
            e.data = { __RequestVerificationToken: token, Folder: "Temp" };
        },
        select: function (event) {
            var notAllowed = false;
            $.each(event.files, function (index, value) {
                if (value.extension !== '.csv') {
                    alert("Plese select a csv file only!");
                    notAllowed = true;
                }
            });
            var breakPoint = 0;
            if (notAllowed == true) e.preventDefault();
        },
        multiple: false,
        success: onSuccess,
        remove: onRemove,
        showFileList: false
    });
});
function Import() {
    var dialog = $("#ModalImport").dialog({
        autoOpen: false,
        modal: true,
        title: "State Master",
        width: 909,
        closeText: "",
        position: {
            my: "center",
            at: "center",
            of: window,
            collision: "none"
        },
        create: function (event, ui) {
            $(event.target).parent().css('position', 'fixed');
        }
    });
    dialog.dialog("open");
    event.preventDefault();
}
var currentPage = 0;
function OnSuccessPage(e) {
    HandleResponse(e, "dvState", "btnReset", "ActID");
    if (e.IsSuccess == true) {
        var grid = $("#dvStategrid").data("kendoGrid");
        currentPage = grid.dataSource.page();
        BindState();
    }
}
function OnFailure() {
    alert("Failure");
}
function HistoryGridData(StateID) {
    $.ajax({
        type: "GET",
        url: GetStateHistoryUrl,
        contentType: "application/json; charset=utf-8",
        data: { "StateID": StateID },
        success: function (response) {
            HistorybindGrid(response.Data);
            var dialog = $("#modalpartial").dialog({
                autoOpen: false,
                modal: true,
                title: "State Details",
                width: 909,
                closeText: "",
                position: {
                    my: "center",
                    at: "center",
                    of: window,
                    collision: "none"
                },
                create: function (event, ui) {
                    $(event.target).parent().css('position', 'fixed');
                }
            });
            dialog.dialog("open");
        },
        error: function (data) {
            alert("Something went wrong.");
        }
    });
}
var histkgrid = "";
function HistorybindGrid(Data1) {
    if (histkgrid != "") {
        $('#GridHis').kendoGrid('destroy').empty();
    }
    histkgrid = $("#GridHis").kendoGrid({
        dataSource: {
            //pageSize: 10,
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
            else {
                var rows = grid.dataSource.total();
                var colCount = grid.columns.length;
                for (var i = rows - 1; i > 0 ; i--) {
                    for (var k = 0; k < colCount; k++) {

                        if (grid.tbody[0].children[i].cells[k].innerText != grid.tbody[0].children[i - 1].cells[k].innerText) {
                            grid.tbody[0].children[i - 1].cells[k].bgColor = "red";
                        }
                    }
                }
            }
        },
        //pageable: true,
        sortable: true,
        resizable: true
    });
    $("#GridHis .k-grid-content.k-auto-scrollable").css("height", "272px");
}
var kgrid = "";
function BindState() {
    $.ajax({
        type: "GET",
        url: GetStateUrl,
        contentType: "application/json; charset=utf-8",
        data: { "StateID": 0 },
        success: function (response) {
            if (response.IsSuccess) {
                if (kgrid != "") {
                    $('#dvStategrid').kendoGrid('destroy').empty();
                }
                var objAddDiv = $("#dvAdd");
                if (objAddDiv.length > 0) {
                    var cmd = {
                        command: [{ name: "Edit", text: "", imageClass: "k-icon k-edit", click: EditHandler, title: "Edit" },
                                          { name: "View", text: "", imageClass: "k-icon k-view", click: ViewHandler, title: "View" }
                        ], title: "Action", width: 100
                    };
                }
                else {
                    var cmd = {
                        command: [{ name: "View", text: "", imageClass: "k-icon k-view", click: ViewHandler, title: "View" }
                        ], title: "Action", width: 100
                    };
                }
                kgrid = $("#dvStategrid").kendoGrid({
                    dataSource: {
                        pageSize: 15,
                        data: JSON.parse(response.Data)
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
                               { field: "Name", title: "State", width: 200 },
                               { field: "CountryNm", title: "Country", width: 100 },
                               { field: "IsActNm", title: "Status", width: 100 },
                               cmd
                    ],
                    dataBound: ShowToolTip,
                    height: 400,
                    pageable: { pageSizes: true },
                    filterable: true,
                    sortable: true,
                    reorderable: true,
                    resizable: true
                });
                if (currentPage != 0)
                    $('#dvStategrid').data().kendoGrid.dataSource.page(currentPage);
            }
            else {
                FailResponse(response);
            }
        },
        error: function (data) {
            alert('Error occured');
        }
    });
}
function onDataBound(arg) {
    alert("Hi");
}
function ShowToolTip() {
    $(".k-icon.k-edit").parent().attr("title", "Edit");
    $(".k-icon.k-view").parent().attr("title", "View");

    $(".k-icon.k-edit").parent().kendoTooltip({
        width: 60,
        position: "top"
    }).data("kendoTooltip");
    $(".k-icon.k-view").parent().kendoTooltip({
        width: 60,
        position: "top"
    }).data("kendoTooltip");
}
function OpenAddPopUp() {
    $("#btnreset").click();
    $("#StateID").val("0");
    var dialog = $("#dvState").dialog({
        autoOpen: false,
        modal: true,
        title: "State Master",
        width: 500,
        closeText: "",
        position: {
            my: "center",
            at: "center",
            of: window,
            collision: "none"
        },
        create: function (event, ui) {
            $(event.target).parent().css('position', 'fixed');
        }
    });
    dialog.dialog("open");
}
function OpenUploadPopup() {
    $("#dvUpload").dialog({
        autoOpen: false,
        width: 500,
        title: "Upload State",
        closeText: "",
        position: {
            my: "center",
            at: "center",
            of: window,
            collision: "none"
        },
        create: function (event, ui) {
            $(event.target).parent().css('position', 'fixed');
        }
    });
    $("#dvUpload").dialog("open");
    event.preventDefault();
}
function DownLoadResultFile() {
    var FileName = $("#hdnresultFile").val();
    var Data = { FileName: FileName };
    var URL = DownLoadResultFileUrl + '?FileName=' + FileName;
    window.location = URL;
    return false;
}

function DownloadSampleState() {
    //public ActionResult GetMapppingCount(string CompIDS,string sitesIDs,string ActIds,string ContractorIds)
    var URL = DownloadSampleStateUrl;
    window.location = URL;
    return false;
}
//Handlers Section
var ViewHandler = function ViewHandler(e) {
    $("#liDetails").removeClass('active').addClass('active');
    $("#liHistory").removeClass('active')
    $("#tab_1_1").removeClass('active').addClass('active');
    $("#tab_1_2").removeClass('active');
    e.preventDefault();
    var dataItem = {};
    dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var StateID = dataItem.StateID;
    $.get(GetStateUrl, { StateID: StateID }, function (response) {
        //console.log(response);
        if (response.IsSuccess) {
            var data = JSON.parse(response.Data)[0];
            $("#lblState_Name").html(data.Name);
            $("#lblCountry_Name").html(data.CountryNm);
            $("#lblGeoFance_Name").html(data.Geofence);

            var IsAct = data.IsAct;
            (IsAct == 1) ? $('#lblIsAct').html('Active') : $('#lblIsAct').html('In Active');
            HistoryGridData(StateID);
        }
        else {
            FailResponse(response);
        }
    });
}
//Handlers Section
var EditHandler = function EditHandler(e) {
    e.preventDefault();
    $("#btnreset").click();
    var dataItem = {};
    dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var StateID = dataItem.StateID;
    $.get(GetStateUrl, { StateID: StateID }, function (response) {
        //console.log(response);
        if (response.IsSuccess) {
            var data = JSON.parse(response.Data)[0];
            $("#Name").val(data.Name);
            $("#Geofence").val(data.Geofence);
            $("#Country").val(data.Country);
            $("#StateID").val(data.StateID);
            var IsAct = data.IsAct;
            (IsAct == 1) ? $('#IsAct').prop('checked', true) : $('#IsAct').prop('checked', false);
            var dialog = $("#dvState").dialog({
                autoOpen: false,
                modal: true,
                title: "State Master",
                width: 500,
                closeText: "",
                position: {
                    my: "center",
                    at: "center",
                    of: window,
                    collision: "none"
                },
                create: function (event, ui) {
                    $(event.target).parent().css('position', 'fixed');
                }
            });
            dialog.dialog("open");
        }
        else {
            FailResponse(response);
        }
    });
    return false;
}
var DeleteHandler = function DeleteHandler(e) {
    alert("Delete");
    return false;
}
function DownLoadAll() {
    var URL = DownloadAllMapppingStateUrl;
    window.location = URL;
    return false;
}
