var kgrid;
$(document).ready(function () {
    $("#dvimport").bind("click", {}, OpenUploadPopup);
    $("#dvExport").bind("click", {}, DownLoadAll);
    $("#dvAdd").bind("click", {}, OpenAddPopUp);
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
        //var Data = { __RequestVerificationToken: token, FileName: fileName };

        $.ajax({
            type: "POST",
            url: UploadFrequencyUrl,
            contentType: "application/x-www-form-urlencoded",
            //data: Data,
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

                    $("#dialog").dialog("close");
                    $("#log").dialog({
                        autoOpen: false,
                        width: 500,
                        title: "Result",
                        closeText: ""
                    });
                    $("#log").dialog("open");
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

    $("#files").kendoUpload({
        async: {
            saveUrl:FilesUploadUrl,
            removeUrl: "remove",
            autoUpload: true
        },
        upload: function (e) {
            e.data = { Folder: "Temp" };
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
        title: "Manage Frequency",
        width: 909,
        closeText: ""
    });
    dialog.dialog("open");
    event.preventDefault();
}

function OnSuccess(e) {
    HandleResponse(e, "dvFrequency", "btnReset", "ActID");
    GridData();
}

function OnFailure() {
    alert("Failure");
}
function HistoryGridData(FrequecyID) {

    $.ajax({
        type: "GET",
        url:GetFrequencyHistoryUrl,
        contentType: "application/json; charset=utf-8",
        data: { "FrequecyID": FrequecyID },
        success: function (response) {
            if (response.IsSuccess) {
                HistorybindGrid(response.Data);
                var dialog = $("#modalpartial").dialog({
                    autoOpen: false,
                    modal: true,
                    title: "Frequency Details",
                    width: 909,
                    closeText: ""
                });
                dialog.dialog("open");
            }
            else {
                FailResponse(response);
            }
        },
        error: function (data) {
            alert(data.tostring());

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
        pageable: false,
        sortable: true,
        resizable: true
    });
}
function GridData() {
    $.ajax({
        type: "GET",
        url: GetFrequencyUrl,
        contentType: "application/json; charset=utf-8",
        data: { "FrequecyID": "0" },
        success: function (response) {
            if (response.IsSuccess) {
                bindGrid(response.Data)
            }
            else {
                FailResponse(response);
            }
        },
        error: function (data) {
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
    else {
        var cmd = {
            command: [{ name: "View", text: "", imageClass: "k-icon k-view", click: ViewHandler, title: "View" }
            ], title: "Action", width: 100
        };
    }
    kgrid = $("#dvFrequencygrid").kendoGrid({
        dataSource: {
            pageSize: 15,
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
                   { field: "Frequency", title: "Frequency", width: 300 },
                   { field: "IsActNm", title: "Status", width: 100 },
                   cmd
        ],
        height: 400,
        pageable: true,
        filterable: true,
        sortable: true,
        resizable: true
    });

}
function OpenAddPopUp() {
    $("#btnreset").click();
    $("#FrequencyID").val("0");
    var dialog = $("#dvFrequency").dialog({
        autoOpen: false,
        modal: true,
        title: "Frequency Master",
        width: 500,
        closeText: ""
    });
    dialog.dialog("open");
    event.preventDefault();
}
// For Upload popup

function OpenUploadPopup() {
    $("#dialog").dialog({
        autoOpen: false,
        width: 500,
        title: "Upload Frequency",
        closeText: ""
    });
    $("#dialog").dialog("open");
    event.preventDefault();
}

function DownLoadResultFile() {
    var FileName = $("#hdnresultFile").val();
    var Data = { FileName: FileName };
    var URL = DownLoadResultFileUrl + '?FileName=' + FileName;
    window.location = URL;
    return false;
}
function DownloadSampleFrequency() {
    var URL = DownloadSampleFrequencyUrl;
    window.location = URL;
    return false;
}
//Handlers Section
var ViewHandler = function ViewHandler(e) {
    e.preventDefault();
    var dataItem = {};
    dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var FrequencyID = dataItem.FrequencyID;
    $.get(GetFrequencyUrl, { FrequecyID: FrequencyID }, function (response) {
        //console.log(response);
        if (response.IsSuccess) {
            var data = JSON.parse(response.Data)[0];
            $("#lblFull_Name").html(data.Frequency);
            var IsAct = data.IsAct;
            (IsAct == 1) ? $('#lblIsAct').html('Active') : $('#lblIsAct').html('In Active');
            HistoryGridData(FrequencyID);
        }
        else {
            FailResponse(response);
        }
    });
}
//Handlers Section
var EditHandler = function EditHandler(e) {
    e.preventDefault();
    var dataItem = {};
    dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var FrequencyID = dataItem.FrequencyID;
    $.get(GetFrequencyUrl, { FrequecyID: FrequencyID }, function (response) {
        //console.log(response);
        if (response.IsSuccess) {
            var data = JSON.parse(response.Data)[0];
            $("#Name").val(data.Frequency);
            $("#FrequencyID").val(data.FrequencyID);
            var IsAct = data.IsAct;
            (IsAct == 1) ? $('#IsAct').prop('checked', true) : $('#IsAct').prop('checked', false);
            var dialog = $("#dvFrequency").dialog({
                autoOpen: false,
                modal: true,
                title: "Manage Frequency",
                width: 500,
                closeText: ""
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
    var URL = DownloadAllMapppingFrequencyUrl;
    window.location = URL;
    return false;
}