function OpenAddPopUp() {
    $("#hdnCustID").val(0);
    $("#btnReset").click();
    $("#IsAct").prop("checked", false);
    $("#btnSubmit").val("Submit");
    var dialog = $("#dvCustomer").dialog({
        //autoOpen: false,
        modal: true,
        title: "Customer Master",
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
    //dialog.dialog("open");
    event.preventDefault();
}
$(document).ready(function () {
    $("#dvimport").bind("click", {}, OpenUploadPopup);
    $("#dvExport").bind("click", {}, DownLoadAll);
    $("#dvAdd").bind("click", {}, OpenAddPopUp);
    $("#menu_2").addClass("active-menu");
    var ContractorID = 0;
    BindGrid();

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
            url: UploadCustomerUrl,
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
                    $("#lblTotSuccess").html(Data["Success"]);
                    $("#lblTotFailed").html(Data["Failed"]);
                    $("#hdnresultFile").val(Data["FileName"]);
                    $("#dialog").dialog("close");
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
            saveUrl:FilesUploadUrl,
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
var currentPage = 0;
function SuccessMessage(e) {
    HandleResponse(e, "dvCustomer", "btnReset", "hdnCustID");
    if (e.IsSuccess) {
        var grid = $("#Kgrid").data("kendoGrid");
        currentPage = grid.dataSource.page();
        BindGrid();
    }
        
}
function FailMessage() {
    alert("Fail Post");
}
var Kgrid = "";
function HistoryGridData(CustID) {
    $.ajax({
        type: "GET",
        url: GetCustomerHistoryUrl,
        contentType: "application/json; charset=utf-8",
    data: {"CustID": CustID },
    dataType: "json",
    success: function (response) {
        if (response.IsSuccess) {
            HistorybindGrid(response.Data);
            var dialog = $("#modalpartial").dialog({
                autoOpen: false,
                modal: true,
                title: "Customer Details",
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
            //pageSize: 10,
            data: JSON.parse(Data1)
        },
        dataBound: function (e) {
            var grid = e.sender;
            if (grid.dataSource.total() != 0) {
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
        height:350,
        sortable: true,
        resizable: true,
        noRecords: true
    });
    $("#GridHis .k-grid-content.k-auto-scrollable").css("height", "272px");
}
function BindGrid() {
    var CustID = 0;
    $.get(GetCustomerUrl, { CustID: CustID }, function (response) {
        if (Kgrid != "") {
            $('#Kgrid').kendoGrid('destroy').empty();
        }
        if (response.IsSuccess) {
            var Data = $.parseJSON(response.Data);
            var columns = [{ field: "Name", title: "Customer" },
                      //{ field: "Code", title: "Code" },
                      { field: "IsActText", title: "Status", width: 100 },

            ];
            var objAddDiv = $("#dvAdd");
            if (objAddDiv.length > 0) {
                var cmd = {
                    command: [{ name: "Edit", text: "", imageClass: "k-icon k-edit", click: EditHandler, title: "Edit" },
                                      { name: "View", text: "", imageClass: "k-icon k-view", click: ViewHandler, title: "View" },
                                      { name: "IPAddress", text: "", imageClass: "k-icon k-i-globe-outline", click: ViewIPRange, title: "IP Address" }
                    ], title: "Action", width: 150
                };
            }
            else {
                var cmd = {
                    command: [{ name: "View", text: "", imageClass: "k-icon k-view", click: ViewHandler, title: "View" },
                    ], title: "Action", width: 150
                };
            }
            columns.push(cmd);
            var Data =
            Kgrid = $("#Kgrid").kendoGrid({
                dataSource: {
                    pageSize: 15,
                    data: Data,
                    sort: { field: "Name", dir: "asc" }
                },
                dataBound: ShowToolTip,
                pageable: { pageSizes: true },
                height: 400,
                filterable: true,
                noRecords: true,
                resizable: true,
                reorderable: true,
                sortable: true,
                //groupable: true,
                columns: columns,
            });
            if (currentPage != 0)
                $('#Kgrid').data().kendoGrid.dataSource.page(currentPage);
        }
        else {
            FailResponse(response);
        }
    });
}
// For Upload popup
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

function OpenUploadPopup() {
    $("#Uploaddialog").dialog({
        autoOpen: false,
        width: 500,
        title: "Upload Customer",
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
    $("#Uploaddialog").dialog("open");
}

function DownLoadResultFile() {
    var FileName = $("#hdnresultFile").val();
    var Data = { FileName: FileName };
    var URL = DownLoadResultFileUrl + '?FileName=' + FileName;
    window.location = URL;
    return false;
}

function DownloadSampleCustomer() {
    //public ActionResult GetMapppingCount(string CompIDS,string sitesIDs,string ActIds,string ContractorIds)
    var URL = DownloadSampleCustomerUrl;
    window.location = URL;
    return false;
}
var ViewHandler = function ViewHandler(e) {
    $("#liDetails").removeClass('active').addClass('active');
    $("#liHistory").removeClass('active');
    $("#tab_1_1").removeClass('active').addClass('active');
    $("#tab_1_2").removeClass('active');
    e.preventDefault();
    dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var CustID = dataItem.CustID;
    $.get(GetCustomerUrl, { CustID: CustID }, function (response) {
        if (response.IsSuccess) {
            var Data = $.parseJSON(response.Data);
            $("#lblName").html(Data[0].Name);
            $("#lblSubDomain").html(Data[0].SubDomain);
            $("#lblIPAddressE").html(Data[0].EnableIPRangText)
            //$("#lblCode").html(Data[0].Code);
            $("#lblSource").html(Data[0].Source);
            var IsAct = Data[0].IsAct;
            (IsAct == 1) ? $('#lblIsAct').html('Active') : $('#lblIsAct').html('In Active');
            HistoryGridData(CustID);
        }
        else {
            FailResponse(response);
        }
    });
};
var EditHandler = function EditHandler(e) {
    e.preventDefault();
    dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var CustID = dataItem.CustID;
    $.get(GetCustomerUrl, { CustID: CustID }, function (response) {
        if (response.IsSuccess) {
            var Data = $.parseJSON(response.Data);
            $("#hdnCustID").val(CustID);
            $("#txtName").val(Data[0].Name);
            $("#SubDomain").val(Data[0].SubDomain);
            //$("#txtCode").val(Data[0].Code);
            $("#txtSource").val(Data[0].Source);
            var EableIPAddress = Data[0].EnableIPRang;
            if (EableIPAddress == 1)
                $("#EableIPAddress").prop("checked", true);
            else
                $("#EableIPAddress").prop("checked", false);
            var IsAct = Data[0].IsAct;
            if (IsAct == 1)
                $("#IsAct").prop("checked", true);
            else
                $("#IsAct").prop("checked", false);
            $("#btnSubmit").val("Update");
            var dialog = $("#dvCustomer").dialog({
                //autoOpen: false,
                modal: true,
                title: "Customer Master",
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
        }
        else {
            FailResponse(response);
        }
    });
};

var kgrdIPRange = "";
var ViewIPRange = function IPRangeGrid(e) {
    e.preventDefault();
    dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var CustID = dataItem.CustID;
    $("#hdnIPCustID").val(CustID);
    BindIPRangeGrid(CustID);
};
//$("#btnAddIPRange").bind("click", {}, openModel)
$("#btnAddIPRange").click(function () {
    openModel("Add");
});
var Configdialog;
function OpenIPRangePopup() {
    if (Configdialog == undefined) {
        Configdialog = $("#dvIPRang").dialog({
            autoOpen: false,
            modal: true,
            title: "IP Address Details",
            width: 800,
            height: 450,
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
    }
    Configdialog.dialog("open");
}
function BindIPRangeGrid(CustID){
    $.ajax({
        type: "GET",
        url: GetIPRangeGridUrl,
        contentType: "application/json; charset=utf-8",
        data: { CustID: CustID,IPRangeTID: 0},
        success: function (response) {
            if (response.IsSuccess) {
                if (kgrdIPRange != "") {
                    $('#grdIPRang').kendoGrid('destroy').empty();
                }
               // var Configdialog = $("#dvIPRang").dialog({
               //     autoOpen: false,
               //     modal: true,
               //     title: "IP Address Details",
               //     width: 800,
               //     height: 450,
               //     closeText: "",
               //     position: {
               //         my: "center",
               //         at: "center",
               //         of: window,
               //         collision: "none"
               //     },
               //     create: function (event, ui) {
               //         $(event.target).parent().css('position', 'fixed');
               //     }
               // });
               //Configdialog.dialog("open");
                OpenIPRangePopup();
                    var cmd = {
                        command: [{ name: "Edit", text: "", imageClass: "k-icon k-edit", click: EditIPRangeHandler, title: "Edit" },
                            { name: "Delete", text: "", iconClass: "k-icon kdelete", click: DeleteHandler, title: "Delete" }
                        ], title: "Action", width: 50
                    };
                
                 
                    kgrdIPRange = $("#grdIPRang").kendoGrid({
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
                        ShowToolTip();
                    },
                    columns: [
                               { field: "CustomerName", title: "Customer Name", width: 150 },
                        { field: "IPAddressRang", title: "IP Range", width: 100 },
                               { field: "IsAuthText", title: "Status", width: 50 },
                               cmd
                    ],
                    //dataBound: ShowToolTip,
                    height: 320,
                    pageable: { pageSizes: true },
                    filterable: true,
                    sortable: true,
                    reorderable: true,
                    resizable: true
                });
                if (currentPage != 0)
                    $('#grdIPRang').data().kendoGrid.dataSource.page(currentPage);
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
//$("#txtIPRange").keypress(function () {
//    var rawNumbers = $(this).val().replace(/-/g, '');
//    var cardLength = rawNumbers.length;
//    if (cardLength !== 0 && cardLength <= 8) {
//        $(this).val($(this).val() + '.');
//    }
//});

var DeleteTID = "";
var DeleteHandler = function DeleteHandler(e) {
    e.preventDefault();
    dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    DeleteTID = dataItem.TID;
    $("#dvDeleteResponse").html('Are you sure you want to delete IP Address Rang.' + dataItem.IPAddressRang + ' Records ?');
    $("#dvDelete").dialog({
        //autoOpen: false,
        modal: true,
        title: "Delete Confirmation",
        width: 330,
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
};


$("#btnDelete").click(function () {
    var form = $('#__AjaxAntiForgeryForm');
    var token = $('input[name="__RequestVerificationToken"]', form).val();
    var DeleteCustID = $("#hdnIPCustID").val();
    $("#dvDelete").dialog('close');
    $.post(DeleteIPRangeURL, { __RequestVerificationToken: token, DeleteTID: DeleteTID, DeleteCustID: DeleteCustID }, function (response) {
        if (response.IsSuccess) {
            var aa = $("#hdnIPCustID").val();
            BindIPRangeGrid(aa);
            createSuccessPOP(" IPRange Deleted successfully.");
        }
    });
    /////
});
$("#btnReject").click(function () {
    $("#dvDelete").dialog('close');
});

var EditIPRangeHandler = function EditIPRangeHandler(e) {
    e.preventDefault();
    dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var CustID = dataItem.Document_ID;
    var TID = dataItem.TID;
    $.get(GetIPRangeGridUrl, { CustID: CustID, IPRangeTID: TID }, function (response) {
        if (response.IsSuccess) {
            var Data = $.parseJSON(response.Data);
            $("#hdnIPCustID").val(Data[0].Document_ID);
            $("#hdnTID").val(Data[0].TID);
            $("#txtIPRange").val(Data[0].IPRange);
            $("#txtIPEnd").val(Data[0].EndIPAddress);
            $("#spnIPAdd").html("");
            $("#spnIPAdd").val("");
            $("#txtIPRange").next().removeClass("field-validation-error").addClass("field-validation-valid").html("");
            $("#txtIPEnd").next().removeClass("field-validation-error").addClass("field-validation-valid").html("");
            //var IsAct = Data[0].IsAuth;
            //if (IsAct == 1)
            //    $("#chkIsAct").prop("checked", true);
            //else
            //    $("#chkIsAct").prop("checked", false);
            $("#btnSubmit").val("Update");
            openModel("Update");
        }
        else {
            FailResponse(response);
        }
    });
}

$("#btnUpdateIPRange").bind("click", {}, AddUpdateIPRange);
function AddUpdateIPRange() {
    var CustID = $("#hdnIPCustID").val();
    var TID = $("#hdnTID").val();
    var IPRange = $("#txtIPRange").val();
    var EndIPAddress = $("#txtIPEnd").val();
    //var ISAct = $("#chkIsAct").is(":checked");
    var IsActive = 0;
    TID = TID == "" ? 0 : TID;
    //if (ISAct == true) {
    //    IsActive = 1;
    //} else {
    //    IsActive = 0;
    //}
    if (EndIPAddress != undefined || EndIPAddress != "") {
        if (EndIPAddress > 255) {
            $("#txtIPEnd").next().toggleClass("field-validation-error").toggleClass("field-validation-valid").html("Enter less then 256.");
            return false;
        }
    }
        if (IPRange == undefined || IPRange == "") {
            $("#txtIPRange").next().toggleClass("field-validation-error").toggleClass("field-validation-valid").html("Please Enter IP Address.");
            return false;
        }
        if (/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(IPRange)) {
   
     }
     else {
            $("#txtIPRange").next().toggleClass("field-validation-error").toggleClass("field-validation-valid").html("Enter IP Address Correct Format.");
            return false;
     }
    $("#txtIPRange").next().toggleClass("field-validation-error").toggleClass("field-validation-valid").html("");
    $("#txtIPEnd").next().toggleClass("field-validation-error").toggleClass("field-validation-valid").html("");
       
    
    if (IPRange != undefined && IPRange != "") {
        $.get(AddUpdateIPRangefURL, { TID: TID, CustID: CustID, IPRange: IPRange, EndIPAddress: EndIPAddress, IsAct: 1 }, function (response) {
            if (response.IsSuccess) {
                if (TID == 0 && TID == "") {
                    createSuccessPOP(" IPRange Insert successfully.");
                    BindIPRangeGrid(CustID);
                } else {
                    createSuccessPOP(" IPRange updated successfully.");
                    BindIPRangeGrid(CustID);
                }
                $("#dialogIPRange").dialog('close');
                IPRange = "", ISAct = ""; EndIPAddress = "";
               // BindIPRangeGrid(CustID);
            }
            else {
                createErrPOP("Sorry!!. Error occured in server. Please try again.");
            }
        });
    }
    else {
        createErrPOP("Please Enter IP Address.");
    }
}
$("#btnResetIP").click(function () {
   // $("#chkIsAct").prop("checked", false);
    $("#txtIPRange").val("");
    $("#txtIPEnd").val("");
    $("#spnIPAdd").html("");
})
function openModel(bot) {
    if (bot == "Add") {
        //  $("#chkIsAct").prop("checked", false);
       // $("#hdnIPCustID").val(0);
        $("#txtIPRange").val("");
        $("#txtIPEnd").val("");
        $("#hdnTID").val("");
        $("#spnIPAdd").val("");
        $("#txtIPRange").next().removeClass("field-validation-error").addClass("field-validation-valid").html("");
        $("#txtIPEnd").next().removeClass("field-validation-error").addClass("field-validation-valid").html("");
    }
    var dialog = $("#dialogIPRange").dialog({
        //autoOpen: false,
        modal: true,
        title: "IP Address Master",
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
}
function DownLoadAll() {
    //public ActionResult GetMapppingCount(string CompIDS,string sitesIDs,string ActIds,string ContractorIds)
    var URL = DownloadAllMapppingCustomerUrl;
    window.location = URL;
    return false;
}