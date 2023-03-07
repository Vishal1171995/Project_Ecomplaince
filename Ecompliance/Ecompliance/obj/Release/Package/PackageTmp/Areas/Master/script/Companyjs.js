var kgrid="";
$(document).ready(function () {
    $("#dvimport").bind("click", {}, OpenUploadPopup);
    $("#dvExport").bind("click", {}, DownLoadAll);
    $("#dvAdd").bind("click", {}, OpenAddPopUp);
    $("#aCompanyTotal").addClass("Active-SnapShot");
    $("#menu_2").addClass("active-menu");
    GetCompany(0);
    $('.scrollbox3').enscroll({
        showOnHover: false,
        verticalTrackClass: 'track3',
        verticalHandleClass: 'handle3'
    });
    $("#tabstrip").kendoTabStrip({
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
            url: UploadCompanyUrl,
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

                    $("#dvUpload").dialog("close");
                    $("#dvUploadLog").dialog({
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
                    $("#dvUploadLog").dialog("open");
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
function reset() {
    var validator = $("#dvAddUpdate").validate();
    validator.resetForm();
}
var currentPage = 0;
function OnSuccess(e) {
    HandleResponse(e, "dvAddUpdate", "btnReset", "CompanyID");
    if (e.IsSuccess == true) {
        var grid = $("#dvCompanygrid").data("kendoGrid");
        currentPage = grid.dataSource.page();
        GetCompany($("#hdnFilterCustID").val());
    }
}
function OnFailure() {
    alert("Failure");
}
function HistoryGridData(CompanyID) {
    $.ajax({
        type: "GET",
        url:GetCompanyHistoryUrl,
        contentType: "application/json; charset=utf-8",
        data: { "CompanyID": CompanyID },
        success: function (response) {
            if (response.IsSuccess) {
                HistorybindGrid(response.Data);
                var dialog = $("#dvCompanyDetail").dialog({
                    autoOpen: false,
                    modal: true,
                    title: "Company Details",
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
            data: JSON.parse(Data1)
        },
        columns: [
                    //{ field: "CompID", title: "CompanyID", width: 50 },
                    { field: "Name", title: "Company", width: 200 },
                    { field: "CustomerNm", title: "Customer", width:150 },
                    { field: "MakerNm", title: "Maker", width: 120 },
                    { field: "CheckerNm", title: "Checker", width: 120 },
                    { field: "Contact_Person", title: "Contact Person", width: 120 },
                    { field: "Address", title: "Address", width: 150 },
                    { field: "Code", title: "Code", width: 80 },
                    { field: "Email", title: "Email", width: 100 },
                    { field: "IsActNm", title: "Status", width: 60 },
                    
                    { field: "Action", title: "Action", width: 80 },
                    { field: "Updated_by", title: "UpDatedBy", width: 60 },
                    { field: "UpdatedOn", title: "UpDatedOn", width: 60 },
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
        width: 1150,
        height: 300,
        noRecords: true,
        sortable: true,
        resizable: true
    });
    $("#GridHis .k-grid-content.k-auto-scrollable").css("height", "272px");
    //var columns = $("#GridHis").data("kendoGrid").columns;
    //var headerTable = $('.k-grid .k-grid-header table');
    //var contentTable = $('.k-grid .k-grid-content table');
    //var columnDefs = $(".k-grid-content colgroup:first col");
    //for (var i = 0; i < columns.length; i++) {
    //    var col = headerTable.find('colgroup col:eq(' + i + ')')
    //                        .add(contentTable.find('colgroup col:eq(' + i + ')'));
    //    col.css('width', "150px");
    //}
}

function GetCompany(CustID) {
    $.ajax({
        type: "GET",
        url: GetCompanyUrl,
        contentType: "application/json; charset=utf-8",
        data: {CompanyID:0,CustID:CustID},
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess) {
                var objAddDiv = $("#dvAdd");
                if (objAddDiv.length > 0) {
                    var cmd = {
                        command: [{ name: "Edit", text: "", imageClass: "k-icon k-edit", click: EditHandler, title: "Edit" },
                                { name: "View", text: "", imageClass: "k-icon k-view", click: ViewHandler, title: "View" },
                                { name: "ViewConfig", text: "", imageClass: "k-icon k-config", click: ViewConfig }
                        ], title: "Action", width: 120
                    };
                }
                else {
                    var cmd = {
                        command: [{ name: "View", text: "", imageClass: "k-icon k-view", click: ViewHandler, title: "View" }
                            ,{ name: "ViewConfig", text: "", imageClass: "k-icon k-config", click: ViewConfig }
                        ], title: "Action", width: 120
                    };
                }
                if (kgrid != "") {
                    $('#dvCompanygrid').kendoGrid('destroy').empty();
                }
                kgrid = $("#dvCompanygrid").kendoGrid({
                    dataSource: {
                        pageSize: 15,
                        data: JSON.parse(response.Data)
                    },
                    columns: [

                               { field: "Name", title: "Company", width: 300 },
                               { field: "CustomerNm", title: "Customer", width:300 },
                               { field: "MakerNm", title: "Maker" },
                               { field: "CheckerNm", title: "Checker" },
                               { field: "IsActNm", title: "Status", width: 80 },
                               cmd
                    ],
                    dataBound: ShowToolTip,
                    height: 400,
                    noRecords: true,
                    pageable: { pageSizes: true},
                    filterable: true,
                    sortable: true,
                    resizable: true,
                    reorderable: true
                });
                if (currentPage != 0)
                    $('#dvCompanygrid').data().kendoGrid.dataSource.page(currentPage);
            }
            else {
                FailResponse(response);
            }
        },
        error: function (data) {
            alert("error");
        }
    });
}
function ShowToolTip() {
    $(".k-icon.k-edit").parent().attr("title", "Edit");
    $(".k-icon.k-view").parent().attr("title", "View");
    $(".k-icon.k-config").parent().attr("title", "Configuration");

    $(".k-icon.k-edit").parent().kendoTooltip({
        width: 60,
        position: "top"
    }).data("kendoTooltip");
    $(".k-icon.k-view").parent().kendoTooltip({
        width: 60,
        position: "top"
    }).data("kendoTooltip");
    $(".k-icon.k-config").parent().kendoTooltip({
        width: 90,
        position: "top"
    }).data("kendoTooltip");
}
function OpenAddPopUp() {
    $("#btnreset").click();
    $("#btnSubmit").val("Submit");
    $("#CompanyID").val(0);
    $('#IsAct').prop('checked', true)
    var dialog = $("#dvAddUpdate").dialog({
        autoOpen: false,
        modal: true,
        title: "Company Master",
        width: 950,
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
// For Upload popup

function OpenUploadPopup() {
    $("#dvUpload").dialog({
        autoOpen: false,
        width: 500,
        title: "Upload Company",
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

function DownLoadSampleCompany() {
    var URL = DownLoadSampleCompanyUrl;
    window.location = URL;
    return false;
}
//ViewConfig
var kgrdPE = "";
var kgrdContr = "";
function ViewConfig(e) {
    $("#liComp").removeClass('active').addClass('active');
    $("#liContractor").removeClass('active')
    $("#tabdvPE").removeClass('active').addClass('active');
    $("#tabdvCont").removeClass('active');
    e.preventDefault();
    var dataItem;
    dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var CompanyID = dataItem.CompID;
    //dvCompanyMapping
    //grdPE grdCont kgrdContr
    BindPEMapping(CompanyID);
    BindContractorMapping(CompanyID);
    return false;
}

function BindPEMapping(CompanyID)
{
    $.get(GetCompanyMappingUrl, { CompanyID: CompanyID, SiteID: 0}, function (response) {
        if (response.IsSuccess) {
            var data = JSON.parse(response.Data);
            if (kgrdPE != "") {
                $('#grdPE').kendoGrid('destroy').empty();
            }
            kgrdPE = $("#grdPE").kendoGrid({
                dataSource: {
                    data: JSON.parse(response.Data),
                    group: [{ field: "Comp", dir: "asc", aggregates: [{ field: "Activity", aggregate: "count" }] },
                        { field: "Site", dir: "asc", aggregates: [{ field: "Activity", aggregate: "count" }] },
                        { field: "Act", dir: "asc" }],
                    aggregate: [{ field: "Activity", aggregate: "count" }
                    ]
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
                columns: [{ field: "Comp", width: 100, visible: false, groupHeaderTemplate: "#=value # : (Total Activity : #=aggregates.Activity.count#) " },
                    { field: "Site", width: 100, visible: false, groupHeaderTemplate: "#=value # : (Total Activity : #=aggregates.Activity.count#) " },
                            { field: "Act", title: "Act", width: 100 },
                           { field: "Activity", title: "Activity",width:300 },
                           { field: "Frequency", title: "Frequency", width: 100 },
                           { field: "StartDate", title: "StartDate", width: 100 },
                             { field: "ExpiryDate", title: "Expiry Date", width: 100 },
                           { field: "Maker", title: "Maker", width: 100 },
                           { field: "Cheker", title: "Cheker", width: 100 },
                           { field: "CreatedOn", title: "Created On", width: 100 },
                           { field: "Status", title: "Status", width: 100 }

                ],
                width: 1100,
                height: 350,
                pageable: false,
                filterable: true,
                sortable: true,
                resizable: true,
                toolbar: [{ name: "excel", text: " Export" }, { template: kendo.template($("#template").html()) },
                              { template: kendo.template($("#template1").html()) }
                ],
                excel: {
                    fileName: "Company_Mapping.xlsx",
                    filterable: true,
                    pageable: true,
                    allPages: true
                },
                   
            });
            //collapseAll();
            $("#grdPE .k-grid-content.k-auto-scrollable").css("height", "272px");
        }
        else {
            FailResponse(response);
        }
    });
}

function BindContractorMapping(CompanyID) {
    $("#tabdvCont").addClass('active');
    $.get(GetContractorMappingUrl, { CompanyID: CompanyID,SiteID: 0 }, function (response) {
        //grdCont kgrdContr
        if (response.IsSuccess) {
            var data = JSON.parse(response.Data);
            var data = JSON.parse(response.Data);
            if (kgrdContr != "") {
                $('#grdCont').kendoGrid('destroy').empty();
            }
            var Configdialog = $("#dvCompanyMapping").dialog({
                autoOpen: false,
                modal: true,
                title: "Mapping Details",
                width: 1150,
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
            Configdialog.dialog("open");
            kgrdContr = $("#grdCont").kendoGrid({
                dataSource: {
                    data: JSON.parse(response.Data),
                    group: [{ field: "Comp", dir: "asc", aggregates: [{ field: "Activity", aggregate: "count" }] }, { field: "Site", dir: "asc", aggregates: [{ field: "Activity", aggregate: "count" }] },
                        { field: "Contractor", dir: "asc", aggregates: [{ field: "Activity", aggregate: "count" }] }, { field: "Act", dir: "asc" }],
                    aggregate: [{ field: "Activity", aggregate: "count" }
                    ]
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
                columns: [{ field: "Comp", width: 100, visible: false, groupHeaderTemplate: "#=value # : (Total Activity : #=aggregates.Activity.count#) " },
                    { field: "Site", width: 100, visible: false, groupHeaderTemplate: "#=value # : (Total Activity : #=aggregates.Activity.count#) " },
                     { field: "Contractor", width: 100, visible: false, groupHeaderTemplate: "#=value # : (Total Activity : #=aggregates.Activity.count#) " },
                     { field: "Act", title: "Act", width: 100 },
                    { field: "Activity", title: "Activity", width: 300 },
                           { field: "Frequency", title: "Frequency", width: 100 },
                           { field: "StartDate", title: "StartDate", width: 100 },
                             { field: "ExpiryDate", title: "Expiry Date", width: 100 },                             
                           { field: "Maker", title: "Maker", width: 100 },
                           { field: "Cheker", title: "Cheker", width: 100 },
                           { field: "CreatedOn", title: "Created On", width: 100 },
                           { field: "Status", title: "Status", width: 100 }

                ],
                  
                width: 1100,
                height: 350,
                pageable: false,
                filterable: true,
                sortable: true,
                scrollable:true,
                resizable: true,
                toolbar: [{ name: "excel", text: " Export" }, { template: kendo.template($("#expandallcont").html()) },
                                     { template: kendo.template($("#collapseallcont").html()) }

                ],
                excel: {
                    fileName: "Contractor Mapping.xlsx",
                    filterable: true,
                    pageable: true,
                    allPages: true
                }
            });
            $("#grdCont .k-grid-content.k-auto-scrollable").css("height", "272px");
            //collapseAllcont();
        }
        else {
            FailResponse(response);
        }
    });

        
}
var ViewHandler = function ViewHandler(e) {
    $("#liDetails").removeClass('active').addClass('active');
    $("#liHistory").removeClass('active')
    $("#tab_1_1").removeClass('active').addClass('active');
    $("#tab_1_2").removeClass('active');
        
    e.preventDefault();
    var dataItem;
    dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var CompanyID = dataItem.CompID;
    $.get(GetCompanyUrl, { CompanyID: CompanyID, CustID: 0 }, function (response) {
        if (response.IsSuccess) {
            var data = JSON.parse(response.Data)[0];
            $("#lblName").html(data.Name);
            $("#lblCustomer").html(data.CustomerNm);
            $("#lblAddress").html(data.Address);
            $("#lblContact_Person").html(data.Contact_Person);
            $("#lblPhone_Number").html(data.Phone_Number);
            $("#lblEmail").html(data.Email);
            $("#lblMaker").html(data.MakerNm);
            $("#lblChecker").html(data.CheckerNm);
            $("#lblMaker2").html(data.MakerText2);
            $("#lblChecker2").html(data.CheckerText2);
            $("#lblAuditor1").html(data.AuditorText1);
            $("#lblAuditor2").html(data.AuditorText2);
            var IsAct = data.IsAct;
            (IsAct == 1) ? $('#lblIsAct').html('Active') : $('#lblIsAct').html('In Active');
            HistoryGridData(CompanyID);
                
        }
        else {
            FailResponse(response);
        }
    });
    return false;
}
var EditHandler = function EditHandler(e) {
    e.preventDefault();
    $("#btnreset").click();
    var dataItem;
    dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var CompanyID = dataItem.CompID;
    $("#CompanyID").val(CompanyID);
    $.get(GetCompanyUrl, { CompanyID: CompanyID, CustID: 0 }, function (response) {
        if (response.IsSuccess) {
            var data = JSON.parse(response.Data)[0];
            $("#Name").val(data.Name);
            $("#Customer").val(data.Customer);
            $("#Address").val(data.Address);
            $("#Contact_Person").val(data.Contact_Person);
            $("#Phone_Number").val(data.Phone_Number);
            $("#Email").val(data.Email);
            $("#Maker").val(data.Maker);
            $("#Checker").val(data.Checker);
            $("#ddlMaker2").val(data.Maker2);
            $("#ddlChecker2").val(data.Checker2);
            $("#ddlAuditor1").val(data.Auditor1);
            $("#ddlAuditor2").val(data.Auditor2);
            $("#CompanyID").val(data.CompID);
            $("#CompanyCode").val(data.Code);
            //CompanyCode
            var IsAct = data.IsAct;
            (IsAct == 1) ? $('#IsAct').prop('checked', true) : $('#IsAct').prop('checked', false);
            $("#btnSubmit").val("Update");
            var dialog = $("#dvAddUpdate").dialog({
                autoOpen: false,
                modal: true,
                title: "Company Master",
                width: 950,
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
function FilterGrid(CustID, id) {
    $("a").removeClass("Active-SnapShot");
    $("#" + id).addClass("Active-SnapShot");
    $("#hdnFilterCustID").val(CustID);
    currentPage = 0;
    GetCompany(CustID);
}
function DownLoadAll() {
    //public ActionResult GetMapppingCount(string CompIDS,string sitesIDs,string ActIds,string ContractorIds)
    var URL = DownloadAllMapppingCompanyUrl;
    window.location = URL + "?CustID=" + $("#hdnFilterCustID").val() + "";
    return false;
}

function collapseAll() {
    var grid = $("#grdPE").data("kendoGrid");
    grid.tbody.find("tr.k-grouping-row").each(function (index) {
        grid.collapseGroup(this);
    });
    grid.pageable = false;
    return false;
}


function expandAll() {
    var grid = $("#grdPE").data("kendoGrid");


    grid.tbody.find("tr.k-grouping-row").each(function (index) {
        grid.expandGroup(this);

    });
    grid.pageable = true;
    grid.dataSource.pageSize(100);

    return false;
}
function collapseAllcont() {
    var grid = $("#grdCont").data("kendoGrid");
    grid.tbody.find("tr.k-grouping-row").each(function (index) {
        grid.collapseGroup(this);
    });
    grid.pageable = false;
    return false;
}
function expandAllcont() {
    var grid = $("#grdCont").data("kendoGrid");
    grid.tbody.find("tr.k-grouping-row").each(function (index) {
        grid.expandGroup(this);
    });
    grid.pageable = true;
    return false;
}
