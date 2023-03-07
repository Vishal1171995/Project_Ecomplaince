$(document).ready(function () {
    $("#dvimport").bind("click", {}, OpenUploadPopup);
    $("#dvExport").bind("click", {}, DownLoadAll);
    $("#dvAdd").bind("click", {}, OpenAddPopUp);
    $("#btnUdateActActivity").click(UpdateActActivityUser);
    BindCustomer();
});
$(document).ready(function () {
    $('#Kgrid').on('click', '.locked', function () {
        var grid = $("#Kgrid").data("kendoGrid");
        var row = grid.dataItem($(this).closest('tr'));
        var lockedval = row.locked;

        var UID = row.UID;
        var form = $('#__AjaxAntiForgeryForm');
        var token = $('input[name="__RequestVerificationToken"]', form).val();

        $.post(BlockUnblockUserUrl, { __RequestVerificationToken: token, UID: UID, Status: row.locked }, function (response) {
            if (response.IsSuccess) {
                var setvalue = 0;
                if (lockedval == 0)
                { setvalue = 1; }

                row.set('locked', setvalue);
            }
        });
        
    });
    $("#menu_17").addClass("active-menu");
    BindGrid();
    $("#Role").change(function () {

        $("#dvCompanylbl").hide(); $("#dvCompanyddl").hide(); $("#dvContractorlbl").hide();
        $("#dvContractorddl").hide(); $("#dvCustomerlbl").hide(); $("#dvCustomerddl").hide();
        if (this.value == 18 || this.value == 23 || this.value==24)
        { $("#dvCustomerlbl").show(); $("#dvCustomerddl").show(); }
        else if (this.value == 19)
        { $("#dvCompanylbl").show(); $("#dvCompanyddl").show(); }
        else if (this.value == 20)
        { $("#dvContractorlbl").show(); $("#dvContractorddl").show(); }

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
            url: UploadUserUrl,
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
                    $("#dialogupload").dialog("close");
                    $("#log").dialog(
                        {
                            autoOpen: false,
                            width: 500,
                            title: "Result",
                            closeText: ""
                        }
                    );
                    $("#log").dialog("open");
                }
                else {
                    alert(response.Message);
                }
                $("#dvDetails").show();
            },
            error: function (data) {
                alert("Please try again later!!! Error occured while binding.");
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

function OpenAddPopUp() {
    ////dvcontent dvMsg
    $("#dvMsg").hide();
    $("#dvcontent").show();
    $("#btnReset").click();
    $("#btnSubmit").val("Submit");
    var dialog = $("#dialog").dialog({
        //autoOpen: false,
        modal: true,
        title: "User Master",
        width: 909,
        closeText: ""
    });
    //dialog.dialog("open");
}
function SuccessMessage(e) {
    HandleResponse(e, "dialog", "btnReset", "hdnUID");
    BindGrid();
}
function FailMessage() {
    alert("Fail Post");
}

function Validate() {
    var Role = $("#Role").val();
    var Contractor = $("#Contractor").val();
    var Company = $("#Company").val();
    var Customer = $("#Customer").val();

    if (Role == 20 && Contractor == "0") {
        $("#Contractor").next().toggleClass("field-validation-error").toggleClass("field-validation-valid").html("Please select a Contractor");
        return false;
    }
    if (Role == 19 && Company == "0") {
        $("#Company").next().toggleClass("field-validation-error").toggleClass("field-validation-valid").html("Please select a Company");
        return false;
    }
    if (Role == 18 && Customer == "0") {
        $("#Customer").next().toggleClass("field-validation-error").toggleClass("field-validation-valid").html("Please select a Customer");
        return false;
    }
    if (Role == 24 && Customer == "0") {
        $("#Customer").next().toggleClass("field-validation-error").toggleClass("field-validation-valid").html("Please select a Customer");
        return false;
    }
    $("#Contractor").next().toggleClass("field-validation-error").toggleClass("field-validation-valid").html("");
    $("#Company").next().toggleClass("field-validation-error").toggleClass("field-validation-valid").html("");
    $("#Customer").next().toggleClass("field-validation-error").toggleClass("field-validation-valid").html("");
    return true;
}
// For Upload popup

function OpenUploadPopup() {
    $("#dialogupload").dialog({
        autoOpen: false,
        width: 500,
        title: "Upload Activity",
        closeText: ""
    });
    $("#dialogupload").dialog("open");
    event.preventDefault();
}
function DownLoadResultFile() {
    var FileName = $("#hdnresultFile").val();
    var Data = { FileName: FileName };
    var URL = DownLoadResultFileUrl + '?FileName=' + FileName;
    window.location = URL;
    return false;
}
function DownLoadSampleUser() {
    //public ActionResult GetMapppingCount(string CompIDS,string sitesIDs,string ActIds,string ContractorIds)
    var URL = DownloadSampleUserUrl
    window.location = URL;
    return false;
}
var Kgrid;
function BindGrid() {
    var UID = 0;
    $.get(getUserUrl, { UID: UID }, function (response) {
        var Kgrid = $("#Kgrid").data("kendoGrid");
        if ($(Kgrid).length > 0) {
            $("#Kgrid").data("kendoGrid").destroy();
            $('#Kgrid').empty();
        }

        if (response.IsSuccess) {
            var Data = $.parseJSON(response.Data);
            var columns = [{ field: "User_Name", title: "User Id", width: 150 },
                    { field: "FullName", title: "User Name", width:100 },
                      { field: "Email", title: "Email", width: 150 },
                      { field: "RoleText", title: "Role", width: 130 },
                    
                      { field: "CompanyText", title: "Company", width: 100 },
                      { field: "ContractorText", title: "Contractor", width: 100 },
                   
                           { field: "Status", title: "Status", width: 100 },
                        {
                            template: "<button class='locked'>#= locked ? 'UnBlock' : 'Block' #</button>"
                        }

            ];
            var objAddDiv = $("#dvAdd");
            if (objAddDiv.length > 0) {
                var cmd = {
                    command: [
                        { name: "Edit", text: "", imageClass: "k-icon k-edit", click: EditHandler, title: "Edit" },
                        { name: "View", text: "", imageClass: "k-icon k-view", click: ViewHandler, title: "View" },
                        { name: "Activate User", text: "", imageClass: "k-icon k-ActivateUser", click: ActivateUser, title: "Activate User" },
                        { name: "Role", text: "", imageClass: "k-icon k-RoleAssign", click: ActivateRole, title: "Role" },
                       


                    ], title: "Action", width: 155
                };
            }
            else {
                var cmd = {
                    command: [
                        { name: "View", text: "", imageClass: "k-icon k-view", click: ViewHandler, title: "View" },
                    ], title: "Action", width: 100
                };
            }
            columns.push(cmd);
            var Data =
            Kgrid = $("#Kgrid").kendoGrid({
                dataSource: {
                    pageSize: 10,
                    data: Data
                }, 
                dataBound: function (e) {
                    ShowToolTip();
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

                        var data = grid.dataSource.data();
                        $.each(data, function (i, row) {
                            var Status = row.Status;
                           
                            if (Status != "Active") {
                                $('tr[data-uid="' + row.uid + '"]').css("background-color", "red");
                            }

                        });

                        //for (var i = 0; i < 10 ; i++) {
                        //     if (grid.tbody[0].rows[i].cells[8].innerText != "Active") {
                        //        //for (var k = 0; k < colCount; k++) {
                        //        grid.tbody[0].rows[i].css("background-color", "red");
                        //        //}
                                    
                        //        }
                            
                        //}
                    }
                },

                //dataBound: ShowToolTip,
                noRecords: true,
                filterable: true,
                sortable: true,              
                pageable: true,
                reorderable: true,
                resizable: true,
                columns: columns,
                height: 400
            });
        }
    });
}
function ShowToolTip() {

    $(".k-icon.k-edit").parent().attr("title", "Edit");

    $(".k-icon.k-edit").parent().kendoTooltip({
        width: 60,
        position: "top"
    }).data("kendoTooltip");

    $(".k-icon.k-view").parent().attr("title", "View");

    $(".k-icon.k-view").parent().kendoTooltip({
        width: 60,
        position: "top"
    }).data("kendoTooltip");

    $(".k-icon.k-ActivateUser").parent().attr("title", "Activate User");

    $(".k-icon.k-ActivateUser").parent().kendoTooltip({
        width: 60,
        position: "top"
    }).data("kendoTooltip");

    $(".k-icon.k-RoleAssign").parent().attr("title", "Role Assignment");

    $(".k-icon.k-RoleAssign").parent().kendoTooltip({
        width: 60,
        position: "top"
    }).data("kendoTooltip");

    //k-RoleAssign
}
function HistoryGridData(UID) {
    $.ajax({
        type: "GET",
        url: getUserHistoryUrl,
        contentType: "application/json; charset=utf-8",
        data: { "UID": UID },
        dataType: "json",
        success: function (response) {
            HistorybindGrid(response.Data);
            var dialog = $("#modalpartial").dialog({
                autoOpen: false,
                modal: true,
                title: "User",
                width: 1000,
                closeText: ""
            });
            dialog.dialog("open");
        },
        error: function (data) {
            alert("something went wrong");
        }
    });
}
var histkgrid = "";
function HistorybindGrid(Data1) {
    if (histkgrid != "") {
        $('#GridHis').kendoGrid('destroy').empty();
    }
    var columns = [{ field: "User_Name", title: "User ID", width: 150 },
                       { field: "FullName", title: "User Name", width: 100 },
                         { field: "Email", title: "Email", width: 150 },
                         { field: "RoleText", title: "Role", width: 130 },
                         { field: "Contact_Number", title: "Contact Number", width: 100 },
                         { field: "CompanyText", title: "Company", width: 100 },
                         { field: "ContractorText", title: "Contractor", width: 100 },
                          { field: "CustName", title: "Customer", width: 100 },
{ field: "updatedon", title: "Updated On", width: 100 },
                        { field: "updatedbyText", title: "Updated By", width: 100 },
                        { field: "Action", title: "Action", width: 100 },
    ];

    histkgrid = $("#GridHis").kendoGrid({
        dataSource: {
            pageSize: 10,
            data: JSON.parse(Data1)
        },
        columns: [{ field: "User_Name", title: "User ID", width: 150 },
                       { field: "FullName", title: "User Name", width: 100 },
                         { field: "Email", title: "Email", width: 150 },
                         { field: "RoleText", title: "Role", width: 130 },
                         { field: "Contact_Number", title: "Contact Number", width: 100 },
                         { field: "CompanyText", title: "Company", width: 100 },
                         { field: "ContractorText", title: "Contractor", width: 100 },
                          { field: "CustName", title: "Customer", width: 100 },
{ field: "updatedon", title: "Updated On", width: 100 },
                        { field: "updatedbyText", title: "Updated By", width: 100 },
                        { field: "Action", title: "Action", width: 100 },
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
        
        noRecords: true,
        filterable: true,
        sortable: true,
        pageable: true,
        reorderable: true,
        resizable: true,
       
       
              
     
    });
}
var EditHandler = function EditHandler(e) {
    e.preventDefault();
    dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var UID = dataItem.UID;
    $.get(getUserUrl, { UID: UID }, function (response) {
        if (response.IsSuccess) {
            var Data = $.parseJSON(response.Data);
            $("#hdnUID").val(UID);
            $("#txtFname").val(Data[0].First_Name);
            $("#txtLname").val(Data[0].Last_Name);
            $("#txtUname").val(Data[0].User_Name);
            $("#txtEmail").val(Data[0].Email);
            $("#Role").val(Data[0].Role);
            $("#Role").change();
            $("#txtContactNumber").val(Data[0].Contact_Number);
            $("#Company").val(Data[0].Company);
            $("#Contractor").val(Data[0].Contractor);
            $("#Customer").val(Data[0].Customer);
            $("#btnSubmit").val("Update");
            $("#dvMsg").hide();
            $("#dvcontent").show();
            var dialog = $("#dialog").dialog({
                //autoOpen: false,
                modal: true,
                title: "User Master",
                width: 909,
                closeText: ""
            });
            //dialog.dialog("open");
        }
    });
}
var BlockClick = function BlockClick(e)
{ alert("BloclClicked"); }
var ViewHandler = function ViewHandler(e) {
    $("#liDetails").removeClass('active').addClass('active');
    $("#liHistory").removeClass('active')
    $("#tab_1_1").removeClass('active').addClass('active');
    $("#tab_1_2").removeClass('active');
    e.preventDefault();
    dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var UID = dataItem.UID;
    $.get(getUserUrl, { UID: UID }, function (response) {
        if (response.IsSuccess) {
            var Data = $.parseJSON(response.Data);
            $("#lblFirst_Name").html(Data[0].First_Name);
            $("#lblLast_Name").html(Data[0].Last_Name);

            $("#lblUser_Name").html(Data[0].User_Name);
            $("#lblEmail").html(Data[0].Email);
            $("#lblRole").html(Data[0].RoleName);
            $("#lblContact_Number").html(Data[0].Contact_Number);
            $("#lblCompany").html(Data[0].CompName);
            $("#lblCustomer").html(Data[0].CustName);
            $("#lblContractor").html(Data[0].ContName);
            var IsAct = Data[0].IsAct;
            (IsAct == 1) ? $('#lblIsAct').html('Active') : $('#lblIsAct').html('In Active');
            HistoryGridData(UID);
        }
    });
}
var ActivateUser = function ActivateUser(e) {
    e.preventDefault();
    dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var UID = dataItem.UID;
    $.get(getActivateUser, { UID: UID }, function (response) {
        if (response.IsSuccess) {
            var Data = $.parseJSON(response.Data);
            if (Data.length > 0) {
                window.location = "/ActivateUser/" + Data[0].PassKey + "";
            }
            else {
                alert("User already activated.");
            }
            //dialog.dialog("open");
        }
    });
}

var ActivateRole = function ActivateRole(e) {
    e.preventDefault();
    dataItem = this.dataItem($(e.currentTarget).closest("tr"));
    var UID = dataItem.UID;
    ObjCustomer = "", ObjCompany = "";
    //dialogRole  Customer Admin 
    $.get(getUserRoleUrl, { UID: UID }, function (response) {
        if (response.IsSuccess) {
            var Data = $.parseJSON(response.Data);
            if (Data.length > 0) {
                if (Data[0].RoleID == 24) {
                    var customer = dataItem.Customer;//37
                    UID = dataItem.UID; //64
                    var URL = GetActAcitivityData + '?CustIDs=' + customer + '&UserID=' + UID;
                    window.location = URL;
                    return false;
                } else if (Data[0].Role == "User" || Data[0].Role == "Auditee" || Data[0].Role == "Auditor") {
                    var customer = Data[0].CustomerTids;
                    var company = Data[0].CompanyTids;
                    //if (customer != "") {
                    $("#ddlCustomer").data("kendoMultiSelect").value(customer.split(","));

                    ObjCustomer = $("#ddlCustomer").data("kendoMultiSelect");

                    //rebind company multiselect ==============================================================
                    var CustIDs;
                    CustIDs = ObjCustomer.value() + "";
                    //var CompID = $("#ddlcompany").val();
                    var Data = { CustIDs: CustIDs };
                    $.ajax({
                        type: "GET",
                        url: getCompanyForuserUrl,
                        contentType: "application/json; charset=utf-8",
                        data: Data,
                        dataType: "json",
                        success: function (response) {
                            if (response.IsSuccess) {
                                var res = response.Data;
                                var data;
                                //dvSite
                                $("#dvCompany").html("");
                                var str = '<select id="ddlCompany" multiple="multiple" data-placeholder="Select company..." >' +
                                            '</select>';
                                $("#dvCompany").html(str);
                                if (response.IsSuccess == true) {
                                    data = $.parseJSON(res);
                                }
                                else {
                                    data = { "Name": "-----Select-------", "CompID": "0" };
                                }
                                ObjCompany = $("#ddlCompany").kendoMultiSelect({
                                    dataTextField: "Name",
                                    dataValueField: "CompID",
                                    dataSource: data,
                                    autoClose: false,
                                }).data("kendoMultiSelect");

                                ObjCompany.value(company.split(","));
                            }
                            else {
                                FailResponse(response);
                            }
                        },
                        error: function (data) {
                            alert("Please try again later!!! Error occured while  binding.");
                        }
                    });

                    //=========================================================================================

                    //}
                    var dialog = $("#dialogRole").dialog({
                        //autoOpen: false,
                        modal: true,
                        title: "Role",
                        width: 900,
                        //height:300,
                        closeText: ""
                    });
                    $("#btnAllCustomer").click(SelectALLCustomers);
                    $("#btnAllCompany").click(SelectALLCompanys);
                    $("#btnUpdateRole").unbind().bind('click', { UID: UID }, UpdateRoleForUser);

                }
                else {
                    createErrPOP("Only user role for role assignment.");
                }
            }
            else {
                //alert("User already activated.");
            }
        }
    });
}
var ObjCustomer = "", ObjCompany = "";
function BindCustomer() {
    var Data = null;
    $.ajax({
        type: "GET",
        url: getCustomerForuserUrl,
        contentType: "application/json; charset=utf-8",
        data: Data,
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess) {
                var res = response.Data;
                var data;
                //dvSite
                $("#dvCustomer").html("");
                var str = '<select id="ddlCustomer"   multiple="multiple" data-placeholder="Select customer..." >' +
                            '</select>';
                $("#dvCustomer").html(str);
                if (response.IsSuccess == true) {
                    data = $.parseJSON(res);
                }
                else {
                    data = { "Name": "-----Select-------", "CustID": "0" };
                }
                ObjCustomer = $("#ddlCustomer").kendoMultiSelect({
                    dataTextField: "Name",
                    dataValueField: "CustID",
                    dataSource: data,
                    autoClose: false,
                    change: function (e) {
                        var value = this.value();
                        BindCompany(value);
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
//Bind Company MultiSelect==========================
function BindCompany(CompIds) {
    var CustIDs;
    if (ObjCustomer != "") CustIDs = ObjCustomer.value() + "";
    //var CompID = $("#ddlcompany").val();
    var Data = { CustIDs: CustIDs };
    $.ajax({
        type: "GET",
        url: getCompanyForuserUrl,
        contentType: "application/json; charset=utf-8",
        data: Data,
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess) {
                var res = response.Data;
                var data;
                //dvSite
                $("#dvCompany").html("");
                var str = '<select id="ddlCompany" multiple="multiple" data-placeholder="Select company..." >' +
                            '</select>';
                $("#dvCompany").html(str);
                if (response.IsSuccess == true) {
                    data = $.parseJSON(res);
                }
                else {
                    data = { "Name": "-----Select-------", "CompID": "0" };
                }
                ObjCompany = $("#ddlCompany").kendoMultiSelect({
                    dataTextField: "Name",
                    dataValueField: "CompID",
                    dataSource: data,
                    autoClose: false,
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
//==============================================
function SelectALLCustomers() {
    var multiSelect = $("#ddlCustomer").data("kendoMultiSelect");
    var selectedValues = "";
    var strComma = "";
    for (var i = 0; i < multiSelect.dataSource.data().length; i++) {
        var item = multiSelect.dataSource.data()[i];
        selectedValues += strComma + item.CustID;
        strComma = ",";
    }
    multiSelect.value(selectedValues.split(","));
    BindCompany("");
}

function SelectALLCompanys() {
    var multiSelect = $("#ddlCompany").data("kendoMultiSelect");
    var selectedValues = "";
    var strComma = "";
    for (var i = 0; i < multiSelect.dataSource.data().length; i++) {
        var item = multiSelect.dataSource.data()[i];
        selectedValues += strComma + item.CompID;
        strComma = ",";
    }
    multiSelect.value(selectedValues.split(","));
}

function UpdateRoleForUser(obj) {
    var UID = obj.data.UID;
    var CustIds = "", CompIds = "";
    if (ObjCustomer != "") CustIds = ObjCustomer.value() + "";
    if (ObjCompany != "") CompIds = ObjCompany.value() + "";
    if (CustIds != "" && CompIds != "") {
        $.get(UpdateRoleAssignUrl, { UID: UID, CustIDs: CustIds, CompIDs: CompIds }, function (response) {
            if (response.IsSuccess) {
                createSuccessPOP("Role updated successfully.");
                $("#dialogRole").dialog('close');
                ObjCustomer = "", ObjCompany = "";
            }
            else {
                createErrPOP("Sorry!!. Error occured in server. Please try again.");
            }
        });
    }
    else
    {
        createErrPOP("Please select customer and company.");
    }
}
//ActivateUser
function DownLoadAll() {
    //public ActionResult GetMapppingCount(string CompIDS,string sitesIDs,string ActIds,string ContractorIds)
    var URL = DownloadAllMapppingUserUrl
    window.location = URL;
    return false;
}


//ActivitySave In User table
function UpdateActActivityUser() {
    var items = document.getElementsByClassName("ActivityType");
    var selectedItems = "";
    for (var i = 0; i < items.length; i++) {
        if (items[i].type == 'checkbox' && items[i].checked == true)
            if (selectedItems == "") {
                selectedItems += items[i].value;
            } else {
                selectedItems += ","+items[i].value;
            }
    }
    var UID = $("#hdnUID").val();
 
    if (selectedItems != "") {
        var form = $('#__AjaxAntiForgeryForm');
        var token = $('input[name="__RequestVerificationToken"]', form).val();

        $.post(UpdateUserActActivityUrl, { __RequestVerificationToken: token, UID: UID, ActivityTIDs: selectedItems }, function (response) {
            if (response.IsSuccess) {
                createSuccessPOP("Activitys updated successfully.");
                // $("#dialogRole").dialog('close');
                selectedItems = "";
            }
            else {
                createErrPOP("Sorry!!. Error occured in server. Please try again.");
            }
        });
       
    }
    else {
        createErrPOP("Please select Act and Activity.");
    }
}