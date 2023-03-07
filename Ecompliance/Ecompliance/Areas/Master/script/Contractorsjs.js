function OpenAddPopUp() {
    
    $("#ContractorID").val(0);
    $("#btnSubmit").val("Submit");
    $("#btnReset").click();
    $('#IsAct').prop('checked', true)
    var dialog = $("#dvAddUpdateContractor").dialog({
        modal: true,
        title: "Contractor Master",
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
}
$(document).ready(function () {
    $("#dvimport").bind("click", {}, OpenUploadPopup);
    $("#dvExport").bind("click", {}, DownLoadAll);
    $("#dvAdd").bind("click", {}, OpenAddPopUp);
    $("#aContractorTotal").addClass("Active-SnapShot");
    $("#menu_2").addClass("active-menu");
    $('.scrollbox3').enscroll({
        showOnHover: false,
        verticalTrackClass: 'track3',
        verticalHandleClass: 'handle3'
    });
    var ContractorID = 0;
    BindGrid(0);
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
            url: UploadContractorUrl,
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
                    BindGrid(0);
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
        async:
            {
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
    //alert("hi");
    HandleResponse(e, "dvAddUpdateContractor", "btnReset", "ContractorID");
    if (e.IsSuccess == true) {
        var grid = $("#Kgrid").data("kendoGrid");
        currentPage = grid.dataSource.page();
        BindGrid($("#hdnfilterComp").val());
    }
    //$("a").removeClass("Active-SnapShot");
    //$("aContractorTotal").addClass("Active-SnapShot");
}
function FailMessage() {
    alert("Fail Post");
}
function HistoryGridData(ContractorID) {

    $.ajax({
        type: "GET",
        url: GetContractorHistoryUrl,
        contentType: "application/json; charset=utf-8",
        data: { "ContractorID": ContractorID },
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess) {
                HistorybindGrid(response.Data);
                var dialog = $("#modalpartial").dialog({
                    autoOpen: false,
                    modal: true,
                    title: "Contractor Details",
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
            alert("Something went wrong");
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
        columns: [
                    //{ field: "CompID", title: "CompanyID", width: 90 },
                    { field: "Name", title: "Contractor", width: 150 },
                    { field: "Address", title: "Address", width: 200 },
                    { field: "Contact_Person", title: "Contact Person", width: 150 },
                    { field: "Contact_Number", title: "Contact Number", width: 120 },
                    { field: "Email", title: "Email", width: 100 },
                    { field: "PF_Code", title: "PF Code", width: 100 },
                    { field: "ESI_Code", title: "ESI Code", width: 100 },
                    { field: "Status", title: "Status", width: 60 },
                    { field: "UpdatedBy", title: "Updated By", width: 100 },
                    { field: "UpdatedOn", title: "Updated On", width: 130 },
                    { field: "Action", title: "Action", width: 80 },
        ],
        dataBound: function (e) {
            var grid = e.sender;
            if (grid.dataSource.total() == 0) {
                var colCount = grid.columns.length;
                $(e.sender.wrapper)
                    .find   ('tbody')
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
        width: 1150,
        height: 300,
        noRecords: true,
        sortable: true,
        resizable: true
    });
    $("#GridHis .k-grid-content.k-auto-scrollable").css("height", "272px");
}
var Kgrid;
function BindGrid(compID) {
    var ContractorID = 0;
    $.get(GetContractorUrl, { ContractorID: ContractorID, CompID: compID }, function (response) {
        var Kgrid = $("#Kgrid").data("kendoGrid");
        if ($(Kgrid).length > 0) {
            $("#Kgrid").data("kendoGrid").destroy();
            $('#Kgrid').empty();
        }
        if (response.IsSuccess) {
            var Data = $.parseJSON(response.Data);
            var columns = [{ field: "Name", title: "Contractor", width: 200 },
                        { field: "Company", title: "Company", width: 200 },
                        { field: "Contact_Person", title: "Contact Person", width: 100 },
                        { field: "IsActText", title: "Status", width: 80 },

            ];
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
            columns.push(cmd);
            var Data =
            Kgrid = $("#Kgrid").kendoGrid({
                dataSource: {
                    pageSize: 15,
                    data: Data
                },
                dataBound: ShowToolTip,
                height: 400,
                noRecords: true,
                filterable: true,
                sortable: true,
                pageable: { pageSizes: true },
                groupable: true,
                resizable: true,
                reorderable: true,
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
// For Upload popup

function OpenUploadPopup() {
    $("#dialog").dialog({
        autoOpen: false,
        width: 500,
        title: "Upload Contractor",
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

function DownLoadSampleContractor() {
    //public ActionResult GetMapppingCount(string CompIDS,string sitesIDs,string ActIds,string ContractorIds)
    var URL = DownLoadSampleContractorUrl;
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
    var ContractorID = dataItem.ContractorID;
    $.get(GetContractorUrl, { ContractorID: ContractorID, CompID: 0 }, function (response) {
        //console.log(response);
        if (response.IsSuccess) {
            var data = JSON.parse(response.Data)[0];
            $("#lblName").html(data.Name);
            $("#lblAddress").html(data.Address);
            $("#lblContact_Person").html(data.Contact_Person);
            $("#lblContact_Number").html(data.Contact_Number);
            $("#lblEmail").html(data.Email);
            $("#lblPF_Code").html(data.PF_Code);
            $("#lblESI_Code").html(data.ESI_Code);
            var IsAct = data.IsAct;
            (IsAct == 1) ? $('#lblIsAct').html('Active') : $('#lblIsAct').html('In Active');
            HistoryGridData(ContractorID);
        }
        else {
            FailResponse(response);
        }
    });
}


var EditHandler = function EditHandler(e) {
    e.preventDefault();
    $("#btnReset").click();
    dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var ContractorID = dataItem.ContractorID;
    $.get(GetContractorUrl, { ContractorID: ContractorID, CompID: 0 }, function (response) {
        if (response.IsSuccess) {
            var data = JSON.parse(response.Data)[0];
            $("#ContractorID").val(data.ContractorID);
            $("#Name").val(data.Name);
            $("#ddlCompany").val(data.CompID);
            $("#Address").val(data.Address);
            $("#Contact_Person").val(data.Contact_Person);
            $("#Contact_Number").val(data.Contact_Number);
            $("#Email").val(data.Email);
            $("#PF_Code").val(data.PF_Code);
            $("#ESI_Code").val(data.ESI_Code);
            var IsAct = data.IsAct;
            (IsAct == 1) ? $('#IsAct').prop('checked', true) : $('#IsAct').prop('checked', false);
            $("#btnSubmit").val("Update");
            var dialog = $("#dvAddUpdateContractor").dialog({
                //autoOpen: false,
                modal: true,
                title: "Contractor Master",
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
        }
        else {
            FailResponse(response);
        }
    });
}
function FilterGrid(companyID, id) {
    $("a").removeClass("Active-SnapShot");
    $("#" + id).addClass("Active-SnapShot");
    $("#hdnfilterComp").val(companyID);
    BindGrid(companyID);
}
function DownLoadAll() {
    var URL = DownloadAllMapppingContractorUrl;
    window.location = URL + "?CompID=" + $("#hdnfilterComp").val() + "";
    return false;
}