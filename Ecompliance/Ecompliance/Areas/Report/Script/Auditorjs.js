var EmptyCount = 0;
$("#ddlCompany").change(function () {
    var CompanyID = $(this).val();
    var ddlSite = $("#ddlSite");
    ddlSite.empty().append($('<option></option>').val("0").html("Please wait..."));
    if (CompanyID != "0") {
        $.get(GetMappedSiteUrl, { CompanyID: CompanyID }, function (response) {
            if (response.IsSuccess) {
                ddlSite.empty().append($('<option></option>').val("0").html("ALL"));
                var ds = $.parseJSON(response.Data);
                if (ds.length > 0) {
                    $.each(ds, function () {
                        ddlSite.append($('<option></option>').val(this.SiteID).html(this.Name));
                    });
                }
            }
        });
    }
    else {
        ddlSite.html('').append($('<option></option>').val("0").html("-- first select a company --"));
    }
});
function BindScoreCardGrid() {
    var Comp = $("#ddlCompany").val();
    var Site = $("#ddlSite").val();
    var Month = $("#ddlMonth").val();
    var Year = $("#ddlYear").val();
    if (Comp == 0) {
        alert("Please select Company");
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
    BindPEGrid(Comp, Site, Month, Year);
    if (EmptyCount >= 2) {
        $("#dvReport").hide();
        $("#dvNoRecord").show();
    }
    else {
        $("#dvReport").show();
        $("#dvNoRecord").hide();
    }
}
$(document).ready(function () {
    $("#menu_4").addClass("active-menu");
    $("#btnSearch").click(BindScoreCardGrid);
    $("#btnSendToAuditor").click(function () {
        UpdateAll('Sent to Auditor');
    });
    $("#btnApprove").click(function () {
        //UpdateAll('Approved by Auditor');
        UpdateAll('Viewed / Approved by Client / Auditor');
    });
    $("#btnReject").click(function () {
        //UpdateAll('Rejected by Auditor');
        UpdateAll('Rejected by Client / Auditor');
    });
});
var DataSendToAuditor;
function CalculateAvg(Site, Status) {
    //var Obj = FilterFunction(Site, Role);
    var Obj = DataSendToAuditor.filter(function (item) {
        return item.Site == Site && item.AuditStatus == Status;
    });//     FilterFunction(Site, Role);
    var ObjComp = DataSendToAuditor.filter(function (item) {
        return item.Site == Site;
    });//FilterFunction(Site, Role);

    var Total = 0;
    var Percent = (Obj.length / ObjComp.length) * 100;
    Percent = parseFloat(Percent).toFixed(2)
    return Percent;
};
//CalculateAvgComp
function CalculateNotSent(Site, Status) {
    //var Obj = FilterFunction(Site, Role);
    var Obj = DataSendToAuditor.filter(function (item) {
        return item.Site == Site && (item.AuditStatus == Status || item.AuditStatus == 'Resubmitted to Client / Auditor');
    });//     FilterFunction(Site, Role);
    var ObjComp = DataSendToAuditor.filter(function (item) {
        return item.Site == Site;
    });//     FilterFunction(Site, Role);

    var Total = 0;
    var Percent = (Obj.length / ObjComp.length) * 100;
    Percent = parseFloat(Percent).toFixed(2)
    return Percent;
};
function CalculateAvgComp(Comp, Status) {
    //var Obj = FilterFunction(Site, Role);
    var Obj = DataSendToAuditor.filter(function (item) {
        return item.Company == Comp && item.AuditStatus == Status;
    });//     FilterFunction(Site, Role);
    var ObjComp = DataSendToAuditor.filter(function (item) {
        return item.Company == Comp;
    });//FilterFunction(Site, Role);

    var Total = 0;
    var Percent = (Obj.length / ObjComp.length) * 100;
    Percent = parseFloat(Percent).toFixed(2)
    return Percent;
};
function CalculateNotSentComp(Comp, Status) {
    //var Obj = FilterFunction(Site, Role);
    var Obj = DataSendToAuditor.filter(function (item) {
        return item.Company == Comp && (item.AuditStatus == Status || item.AuditStatus == 'Resubmitted to Client / Auditor');
    });//     FilterFunction(Site, Role);
    var ObjComp = DataSendToAuditor.filter(function (item) {
        return item.Company == Comp;
    });//     FilterFunction(Site, Role);

    var Total = 0;
    var Percent = (Obj.length / ObjComp.length) * 100;
    Percent = parseFloat(Percent).toFixed(2)
    return Percent;
};
//CalculateNotSentComp
function BindPEGrid(Comp, Site, Month, Year) {
    var str = { "CompanyID": Comp, "SiteID": Site, "Month": Month, "Year": Year, "Type": "PE" };
    $.ajax({
        type: "GET",
        //GetScoreCardData
        url: GetScoreCardDataUrl,
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

                var StrData = $.parseJSON(data.Data);
                if (StrData.length == 0)
                    $("#btnApprove,#btnReject").hide();
                else
                    $("#btnApprove,#btnReject").show();
                DataSendToAuditor = StrData;
                if (StrData.length == 0) {
                    EmptyCount += 1;
                    if (EmptyCount >= 2) {
                        $("#dvReport").hide();
                        $("#dvNoRecord").show();
                    }
                    else {
                        $("#dvReport").show();
                        $("#dvNoRecord").hide();
                    }

                }
                $("#grid").kendoGrid({
                    dataSource: {
                        data: StrData,
                        //pageSize: 100,
                        group: [
                            { field: "Company", aggregates: [{ field: "Company", aggregate: "count" }, { field: "Percentage", aggregate: "average" }] },
                            { field: "Site", aggregates: [{ field: "Site", aggregate: "count" }, { field: "Percentage", aggregate: "average" }] },
                            //{ field: "Maker", aggregates: [{ field: "Maker", aggregate: "count" }, { field: "Percentage", aggregate: "average" }] },

                        ],
                        aggregate: [
                            { field: "Site", aggregate: "average" }
                            , { field: "Company", aggregate: "average" }
                            //, { field: "Maker", aggregate: "average" }
                        ]
                    }
                    , dataBound: function (e) {
                        var grid = e.sender;
                        if (grid.dataSource.total() == 0) {
                            var colCount = grid.columns.length;
                            $(e.sender.wrapper)
                                .find('tbody')
                                .append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data"><span style="margin-left:46%;">No data found.</span></td></tr>');
                        }
                    },
                    columns: [
                        { title: "<input id='chkAll' class='checkAllCls' type='checkbox'/>", width: "35px", template: "<input type='checkbox' class='check-box-inner' />", filterable: false },
                        { field: "Company", hidden: true, title: "Company", groupHeaderTemplate: "#=value #<span style='margin-right: 9px;margin-left: 50px;color:mediumpurple;'>Pending with Client / Auditor:(#=CalculateNotSentComp(value,'Pending with Client / Auditor')#%)</span><span style='margin-right: 9px;color:red;'>Rejected by Client / Auditor:(#=CalculateAvgComp(value,'Rejected by Client / Auditor')#%)</span><span style='margin-right: 9px;color:green;'>Viewed / Approved by Client / Auditor:(#=CalculateAvgComp(value,'Viewed / Approved by Client / Auditor')#%)</span>" },
                        { field: "Site", hidden: true, title: "Site", groupHeaderTemplate: "#=value #<span style='margin-right: 9px;margin-left: 50px;color:mediumpurple;'>Pending with Client / Auditor:(#=CalculateNotSent(value,'Pending with Client / Auditor')#%)</span><span style='margin-right: 9px;color:red;'>Rejected by Client / Auditor:(#=CalculateAvg(value,'Rejected by Client / Auditor')#%)</span><span style='margin-right: 9px;color:green;'>Viewed / Approved by Client / Auditor:(#=CalculateAvg(value,'Viewed / Approved by Client / Auditor')#%)</span>" },
                        { field: "Act", hidden: false, width: "100px", title: "Act", groupHeaderTemplate: "# if( aggregates.Percentage.average == null ) {# #=value #  : (Average : -)#} else {# #=value #  : (Average : #=kendo.format('{0:n}',aggregates.Percentage.average)#%)#} #" },
                        { field: "Activity", title: "Activity", width: "200px" },
                        //{ field: "ActionType", title: "Action<br/> Type", width: "80px" },
                        //{ field: "Applicable_To_Client", title: "Applicable<br/> To Client", width: "110px" },
                        //{ field: "Maker", title: "Maker", groupHeaderTemplate: "# if( aggregates.Percentage.average == null ) {# #=value #  : (Average : -)#} else {# #=value #  : (Average : #=kendo.format('{0:n}',aggregates.Percentage.average)#%)#} #" },
                        { field: "AuditStatus", title: "Audit Status", width: "200px" },
                        //{ field: "PendingWith", title: "Pending With" },
                        { title: "Remarks", width: "300px", template: "<input style='width:280px;' type='textbox' class='Remarkstext'/>", filterable: false },
                        // <span title='' class='glyphicon glyphicon-envelope showTitle' style='cursor:pointer;'></span>
                        //{ field: "Percentage", title: "%", editable: true, aggregates: ["average"], type: "number" },
                        {
                            command: [{ name: "View", text: "", imageClass: "k-icon k-view", click: AttachDocPopUp, title: "View" }
                                , { name: "Message", text: "", imageClass: "k-icon k-Conversation1", click: ShowMesage }
                            ], title: "Action", width: 100
                        }

                    ],
                    dataBound: function (e) {
                        var grid = $("#grid").data("kendoGrid");
                        var gridData = grid.dataSource.data(); //grid.dataSource.view();
                        for (var i = 0; i < gridData.length; i++) {
                            var currentUid = gridData[i].uid;
                            var Role = $("#hdnRole").val();
                            if (gridData[i].AuditStatus == "Viewed / Approved by Client / Auditor" || (gridData[i].AuditStatus == "Rejected by Client / Auditor" && Role == 'Auditor') || (gridData[i].AuditStatus == "Submitted to Client / Auditor" && Role == 'Auditee')) { // || gridData[i].AuditStatus == "Rejected by Auditor"
                                var currentRow = grid.table.find("tr[data-uid='" + currentUid + "']");
                                $(currentRow).find('.check-box-inner').remove();
                            }
                        }
                    },
                    height: 700,
                    scrollable: true,
                    resizable: true,
                    persistSelection: true,
                    noRecords: true,
                    reorderable: true,
                    groupable: false,
                    filterable: true,
                    sortable: true,
                    toolbar: [{ template: kendo.template($("#template").html()) },
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
                });
                collapseAll();
                $(".checkAllCls").on("click", function () {
                    var ele = this;
                    var state = $(ele).is(':checked');
                    var grid = $('#grid').data('kendoGrid');
                    if (state == true) {
                        $('.check-box-inner').prop('checked', true);
                        //$("#btnApprove,#btnReject").addClass('btn-primary');
                    }
                    else {
                        $('.check-box-inner').prop('checked', false);
                        //$("#btnApprove,#btnReject").removeClass('btn-primary');
                    }
                });
            }
            else { FailResponse(data); }
        },
        error: function (data) {
            alert("Something went wrong please try again later!.");
            // $("#mask").hide();
        }
    });
}
function UpdateAll(type) {
    var grid = $("#grid").data("kendoGrid");
    var ds = grid.dataSource.data();
    var lstSendToAuditor = [];
    var arrError = [];
    for (var i = 0; i < ds.length; i++) {
        var row = grid.table.find("tr[data-uid='" + ds[i].uid + "']");
        var checkbox = $(row).find(".check-box-inner");
        var txtValue = $(row).find(".Remarkstext").val();
        if (checkbox.is(":checked")) {
            var idsToSend = { DocID: "", Remarks: "" };
            if (type == 'Rejected by Client / Auditor') {
                if (txtValue == '') {
                    $(row).find(".Remarkstext").css('border-color', 'red');
                    arrError.push(false);
                }
                else {
                    $(row).find(".Remarkstext").css('border-color', '');
                    arrError.push(true);
                }

            }
            else {
                $(row).find(".Remarkstext").css('border-color', '');
                arrError.push(true);
            }
            idsToSend.DocID = ds[i].DocID;
            idsToSend.Remarks = txtValue;
            lstSendToAuditor.push(idsToSend);
            //idsToSend.push(txtValue);
        }
        else {
            $(row).find(".Remarkstext").css('border-color', '');
            arrError.push(true);
        }
    }
    if (lstSendToAuditor.length > 0) {
        if (arrError.length > 0) {
            for (var i = 0; i < arrError.length; i++) {
                if (arrError[i] == false) {
                    createErrPOP("Please enter remarks");
                    return false;
                }
            }
        }
        $.post("SetAuditor", { Model: lstSendToAuditor, Type: type }, function (response) {
            if (response.IsSuccess) {
                createSuccessPOP(response.Message);
                BindScoreCardGrid();
                expandAll();
            }
        });
    }
    else {
        createErrPOP("Please select at-least one activity to proceed.");
    }
}
function ShowToolTip(title) {
    $(".showTitle").parent().attr("title", title);

    $(".showTitle").parent().kendoTooltip({
        width: 60,
        position: "top"
    }).data("kendoTooltip");
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

/////////////////
var GlobalDOCID = 0;
function GetTaskFiles(DocID) {
    var data = { DOCID: DocID, FileID: 0 };
    $.ajax({
        type: "GET",
        url: GetTaskFilesUrl,
        contentType: "application/json; charset=utf-8",
        data: data,
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess == true) {
                if (kgrid != "") {
                    $('#dvAttachGrd').kendoGrid('destroy').empty();
                }
                BindAttachGrid(response.Data);
                $("#log").dialog({
                    autoOpen: false,
                    width: 700,
                    title: "Document Details",
                    closeText: ""

                });
                $("#log").dialog("open");
            }
            else { FailResponse(response); }
        },
        error: function (data) {
            alert("Something went wrong please try again later!.");
        }
    });
}
var kgrid = "";
function BindAttachGrid(Data1) {
    var objAddDiv = "";
    var GridColumns = [
        { field: "Desc", title: "File Description" },
        { field: "UserName", title: "Uploaded By" },
        { field: "UploadedOn", title: " Uploaded On" },
    ];
    //if (objAddDiv.length > 0) {
    var cmd = {
        command: [
            { name: "Delete", text: "", imageClass: "k-icon k-filedownload", click: Download, title: "Download" }
        ], title: "Action"
    };
    GridColumns.push(cmd);
    //}
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
        columns: GridColumns,
        height: 200,
        pageable: false,
        filterable: false,
        sortable: true,
        resizable: true
    });
}
function Download(e) {
    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var FileID = dataItem.FileID;
    var DocID = dataItem.DOCID;
    var data = { DOCID: DocID, FileID: FileID };
    var URL = DownloadTaskFileUrl + '?DOCID=' + DocID + '&FileID=' + FileID;
    window.location = URL;
}
function onSuccess(e) {
    var uploaderid = e.sender.element[0].id;
    var responseData = e.response;
    if (responseData.IsSuccess == true) {
        GetTaskFiles(GlobalDOCID);
    }

};
function GetCRMMSGData(DocID) {
    var data = { DOCID: DocID };
    $.ajax({
        type: "GET",
        url: GetCRMMSGUrl,
        contentType: "application/json; charset=utf-8",
        data: data,
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess == true) {
                if (kgrid != "") {
                    $('#dvAttachGrd').kendoGrid('destroy').empty();
                }
                //BindAttachGrid(response.Data);
            }
            else { FailResponse(response); }
        },
        error: function (data) {
            alert("Something went wrong please try again later!.");
        }
    });
}
function AttachDocPopUp(e) {
    e.preventDefault();//viek
    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    GlobalDOCID = dataItem.DocID;
    var MakerRemarks = dataItem.makerRemark;
    $("#spnMakerRemarks").html(MakerRemarks);
    GetTaskFiles(GlobalDOCID);
    $("#log").dialog({
        autoOpen: false,
        modal: true,
        width: 700,
        title: "Attach Document",
        closeText: ""

    });
    // GetTaskFiles("fileToUpload");
    $("#log").dialog("open");
}
function ShowMesage(e) {
    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var DocID = dataItem.DocID;
    $.get(GetMsgUrl, { DocID: DocID }, function (response) {
        if (response)
        $("#dvMsg").html(response);
        $("#dvMsg").dialog({
            autoOpen: false,
            modal: true,
            width: 700,
            title: "View Conversation",
            closeText: ""

        });
        // GetTaskFiles("fileToUpload");
        $("#dvMsg").dialog("open");
    });
}
$("#btnAttachOK").bind('click', function () {
    $("#log").dialog("close");
});
var form = $('#__AjaxAntiForgeryForm');
var token = $('input[name="__RequestVerificationToken"]', form).val();
$("#fileToUpload").kendoUpload({
    async: {
        saveUrl: UploadTaskFileUrl,
        removeUrl: "remove",
        autoUpload: true
    },
    upload: function (e) {
        e.data = { __RequestVerificationToken: token, DOCID: GlobalDOCID };
    },
    multiple: true,
    success: onSuccess,
    remove: onRemove,
    showFileList: false
});


                /////////////////
////////////////////
