$(document).ready(function () {
    $("#dvimport").bind("click", {}, OpenUploadPopup);
    $("#dvExport").bind("click", {}, DownLoadAll);
    $("#dvAdd").bind("click", {}, OpenAddPopUp);
});

function OpenAddPopUp() {
    $("#hdnSiteID").val(0);
    $("#btnSubmit").val("Submit");
    $("#btnReset").click();
    $("#IsAct").prop("checked", false);
    $("#ddlCompany").html('').append($('<option></option>').val("0").html("-- first select a customer --"));
    $("#dvAddUpdate").dialog({
        modal: true,
        title: "Site Master",
        width: 909,
        height: 550,
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
    event.preventDefault();
}

$(document).ready(function () {
    $("#btnMap").unbind().bind('click', MapPlot);
    $("#aSiteTotal").addClass("Active-SnapShot");
    $("#menu_2").addClass("active-menu");
    var SiteID = 0;
    BindGrid2(0);
    $('.scrollbox3').enscroll({
        showOnHover: false,
        verticalTrackClass: 'track3',
        verticalHandleClass: 'handle3'
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
            url: UploadSiteUrl,
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
var currentPage = 0;
function SuccessMessage(e) {
    HandleResponse(e, "dvAddUpdate", "btnReset", "hdnSiteID");
    if (e.IsSuccess == true) {
        var grid = $("#Kgrid").data("kendoGrid");
        currentPage = grid.dataSource.page();
        BindGrid2($("#hdnFilterComp").val());
        //refreshPageSize(currentPage);
    }
}
function FailMessage() {
    alert("Fail Post");
}

var Kgrid;
function HistoryGridData(SiteID) {
    $.ajax({
        type: "GET",
        url: getSiteHistoryUrl,
        contentType: "application/json; charset=utf-8",
        data: { "SiteID": SiteID },
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess) {
                HistorybindGrid(response.Data);
                var dialog = $("#modalpartial").dialog({
                    autoOpen: false,
                    modal: true,
                    title: "Site Details",
                    width: 1200, closeText: "",
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
                $('.ui-dialog-titlebar').show();
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
            data: JSON.parse(Data1),
            //width:200
        },
        columns: [
            //{ field: "CompID", title: "CompanyID", width: 90 },
            { field: "Company", title: "Company", width: 200 },
            { field: "Customer", title: "Customer", width: 150 },
            { field: "SiteName", title: "Site", width: 100 },
            { field: "State", title: "State", width: 100 },
            { field: "Location", title: "Location", width: 100 },
            { field: "ContactPerson", title: "Contact Person", width: 100 },
            { field: "ContactNumber", title: "Contact Number", width: 100 },
            { field: "Address", title: "Address", width: 150 },
            { field: "Maker", title: "Maker", width: 100 },
            { field: "Checker", title: "Checker", width: 100 },
            { field: "Status", title: "Status", width: 80 },
            { field: "UpdatedBy", title: "Updated By", width: 100 },
            { field: "UpdatedOn", title: "Updated On", width: 150 },
            { field: "Action", title: "Action", width: 80 },
        ],
        dataBound: function (e) {
            //=================================================
            var grid = e.sender;
            if (grid.dataSource.total() != 0) {
                var rows = grid.dataSource.total();
                var colCount = grid.columns.length;
                for (var i = rows - 1; i > 0; i--) {
                    for (var k = 0; k < colCount; k++) {

                        if (grid.tbody[0].children[i].cells[k].innerText != grid.tbody[0].children[i - 1].cells[k].innerText) {
                            grid.tbody[0].children[i - 1].cells[k].bgColor = "red";
                        }
                    }
                }
            }
        },
        //pageable: true,
        filterable: true,
        width: 1150,
        height: 300,
        noRecords: true,
        sortable: true,
        resizable: true,
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

function BindGrid(CompID) {
    var SiteID = 0;
    $.get(getSiteUrl, { SiteID: SiteID, CompID: CompID }, function (response) {
        var Kgrid = $("#Kgrid").data("kendoGrid");
        if ($(Kgrid).length > 0) {
            $("#Kgrid").data("kendoGrid").destroy();
            $('#Kgrid').empty();
        }
        if (response.IsSuccess) {
            var Data = $.parseJSON(response.Data);
            var columns = [{ field: "Name", title: "Site", width: 150 },
            { field: "CompanyText", title: "Company", width: 200 },
            { field: "CustomerText", title: "Customer", width: 150 },
            { field: "MakerText", title: "Maker", width: 100 },
            { field: "ChekcerText", title: "Cheker", width: 100 },
            { field: "IsActText", title: "Status", width: 80 },

            ];
            var objAddDiv = $("#dvAdd");
            if (objAddDiv.length > 0) {
                var cmd = {
                    command: [{ name: "Edit", text: "", imageClass: "k-icon k-edit", click: EditHandler, title: "Edit" },
                    { name: "View", text: "", imageClass: "k-icon k-view", click: ViewHandler, title: "View" },
                    { name: "ViewConfig", text: "", imageClass: "k-icon k-config", click: ViewConfig },
                        { name: "BindSite", text: "", imageClass: "k-icon ActionIconCopy", click: BindSite }
                    ], title: "Action", width: 120
                };
            }
            else {
                var cmd = {
                    command: [{ name: "View", text: "", imageClass: "k-icon k-view", click: ViewHandler, title: "View" },
                    { name: "ViewConfig", text: "", imageClass: "k-icon k-config", click: ViewConfig },
                        { name: "BindSite", text: "", imageClass: "k-icon ActionIconCopy", click: BindSite }
                    ], title: "Action", width: 120
                };
            }
            columns.push(cmd);
            var Data =
                Kgrid = $("#Kgrid").kendoGrid({
                    dataSource: {

                        transport: {},

                        parameterMap: function (data, type) {
                            return JSON.stringify({
                                SiteID: SiteID,
                                CompID: CompID,
                                page: data.page,
                                pageSize: data.pageSize,
                                skip: data.skip,
                                take: data.take,
                                sorting: data.sort === undefined ? null : data.sort,
                                filter: data.filter === undefined ? null : data.filter
                            });

                        },
                        schema: {
                            model: {
                                fields: {
                                    SiteID: { type: "number" },
                                    Company: { type: "number" },
                                    Site_Code: { type: "string" },
                                    CompanyText: { type: "string" },
                                    Customer: { type: "number" },
                                    CustomerText: { type: "string" },
                                    Name: { type: "string" },
                                    State: { type: "string" },
                                    StateText: { type: "string" },
                                    Maker: { type: "number" },
                                    Checker: { type: "number" },
                                    MakerText: { type: "string" },
                                    CheckerText: { type: "string" },

                                }
                            },
                            data: function (data) {
                                var res = JSON.parse(data.Data)

                                if (data.IsSuccess) {
                                    if (res.Data.length > 0) {
                                        return res.Data || [];
                                    }
                                }
                                else {
                                    alert("data 1")
                                    FailResponse(data);
                                }
                            },

                            total: function (data) {
                                if (data.IsSuccess) {
                                    var res = JSON.parse(data.Data)
                                    //var res = $.parseJSON(data.Data);
                                    if (res.Data.length > 0) {
                                        return res.Total || [];
                                    }
                                }
                                else {
                                    alert("data 2")
                                    FailResponse(data);
                                }
                            }
                        },
                        //pageSize: 15,
                        pageSize: 10,
                        serverPaging: true,
                        serverFiltering: true,
                        serverSorting: true,
                        data: Data,
                        sort: { field: "Name", dir: "asc" }
                    },
                    dataBound: ShowToolTip,
                    pageable: { pageSizes: true },
                    filterable: true,
                    sortable: true,
                    groupable: true,
                    resizable: true,
                    reorderable: true,
                    noRecords: true,
                    height: 400,
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

var Kgrid = "";
function BindGrid2(CompID) {
    var SiteID = 0;
    var url = getSiteUrl;
    var typepar = "";
    if (Kgrid != "") {
        $('#Kgrid').kendoGrid('destroy').empty();
    }
    var columns = [{ field: "Name", title: "Site", width: 150 },
    { field: "CompanyText", title: "Company", width: 200 },
    { field: "CustomerText", title: "Customer", width: 150 },
    { field: "MakerText", title: "Maker", width: 100 },
    { field: "ChekcerText", title: "Cheker", width: 100 },
    { field: "IsActText", title: "Status", width: 80 },

    ];
    var objAddDiv = $("#dvAdd");
    if (objAddDiv.length > 0) {
        var cmd = {
            command: [{ name: "Edit", text: "", imageClass: "k-icon k-edit", click: EditHandler, title: "Edit" },
            { name: "View", text: "", imageClass: "k-icon k-view", click: ViewHandler, title: "View" },
            { name: "ViewConfig", text: "", imageClass: "k-icon k-config", click: ViewConfig },
                { name: "BindSite", text: "", imageClass: "k-icon ActionIconCopy", click: BindSiteHandler }
            ], title: "Action", width: 150
        };
    }
    else {
        var cmd = {
            command: [{ name: "View", text: "", imageClass: "k-icon k-view", click: ViewHandler, title: "View" },
            { name: "ViewConfig", text: "", imageClass: "k-icon k-config", click: ViewConfig },
                { name: "BindSite", text: "", imageClass: "k-icon ActionIconCopy", click: BindSiteHandler }
            ], title: "Action", width: 150
        };
    }
    columns.push(cmd);
    Kgrid = $("#Kgrid").kendoGrid({
        dataSource: {
            type: "json",
            transport: {
                read: {
                    url: getSiteUrl,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                },
                parameterMap: function (data, type) {
                    return JSON.stringify({
                        SiteID: SiteID,
                        CompID: CompID,
                        page: data.page,
                        pageSize: data.pageSize,
                        skip: data.skip,
                        take: data.take,
                        sorting: data.sort === undefined ? null : data.sort,
                        filter: data.filter === undefined ? null : data.filter
                    });

                },

            },

            schema: {
                model: {
                    fields: {
                        Name: { type: "string" },
                        CompanyText: { type: "string" },
                        CustomerText: { type: "string" },
                        MakerText: { type: "string" },
                        CheckerText: { type: "string" },
                        IsActText: { type: "string" },
                    }
                },
                data: function (data) {
                    var res = JSON.parse(data.Data)
                    if (data.IsSuccess) {
                        if (res.Data.length > 0) {
                            return res.Data || [];
                        }
                    }
                    else {
                        alert("data 1")
                        FailResponse(data);
                    }
                },
                total: function (data) {
                    if (data.IsSuccess) {
                        var res = JSON.parse(data.Data)
                        if (res.Data.length > 0) {
                            return res.Total || [];
                        }
                    }
                    else {
                        alert("data 2")
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
        height: 400,
        filterable: true,
        toolbar: [{ name: "excel" }],
        excel: {
            fileName: "TaskReconsilation.xlsx",
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
        columns: columns

    });
}




function ShowToolTip() {
    $(".k-icon.k-edit").parent().attr("title", "Edit");
    $(".k-icon.k-view").parent().attr("title", "View");
    $(".k-icon.k-config").parent().attr("title", "Configuration");
    $(".k-icon.ActionIconCopy").parent().attr("title", "Copy");
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
    $(".k-icon.ActionIconCopy").parent().kendoTooltip({
        width: 90,
        position: "top"
    }).data("kendoTooltip");
}
// For Upload popup

function OpenUploadPopup() {
    $("#dialog").dialog({
        autoOpen: false,
        width: 500,
        title: "Upload Site",
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

function DownLoadSampleSite() {
    //public ActionResult GetMapppingCount(string CompIDS,string sitesIDs,string ActIds,string ContractorIds)
    var URL = DownloadSampleSiteUrl;
    window.location = URL;
    return false;
}
var ViewHandler = function ViewHandler(e) {
    $("#liDetails").removeClass('active').addClass('active');
    $("#liHistory").removeClass('active')
    $("#tab_1_1").removeClass('active').addClass('active');
    $("#tab_1_2").removeClass('active');
    e.preventDefault();
    dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var SiteID = dataItem.SiteID;
    $.post(getSiteUrl, { SiteID: SiteID, CompID: 0, page: 1, pageSize: 10, skip: 0, take: 10 }, function (response) {
        if (response.IsSuccess) {
            var Data = $.parseJSON(response.Data).Data;
            $("#lblCompany").html(Data[0].CompanyText);
            $("#lblCustomer").html(Data[0].CustomerText);
            $("#lblName").html(Data[0].Name);
            $("#lblState").html(Data[0].StateText);
            $("#lblLocation").html(Data[0].Location);
            $("#lblContact_Person").html(Data[0].Contact_Person);
            $("#lblContact_Number").html(Data[0].Contact_Number);
            $("#lblAddress").html(Data[0].Address);
            $("#lblMaker").html(Data[0].MakerText);
            $("#lblChecker").html(Data[0].CheckerText);
            $("#lblMaker2").html(Data[0].MakerText2);
            $("#lblChecker2").html(Data[0].CheckerText2);
            $("#lblAuditor1").html(Data[0].AuditorText1);
            $("#lblAuditor2").html(Data[0].AuditorText2);
            var IsAct = Data[0].IsAct;
            (IsAct == 1) ? $('#lblIsAct').html('Active') : $('#lblIsAct').html('In Active');
            HistoryGridData(SiteID);
        }
        else {
            FailResponse(response);
        }
    });
}
var EditHandler = function EditHandler(e) {
    $("#btnReset").click();
    e.preventDefault();
    dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var SiteID = dataItem.SiteID;
    $.post(getSiteUrl, { SiteID: SiteID, CompID: 0, page: 1, pageSize: 10, skip: 0, take: 10, }, function (response) {
        if (response.IsSuccess) {
            var Data = $.parseJSON(response.Data).Data;
            $("#hdnSiteID").val(SiteID);
            $("#ddlCustomer").val(Data[0].Customer);
            //Bind Company DropDownList===============
            var CustID = Data[0].Customer;
            var ddlCompany = $("#ddlCompany");
            ddlCompany.empty().append($('<option></option>').val("0").html("Please wait..."));
            if (CustID != "0") {
                $.get(GetMappedCompanyUrl, { CustID: CustID }, function (response) {
                    if (response.IsSuccess) {
                        ddlCompany.empty().append($('<option></option>').val("0").html("-- Select --"));
                        var ds = $.parseJSON(response.Data);
                        if (ds.length > 0) {
                            $.each(ds, function () {
                                ddlCompany.append($('<option></option>').val(this.CompID).html(this.Name));
                            });
                            $("#ddlCompany").val(Data[0].Company);
                        }
                        else {
                            ddlCompany.empty().append($('<option></option>').val(0).html("--Select--"));
                        }
                    }
                });
            }
            else {
                ddlCompany.html('').append($('<option></option>').val("0").html("-- first select a customer --"));
            }
            //=======================================
            $("#ddlState").val(Data[0].State);
            //Bind Location Drop down list
            var StateID = Data[0].State;
            var ddlLocation = $("#ddlLocation");
            ddlLocation.empty().append($('<option></option>').val("0").html("Please wait..."));
            if (StateID != "0") {
                $.get(GetLocationForSiteUrl, { StateID: StateID }, function (response) {
                    if (response.IsSuccess) {
                        ddlLocation.empty().append($('<option></option>').val("0").html("-- Select --"));
                        var ds = $.parseJSON(response.Data);
                        if (ds.length > 0) {
                            $.each(ds, function () {
                                ddlLocation.append($('<option></option>').val(this.LocationID).html(this.Name));
                            });
                            $("#ddlLocation").val(Data[0].LocationID);
                        }
                        else {
                            ddlLocation.empty().append($('<option></option>').val(0).html("--Select--"));
                        }
                    }
                    else {
                        FailResponse(response);
                    }
                });
            }
            else {
                ddlLocation.html('').append($('<option></option>').val("0").html("-- first select a state --"));
            }
            //==============================================================
            $("#txtName").val(Data[0].Name);
            $("#txtSiteCode").val(Data[0].Site_Code);
            $("#txtContact_Person").val(Data[0].Contact_Person);
            $("#txtContact_Number").val(Data[0].Contact_Number);
            $("#txtAddress,#txtMapAddress").val(Data[0].Address);
            $("#hdnSiteLatLong").val(Data[0].LatLong);
            $("#hdnPlaceID").val(Data[0].PlaceID)
            $("#ddlMaker").val(Data[0].Maker);
            $("#ddlChecker").val(Data[0].Checker);
            $("#ddlMaker2").val(Data[0].Maker2);
            $("#ddlChecker2").val(Data[0].Checker2);
            $("#ddlAuditor1").val(Data[0].Auditor1);
            $("#ddlAuditor2").val(Data[0].Auditor2);
            var IsAct = Data[0].IsAct;
            (IsAct == 1) ? $('#IsAct').prop('checked', true) : $('#IsAct').prop('checked', false);
            $("#btnSubmit").val("Update");
            $("#dvAddUpdate").dialog({
                modal: true,
                title: "Site Master",
                width: 909, closeText: "",
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
            //event.preventDefault();
        }
        else {
            FailResponse(response);
        }
    });
}
//Edited by

function BindCompanyForMapping() {
    var ddlMappingCompany = $("#ddlMappingCompany");
    $.get(GetMappedCompanyUrl, { CustID: CustIDforBind }, function (response) {
        if (response.IsSuccess) {
            ddlMappingCompany.empty().append($('<option></option>').val("").html("-- Select --"));
            var ds = $.parseJSON(response.Data);
            if (ds.length > 0) {
                $.each(ds, function () {
                    ddlMappingCompany.append($('<option></option>').val(this.CompID).html(this.Name));
                });
                $("#ddlMappingCompany").val(CompanyIDForBind);
            }
        }
    });
}

$("#ddlMappingCompany").change(function () {
    var CompID = $(this).val();
    BindSiteForMapping(CompID);
});
function BindSiteForMapping(CompID) {
        var ddlMappingSite = $("#ddlMappingSite");
        ddlMappingSite.empty().append($('<option></option>').val("0").html("Please wait..."));
        if (CompID != "0") {
            $.get(GetMappingSiteURL, { CompanyID: CompID }, function (response) {
                if (response.IsSuccess) {
                    ddlMappingSite.empty().append($('<option></option>').val("0").html("-- Select --"));
                    var ds = $.parseJSON(response.Data);
                    if (ds.length > 0) {
                        $.each(ds, function () {
                            ddlMappingSite.append($('<option></option>').val(this.siteID).html(this.Name));
                        });
                        $("#ddlMappingSite").val(SiteIDForBind);
                    }
                    else {
                        ddlMappingSite.empty().append($('<option></option>').val(0).html("--Select--"));
                    }
                }
                else {
                    FailResponse(response);
                }
            });
        }
        else {
            ddlMappingSite.html('').append($('<option></option>').val("0").html("-- first select a Company --"));
        }
   // });
}
var SiteIDForBind = '';
var SiteNameForBind = '';
var CompanyIDForBind = "";
var CustIDforBind = "";
function BindSiteHandler(e) {
    e.preventDefault();
    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    //alert(dataItem.SiteID);
    SiteIDForBind = dataItem.SiteID;
    CompanyIDForBind = dataItem.Company;
    SiteNameForBind = dataItem.Name;
    CustIDforBind = dataItem.Customer;
   // BindSiteForMapping();
    GetMappingSiteData(SiteIDForBind);
    if (dataItem.TotalMapping <= 0) {
        $("#divGroupDowndown").show();
        BindCompanyForMapping();
        BindSiteForMapping(CompanyIDForBind);
        $("#btnSubmitSite").val("Copy");
    } else {
        $("#divGroupDowndown").hide();
        $("#btnSubmitSite").val("Update");
    }
   // $("#ddlMappingSite").val(dataItem.SiteID);
    //$("#dvMappingSite").modal('show');
    OpenSiteMappingPopUp();
}
function GetMappingSiteData(value) {
    $.get(BindSiteUrl, { SiteID: value, NewSiteID: SiteIDForBind }, function (response) {
        if (response.IsSuccess) {
            var data = JSON.parse(response.Data);
            $("#hdnCountsite").val(data.Total);
            BindActivityMappingGrid(data.Data);
        }
    });
}
$("#ddlMappingSite").change(function () {
    var value = $('select#ddlMappingSite option:selected').val();
    GetMappingSiteData(value);
});
var KSitegrd = "";
function BindActivityMappingGrid(Data) {
    
    if (KSitegrd != "") {
        $('#KSitegrd').kendoGrid('destroy').empty();
    }
    var GridColumns = [
        { title: "<input id='chkAll' class='checkAllCls' type='checkbox'/>", width: "20px", template: "<input type='checkbox' class='check-box-inner' />", filterable: false },
        { field: "MappingID", title: "MappingID", width: 60 },
        { field: "CompanyName", title: "CompanyName", width: 60 },
        { field: "SiteName", title: "SiteName", width: 60 },
        { field: "ActName", title: "ActName", width: 60 },
        { field: "ActivityName", title: "ActivityName", width: 60 },
        { field: "StartDate", title: "StartDate", width: 60 }

    ];

    KSitegrd = $("#KSitegrd").kendoGrid({
        dataSource: {
           // pageSize: 10,
            data: Data,
            schema: {
                model: {
                    id: "TID"

                }
            }
        },
        //pageable: { pageSizes: true },
        height: 390,
        filterable: true,
        noRecords: true,
        resizable: true,
        persistSelection: true,
        reorderable: true,
        sortable: true,
       // toolbar: [{ template: kendo.template($("#template").html()) }],
        columns: GridColumns,
        //dataBound: function (e) {
        //    var grid = $("#KSitegrd").data("kendoGrid");
        //    var gridData = grid.dataSource.view();
        //    for (var i = 0; i < gridData.length; i++) {

        //    }
        //}

    });
    $(".checkAllCls").on("click", function () {
        var ele = this;
        var state = $(ele).is(':checked');
        // alert(state);
        var grid = $('#KSitegrd').data('kendoGrid');
        if (state == true) {
            $('.check-box-inner').prop('checked', true);

        }
        else {
            $('.check-box-inner').prop('checked', false);

        }
    });

    $(".check-box-inner").click(function () {
        if ($(".check-box-inner").length == $(".check-box-inner:checked").length) {
            $('.checkAllCls').prop('checked', true);
        } else {
            $('.checkAllCls').prop('checked', false);
        }

    });
    //bind the click event to the checkbox
   // KSitegrd.element.on("click", ".k-checkbox", selectRow);
}



$("#btnSubmitSite").click(function () {
    var grid = $("#KSitegrd").data("kendoGrid");
    var ds = grid.dataSource.data();
    var lstMapping = "";
    var sitecount = $("#hdnCountsite").val();
    for (var i = 0; i < ds.length; i++) {
        var row = grid.table.find("tr[data-uid='" + ds[i].uid + "']");
        var checkbox = $(row).find(".check-box-inner");
        if (checkbox.is(":checked")) {
            if (lstMapping == "") {
                lstMapping += ds[i].MappingID;
            } else {
                lstMapping += "," + ds[i].MappingID;
            }
            // lstMapping.push(ds[i].MappingID);
        }
    }
  
    if (lstMapping != "") {
        var form = $('#__AjaxAntiForgeryForm');
        var token = $('input[name="__RequestVerificationToken"]', form).val();
        // var Data = { __RequestVerificationToken: token, MappingID: lstMapping };
        $.ajax({
            type: "POST",
            url: AddMappingSiteUrl,
            contentType: "application/x-www-form-urlencoded",
            data: {
                __RequestVerificationToken: token,
                MappingID: lstMapping,
                SiteID: SiteIDForBind,
                CompanyID: CompanyIDForBind,
                MappingCount: sitecount
            },
            dataType: "json",
            success: function (response) {
                if (response.IsSuccess == true) {
                    response.Message = 'Mapping of the Site ' + SiteNameForBind + ' changed successfully.';
                    BindGrid2(0);
                }
                else {
                    response.Message = 'Something went wrong.';
                }
                HandleResponse(response, "dvMappingSite", "btnReset","");
                //FailResponse(response);
            }
        });
    }
    else {
        alert("Please Select checkBox.");
    }
});


//Vishal

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
    var CompanyID = dataItem.Company;
    var SiteID = dataItem.SiteID;
    //alert(CompanyID + '&' + SiteID);
    //dvCompanyMapping
    //grdPE grdCont kgrdContr
    BindPEMapping(CompanyID, SiteID);
    BindContractorMapping(CompanyID, SiteID);
    return false;
}

function OpenSiteMappingPopUp() {
    var dialog =  $("#dvMappingSite").dialog({
        modal: true,
        title: "Chose Site",
        width: 909,
        height: 550,//570,
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
function BindPEMapping(CompanyID, SiteID) {
    $("#tabdvPE").addClass('active');
    $.get(GetCompanyMappingUrl, { CompanyID: CompanyID, SiteID: SiteID }, function (response) {
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
            $("#grdPE .k-grid-content.k-auto-scrollable").css("height", "272px");
            //$(".k-auto-scrollable").css("height", "272px");
            //expandAll();
            //collapseAll();
        }
        else {
            FailResponse(response);
        }
    });
}

function BindContractorMapping(CompanyID, SiteID) {
    $("#tabdvCont").addClass('active');
    $.get(GetContractorMappingUrl, { CompanyID: CompanyID, SiteID: SiteID }, function (response) {
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
                scrollable: true,
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

            //collapseAllcont();
            $("#grdCont .k-grid-content.k-auto-scrollable").css("height", "272px");
        }
        else {
            FailResponse(response);
        }
    });


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

function FilterGrid(companyID, id) {
    $("a").removeClass("Active-SnapShot");
    $("#" + id).addClass("Active-SnapShot");
    $("#hdnFilterComp").val(companyID);
    currentPage = 0;
    BindGrid2(companyID);
}


function DownLoadAll() {
    //public ActionResult GetMapppingCount(string CompIDS,string sitesIDs,string ActIds,string ContractorIds)
    var URL = DownloadAllMapppingSiteUrl;
    window.location = URL + "?CompID=" + $("#hdnFilterComp").val() + "";
    return false;
}

$(document).ready(function () {

    $("#btnMapOK").click(function () {
        $('#dvfilter').dialog('close');
    });

    $("#ddlCustomer").change(function () {
        var CustID = $(this).val();
        var ddlCompany = $("#ddlCompany");
        ddlCompany.empty().append($('<option></option>').val("0").html("Please wait..."));
        if (CustID != "0") {
            $.get(GetMappedCompanyUrl, { CustID: CustID }, function (response) {
                if (response.IsSuccess) {
                    ddlCompany.empty().append($('<option></option>').val("0").html("-- Select --"));
                    var ds = $.parseJSON(response.Data);
                    if (ds.length > 0) {
                        $.each(ds, function () {
                            ddlCompany.append($('<option></option>').val(this.CompID).html(this.Name));
                        });
                    }
                    else {
                        ddlCompany.empty().append($('<option></option>').val(0).html("--Select--"));
                    }
                }
                else {
                    FailResponse(response);
                }
            });
        }
        else {
            ddlCompany.html('').append($('<option></option>').val("0").html("-- first select a customer --"));
        }
    });

    $("#ddlState").change(function () {
        var StateID = $(this).val();
        var ddlLocation = $("#ddlLocation");
        ddlLocation.empty().append($('<option></option>').val("0").html("Please wait..."));
        if (StateID != "0") {
            $.get(GetLocationForSiteUrl, { StateID: StateID }, function (response) {
                if (response.IsSuccess) {
                    ddlLocation.empty().append($('<option></option>').val("0").html("-- Select --"));
                    var ds = $.parseJSON(response.Data);
                    if (ds.length > 0) {
                        $.each(ds, function () {
                            ddlLocation.append($('<option></option>').val(this.LocationID).html(this.Name));
                        });
                    }
                    else {
                        ddlLocation.empty().append($('<option></option>').val(0).html("--Select--"));
                    }
                }
                else {
                    FailResponse(response);
                }
            });
        }
        else {
            ddlLocation.html('').append($('<option></option>').val("0").html("-- first select a state --"));
        }
    });

});

function initMap() {
    $("form").bind("keypress", function (e) {
        if (e.keyCode == 13) {
            return false;
        }
    });
    var input = document.getElementById('txtAddress');
    var autocomplete = new google.maps.places.Autocomplete(input);

    google.maps.event.addListener(autocomplete, 'place_changed', function (e) {
        var place = autocomplete.getPlace();
        var address = '';
        if (place.address_components) {
            address = [
                (place.address_components[0] && place.address_components[0].short_name || ''),
                (place.address_components[1] && place.address_components[1].short_name || ''),
                (place.address_components[2] && place.address_components[2].short_name || '')
            ].join(' ');
        }
        if (place.formatted_address != undefined) {
            $('#txtAddress,#txtMapAddress').val(place.formatted_address);
            $("#hdnPlaceID").val(place.place_id);
        }
        var geocoder = new google.maps.Geocoder();
        geocoder.geocode({ 'address': place.formatted_address }, function (results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
                $("#hdnSiteLatLong").val(results[0].geometry.location.lat() + ", " + results[0].geometry.location.lng());
                return;
            } else {
                alert("Something got wrong " + status);
                return;
            }
        });
    });
}
var map = "", marker = "", placeID = "";
function MapPlot() {
    $("#dvfilter").dialog({
        modal: true,
        title: "Site Address Map",
        width: 600, closeText: "",
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
    $("#mapaddress").empty();
    marker = "", placeID = "";
    var LatLong = $("#hdnSiteLatLong").val();
    var Lat = 20.5937;
    var Long = 78.9629;
    placeID = "ChIJo9kg20EZDTkRkLRaMOAQhmQ";
    if (LatLong != "") {
        Lat = LatLong.split(', ')[0];
        Long = LatLong.split(', ')[1];
        placeID = $("#hdnPlaceID").val() != "" ? $("#hdnPlaceID").val() : "ChIJo9kg20EZDTkRkLRaMOAQhmQ";
    }
    var mapOptions = {
        center: new google.maps.LatLng(Lat, Long),
        zoom: 17,
        disableDefaultUI: true,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map(document.getElementById('mapaddress'), mapOptions);

    var infowindow = new google.maps.InfoWindow();

    var service = new google.maps.places.PlacesService(map);
    service.getDetails({
        placeId: placeID
    }, function (place, status) {
        if (status === google.maps.places.PlacesServiceStatus.OK) {
            marker = new google.maps.Marker({
                map: map,
                position: place.geometry.location
            });
            if (place.geometry.viewport) {
                map.fitBounds(place.geometry.viewport);
            } else {
                map.setCenter(place.geometry.location);
                map.setZoom(17);
            }

            // Set the position of the marker using the place ID and location.
            marker.setPlace({
                placeId: place.place_id,
                location: place.geometry.location
            });
            marker.setVisible(true);

            google.maps.event.addListener(marker, 'click', function () {
                infowindow.setContent('<div><strong>' + place.name + '</strong><br>' +
                    'Place ID: ' + place.place_id + '<br>' +
                    place.formatted_address + '</div>');
                infowindow.open(map, this);
            });
        }
    });

    var infowindowContent = document.getElementById('infowindow-content');
    infowindow.setContent(infowindowContent);

    var input = document.getElementById('txtMapAddress');
    var autocomplete = new google.maps.places.Autocomplete(input);

    autocomplete.bindTo('bounds', map);
    //marker = new google.maps.Marker({
    //    map: map,
    //    anchorPoint: new google.maps.Point(0, -29)
    //});
    google.maps.event.addListener(autocomplete, 'place_changed', function () {
        infowindow.close();
        place = autocomplete.getPlace();
        if (!place.geometry) {
            return;
        }
        var address = '';
        if (place.address_components) {
            address = [
                (place.address_components[0] && place.address_components[0].short_name || ''),
                (place.address_components[1] && place.address_components[1].short_name || ''),
                (place.address_components[2] && place.address_components[2].short_name || '')
            ].join(' ');
        }
        if (place.formatted_address != undefined) {
            $('#txtAddress,#txtMapAddress').val(place.formatted_address);
            $("#hdnPlaceID").val(place.place_id);
        }
        marker.setMap(null);
        //markers = [];
        marker = new google.maps.Marker({
            map: map,
            position: place.geometry.location
        });
        if (place.geometry.viewport) {
            map.fitBounds(place.geometry.viewport);
        } else {
            map.setCenter(place.geometry.location);
            map.setZoom(17);
        }

        // Set the position of the marker using the place ID and location.
        marker.setPlace({
            placeId: place.place_id,
            location: place.geometry.location
        });
        marker.setVisible(true);
        infowindow = new google.maps.InfoWindow();
        google.maps.event.addListener(marker, 'click', function () {
            infowindow.setContent('<div><strong>' + place.name + '</strong><br>' +
                'Place ID: ' + place.place_id + '<br>' +
                place.formatted_address + '</div>');
            infowindow.open(map, this);
        });
        var geocoder = new google.maps.Geocoder();
        geocoder.geocode({ 'address': place.formatted_address }, function (results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
                $("#hdnSiteLatLong").val(results[0].geometry.location.lat() + ", " + results[0].geometry.location.lng());
                return;
            } else {
                alert("Something got wrong " + status);
                return;
            }
        });
    });
}


