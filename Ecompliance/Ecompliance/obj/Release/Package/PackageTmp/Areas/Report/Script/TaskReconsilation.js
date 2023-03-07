var ObjSites = "";
var ObjActs = "";
var ObjActivitys = "";
var ObjContractors = "";
function getYear() {
    var date = new Date();
    var CurrYear = date.getFullYear();
    var PrevYear = date.getFullYear() - 1;
    var PastYear = date.getFullYear() + 1;
    $("#ddlYear").append($('<option></option>').val(PrevYear).html(PrevYear));
    $("#ddlYear").append($('<option></option>').val(CurrYear).html(CurrYear));
    $("#ddlYear").append($('<option></option>').val(PastYear).html(PastYear));
}
$(document).ready(function () {
    $('#txtDocID').keypress(function (event) {
        if (event.keyCode == 13) {
            $('#btnShow').click();
        }
    });
    getYear();
    $("#txtExpiryDate").datepicker({
        dateFormat: 'dd/mm/yy',
    });
    $("#txtFromDate").datepicker({
        dateFormat: 'dd/mm/yy',
        changeMonth: true,
        changeYear: true,
        showOtherMonths: true,
        selectOtherMonths: true
      
    });
    $("#txtFromDate").datepicker().datepicker("setDate", new Date());
    $('#txtFromDate').change(function () {

        var start_date = $(this).val();
        var maxdate = new Date();
       var start_date1 = $(this).datepicker('getDate');
       maxdate = start_date1;
        maxdate.setMonth(start_date1.getMonth() + 3);
        
        $('#txtToDate').datepicker('destroy');
        $('#txtToDate').val('');
        $("#txtToDate").datepicker({            
            minDate: start_date,
            maxDate:maxdate,
            dateFormat: 'dd/mm/yy',
        });
        $("#txtToDate").datepicker().datepicker("setDate", maxdate);
    });
    var MaxDateTODT = new Date();
    MaxDateTODT.setMonth(MaxDateTODT.getMonth()+3);
    $("#txtToDate").datepicker({
        minDate: new Date(),
        maxDate:MaxDateTODT,
        dateFormat: 'dd/mm/yy',
        defaultDate:MaxDateTODT
    });
    $("#txtToDate").datepicker().datepicker("setDate", MaxDateTODT);
    
   
   
    $("#spnExpDate").click(function () {
        $('#txtExpiryDate').datepicker('show');
    });
    $("#spnfrmDate").click(function () {
        $('#txtFromDate').datepicker('show');
    });
    $("#spnToDate").click(function () {
        $('#txtToDate').datepicker('show');
    });
    $("#ddlcompany").change(function () {
        var Company = $(this).val();
        BindSite(Company);
        BindContractor(Company);
    });

    //ObjActs = $("#ddlAct").kendoMultiSelect({
    //    autoClose: false,
    //    change: function (e) {
    //        var value = this.value();
    //        BindActivity(value);
    //        //alert(value);
    //    }
    //}).data("kendoMultiSelect");

    $("#btnShow").bind("click", {}, BindGrid);

    $("#btnAllSite").click(SelectALLSites);
    $("#btnAllActs").click(SelectALLActs);
    $("#btnAllContractor").click(SelectALLContractors);
    $("#btnAllActivitys").click(SelectALLActivity);

    $("#ddlActivitytype").change(function () {
        var ActivityType = $(this).val();
        if (ActivityType == "Contractor") {
            $("#dvCont").removeClass("modal");
        }
        else {
            $("#dvCont").addClass("modal");
            ObjContractors.value("");
            ContractorIDs = "";
            //$("#ddlContractor").next().removeClass("field-validation-error").addClass("field-validation-valid").html("");
        }
    });
});

//Bind Search Drop down list.............
function BindSite(CompID) {
    var Data = { CompanyID: CompID };
    $.ajax({
        type: "GET",
        url: GetMappedSiteUrl,
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
                ObjSites = $("#ddlSite").kendoMultiSelect({
                    dataTextField: "Name",
                    dataValueField: "SiteID",
                    dataSource: data,
                    autoClose: false,
                    change: function (e) {
                        var value = this.value();
                        BindActs(value);
                        //alert(value);
                    }
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
function BindContractor(CompID) {
    var Data = { CompID: CompID };
    $.ajax({
        type: "GET",
        url: GetContractorOfTaskFilterUrl,
        contentType: "application/json; charset=utf-8",
        data: Data,
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess) {
                var res = response.Data;
                var data;
                //dvSite
                $("#dvContractor").html("");
                var str = '<select id="ddlContractor"   multiple="multiple" data-placeholder="Select contractor..." >' +
                            '</select>';
                $("#dvContractor").html(str);
                if (response.IsSuccess == true) {
                    data = $.parseJSON(res);
                }
                else {
                    data = { "Name": "-----Select-------", "ContractorID": "0" };
                }
                ObjContractors = $("#ddlContractor").kendoMultiSelect({
                    dataTextField: "Name",
                    dataValueField: "ContractorID",
                    dataSource: data,
                    autoClose: false
                }).data("kendoMultiSelect");
            }
            else {
                FailResponse(response);
            }
        }
    });
}
//Bind Act MultiSelect==========================
function BindActs(SiteIdss) {
    var SiteIDs;
    if (ObjSites != "") SiteIDs = ObjSites.value() + "";
    //var CompID = $("#ddlcompany").val();
    var Data = { SiteIDs: SiteIDs };
    $.ajax({
        type: "GET",
        url: GetMappedActsForMultipleSiteUrl,
        contentType: "application/json; charset=utf-8",
        data: Data,
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess) {
                var res = response.Data;
                var data;
                //dvSite
                $("#dvAct").html("");
                var str = '<select id="ddlAct" multiple="multiple" data-placeholder="Select site..." >' +
                            '</select>';
                $("#dvAct").html(str);
                if (response.IsSuccess == true) {
                    data = $.parseJSON(res);
                }
                else {
                    data = { "Name": "-----Select-------", "ActID": "0" };
                }
                ObjActs = $("#ddlAct").kendoMultiSelect({
                    dataTextField: "Name",
                    dataValueField: "ActID",
                    dataSource: data,
                    autoClose: false,
                    change: function (e) {
                        var value = this.value();
                        BindActivity(value);
                        //alert(value);
                    }
                }).data("kendoMultiSelect");
            }
            else {
                FailResponse(response);
            }
        }
    });
}
//==============================================
function BindActivity(ActIdss) {
    var ActIDs;
    if (ObjActs != "") ActIDs = ObjActs.value() + "";
    var Data = { ActIds: ActIDs };
    $.ajax({
        type: "GET",
        url: GetActivityForAllAertsUrl,
        contentType: "application/json; charset=utf-8",
        data: Data,
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess) {
                var res = response.Data;
                var data;
                //dvSite
                $("#dvActivity").html("");
                var str = '<select id="ddlActivity" multiple="multiple" data-placeholder="Select activity..." >' +
                            '</select>';
                $("#dvActivity").html(str);
                if (response.IsSuccess == true) {
                    data = $.parseJSON(res);
                }
                else {
                    data = { "Name": "-----Select-------", "ActivityID": "0" };
                }
                ObjActivitys = $("#ddlActivity").kendoMultiSelect({
                    dataTextField: "Name",
                    dataValueField: "ActivityID",
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
function SelectALLActs() {
    var multiSelect = $("#ddlAct").data("kendoMultiSelect");
    var selectedValues = "";
    var strComma = "";
    for (var i = 0; i < multiSelect.dataSource.data().length; i++) {
        var item = multiSelect.dataSource.data()[i];
        selectedValues += strComma + item.ActID;
        strComma = ",";
    }
    multiSelect.value(selectedValues.split(","));
    BindActivity("");
}
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
    BindActs("");
}
function SelectALLContractors() {
    var multiSelect = $("#ddlContractor").data("kendoMultiSelect");
    var selectedValues = "";
    var strComma = "";
    for (var i = 0; i < multiSelect.dataSource.data().length; i++) {
        var item = multiSelect.dataSource.data()[i];
        selectedValues += strComma + item.ContractorID;
        strComma = ",";
    }
    multiSelect.value(selectedValues.split(","));
}
function SelectALLActivity() {
    var multiSelect = $("#ddlActivity").data("kendoMultiSelect");
    var selectedValues = "";
    var strComma = "";
    for (var i = 0; i < multiSelect.dataSource.data().length; i++) {
        var item = multiSelect.dataSource.data()[i];
        selectedValues += strComma + item.ActivityID;
        strComma = ",";
    }
    multiSelect.value(selectedValues.split(","));
}
//=================================================================

var Kgrid = "";
function BindGrid() {
    var ActvityType = $("#ddlActivitytype").val();
    var CompID = $("#ddlcompany").val();

    var FromDate = $("#txtFromDate").val();
    var ToDate = $("#txtToDate").val();
    var DocID = $("#txtDocID").val();
    var url = GetDocTaskSearchGridUrl;
    var typepar = "";
    if (Kgrid != "") {
        $('#Kgrid').kendoGrid('destroy').empty();
    }
    Kgrid = $("#Kgrid").kendoGrid({
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
                        ActivityType: ActvityType,
                        CompIDs: CompID,
                        //SiteIDs: SiteIDs,
                        //ActIDs: ActIDs,
                        //ActivityIDs: ActivityIDs,
                        FromDate: FromDate,
                        ToDate: ToDate,
                      //  DocID: DocID,
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
                        DOCID: { type: "number" },
                        Attachment: { type: "number" },
                        Company: { type: "string" },
                        Site: { type: "string" },
                        Act: { type: "string" },
                        Activity: { type: "string" },
                        ActivityType: { type: "string" },
                        TaskCreationDate: { type: "date" },
                        Maker: { type: "string" },
                        Checker: { type: "string" },
                        Currstatus: { type: "string" },
                        Status:{type:"string"},
                        ComplianceStatus:{type: "string"},
                        Action_CompletionDate: { type: "date" },
                        InDate: { type: "date" },
                        remarks: { type: "string" },
                        ExpiryDate: { type: "date" },
                        TaskCreationDate: { type: "date" },
                        Delay_Region: { type: "number" },
                        PTat: { type: "number" },
                        ATat: { type: "number" }
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
        columns: [
                //{ command: [{ name: "View", text: "", imageClass: "k-icon k-view", click: ViewHandler, title: "View" }], title: "View", width: 60 },
                //{ template: '<a href="javascript:GetFile(#=DOCID#)">#=Attachment#</a>', field: "Attachment", title: "Attachment", width: 90, filterable: false, sortable: false },
                {
                    field: "DOCID", title: "DocID", width: 80, filterable: {
                        ui: function (element) {
                            element.kendoNumericTextBox({
                                format: "#"
                            });
                        }
                    }
                },
                { field: "ActivityType", title: "Activity Type", width: 120 },
                { field: "Company", title: "Company", width: 120 },
                { field: "Site", title: "Site", width: 100 },
                { field: "Act", title: "Act", width: 100 },
                { field: "Activity", title: "Activity", width: 150 },
                { field: "TaskCreationDate", title: "Created Date", width: 150, type: "date", format: "{0:dd/MM/yyyy}" },
                { field: "Maker", title: "Maker", width: 100 },
                { field: "Checker", title: "Checker", width: 100 },
                { field: "Action_CompletionDate", title: "Completion Date", width: 150, type: "date", format: "{0:dd/MM/yyyy}" },
                  { field: "Status", title: "Movement Status", width: 150 },
                { field: "InDate", title: "Movement Date", width: 150, type: "date", format: "{0:dd/MM/yyyy}" },
                { field: "remark", title: "Movement Remark", width: 150 },
                { field: "Currstatus", title: "Current Status", width: 150 },                
                { field: "ComplianceStatus", title: "Compliance Status", width: 100 },
                { field: "Delay_Region", title: "Delay Reason", width: 150 },
                { field: "PTat", title: "Planned SLA", width: 150 },
                { field: "ATat", title: "Actual SLA", width: 150 }
        ]

    });
}

function GetFile(DocID) {
    var data = { DOCID: DocID, FileID: 0 };
    $.ajax({
        type: "GET",
        url: GetTaskFilesUrl,
        contentType: "application/json; charset=utf-8",
        data: data,
        dataType: "json",
        success: function (response) {
            if (KAttachGrd != "") {
                $('#dvAttachGrd').kendoGrid('destroy').empty();
            }
            BindAttachGrid(response.Data)
        },
        error: function (data) {
            alert('Error');
        }
    });
}
var KAttachGrd = "";
function BindAttachGrid(Data1) {
    KAttachGrd = $("#dvAttachGrd").kendoGrid({
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
                        command: [
                            { name: "Delete", text: "", imageClass: "k-icon k-filedownload", click: Download, title: "Download" }
                        ], title: "Action", width: 150
                    }
        ],
        height: 200,
        pageable: false,
        filterable: false,
        sortable: true,
        resizable: true
    });
    $("#dvAttachGrd").dialog({
        width: 700,
        title: "Download Attachment",
        closeText: ""
    });
}
function Deletefile(e) {
    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var FileID = dataItem.FileID;
    var DocID = dataItem.DOCID;
    var data = { DOCID: DocID, FileID: FileID };
    if (confirm("You want to delete this file")) {
        $.ajax({
            type: "POST",
            url: RemoveTaskFileUrl,
            contentType: "application/json; charset=utf-8",
            data: data,
            dataType: "json",
            success: function (response) {
                if (response.IsSuccess) {
                    GetFile(DocID);
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

function ShowToolTip() {
    $(".k-icon.k-view").parent().attr("title", "View");

    $(".k-icon.k-view").parent().kendoTooltip({
        width: 60,
        position: "top"
    }).data("kendoTooltip");
}
var ViewHandler = function ViewHandler(e) {
    //alert("ViewDet");
    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var DocID = dataItem.DOCID;
    var URL = '../../document/Task/' + DocID;
    OpenWindow(URL);
}
var new_window;
function OpenWindow(url) {
    var new_window = window.open(url, "List", "scrollbars=yes,resizable=yes,width=800,height=480");
    return false;
}
