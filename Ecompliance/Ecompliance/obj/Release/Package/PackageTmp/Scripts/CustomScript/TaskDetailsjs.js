var FileUploadID = "";

$("#dialog").dialog({
    autoOpen: false,
    width: 600,
    modal: true,
    title: "Send To Verify",
    closeText: ""
});

// Link to open the dialog
$("#link").click(function (event) {
    $("#dialog").dialog("open");
    event.preventDefault();
});

$("#verify-link").click(function (event) {
    AttachDocPopUp();
    event.preventDefault();
});
function AttachDocPopUp() {
    $("#log").dialog({
        autoOpen: false,
        modal: true,
        width: 700,
        title: "Attach Document",
        closeText: ""

    });
    GetTaskFiles("fileToUpload");
    $("#log").dialog("open");
}
$(document).ready(function () {
    $("#btnAttachOK").bind('click', function () {
        $("#log").dialog("close");
    });
    var form = $('#__AjaxAntiForgeryForm');
    var token = $('input[name="__RequestVerificationToken"]', form).val();
    $("#fileToUpload,#ApprovefileToUpload,#ReconsiderfileToUpload").kendoUpload({
        async: {
            saveUrl: UploadTaskFileUrl,
            removeUrl: "remove",
            autoUpload: true
        },
        upload: function (e) {
            e.data = { __RequestVerificationToken: token, DOCID: Item1DOCID };
        },
        multiple: true,
        success: onSuccess,
        remove: onRemove,
        showFileList: false
    });

    $("#txtActivityCompDate").kendoDatePicker(
        {
            format: 'dd/MM/yyyy',
            width: 500,
            value: new Date()
        });
    $("#txtExpDate").datepicker({
        //comment the beforeShow handler if you want to see the ugly overlay
        beforeShow: function () {
            setTimeout(function () {
                $('.ui-datepicker').css('z-index', 99999999999999);
            }, 0);
        }
        ,
        dateFormat: 'dd/mm/yy'
    });
    $('#spnEdate').click(function () {
        $("#txtExpDate", $(this).closest(".input-group")).focus();
    });

    $("#lnkApprove").click(function (event) {
        GetTaskFiles("ApprovefileToUpload");
        $("#dvApprove").dialog({
            width: 800,
            modal: true,
            title: "Approve",
            closeText: ""
        });
        event.preventDefault();
    });
    $("#linkReconsider").click(function (event) {
        GetTaskFiles("ReconsiderfileToUpload");
        $("#dvReconsider").dialog({
            width: 600,
            modal: true,
            title: "Reconsider",
            closeText: ""
        });
        event.preventDefault();
    });
    $("#txtExtendedExpDate").datepicker({
        //comment the beforeShow handler if you want to see the ugly overlay
        beforeShow: function () {
            setTimeout(function () {
                $('.ui-datepicker').css('z-index', 99999999999999);
            }, 0);
        },
        dateFormat: 'dd/mm/yy',
        minDate: +1,
    });
    $('#spnExtExpdate').click(function () {
        $("#txtExtendedExpDate", $(this).closest(".input-group")).focus();
    });
    $("#liExtendExpDate").click(function (event) {
        $.get(GetExtExPDateUrl, { DocID: Item1DOCID }, function (response) {
            var Dt = JSON.parse(response.Data);
            $("#txtExtendedExpDate").val(Dt[0].Expiry_Date);
            $("#txtRemarks").val(Dt[0].ExtendableExpDate);
            $("#dvExtendExpDate").dialog({
                width: 600,
                modal: true,
                title: "Extend Expiry Date",
                closeText: ""
            });
            event.preventDefault();
        });
    });
    $("#btnExtendedExpSubmit").click(function () {
        var ExtendedExpDate = $.trim($("#txtExtendedExpDate").val());
        var Remarks = $.trim($("#txtRemarks").val());
        if (ExtendedExpDate == "") {
            alert("Please select extednded expiry date");
            return;
        }
        if (Remarks == "") {
            alert("Please enter remarks.");
            return;
        }
        var form = $('#__AjaxAntiForgeryForm');
        var token = $('input[name="__RequestVerificationToken"]', form).val();

        $.post(SetExtExpDateUrl, { __RequestVerificationToken: token, ExtendedExpDate: ExtendedExpDate, Remarks: Remarks, DocID: Item1DOCID }, function (response) {
            if (response.IsSuccess) {
                var result = response.Data;
                if (result == "-1") {
                    createErrPOP("Expiry date shuld be greater than current date.");
                }
                else if (result == "-2")
                    createErrPOP("Sorry! error occured in server. Please try again.");
                else if (result == "-3")
                    createErrPOP("Please enter ramarks.");
                else {
                    createSuccessPOPForTask("Expiry date changed successfully.");
                    $("#btnReset").click();
                }
            }
        });
    });
    $("#liExtendExpDateHis").click(function () {
        var kgridHis = "";
        $.get(GETExtendedExpDateHisUrl, { DocID: Item1DOCID }, function (response) {
            if (response.IsSuccess) {
                kgridHis = $("#KgridExtendExpDateHis").kendoGrid({
                    dataSource: {
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
                        { field: "User_Name", title: "Extend By", width: 100 },
                        { field: "UpdatedOn", title: "Extend On", width: 100 },
                        { field: "Expiry_Date", title: "Expiry Date", width: 100 },
                        { field: "Extendable_Exp_Date_Remark", title: "Remarks", width: 200 },
                        { field: "Action", title: "Action", width: 150 },

                    ],
                    height: 200,
                    pageable: false,
                    filterable: false,
                    sortable: true,
                    resizable: true
                });
                $("#dvExtendExpDateHis").dialog({
                    width: 750,
                    modal: true,
                    title: "Extend Expiry Date History",
                    closeText: ""
                });
            }
        });
    });
});

function onSuccess(e) {
    var uploaderid = e.sender.element[0].id;
    if (e.operation == 'upload') {
        var responseData = e.response;
        if (responseData.IsSuccess == true) {
            GetTaskFiles(uploaderid);
        }
        else {
            alert(responseData.Data);
        }
    }
}
function onError(e) {
    $(".k-upload-files.k-reset").find("li").remove();
}
function onRemove(e) {
    $(".k-upload-files.k-reset").find("li").remove();
}
function GetTaskFiles(uploaderid) {
    FileUploadID = uploaderid;
    var data = { DOCID: Item1DOCID, FileID: 0 };
    $.ajax({
        type: "GET",
        url: GetTaskFilesUrl,
        contentType: "application/json; charset=utf-8",
        data: data,
        dataType: "json",
        success: function (response) {


            if (uploaderid == "fileToUpload") {
                if (kgrid != "") {
                    $('#dvAttachGrd').kendoGrid('destroy').empty();
                }
                BindAttachGrid(response.Data)
            }
            else if (uploaderid == "ReconsiderfileToUpload") {
                if (kgridReconsider != "") {
                    $('#dvReconsiderAttachGrd').kendoGrid('destroy').empty();
                }
                BindReconsiderAttachGrid(response.Data);
            }
            else {
                if (kgridApprove != "") {
                    $('#dvApproveAttachGrd').kendoGrid('destroy').empty();
                }
                BindApproveAttachGrid(response.Data);
            }
        },
        error: function (data) {
            alert('Error');
        }
    });
}
var kgrid = "";
function BindAttachGrid(Data1) {
    kgrid = $("#dvAttachGrd").kendoGrid({
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
        },
        columns: [
            { field: "Desc", title: "File Description" },
            { field: "UserName", title: "Uploaded By" },
            { field: "UploadedOn", title: " Uploaded On" },
            {
                command: [{ name: "Download", width: "25px", text: "", imageClass: "k-icon k-filedelete", click: Deletefile, title: "Delete" },
                { name: "Delete", text: "", imageClass: "k-icon k-filedownload", click: Download, title: "Download" }
                ], title: "Action", width: 150
            }
        ],
        dataBound: ShowToolTip,
        height: 200,
        pageable: false,
        filterable: false,
        sortable: true,
        resizable: true
    });
}
//Approve File Grid=====================
var kgridApprove = "";
function BindApproveAttachGrid(Data1) {
    kgridApprove = $("#dvApproveAttachGrd").kendoGrid({
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
        },
        columns: [
            { field: "Desc", title: "File Description" },
            { field: "UserName", title: "Uploaded By" },
            { field: "UploadedOn", title: " Uploaded On" },
            {
                command: [{ name: "Download", width: "25px", text: "", imageClass: "k-icon k-filedelete", click: Deletefile, title: "Delete" },
                { name: "Delete", text: "", imageClass: "k-icon k-filedownload", click: Download, title: "Download" }
                ], title: "Action", width: 150
            }
        ],
        dataBound: ShowToolTip,
        height: 200,
        pageable: false,
        filterable: false,
        sortable: true,
        resizable: true
    });
}

//======================================
//Approve File Grid=====================

var kgridReconsider = "";
function BindReconsiderAttachGrid(Data1) {
    kgridReconsider = $("#dvReconsiderAttachGrd").kendoGrid({
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
        },
        columns: [
            { field: "Desc", title: "File Description" },
            { field: "UserName", title: "Uploaded By" },
            { field: "UploadedOn", title: " Uploaded On" },
            {
                command: [{ name: "Download", width: "25px", text: "", imageClass: "k-icon k-filedelete", click: Deletefile, title: "Delete" },
                { name: "Delete", text: "", imageClass: "k-icon k-filedownload", click: Download, title: "Download" }
                ], title: "Action", width: 150
            }
        ],
        dataBound: ShowToolTip,
        height: 200,
        pageable: false,
        filterable: false,
        sortable: true,
        resizable: true
    });
}
function ShowToolTip() {
    $(".k-icon.k-filedelete").parent().attr("title", "Delete");

    $(".k-icon.k-filedelete").parent().kendoTooltip({
        width: 60,
        position: "top"
    }).data("kendoTooltip");

    $(".k-icon.k-filedownload").parent().attr("title", "Download");

    $(".k-icon.k-filedownload").parent().kendoTooltip({
        width: 60,
        position: "top"
    }).data("kendoTooltip");
}
//======================================
//filedownload filedelete
function Deletefile(e) {
    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var FileID = dataItem.FileID;
    var DocID = dataItem.DOCID;

    var form = $('#__AjaxAntiForgeryForm');
    var token = $('input[name="__RequestVerificationToken"]', form).val();

    var data = { __RequestVerificationToken: token, DOCID: DocID, FileID: FileID };

    if (confirm("You want to delete this file")) {
        $.ajax({
            type: "POST",
            url: RemoveTaskFileUrl,
            contentType: "application/x-www-form-urlencoded",
            data: data,
            dataType: "json",
            success: function (response) {
                if (response.IsSuccess) {
                    GetTaskFiles(FileUploadID);
                }
            },
            error: function (data) {
                alert('Error');
            }
        });
    }
}
function Download(e) {
    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var FileID = dataItem.FileID;
    var DocID = dataItem.DOCID;

    var data = { DOCID: DocID, FileID: FileID };
    var URL = DownloadTaskFileUrl + '?DOCID=' + DocID + '&FileID=' + FileID;
    window.location = URL;

}

function DownloadFile(FileID, DocID) {
  
    var data = { DOCID: DocID, FileID: FileID };
    var URL = DownloadTaskFileUrl + '?DOCID=' + DocID + '&FileID=' + FileID;
    window.location = URL;
  
}



function DownloadFile_Integration(Name, Integration_TID) {
    $.get(GetHashCodeUrl, { Hash: Name }, function (Data) {
        console.log();
        window.location = 'http://g4sact.myndsolution.com/getfile.aspx?hash=' + JSON.stringify(Data) + '&tid=' + Integration_TID;
    });
}


window.onunload = function () {
    var win = window.opener;
    if (!win.closed) {
        win.childClose();
    }
};
jQuery(function ($) {
    $.validator.addMethod('date',
        function (value, element) {
            if (this.optional(element)) {
                return true;
            }
            var ok = true;
            try {
                $.datepicker.parseDate('dd/mm/yy', value);
            }
            catch (err) {
                ok = false;
            }
            return ok;
        });
});

function SuccessMessage(e) {
    if (e.IsSuccess == true) {
        if (e.Data == "-1") {
            createErrPOP("Invalid action.");
        }
        else if (e.Data == "-2")
            createErrPOP("Sorry! error occured in server. Please try again.");
        else {
            createSuccessPOPForTask("Task verify send successfully.");
            $("#btnReset").click();
        }
    }
}
function FailMessage() {
    alert("Fail Post");
}
function Validate() {
    var ActivityCompDate = $("#txtActivityCompDate").val();
    var arrDate = ActivityCompDate.split("/");
    ActivityCompDate = arrDate[1] + "/" + arrDate[0] + "/" + arrDate[2];
    var Today = new Date();
    Today.setHours(0, 0, 0, 0);
    var dt = new Date(ActivityCompDate);
    var DelayReason = $("#ddlDelayReason").val();
    if (dt < Today && DelayReason == "0") {
        $("#ddlDelayReason").next().toggleClass("field-validation-error").toggleClass("field-validation-valid").html("Please select a delayReason");
        return false;
    }
    else {
        $("#ddlDelayReason").next().toggleClass("field-validation-error").toggleClass("field-validation-valid").html("");
        return true;
    }
}
$(document).ready(function () {

    $("#btnReconsider").click(function () {
        var Remarks = $("#txtReconsiderRemarks").val();
        $("#txtReconsiderRemarks").next().toggleClass("field-validation-error").toggleClass("field-validation-valid").html("");
        if (Remarks != "") {
            var form = $('#__AjaxAntiForgeryForm');
            var token = $('input[name="__RequestVerificationToken"]', form).val();

            $.post(ReconsiderUrl, { __RequestVerificationToken: token, Remarks: Remarks, DocID: Item1DOCID }, function (response) {
                if (response.IsSuccess) {
                    var result = response.Data;
                    if (result == "-1") {
                        createErrPOP("Invalid action.");
                    }
                    else if (result == "-2")
                        createErrPOP("Sorry! error occured in server. Please try again.");
                    else if (result == "-3")
                        createErrPOP("Please enter ramarks.");
                    else {
                        createSuccessPOPForTask("Reconsider successfully.");
                        $("#btnReset").click();
                    }
                }
            });
        }
        else {
            createErrPOP("Please enter ramarks.");
        }
    });

    $("#aVM").click(function () {
        var desc = $("#hdnVM").val();
        $("#dvContant").html(desc);
        $("#dvViewMore").dialog({
            closeOnEscape: false,
            modal: true,
            title: "Description",
            width: 425,
            closeText: ""
        });
    });
});
function openRemarksPopup(Remarks) {
    $("#dvContant").html(Remarks);
    $("#dvViewMore").dialog({
        closeOnEscape: false,
        modal: true,
        title: "Remarks",
        width: 425,
        closeText: ""
    });
}
function createSuccessPOPForTask(strMsg) {
    debugger;
    var rlDiv = document.getElementById("popSuccessTask");
    var objDiv = null;
    if (rlDiv == null) {
        var strHTML = "<div id=\"popSuccessTask\" class=\"popError\" style=\"display: none;\">" +
            "<div class='popwrapper'>" +
            //"<div class=\"header sucMsg\"><img src=\"../../content/images/iconCheck.png\" alt=\"\">Success</div>" +
            "<div></div><br/>" +
            "<p style='margin:10px 0 40px 0; float:left; color: green; font-weight: bold;' id=\"popSucMsg\">" + strMsg + "</p>" +
            "</div>" +
            "<div class='footer'>" +
            //"<div class='tip'></div>" +
            "<div><input name=\"\" id=\"btnSuccessOK\" type=\"button\" value=\"Ok\" class=\"ok button\" onclick=\"javascript:window.location = self.location;\"></div>" +
            "</div>" +
            "</div>";
        objDiv = document.createElement('div');
        objDiv.setAttribute('id', 'RLWrapper');
        objDiv.style.display = "none";
        objDiv.innerHTML = strHTML;
        document.body.appendChild(objDiv);
    }
    else {
        $('#popSuccessTask').html(strMsg);
    }
    $("#popSuccessTask").dialog({
        closeOnEscape: false,
        modal: true,
        title: "Success",
        width: 425
    });
    $('#popSuccessTask').parent().children().children('.ui-dialog-titlebar-close').hide();
    //$('.ui-dialog-titlebar-close').show();
}