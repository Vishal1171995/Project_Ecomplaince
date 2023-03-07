﻿var ObjSite = "";
var ObjActs = "";
var ObjContractor = "";
$(document).ready(function () {
    $("#menu_2").addClass("active-menu");
    $("#btnShow").bind("click", {}, GetMapping);
    $("#btnUploadOpen").click(btnUploadClick);

    $("#ddlcompany").change(function () {
        var Company = $(this).val();
        BindSite(Company);
    });

    ObjActs = $("#ddlAct").kendoMultiSelect({
        autoClose: false
    }).data("kendoMultiSelect");
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
        showFileList: true
    });
    $("#btnAllSite").click(SelectALLSites);
    $("#btnAllActs").click(SelectALLActs);
    $("#btnAllContracotor").click(SelectALLContractors);
});
function SelectALLSites() {
    var multiSelect = $("#ddlSite").data("kendoMultiSelect");
    var selectedValues = "";
    var strComma = "";
    for (var i = 0; i < multiSelect.dataSource.data().length; i++) {
        var item = multiSelect.dataSource.data()[i];
        selectedValues += strComma + item.SiteID;
        strComma = ",";
    }
    multiSelect.value(selectedValues.split(","));
}

function SelectALLActs() {
    var multiSelect = $("#ddlAct").data("kendoMultiSelect");
    var selectedValues = "";
    var strComma = "";
    for (var i = 0; i < multiSelect.dataSource.data().length; i++) {
        var item = multiSelect.dataSource.data()[i];
        selectedValues += strComma + item.value;
        strComma = ",";
    }
    multiSelect.value(selectedValues.split(","));
}
function BindSite(CompID) {
    var Data = { CompID: CompID };
    $.ajax({
        type: "GET",
        url: GetSiteOfCompPEUrl,
        contentType: "application/json; charset=utf-8",
        data: Data,
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess) {
                var res = response.Data;
                var data;
                //dvSite
                $("#dvSite").html("");
                var str = '<select id="ddlSite"   multiple="multiple" data-placeholder="Select site..." >' +
                           '</select>';
                $("#dvSite").html(str);
                if (response.IsSuccess == true) {
                    data = $.parseJSON(res);
                }
                else {
                    data = { "Name": "-----Select-------", "SiteID": "0" };
                }
                ObjSite = $("#ddlSite").kendoMultiSelect({
                    dataTextField: "Name",
                    dataValueField: "SiteID",
                    dataSource: data,
                    autoClose: false
                }).data("kendoMultiSelect");
            }
            else {
                FailResponse(response);
            }
        },
        error: function (data) {
            alert("Please try again later!!! Error occured while  binding.");
        }
    });
}

function GetMapping() {
    var CompIDS = "0";
    CompIDS = $("#ddlcompany").val();
    if (CompIDS == "0") {
        alert("Please select company");
        return;
    }
    var sitesIDs = ObjSite.value() + "";
    var ActIds = ObjActs.value() + "";

    if (sitesIDs == "") {
        alert("Please select site");
        return;
    }
    if (ActIds == "") {
        alert("Please select act");
        return;
    }
    var Data = { CompIDS: CompIDS, sitesIDs: sitesIDs, ActIds: ActIds };
    $.ajax({
        type: "POST",
        url: GetMapppingCountPEUrl,
      //  contentType: "application/json; charset=utf-8",
        data: Data,
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess == true) {
                var Data = response.Data.split(",");
                $("#spnTotalRecord").html(Data[0]);
                $("#spnTotalSchTask").html(Data[1]);
                $("#spnTotalUnSchTask").html(Data[2]);
                $("#spnTotalInActSchTask").html(Data[3]);
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
    return false;

}

function DownLoadAllMapping() {
    //public ActionResult GetMapppingCount(string CompIDS,string sitesIDs,string ActIds,string ContractorIds)
    var CompIDS = "0";
    var sitesIDs = ObjSite.value() + "";
    var ActIds = ObjActs.value() + "";
       
    var Data = { CompIDS: CompIDS, sitesIDs: sitesIDs, ActIds: ActIds };
    var URL = DownloadAllMapppingPEUrl + '?sitesIDs=' + sitesIDs + '&ActIds=' + ActIds;
    window.location = URL;
    return false;
}

function DownLoadAllScheduled() {
    //public ActionResult GetMapppingCount(string CompIDS,string sitesIDs,string ActIds,string ContractorIds)
    var CompIDS = "0";
    var sitesIDs = ObjSite.value() + "";
    var ActIds = ObjActs.value() + "";
      
    var Data = { CompIDS: CompIDS, sitesIDs: sitesIDs, ActIds: ActIds };
    var URL = DownloadAllScheduledPEUrl + '?sitesIDs=' + sitesIDs + '&ActIds=' + ActIds;
    window.location = URL;
    return false;
}
function DownLoadAllUnScheduled() {
    //public ActionResult GetMapppingCount(string CompIDS,string sitesIDs,string ActIds,string ContractorIds)
    var CompIDS = "0";
    var sitesIDs = ObjSite.value() + "";
    var ActIds = ObjActs.value() + "";
       
    var Data = { CompIDS: CompIDS, sitesIDs: sitesIDs, ActIds: ActIds };
    var URL = DownloadAllUnScheduledPEUrl + '?sitesIDs=' + sitesIDs + '&ActIds=' + ActIds;
    window.location = URL;
    return false;
}
function DownLoadAllInActive() {
    var CompIDS = "0";
    var sitesIDs = ObjSite.value() + "";
    var ActIds = ObjActs.value() + "";
      
    var Data = { CompIDS: CompIDS, sitesIDs: sitesIDs, ActIds: ActIds };
    var URL = DownloadAllInActivePEUrl + '?sitesIDs=' + sitesIDs + '&ActIds=' + ActIds;
    window.location = URL;
    return false;
}
function DownLoadResultFile() {
    var FileName = $("#hdnresultFile").val();
    var Data = { FileName: FileName };
    var URL = DownLoadResultFilePEUrl + '?FileName=' + FileName;
    window.location = URL;
    return false;
}
function btnUploadClick() {
    
    var dialog = $("#dialog").dialog({
        autoOpen: false,
        modal: true,
        title: "Upload Mapping",
        width: 600,
        closeText: ""
    });
    dialog.dialog("open");
}
//anchALLTaskDownload

function onSuccess(e) {
    var name = this.name;
    var target = $("#" + name).attr("target-control");
    if (e.operation == 'upload') {
        var responseData = e.response;
        if (responseData.IsSuccess == true) {
            var res = $.parseJSON(responseData.Data);
            var Filename = res.new;
            var original = res.original;
            $("#" + target).val(Filename);
            $(".k-upload-pct").remove();
        }
        else {
            $(".k-upload-files.k-reset").find("li").remove();
            $("#" + target).val("");
            alert(responseData.Message);
        }
    }
}
function onError(e) {
    $(".k-upload-files.k-reset").find("li").remove();
}
function onRemove(e) {
    var name = this.name;
    var target = $("#" + name).attr("target-control");
    $(".k-upload-files.k-reset").find("li").remove();
    $(".k-upload-status.k-upload-status-total").remove();
    $("#" + target).val("");
}

$("#dialog").dialog({
    autoOpen: false,
    width: 500,
    title: "Upload Mapping",
    closeText: ""
});
$("#log").dialog({
    autoOpen: false,
    width: 500,
    title: "Result",
    closeText: ""
});
// Link to open the dialog
$("#link").click(function (event) {
    var company = $("#ddlcompany").val();
    if (company == "0") {
        alert("Please select a company");
        return false;
    }
    onRemove($("#file"));
    $("#hdnFIleName").val("");
    $("#dialog").dialog("open");
    $('.ui-dialog-titlebar').show();
    event.preventDefault();
});


$("#load").click(function (event) {
    $("#log").dialog("open");
    $('.ui-dialog-titlebar').show();
    event.preventDefault();
});
$("#tbnUpload").click(function (event) {
    var fileName = $("#hdnFIleName").val();
    if (fileName.trim() == "") {
        alert("Please select a CSV file");
        return false;
    }
    var company = $("#ddlcompany").val();
    if (company == "0") {
        alert("Please select a company");
        return false;
    }
    var form = $('#__AjaxAntiForgeryForm');
    var token = $('input[name="__RequestVerificationToken"]', form).val();

    var Data = { __RequestVerificationToken: token, fileName: fileName, CompID: company };
    $.ajax({
        type: "POST",
        url: UploadMappingPEUrl,
        contentType: "application/x-www-form-urlencoded",
        //data: Data,
        data: {
            __RequestVerificationToken: token,
            fileName: fileName,
            CompID: company
        },
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess == true) {
                //spnTotalInActSchTask spnTotalUnSchTask spnTotalSchTask spnTotalRecord
                var Data = JSON.parse(response.Data);//.split(",");
                // alert(Data);
                $("#lblTotSuccess").html(Data["Success"]);
                $("#lblTotFailed").html(Data["Failed"]);
                $("#hdnresultFile").val(Data["FileName"]);
                $("#dialog").dialog("close");
                $("#log").dialog("open");
                $('.ui-dialog-titlebar').show();
            }
            else
            {
                FailResponse(response);
            }
            $("#dvDetails").show();
        },
        error: function (data) {
            alert("Please try again later!!! Error occured while  binding.");
        }
    });
});