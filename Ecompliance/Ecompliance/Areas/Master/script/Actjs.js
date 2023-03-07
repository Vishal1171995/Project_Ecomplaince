$(document).ready(function () {
    $("#dvimport").bind("click", {}, OpenUploadPopup);
    $("#dvExport").bind("click", {}, DownLoadAll);
    $("#dvAdd").bind("click", {}, OpenAddPopUp);
});
var kgrid="";
$(document).ready(function () {
    $("#menu_2").addClass("active-menu");
    GridData();
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
            url: UploadActUrl,
            contentType: "application/x-www-form-urlencoded",
            //data: Data,
            data: {
                __RequestVerificationToken: token,
                FileName: fileName
            },
            dataType: "json",
            success: function (response) {
                if (response.IsSuccess == true) {
                    var Data = JSON.parse(response.Data);
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

//----
function Import() {
    var dialog = $("#ModalImport").dialog({
        autoOpen: false,
        modal: true,
        title: "Act Master",
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
function OnSuccess(e) {
    HandleResponse(e, "dvAddUpdate", "btnReset", "ActID");
    var grid = $("#dvActgrid").data("kendoGrid");
    currentPage = grid.dataSource.page();
    GridData();
}
function OnFailure() {
    alert("Failure");
}
function HistoryGridData(ActId) {
    $.ajax({
        type: "GET",
        url: GetActHistoryUrl,
        contentType: "application/json; charset=utf-8",
        data: {"ActID": ActId },
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess) {
                HistorybindGrid(response.Data);
                var dialog = $("#modalpartial").dialog({
                    autoOpen: false,
                    modal: true,
                    title: "Act Details",
                    width: 1200,
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
        },
        error: function (data) {
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
        columns: [
                    //{ field: "CompID", title: "CompanyID", width: 90 },
                    { field: "Full_Name", title: "Full Name", width: 150 },
                    { field: "Short_Name", title: "Short Name", width: 200 },
                    { field: "Status", title: "Status", width: 150 },
                    { field: "UpdatedOn", title: "Updated On", width: 120 },
                    { field: "UpdatedBy", title: "Updated By", width: 100 },
                    { field: "Action", title: "Action", width: 100 },
        ],
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
        pageable: false,
        filterable: true,
        width: 1150,
        height: 300,
        noRecords: true,
        sortable: true,
        resizable: true
    });
    $("#GridHis .k-grid-content.k-auto-scrollable").css("height", "272px");
}
function GridData() {
    $.ajax({
        type: "GET",
        url: GetActUrl,
        contentType: "application/json; charset=utf-8",
        data: { ActID: 0 },
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess)
                bindGrid(response.Data)
            else
                FailResponse(response);
        },
        error: function (data) {
            alert("Something went wrong.");
        }
    });
}
function bindGrid(Data1) {
    var objAddDiv = $("#dvAdd");
    if (objAddDiv.length > 0) {
        var cmd = {
            command: [{ name: "Edit", text: "", imageClass: "k-icon k-edit", click: EditHandler, title: "Edit" },
                              { name: "View", text: "", imageClass: "k-icon k-view", click: ViewHandler, title: "View" }
            ], title: "Action", width: 100
        };
    }
    else
    {
        var cmd = {
            command: [{ name: "View", text: "", imageClass: "k-icon k-view", click: ViewHandler, title: "View" }
            ], title: "Action", width: 100
        };
    }
    if (kgrid) {
        $('#dvActgrid').kendoGrid('destroy').empty();
    }
    kgrid = $("#dvActgrid").kendoGrid({
        dataSource: {
            pageSize: 15,
            data: JSON.parse(Data1),
            pageable: {
                pageSize: 15
            }
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
                   { field: "Full_Name", title: "Full Name" },
                   { field: "Short_Name", title: "Short Name" },
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
        $('#dvActgrid').data().kendoGrid.dataSource.page(currentPage);
}
function ShowToolTip()
{
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
    $("#btnSubmit").val("Submit");
    $("#ActID").val(0);
    var dialog = $("#dvAddUpdate").dialog({
        autoOpen: false,
        modal: true,
        title: "Act Master",
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
    event.preventDefault();
}

// For Upload popup

function OpenUploadPopup() {
    $("#dvUpload").dialog({
        autoOpen: false,
        width: 500,
        title: "Upload Act",
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

function DownLoadSampleAct() {
    var URL = DownloadSampleActUrl;
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
    var ActID = dataItem.ActID;
    $.get(GetActUrl, { ActID: ActID }, function (response) {
        //console.log(response);
        if (response.IsSuccess) {
            var data = JSON.parse(response.Data)[0];
            $("#lblFull_Name").html(data.Full_Name);
            $("#lblShort_Name").html(data.Short_Name);
            var IsAct = data.IsAct;
            (IsAct == 1) ? $('#lblIsAct').html('Active') : $('#lblIsAct').html('In Active');
            HistoryGridData(ActID);
        }
        else {
            FailResponse(response);
        }
    });
}
var EditHandler = function EditHandler(e) {
    e.preventDefault();
    $("#btnreset").click();
    var dataItem = {};
    dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var ActID = dataItem.ActID;
    $.get(GetActUrl, { ActID: ActID }, function (response) {
        //console.log(response);
        if (response.IsSuccess) {
            var data = JSON.parse(response.Data)[0];
            $("#Full_Name").val(data.Full_Name);
            $("#Short_Name").val(data.Short_Name);
            $("#ActID").val(data.ActID);
            var IsAct = data.IsAct;
            (IsAct == 1) ? $('#IsAct').prop('checked', true) : $('#IsAct').prop('checked', false);
            $("#btnSubmit").val("Update");
            var dialog = $("#dvAddUpdate").dialog({
                autoOpen: false,
                modal: true,
                title: "Act Master",
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
function DownLoadAll() {
    //public ActionResult GetMapppingCount(string CompIDS,string sitesIDs,string ActIds,string ContractorIds)
    var URL = DownloadAllMapppingActUrl;
    window.location = URL;
    return false;
}