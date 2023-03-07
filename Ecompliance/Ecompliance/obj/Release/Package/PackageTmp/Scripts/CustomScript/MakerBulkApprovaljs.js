$(document).ready(function () {
    BindGrid();
    //$('.k-button').href( 'javascript:void(0)');
});
var Kgrid = "";
function BindGrid() {
    var url = GetMyTaskUrl;
    //var typepar = '@ViewBag.Type';
    var type1 = GetParameterValues('Type');
    var CompID = GetParameterValues('compID');
    var SMonth = GetParameterValues('SMonth');
    var TMonth = GetParameterValues('TMonth');
    var Syear = GetParameterValues('Syear');
    var Tyear = GetParameterValues('Tyear');
    if (CompID == null) CompID = 0;
    if (SMonth == null) SMonth = 0;
    if (TMonth == null) TMonth = 0;
    if (Syear == null) Syear = 0;
    if (Tyear == null) Tyear = 0;
    if (Kgrid != "") {
        $('#dvgrid').kendoGrid('destroy').empty();
    }
    Kgrid = $("#dvgrid").kendoGrid({
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
                        Type: typepar,
                        CompID: CompID,
                        SMonth: SMonth,
                        TMonth: TMonth,
                        Syear: Syear,
                        Tyear: Tyear,
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
                        CompName: { type: "string" },
                        SiteName: { type: "string" },
                        ActName: { type: "string" },
                        ActivityName: { type: "string" },
                    }
                },
                data: function (data) {
                    var res = $.parseJSON(data.Data);
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
                        var res = $.parseJSON(data.Data);
                        if (res.Data.length > 0) {
                            return res.Total || [];
                        }
                    }
                    else {
                        FailResponse(data);
                    }
                }
            },
            pageSize: 10,
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        },
        dataBound: ShowToolTip,
        noRecords: true,
        groupable: false,
        resizable: true,
        height: 350,
        filterable: true,
        toolbar: [{ name: "excel" }],
        excel: {
            fileName: "MyTask.xlsx",
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
            //{ command: [{ name: "View", text: "", imageClass: "k-icon k-view", click: ViewHandler, title: "View" }], title: "View", width: 60 },
            { title: "<input id='chkAll' class='checkAllCls' type='checkbox'/>", width: "35px", template: "<input type='checkbox' class='check-box-inner' />", filterable: false },
            { template: '<a href="javascript:ViewDetails(#=DOCID#)">#=DOCID#</a>', field: "DOCID", title: "DocID", width: 80 },
            { field: "CompName", title: "Company", width: 100 },
            { field: "SiteName", title: "Site", width: 100 },
            { field: "ActName", title: "Act", width: 100 },
            { field: "ActivityName", title: "Activity", width: 150 },
            { field: "ActivityCompDate", title: "Completion Date", width: 150, template: "<input name='CompDate' type='text' class='CompDate' />", filterable: false },
            { field: "DelayReason", title: "Delay Reason", width: 150, template: "<input class='dropDownTemplate DelayReason'/>", filterable: false },
            { field: "MakerRemarks", title: "Maker Remarks", width: 150, template: "<textarea cols='2' rows='2' class='k-textbox MakerRemarks'></textarea>", filterable: false },
            { field: "MakerFile", title: "Upload", width: 200, template: "<input type='file' attr-DocID ='#=DOCID#'  name='fileToUpload' class='ApprovefileToUpload'>", filterable: false }
        ]
    });
    if (Kgrid != "") {
        if (filtersNeedToAct != null) {
            $("#dvgrid").data("kendoGrid").refresh();
            $("#dvgrid").data("kendoGrid").dataSource.filter(filtersNeedToAct);
        }

        $(".checkAllCls").on("click", function () {
            var ele = this;
            var state = $(ele).is(':checked');
            var grid = $('#grid').data('kendoGrid');
            if (state == true) {
                $('.check-box-inner').prop('checked', true);
            }
            else {
                $('.check-box-inner').prop('checked', false);
            }
        });

        $("#liApprove").unbind().bind('click',function () {
            var grid = $("#dvgrid").data("kendoGrid");
            var ds = grid.dataSource.data();
            var lstData = [];
            var arrError = [];
            for (var i = 0; i < ds.length; i++) {
                var row = grid.table.find("tr[data-uid='" + ds[i].uid + "']");
                var checkbox = $(row).find(".check-box-inner");
                var MakerRemarks = $(row).find(".MakerRemarks").val();
                var CompDate = $(row).find(".CompDate").find(".CompDate").val();
                var DelayReason = $(row).find(".DelayReason").find(".DelayReason").val();
                if (checkbox.is(":checked")) {
                    var idsToSend = { DocID: "", ActivityCompDate: "", DelayReason: "", Remark: "" };
                    if (CompDate == "") {
                        $(row).find(".CompDate").find(".CompDate").addClass('error');
                        arrError.push(false);
                    }
                    else {
                        $(row).find(".CompDate").find(".CompDate").removeClass('error');
                        arrError.push(true);
                    }
                    if (DelayReason == "") {
                        $(row).find(".DelayReason").addClass('error');
                        arrError.push(false);
                    }
                    else {
                        $(row).find(".DelayReason").removeClass('error');
                        arrError.push(true);
                    }
                    if (MakerRemarks == "") {
                        $(row).find(".MakerRemarks").css('border-color', 'red');
                        arrError.push(false);
                    }
                    else {
                        $(row).find(".MakerRemarks").css('border-color', '');
                        arrError.push(true);
                    }
                    idsToSend.DocID = ds[i].DOCID;
                    idsToSend.ActivityCompDate = CompDate;
                    idsToSend.DelayReason = DelayReason;
                    idsToSend.Remark = MakerRemarks;
                    lstData.push(idsToSend);
                }
                else {
                    $(row).find(".CompDate").find(".CompDate").removeClass('error');
                    arrError.push(true);
                    $(row).find(".DelayReason").removeClass('error');
                    arrError.push(true);
                    $(row).find(".MakerRemarks").css('border-color', '');
                    arrError.push(true);
                }
            }

            if (lstData.length > 0) {
                if (arrError.length > 0) {
                    for (var i = 0; i < arrError.length; i++) {
                        if (arrError[i] == false) {
                            return false;
                        }
                    }
                }
                var form = $('#__AjaxAntiForgeryForm');
                var token = $('input[name="__RequestVerificationToken"]', form).val();
                $.post(MakerBulkApproveUrl, { __RequestVerificationToken: token, TaskVerifyVM: lstData }, function (response) {
                    if (response.IsSuccess) {
                        var Data = JSON.parse(response.Data);
                        $("#lblTotSuccess").html(Data["Success"]);
                        $("#lblTotFailed").html(Data["Failed"]);
                        $("#hdnresultFile").val(Data["FileName"]);
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
                        BindGrid();
                        $("#log").dialog("open");
                        
                    }
                });
            }
            else {
                createErrPOP("Please select at-least one activity to proceed.");
            }
        });
    }
}
function ShowToolTip() {
    $(".CompDate").kendoDatePicker(
        {
            format: 'dd/MM/yyyy',
            width: 500,
            value: new Date()
        });
    var data = [
        { text: "--Select--", value: "" },
        { text: "To be Delayed", value: "To be Delayed" },
        { text: "Information delayed from External Sources", value: "Information delayed from External Sources" },
        { text: "Information delayed from Internal Sources", value: "Information delayed from Internal Sources" },
        { text: "Technical Delay", value: "Technical Delay" },
        { text: "Others", value: "Others" },
    ];
    $(".dropDownTemplate").kendoDropDownList({
        dataTextField: "text",
        dataValueField: "value",
        dataSource: data,
        height: 100
    });
    var form = $('#__AjaxAntiForgeryForm');
    var token = $('input[name="__RequestVerificationToken"]', form).val();
    $(".ApprovefileToUpload").kendoUpload({
        async: {
            saveUrl: UploadTaskFileUrl,
            removeUrl: RemoveTaskFileUrl,
            autoUpload: true,
            showFileList: true
        },
        upload: function (e) {
            var Item1DOCID = $(e.sender.element[0]).attr('attr-docid');
            e.data = { __RequestVerificationToken: token, DOCID: Item1DOCID };
        },
        multiple: true,
        success: onSuccess,
        remove: function (e) {
            var DocID = $(e.sender.element[0]).attr('attr-docid');
            var FileID = e.files[0].FileID;
            e.data = { __RequestVerificationToken: token, DOCID: DocID, FileID: FileID, System_FileName: e.files[0].System_File_Name };
        },
        showFileList: true
    });

    $(".k-icon.k-view").parent().attr("title", "View");

    $(".k-icon.k-view").parent().kendoTooltip({
        width: 60,
        position: "top"
    }).data("kendoTooltip");
}
function onSuccess(e) {
    var uploaderid = e.sender.element[0].id;
    if (e.operation == 'upload') {
        var responseData = e.response;
        if (responseData.IsSuccess == true) {
            var res = $.parseJSON(responseData.Data);
            e.files[0].FileID = res.FileID;
            e.files[0].System_File_Name = res.FileName;
            $('.k-file-extension-wrapper').hide();
            $('.k-file-name-size-wrapper').css("width", '55%');
            $('.k-file-name-size-wrapper').css("margin-left", '0px');
            $('.k-upload-status').css("width", '32%');

            //GetTaskFiles(uploaderid);
        }
        else {
            alert(responseData.Data);
        }
    }
    else {
    }
}
function onError(e) {
    $(".k-upload-files.k-reset").find("li").remove();
}
function ViewDetails(DocID) {
    var URL = '../../document/Task/' + DocID;
    OpenWindow(URL);
}
var new_window;
function OpenWindow(url) {
    var new_window = window.open(url, "List", "scrollbars=yes,resizable=yes,width=800,height=480");
    return false;
}
var filtersNeedToAct;
function childClose() {
    if ($('#dvgrid').length > 0)
        filtersNeedToAct = $("#dvgrid").data("kendoGrid").dataSource.filter();
    BindGrid();
}
function GetParameterValues(name, url) {
    if (!url) {
        url = window.location.href;
    }
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

function GetParameterValues11(param) {
    var url = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for (var i = 0; i < url.length; i++) {
        var urlparam = url[i].split('=');
        if (urlparam[0] == param) {
            return urlparam[1];
        }
    }
}

function DownLoadResultFile() {
    var FileName = $("#hdnresultFile").val();
    var Data = { FileName: FileName };
    var URL = DownLoadResultFileUrl + '?FileName=' + FileName;
    window.location = URL;
    return false;
}
