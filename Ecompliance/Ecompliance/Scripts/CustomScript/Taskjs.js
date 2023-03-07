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
    $("#ActivityType").change(function () {
        var ActivityType = $("#ActivityType").val();
        if (ActivityType == "Contractor") {
            $("#dvContracotrlbl,#dvContracotr").removeClass("modal");
        }
        else {
            $("#dvContracotrlbl,#dvContracotr").addClass("modal");
            $("#ddlContractor").val("0")
            $("#ddlContractor").next().removeClass("field-validation-error").addClass("field-validation-valid").html("");
        }
    });
    // Bind Site on change company..............
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
// Bind filter Drop Down list.............................
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
//Task Create Add Update sucess and fail event............
function SuccessMessage(e) {
    if (e.IsSuccess == true) {
        if (e.Data == "-5") {
            createErrPOP("Next approval not found.");
        }
        else if (e.Data == "-2")
            createErrPOP("Sorry! error occured in server. Please try again.");
        else if (e.Data == "0") {
            createSuccessPOPForAlert("Task updated successfully.");
            //setTimeout(window.location.href = "../../document/AsNeeded",2000);
        }
        else {
            createSuccessPOP("Task created successfully. Your transaction-id is " + e.Data);
            $("#btnReset").click();
            $("#txtExpiryDate").data("kendoDatePicker").value(new Date());
            $("#hdnDocID").val("0");
        }
    }
    else {
        FailResponse(e);
    }
    //HandleResponse(e, "", "btnReset", "");
}
function FailMessage() {
    alert("Fail Post");
}
// Custom validate function on calculate expary date and Show hide Contractor on Activity type change event.
function Validate() {
    var ActivityType = $("#ActivityType").val();
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
//Bind As Needed Document on edit
$(document).ready(function () {
    //var DocID =@ViewBag.DocID;
    if(DocID !="0")
    {
        $.get(GetAsneededDocumentUrl, { DocID: DocID }, function (response) {
            if(response.IsSuccess)
            {
                var dsTask = $.parseJSON(response.Data);
                if (dsTask.length > 0) {
                    $("#hdnDocID").val(dsTask[0].DOCID);
                    $("#ActivityType").val(dsTask[0].ActivityType);

                    var ActivityType = $("#ActivityType").val();
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

                    if (CompID != "0" && SiteID != "0" && ActID !="0") {
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

                }
                else
                {
                    $("#hdnDocID").val("0");
                    createErrPOP("Sorry! Your docid is not valid in current user.");
                }
            }
        });
    }
    else
    {
        $("#hdnDocID").val("0");
    }
});
function createSuccessPOPForAlert(strMsg) {
    debugger;
    var rlDiv = document.getElementById("popSuccessAlert");
    var objDiv = null;
    if (rlDiv == null) {
        var strHTML = "<div id=\"popSuccessAlert\" class=\"popError\" style=\"display: none;\">" +
                            "<div class='popwrapper'>" +
                                //"<div class=\"header sucMsg\"><img src=\"../../content/images/iconCheck.png\" alt=\"\">Success</div>" +
                                "<div></div><br/>"+
                                "<p style='margin:10px 0 40px 0; float:left; color: green; font-weight: bold;' id=\"popSucMsg\">" + strMsg + "</p>" +
                            "</div>" +
                            "<div class='footer'>" +
                                //"<div class='tip'></div>" +
                                "<div><input name=\"\" id=\"btnSuccessOK\" type=\"button\" value=\"Ok\" class=\"ok button\" onclick=\"javascript:window.location = '"+ViewAsNeededUrl+"';\"></div>" +
                            "</div>" +
                      "</div>";
        objDiv = document.createElement('div');
        objDiv.setAttribute('id', 'RLWrapper');
        objDiv.style.display = "none";
        objDiv.innerHTML = strHTML;
        document.body.appendChild(objDiv);
    }
    else {
        $('#popSuccessAlert').html(strMsg);
    }
    $("#popSuccessAlert").dialog({
        closeOnEscape: false,
        modal: true,
        title: "Success",
        width: 425
    });
    $('#popSuccessAlert').parent().children().children('.ui-dialog-titlebar-close').hide();
    //$('.ui-dialog-titlebar-close').show();
}