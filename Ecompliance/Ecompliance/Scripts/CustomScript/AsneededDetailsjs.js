var FileUploadID = "";
$("#dialog").dialog({
    autoOpen: false,
    width: 600,
    title: "Send To Verify",
    closeText: ""
});

// Link to open the dialog
$("#link").click(function (event) {
    $("#dialog").dialog("open");
    event.preventDefault();
});
function AttachDocPopUp() {
    $("#log").dialog({
        autoOpen: false,
        width: 700,
        title: "Attach Document",
        closeText: ""

    });
    GetTaskFiles("fileToUpload");
    $("#log").dialog("open");
}
// Link to open the dialog
$("#verify-link").click(function (event) {
    AttachDocPopUp();
    event.preventDefault();
});
$(document).ready(function () {
    $("#btnEdit").click(function () {
        bindEditPopup();
    });
    $.ajax({
        type: "GET",
        url: GetAsNeeded_HisUrl,
        contentType: "application/json; charset=utf-8",
        data: { DocID: docID },
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess) {
                HistorybindGrid(response.Data);
            }
            else {
                FailResponse(response);
            }
        },
        error: function (data) {
            alert(data.tostring());

        }
    });
});

var histkgrid = "";
function HistorybindGrid(Data1) {
    if (histkgrid != "") {
        $('#dvKgridHistory').kendoGrid('destroy').empty();
    }
    histkgrid = $("#dvKgridHistory").kendoGrid({
        dataSource: {
            pageSize: 10,
            data: JSON.parse(Data1)
        },
        dataBound: function (e) {
            var grid = e.sender;
            if (grid.dataSource.total() != 0) {
                var rows = grid.dataSource.total();
                var colCount = grid.columns.length;
                for (var i = rows - 1; i > 0 ; i--) {
                    for (var k = 0; k < colCount; k++) {
                        grid.autoFitColumn(k);
                        if (grid.tbody[0].children[i].cells[k].innerText != grid.tbody[0].children[i - 1].cells[k].innerText) {
                            grid.tbody[0].children[i - 1].cells[k].bgColor = "red";
                        }
                    }
                }
            }
        },
        pageable: true,
        filterable: true,
        noRecords: true,
        sortable: true,
        resizable: true,
    });
}
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

$(document).ready(function () {
    $("#txtExpiryDate").kendoDatePicker(
        {
            format: 'dd/MM/yyyy',
            width: 500,
            value: new Date()
        });
    $("#ddlActivityType").change(function () {
        var ActivityType = $("#ddlActivityType").val();
        if (ActivityType == "Contractor") {
            $("#dvContracotrlbl,#dvContracotr").removeClass("modal");
        }
        else {
            $("#dvContracotrlbl,#dvContracotr").addClass("modal");
            $("#ddlContractor").val("0")
            $("#ddlContractor").next().removeClass("field-validation-error").addClass("field-validation-valid").html("");
        }
    });

    $("#ddlCompany").change(function () {
        var CompanyID = $(this).val();
        var ddlSite = $("#ddlSite");
        ddlSite.empty().append($('<option></option>').val("0").html("Please wait..."));
        $("#ddlContractor").empty().append($('<option></option>').val("0").html("first select a site..."))
        $("#ddlAct").empty().append($('<option></option>').val("0").html("first select a site..."))
        $("#ddlActivity").empty().append($('<option></option>').val("0").html("first select a act..."))
        if (CompanyID != "0") {
            $.get(GetMappedSiteUrl, { CompanyID: CompanyID }, function (response) {
                if (response.IsSuccess) {
                    ddlSite.empty().append($('<option></option>').val("0").html("-- Select --"));
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
        //BindActivityDropDown();
    });
    $("#ddlSite").change(function () {
        BindActDropDown();
        BindContractorDropDown();
    });
    $("#ddlContractor").change(function () {
        BindActDropDown();
        //BindActivityDropDown();
    });
    $("#ddlAct").change(function () {
        BindActivityDropDown();
    });
});

function BindActDropDown() {
    var CompID = $("#ddlCompany").val();
    var ContractorID = $("#ddlContractor").val();
    var SiteID = $("#ddlSite").val();
    var ddlAct = $("#ddlAct");
    $("#ddlActivity").empty().append($('<option></option>').val("0").html("first select a act..."))
    if (CompID != "0" && SiteID != "0") {
        $.get(GetMappedActsUrl, { CompID: CompID, ContractorID: ContractorID, SiteID: SiteID }, function (response) {
            if (response.IsSuccess) {
                ddlAct.empty().append($('<option></option>').val("0").html("-- Select --"));
                var ds = $.parseJSON(response.Data);
                if (ds.length > 0) {
                    $.each(ds, function () {
                        ddlAct.append($('<option></option>').val(this.ActID).html(this.Name));
                    });
                }
                else {
                    ddlAct.empty().append($('<option></option>').val("0").html("-- Select --"));
                }
            }
        });
    }
    else {
        ddlAct.empty().append($('<option></option>').val("0").html("first select a site..."));
    }
}
function BindContractorDropDown() {
    var CompID = $("#ddlCompany").val();
    var SiteID = $("#ddlSite").val();
    var ddlContractor = $("#ddlContractor");
    if (CompID != "0" && SiteID != "0") {
        $.get(GetMappedContractorUrl, { CompID: CompID, SiteID: SiteID }, function (response) {
            if (response.IsSuccess) {
                ddlContractor.empty().append($('<option></option>').val("0").html("-- Select --"));
                var ds = $.parseJSON(response.Data);
                if (ds.length > 0) {
                    $.each(ds, function () {
                        ddlContractor.append($('<option></option>').val(this.ContractorID).html(this.Name));
                    });
                }
                else {
                    ddlContractor.empty().append($('<option></option>').val("0").html("-- Select --"));
                }
            }
        });
    }
    else {
        ddlContractor.empty().append($('<option></option>').val("0").html("first select a site..."));
    }
}
function BindActivityDropDown() {
    var CompID = $("#ddlCompany").val();
    var ContractorID = $("#ddlContractor").val();
    var SiteID = $("#ddlSite").val();
    var ActID = $("#ddlAct").val();
    var ddlActivity = $("#ddlActivity");

    if (CompID != "0" && SiteID != "0" && ActID != "0") {
        $.get(GetMappedActivityUrl, { CompanyID: CompID, ContractorID: ContractorID, SiteID: SiteID, ActID: ActID }, function (response) {
            if (response.IsSuccess) {
                ddlActivity.empty().append($('<option></option>').val("0").html("-- Select --"));
                var ds = $.parseJSON(response.Data);
                if (ds.length > 0) {
                    $.each(ds, function () {
                        ddlActivity.append($('<option></option>').val(this.ActivityID).html(this.Name));
                    });
                }
                else {
                    ddlActivity.empty().append($('<option></option>').val("0").html("-- Select --"));
                }
            }
        });
    }
    else {
        ddlActivity.empty().append($('<option></option>').val("0").html("first select a act..."));
    }
}

function SuccessMessage(e) {
    if (e.IsSuccess == true) {
        if (e.Data == "-5") {
            createErrPOP("Next approval not found.");
        }
        else if (e.Data == "-2")
            createErrPOP("Sorry! error occured in server. Please try again.");
        else if (e.Data == "0") {
            createSuccessPOPForAsNeeded("Task updated successfully.");
            //setTimeout(window.location.href = "../../document/AsNeeded",2000);
        }
        else {
            createSuccessPOP("Task created successfully. Your transaction-id is " + e.Data);
            $("#btnReset").click();
            $("#txtExpiryDate").data("kendoDatePicker").value(new Date());
            $("#hdnDocID").val("0");
        }
    }
    //HandleResponse(e, "", "btnReset", "");
}
function FailMessage() {
    alert("Fail Post");
}

function Validate() {
    var ActivityType = $("#ddlActivityType").val();
    var Contractor = $("#ddlContractor").val();
    var expDate = $("#txtExpiryDate").val();
    var RemindDays = $("#txtRemindDays").val();

    var arrDate = expDate.split("/");
    expDate = arrDate[1] + "/" + arrDate[0] + "/" + arrDate[2];
    var Today = new Date();
    Today.setHours(0, 0, 0, 0);
    var dt = new Date(expDate);
    dt.setDate(dt.getDate() - parseInt(RemindDays));

    if (ActivityType == "Contractor" && Contractor == "0") {
        $("#ddlContractor").next().toggleClass("field-validation-error").toggleClass("field-validation-valid").html("Please select a contractor");
        return false;
    }
    if (dt < Today) {
        //$("#txtExpiryDate").next().toggleClass("field-validation-error").toggleClass("field-validation-valid").html("Please enter valid expiry date.");
        alert("Please enter valid expiry date.");
        return false;
    }
    $("#ddlContractor").next().toggleClass("field-validation-error").toggleClass("field-validation-valid").html("");
    return true;
}

function bindEditPopup() {
    var DocID = docID;
    if (DocID != "0") {
        $.get(GetAsneededDocumentUrl, { DocID: DocID }, function (response) {
            if (response.IsSuccess) {
                var dsTask = $.parseJSON(response.Data);
                if (dsTask.length > 0) {
                    $("#hdnDocID").val(dsTask[0].DOCID);
                    $("#ddlActivityType").val(dsTask[0].ActivityType);

                    var ActivityType = $("#ddlActivityType").val();
                    if (ActivityType == "Contractor") {
                        $("#dvContracotrlbl,#dvContracotr").removeClass("modal");
                    }
                    else {
                        $("#dvContracotrlbl,#dvContracotr").addClass("modal");
                        $("#ddlContractor").val("0")
                        $("#ddlContractor").next().removeClass("field-validation-error").addClass("field-validation-valid").html("");
                    }

                    $("#ddlCompany").val(dsTask[0].CompanyID);

                    // Bind Company DropDown List and Select==========

                    var CompanyID = dsTask[0].CompanyID;
                    var ddlSite = $("#ddlSite");
                    ddlSite.empty().append($('<option></option>').val("0").html("Please wait..."));
                    $("#ddlContractor").empty().append($('<option></option>').val("0").html("first select a site..."))
                    $("#ddlAct").empty().append($('<option></option>').val("0").html("first select a site..."))
                    $("#ddlActivity").empty().append($('<option></option>').val("0").html("first select a act..."))
                    if (CompanyID != "0") {
                        $.get(GetMappedSiteUrl, { CompanyID: CompanyID }, function (response) {
                            if (response.IsSuccess) {
                                ddlSite.empty().append($('<option></option>').val("0").html("-- Select --"));
                                var ds = $.parseJSON(response.Data);
                                if (ds.length > 0) {
                                    $.each(ds, function () {
                                        ddlSite.append($('<option></option>').val(this.SiteID).html(this.Name));
                                    });

                                    $("#ddlSite").val(dsTask[0].SiteID)
                                }
                            }
                        });
                    }
                    else {
                        ddlSite.html('').append($('<option></option>').val("0").html("-- first select a company --"));
                    }
                    //================================================
                    // Bind Contractor DropDownlist and Select ====================
                    var CompID = dsTask[0].CompanyID;
                    var SiteID = dsTask[0].SiteID;
                    var ddlContractor = $("#ddlContractor");
                    if (CompID != "0" && SiteID != "0") {
                        $.get(GetMappedContractorUrl, { CompID: CompID, SiteID: SiteID }, function (response) {
                            if (response.IsSuccess) {
                                ddlContractor.empty().append($('<option></option>').val("0").html("-- Select --"));
                                var ds = $.parseJSON(response.Data);
                                if (ds.length > 0) {
                                    $.each(ds, function () {
                                        ddlContractor.append($('<option></option>').val(this.ContractorID).html(this.Name));
                                    });
                                    $("#ddlContractor").val(dsTask[0].ContractorID);
                                }
                                else {
                                    ddlContractor.empty().append($('<option></option>').val("0").html("-- Select --"));
                                }
                            }
                        });
                    }
                    else {
                        ddlContractor.empty().append($('<option></option>').val("0").html("first select a site..."));
                    }
                    //=============================================================
                    //Bind Act DropdownList and select ========================
                    var CompID = dsTask[0].CompanyID;
                    var ContractorID = dsTask[0].ContractorID;
                    var SiteID = dsTask[0].SiteID;
                    var ddlAct = $("#ddlAct");
                    $("#ddlActivity").empty().append($('<option></option>').val("0").html("first select a act..."))
                    if (CompID != "0" && SiteID != "0") {
                        $.get(GetMappedActsUrl, { CompID: CompID, ContractorID: ContractorID, SiteID: SiteID }, function (response) {
                            if (response.IsSuccess) {
                                ddlAct.empty().append($('<option></option>').val("0").html("-- Select --"));
                                var ds = $.parseJSON(response.Data);
                                if (ds.length > 0) {
                                    $.each(ds, function () {
                                        ddlAct.append($('<option></option>').val(this.ActID).html(this.Name));
                                    });
                                    $("#ddlAct").val(dsTask[0].ActID);
                                }
                                else {
                                    ddlAct.empty().append($('<option></option>').val("0").html("-- Select --"));
                                }
                            }
                        });
                    }
                    else {
                        ddlAct.empty().append($('<option></option>').val("0").html("first select a site..."));
                    }
                    //==========================================================
                    //Bind Activity dropdownlist and select ====================
                    var CompID = dsTask[0].CompanyID;
                    var ContractorID = dsTask[0].ContractorID;
                    var SiteID = dsTask[0].SiteID;
                    var ActID = dsTask[0].ActID;
                    var ddlActivity = $("#ddlActivity");

                    if (CompID != "0" && SiteID != "0" && ActID != "0") {
                        $.get(GetMappedActivityUrl, { CompanyID: CompID, ContractorID: ContractorID, SiteID: SiteID, ActID: ActID }, function (response) {
                            if (response.IsSuccess) {
                                ddlActivity.empty().append($('<option></option>').val("0").html("-- Select --"));
                                var ds = $.parseJSON(response.Data);
                                if (ds.length > 0) {
                                    $.each(ds, function () {
                                        ddlActivity.append($('<option></option>').val(this.ActivityID).html(this.Name));
                                    });
                                    $("#ddlActivity").val(dsTask[0].ActivityID);
                                }
                                else {
                                    ddlActivity.empty().append($('<option></option>').val("0").html("-- Select --"));
                                }
                            }
                        });
                    }
                    else {
                        ddlActivity.empty().append($('<option></option>').val("0").html("first select a act..."));
                    }
                    //===========================================================

                    $("#txtExpiryDate").data("kendoDatePicker").value(new Date(dsTask[0].ExpiryDate));
                    $("#txtRemindDays").val(dsTask[0].RemindDays);
                    $("#txtCreationDesc").val(dsTask[0].Creation_Desc);
                    $("#txtCreationRemarks").val(dsTask[0].Creation_Remarks);
                    $("#dvPopupEdit").dialog({
                        //autoOpen: false,
                        width: 950,
                        title: "Edit",
                        closeText: ""
                    });
                }
                else {
                    $("#hdnDocID").val("0");
                    createErrPOP("Sorry! Your docid is not valid in current user.");
                }
            }
        });
    }
    else {
        $("#hdnDocID").val("0");
    }
}
function createSuccessPOPForAsNeeded(strMsg) {
    debugger;
    var rlDiv = document.getElementById("popSuccessAsNeeded");
    var objDiv = null;
    if (rlDiv == null) {
        var strHTML = "<div id=\"popSuccessAsNeeded\" class=\"popError\" style=\"display: none;\">" +
                            "<div class='popwrapper'>" +
                                //"<div class=\"header sucMsg\"><img src=\"../../content/images/iconCheck.png\" alt=\"\">Success</div>" +
                                "<div></div><br/>" +
                                "<p style='margin:10px 0 40px 0; float:left; color: green; font-weight: bold;' id=\"popSucMsg\">" + strMsg + "</p>" +
                            "</div>" +
                            "<div class='footer'>" +
                                //"<div class='tip'></div>" +
                                "<div><input name=\"\" id=\"btnSuccessOK\" type=\"button\" value=\"Ok\" class=\"ok button\" onclick=\"javascript:window.location.reload();\"></div>" +
                            "</div>" +
                      "</div>";
        objDiv = document.createElement('div');
        objDiv.setAttribute('id', 'RLWrapper');
        objDiv.style.display = "none";
        objDiv.innerHTML = strHTML;
        document.body.appendChild(objDiv);
    }
    else {
        $('#popSuccessAsNeeded').html(strMsg);
    }
    $("#popSuccessAsNeeded").dialog({
        closeOnEscape: false,
        modal: true,
        title: "Success",
        width: 425
    });
    $('#popSuccessAsNeeded').parent().children().children('.ui-dialog-titlebar-close').hide();
    //$('.ui-dialog-titlebar-close').show();
}