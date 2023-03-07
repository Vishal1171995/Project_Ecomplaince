var kgrid="";
$(document).ready(function () {
    $("#dvimport").bind("click", {}, OpenUploadPopup);
    $("#dvExport").bind("click", {}, DownLoadAll);
    $("#dvAdd").bind("click", {}, OpenAddPopUp);
    $("#aTotalActivity").addClass("Active-SnapShot");
    $("#menu_2").addClass("active-menu");
    GridData(0);
    $('.scrollbox3').enscroll({
        showOnHover: false,
        verticalTrackClass: 'track3',
        verticalHandleClass: 'handle3'
    });
    $("#txtStartDate").datepicker(
         {
             dateFormat: 'dd/mm/yy'
         }
        ).datepicker("setDate", "today");;
    $("#spnfrmDate").click(function () {
        $("#txtStartDate").datepicker('show');//.show();
    });
    $("#txtStartDate").click(function () {
        $("#txtStartDate").datepicker('show');//.show();
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
            //url: '@Url.RouteUrl("UploadActivity")',
            url:UploadActivityUrl,
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
                    $("#dialog").dialog("close");
                    $("#log").dialog({
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
function Validate() {
    var Frequency = $("#Frequency").val();
    var date = new Date();
    var day =  date.getDate();
    var StartDate = $("#txtStartDate").datepicker("getDate");
    //return false;

    if (Frequency == 8 && StartDate.getDate() > 28) {
        $("#txtStartDate").next().next().toggleClass("field-validation-error").toggleClass("field-validation-valid").html("Date cannot be greater than 28 in case of Monthly Frequency !");
        return false;
    }
        
       
    $("#StartDate").next().toggleClass("field-validation-error").toggleClass("field-validation-valid").html("");
    return true;
}
function reset() {
    var validator = $("#myModal").validate();
    validator.resetForm();
}
var currentPage = 0;
function OnSuccess(e) {
    HandleResponse(e, "myModal", "btnReset", "ActivityID");
    var grid = $("#dvActivitygrid").data("kendoGrid");
    currentPage = grid.dataSource.page();
    GridData($("#hdnFilterAct").val());
}
function OnFailure() {
    alert("Failure");
}
function GridData(ActID) {
    $.ajax({
        type: "GET",
        url: GetActivityUrl,
        contentType: "application/json; charset=utf-8",
        data: {ActivityID:0,ActID: ActID },
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess)
                bindGrid(response.Data);
            else
                FailResponse(response);
        },
        error: function (data) {
            alert("error");

        }
    });
}
function bindGrid(Data1) {
    var objAddDiv = $("#dvAdd");
    if (objAddDiv.length > 0) {
        var cmd = {
            command: [{ name: "Edit", text: "", imageClass: "k-icon k-edit", click: EditHandler, title: "Edit" },
                    { name: "View", text: "", imageClass: "k-icon k-view", click: ViewHandler, title: "View" },
                    { name: "Dates", text: "", imageClass: "k-icon k-i-calendar", click: DatesHandler, title: "View" }
            ], title: "Action", width: 120
        };
    }
    else {
        var cmd = {
            command: [{ name: "View", text: "", imageClass: "k-icon k-view", click: ViewHandler, title: "View" },
            { name: "Dates", text: "", imageClass: "k-icon k-i-calendar", click: DatesHandler, title: "View" }
            ], title: "Action", width: 120
        };
    }
    if (kgrid) {
        $('#dvActivitygrid').kendoGrid('destroy').empty();
    }
    kgrid = $("#dvActivitygrid").kendoGrid({
        dataSource: {
            pageSize: 15,
            data: JSON.parse(Data1),
            sort: { field: "Name", dir: "asc" }
        },
        columns: [
                    { field: "Name", title: "Activity" },
                   { field: "ActNm", title: "Act" },
                   { field: "FrequencyNm", title: "Frequency", width: 110 },
                   { field: "StartDate", title: "StartDate", width: 100 },                   
                   { field: "Status", title: "Status", width: 82 },
                   cmd
        ]
        ,
        height: 400,
        dataBound: ShowToolTip,
        noRecords: true,
        pageable: { pageSizes: true },
        filterable: true,
        groupable: true,
        sortable: true,
        reorderable: true,
        resizable: true
    });
    if (currentPage != 0)
        $('#dvActivitygrid').data().kendoGrid.dataSource.page(currentPage);
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
var kgrid2;
function bindGridScheduledDates(Data1) {
    if (kgrid2) {
        $('#gvScheduledDates').kendoGrid('destroy').empty();
    }
    kgrid2 = $("#gvScheduledDates").kendoGrid({
        dataSource: {
            data: Data1
        },
        columns: [{ field: "ScheduledDates", title: "Scheduled Dates" },
         { field: "Day", title: "Day" }],
        pageable: false,
        filterable: false,
        sortable: false,
        resizable: true, height: 200,
    });
}
function HistoryGridData(ActivityID) {
    $.ajax({
        type: "GET",
        url: GetActivityHistoryUrl,
        contentType: "application/json; charset=utf-8",
        data: { ActivityID: ActivityID },
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess) {
                HistorybindGrid(response.Data);
                var dialog = $("#modalpartial").dialog({
                    autoOpen: false,
                    modal: true,
                    title: "Activity Details",
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
                    { field: "Act", title: "Act", width: 150 },
                    { field: "Activity", title: "Activity", width: 200 },
                    { field: "Frequency", title: "Frequency", width: 80 },
                    { field: "Date", title: "Date", width: 50 },
                    { field: "Month", title: "Month", width: 50 },
                    { field: "Year", title: "Year", width: 50 },
                    { field: "RemindDays", title: "Remind Days", width: 100 },
                    { field: "Status", title: "Status", width: 50 },
                    { field: "UpdatedBy", title: "Updated By", width: 100 },
                    { field: "UpdatedOn", title: "Updated On", width: 150 },
                    { field: "Action", title: "Action", width: 50 },

        ],
        dataBound: function (e) {
            var grid = e.sender;
            if (grid.dataSource.total() == 0) {
                var colCount = grid.columns.length;
                //$(e.sender.wrapper)
                //    .find('tbody')
                //    .append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data"><span style="margin-left:46%;">No data found.</span></td></tr>');
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
        width: 1150,
        height: 300,
        noRecords: true,
        sortable: true,
        resizable: true
    });
    $("#GridHis .k-grid-content.k-auto-scrollable").css("height", "272px");
}
function OpenAddPopUp() {
    $("#btnreset").click();
    $("#btnSubmit").val("Submit");
    $("#ActivityID").val(0);
    $('#IsAct').prop('checked', true)
    //$("#ChkActive").attr("checked",true);
    var dialog = $("#myModal").dialog({
        autoOpen: false,
        modal: true,
        title: "Activity Master",
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
    $("#txtStartDate").datepicker("setDate", new Date());
    //  $("#txtStartDate").val("10/01/2017")
    dialog.dialog("open");
    event.preventDefault();
}
// For Upload popup
function OpenUploadPopup() {
    $("#dialog").dialog({
        autoOpen: false,
        width: 500,
        title: "Upload Activity",
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
function DownLoadSampleActivity() {
    //public ActionResult GetMapppingCount(string CompIDS,string sitesIDs,string ActIds,string ContractorIds)
    var URL = DownloadSampleActivityUrl;
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
    var ActivityID = dataItem.ActivityID;
    $.get(GetActivityUrl, { ActivityID: ActivityID, ActID: 0 }, function (response) {
        //console.log(response);
        if (response.IsSuccess) {
            var data = JSON.parse(response.Data)[0];
            $("#lblAct").html(data.ActNm);
            $("#lblName").html(data.Name);
            $("#lblFrequency").html(data.FrequencyNm);
            $("#lblStartDate").html(data.StartDate);
            $("#lblRemindDays").html(data.RemindDays);
            $("#lblDesc").html(data.Activity_Desc);
            var IsAct = data.IsAct;
            (IsAct == 1) ? $('#lblIsAct').html('Active') : $('#lblIsAct').html('In Active');
            var Ext_Exp_Date = data.Extendable_Exp_Date;
            (Ext_Exp_Date == 1) ? $('#lblExt_Exp_Date').html('Active') : $('#lblExt_Exp_Date').html('In Active');
            
            HistoryGridData(ActivityID);
        }
        else {
            FailResponse(response);
        }
    });
}
var EditHandler = function EditHandler(e) {
    e.preventDefault();
    $("#btnreset").click();
    var dataItem;
    dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var ActivityID = dataItem.ActivityID;
    $.get(GetActivityUrl, { ActivityID: ActivityID, ActID: 0 }, function (response) {
        //console.log(response);
        if (response.IsSuccess) {
            var data = JSON.parse(response.Data)[0];
            $("#Act").val(data.Act);
            $("#Name").val(data.Name);
            $("#Activity_Desc").val(data.Activity_Desc);
        
            $("#Frequency").val(data.Frequency);
            $("#RemindDays").val(data.RemindDays);
            $("#ActivityID").val(data.ActivityID);
            $("#txtStartDate").val(data.StartDate);
            $("#Compliance_Nature").val(data.Compliance_Nature);
            var Ext_Exp_Date = data.Extendable_Exp_Date;
            (Ext_Exp_Date == 1) ? $('#Extendable_Exp_Date').prop('checked', true) : $('#Extendable_Exp_Date').prop('checked', false);
            var IsAct = data.IsAct;
            (IsAct == 1) ? $('#IsAct').prop('checked', true) : $('#IsAct').prop('checked', false);
            $("#btnSubmit").val("Update");
            var dialog = $("#myModal").dialog({
                autoOpen: false,
                modal: true,
                title: "Activity Master",
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
        }
        else {
            FailResponse(response);
        }
    });
    return false;
}
var DatesHandler = function DatesHandler(e) {
    e.preventDefault();
    var dataItem;
    dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var ActivityID = dataItem.ActivityID;
    if (dataItem.Frequency == 9) {
        alert("No View Available for Activity having Frequency 'As Needed' !");
        return;
    }
    $("#lblActScheudled").html(dataItem.ActNm);
    $("#lblActivityScheudled").html(dataItem.Name);
    $("#lblFrequencyScheudled").html(dataItem.FrequencyNm);
    $("#lblSDateScheudled").html(dataItem.StartDate);
    $("#lblRemindDaysScheudled").html(dataItem.RemindDays);
    var frequency = dataItem.Frequency;
    var reminddays = dataItem.RemindDays;
    var SDate = dataItem.StartDate;

    var Data = { Frequency: frequency, RemindDays: reminddays, StartDate: SDate };
    $.ajax({
        type: "GET",
        url: GetScheduledDatesUrl,
        contentType: "application/json; charset=utf-8",
        data: Data,
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess == true) {

                var Data = JSON.parse(response.Data);

                bindGridScheduledDates(Data);
                $("#dvScheduledDateslist").dialog({
                    autoOpen: false,
                    width: 800,
                    height: 400,
                    title: "Scheduled Dates",
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
                $("#dvScheduledDateslist").dialog("open");
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
function FilterGrid(ActID, id) {
    $("a").removeClass("Active-SnapShot");
    $("#" + id).addClass("Active-SnapShot");
    $("#hdnFilterAct").val(ActID);
    currentPage = 0;
    GridData(ActID);
}
function DownLoadAll() {
    //public ActionResult GetMapppingCount(string CompIDS,string sitesIDs,string ActIds,string ContractorIds)
    var URL = DownloadAllMapppingActivityUrl;
    window.location = URL + "?ActID=" + $("#hdnFilterAct").val() + "";
    return false;
}