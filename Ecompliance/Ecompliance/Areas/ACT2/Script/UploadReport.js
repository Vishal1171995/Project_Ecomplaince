$(document).ready(function () {
    //$("#dvimport").bind("click", {}, OpenUploadPopup);
    //$("#dvExport").bind("click", {}, DownLoadAll);
    //$("#dvAdd").bind("click", {}, OpenAddPopUp);
    //$("#aCompanyTotal").addClass("Active-SnapShot");
    //$("#menu_2").addClass("active-menu");
 
    $("#btnUploadSalary").click(function (event) {
        var fileName = $("#hdnSalaryFileName").val();
        if (fileName.trim() == "") {
            alert("Please select a CSV file");
            return false;
        }
       //var form = $('#form0');
       //var token = $('input[name="__RequestVerificationToken"]', form).val();
     
       var token = $('input[name="__RequestVerificationToken"]').val();
        var Data = { __RequestVerificationToken: token, FileName: fileName };
        $.ajax({
            url: UploadSalaryUrl,
            contentType: "application/x-www-form-urlencoded",
            type: 'POST',
            // data: JSON.stringify(Data),
            data: {
                __RequestVerificationToken: token,
                FileName: fileName
            },
            success: function (response) {
                if (response.IsSuccess == true) {
                    var Data = JSON.parse(response.Data);//.split(",");
                    $("#lblTotSuccess").html(Data["Success"]);
                    $("#lblTotFailed").html(Data["Failed"]);
                    $("#hdnresultFile").val(Data["FileName"]);

                   // $("#dvReport").dialog("close");
                    $("#dvUploadLogSalary").dialog({
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
                    $("#dvUploadLogSalary").dialog("open");
                }
                else {
                    FailResponse(response);
                }
                //$("#dvDetails").show();
            },
            error: function (data) {
                alert("Please try again later!!! Error occured while  binding.");
            }
        });
        
    });

    //Muster RollData Upload
    $("#btnUploadMuster").click(function (event) {
        var fileName = $("#hdnMusterFileName").val();
        if (fileName.trim() == "") {
            alert("Please select a CSV file");
            return false;
        }
       //var form = $('#form0');
       //var token = $('input[name="__RequestVerificationToken"]', form).val();
         var token = $('input[name="__RequestVerificationToken"]').val();
        var Data = { __RequestVerificationToken: token, FileName: fileName };
        $.ajax({
            url: UploadMusterUrl,
            contentType: "application/x-www-form-urlencoded",
            type: 'POST',
            // data: JSON.stringify(Data),
            data: {
                __RequestVerificationToken: token,
                FileName: fileName
            },
            success: function (response) {
                if (response.IsSuccess == true) {
                    var Data = JSON.parse(response.Data);//.split(",");
                    $("#lblMTotSuccess").html(Data["Success"]);
                    $("#lblMTotFailed").html(Data["Failed"]);
                    $("#hdnMusterresultFile").val(Data["FileName"]);

                   // $("#dvReport").dialog("close");
                    $("#dvUploadLogMuster").dialog({
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
                    $("#dvUploadLogMuster").dialog("open");
                }
                else {
                    FailResponse(response);
                }
                //$("#dvDetails").show();
            },
            error: function (data) {
                alert("Please try again later!!! Error occured while  binding.");
            }
        });
        
    });
    //end
    //var form = $('#__AjaxAntiForgeryForm');
    //var form = $('#form0');
    //var token = $('input[name="__RequestVerificationToken"]', form).val();
    var token = $('input[name="__RequestVerificationToken"]').val();
    $("#files").kendoUpload({
        async: {
            saveUrl: FilesUploadUrl,
            //removeUrl: "remove",
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

    $("#Musterfiles").kendoUpload({
        async: {
            saveUrl: MusterFilesUploadUrl,
            //removeUrl: "remove",
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


function DownLoadResultFile() {
    var FileName = $("#hdnresultFile").val();
    var Data = { FileName: FileName };
    var URL = DownLoadSalaryResultFileUrl + '?FileName=' + FileName;
    window.location = URL;
    return false;
}


function DownLoadMusterResultFile() {
    var FileName = $("#hdnMusterresultFile").val();
    var Data = { FileName: FileName };
    var URL = DownLoadMusterResultFileUrl + '?FileName=' + FileName;
    window.location = URL;
    return false;
}
function DownLoadSampleSalary() {
    var URL = DownLoadSampleSalaryUrl;
    window.location = URL;
    return false;
}

function DownLoadSampleMuster() {
    var URL = DownLoadSampleMusterRollUrl;
    window.location = URL;
    return false;
}