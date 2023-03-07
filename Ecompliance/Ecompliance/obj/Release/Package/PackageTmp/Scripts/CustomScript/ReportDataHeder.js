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
    $("#txtFromDate,#txtToDate").datepicker({
        dateFormat: 'dd/mm/yy',
    });
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
    BindGrid("","");
    //ObjActs = $("#ddlAct").kendoMultiSelect({
    //    autoClose: false,
    //    change: function (e) {
    //        var value = this.value();
    //        BindActivity(value);
    //        //alert(value);
    //    }
    //}).data("kendoMultiSelect");

    //$("#btnShow").bind("click", {}, BindGrid);
    $("#btnShow").bind("click", {}, function () {
        BindGrid("", "");
    });

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
//Bind Group Act and Comp

function GetReportHeaderAct() {
    var ActvityType = $("#ddlActivitytype").val();
    var CompID = $("#ddlcompany").val();
    var SiteIDs = "", ContractorIDs = "", ActIDs = "", ActivityIDs = "";
    if (ObjSites != "") SiteIDs = ObjSites.value() + "";
    if (ObjContractors != "") ContractorIDs = ObjContractors.value() + "";
    if (ObjActs != "") ActIDs = ObjActs.value() + "";
    if (ObjActivitys != "") ActivityIDs = ObjActivitys.value() + "";
    var Month = $("#ddlMonth").val();
    var Year = $("#ddlYear").val();
    var ExpiryDate = $("#txtExpiryDate").val();
    var FromDate = $("#txtFromDate").val();
    var ToDate = $("#txtToDate").val();
    var DocID = $("#txtDocID").val();
    var HeaderType = $("#ddlHeaderType").val();
    var typepar = "";
    var url = GetReportDataHeaderWiseUrl;

    var Data = {
        Type: typepar,
        ActivityType: ActvityType,
        CompIDs: CompID,
        SiteIDs: SiteIDs,
        ContractorIDs: ContractorIDs,
        ActIDs: ActIDs,
        ActivityIDs: ActivityIDs,
        ExpDate: ExpiryDate,
        Month: Month,
        Year: Year,
        FromDate: FromDate,
        ToDate: ToDate,
        DocID: DocID,
        HeaderType:HeaderType,
        page: 1,
        pageSize: 10,
        skip: 0,
        take: 10,
        sorting: null,
        filter: null
    };
      $.ajax({
        type: "GET",
        url: url,
        contentType: "application/json; charset=utf-8",
        data: Data,
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess) {
                var AllData=    $.parseJSON(response.Data);
                var Actdata = AllData.Actdata;
                //$("#slideshow").append('<a id="prev" title="Previous Slide">Previous Slide</a><a id="next" title="Next Slide">Next Slide</a>');
                var Componentdata = AllData.Componentdata;
                var strdivcontent = "";
                for (var i = 0; i < Actdata.length; i++) {
                    if (i == 0 || i % 3 == 0)
                    { strdivcontent = strdivcontent+ '<div class="col-xs-12 col-sm-12 col-md-12 singleblock" >';}
                    strdivcontent = strdivcontent+   '<div class="col-md-4 col-sm-4 col-xs-12">'+
                    '<div class="databox">' +
                    '<h2>' + Actdata[i].short_name + '</h2>' +
                    '<div>';
                    var filteredCompo = $(Componentdata).filter(function (idx) {
                        return Componentdata[idx].actid === Actdata[i].actid;
                    });                   
                        var filtercompliant = $(filteredCompo).filter(function (idx) {
                            return filteredCompo[idx].ComplianceStatus == "Compliant";
                        });
                        var filterNoncompliant = $(filteredCompo).filter(function (idx) {
                            return filteredCompo[idx].ComplianceStatus == "Non-Compliant";
                        });
                        var filterInprogress = $(filteredCompo).filter(function (idx) {
                            return filteredCompo[idx].ComplianceStatus == "In Progress";
                        });
                       
                        strdivcontent = strdivcontent + '<div class="notificationmainbox">' +
                        '<p class="pull-left">Total Count</p>' +
                        '<label class="pull-right">' + Actdata[i].TotalCount + '</label>' +
                        '<div class="clearfix"></div></div>';
                       
                        if (filtercompliant.length > 0) {
                            strdivcontent = strdivcontent + '<div class="notificationmainbox"><p class="pull-left">Total Complaint</p><label class="pull-right">20</label><div class="clearfix"></div></div>';
                        }
                        else { strdivcontent = strdivcontent + '<div class="notificationmainbox"><p class="pull-left">Total Complaint</p><label class="pull-right">00</label><div class="clearfix"></div></div>'; }
                        if (filterNoncompliant.length > 0) { strdivcontent = strdivcontent + '<div class="notificationmainbox"><p class="pull-left">Total Non-Complaint</p><label class="pull-right">20</label><div class="clearfix"></div></div>'; }
                        else { strdivcontent = strdivcontent + '<div class="notificationmainbox"><p class="pull-left">Total Non-Complaint</p><label class="pull-right">00</label><div class="clearfix"></div></div>'; }
                        if (filterNoncompliant.length > 0) { strdivcontent = strdivcontent + '<div class="notificationmainbox"><p class="pull-left">Total InProgress</p><label class="pull-right">20</label><div class="clearfix"></div></div>'; }
                        else { strdivcontent = strdivcontent + '<div class="notificationmainbox"><p class="pull-left">Total InProgress</p><label class="pull-right">00</label><div class="clearfix"></div></div>'; }
                        
                    strdivcontent = strdivcontent + '</div>';
                    strdivcontent = strdivcontent + '</div>';
                    strdivcontent = strdivcontent + '</div>';
                    if ( (i+1) % 3 == 0)
                    { strdivcontent = strdivcontent + '</div>'; }
                }

                $("#dvHeaderContent").html(strdivcontent);
            }
        },
        error: function (data) {
            alert("Please try again later!!! Error occured while  binding.");
        }
    });
}
//
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
        },
        error: function (data) {
            alert("Please try again later!!! Error occured while  binding.");
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
        },
        error: function (data) {
            alert("Please try again later!!! Error occured while  binding.");
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
function BindGrid(CompNature, CompStatus,ClickType) {
  
    var ActvityType = $("#ddlActivitytype").val();
    var CompID = $("#ddlcompany").val();
    var SiteIDs = "", ContractorIDs = "", ActIDs = "", ActivityIDs = "";
    if (ObjSites != "") SiteIDs = ObjSites.value() + "";
    if (ObjContractors != "") ContractorIDs = ObjContractors.value() + "";
    if (ObjActs != "") ActIDs = ObjActs.value() + "";
    if (ObjActivitys != "") ActivityIDs = ObjActivitys.value() + "";
    var Month = $("#ddlMonth").val();
    var Year = $("#ddlYear").val();
    var ExpiryDate = $("#txtExpiryDate").val();
    var FromDate = $("#txtFromDate").val();
    var ToDate = $("#txtToDate").val();
    var DocID = $("#txtDocID").val();
    var Compliance_nature =CompNature;
    var Compliance_Status = CompStatus;
    var url = GetReportDataHeaderWiseUrl;
   
   
    var typepar = "";
    if (Kgrid != "") {
        $('#dvAttachGrd').kendoGrid('destroy').empty();
    }
    Kgrid = $("#dvAttachGrd").kendoGrid({
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
                        SiteIDs: SiteIDs,
                        ContractorIDs: ContractorIDs,
                        ActIDs: ActIDs,
                        ActivityIDs: ActivityIDs,
                        ExpDate: ExpiryDate,
                        Month: Month,
                        Year: Year,
                        FromDate: FromDate,
                        ToDate: ToDate,
                        DocID: DocID,
                        Compliance_nature: Compliance_nature,
                        Compliance_Status:Compliance_Status,
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
                        FileCount: { type: "number" },
                        DOCID: { type: "number" },
                        ActivityType: { type: "string" },
                        CompName: { type: "string" },
                        SiteName: { type: "string" },
                        Short_Name: { type: "string" },
                        ActivityName: { type: "string" },
                        ContName: { type: "string" },
                        User_Name: { type: "string" },
                        CurrStatus: { type: "string" },
                        Action_CompletionDate: { type: "date" },
                        ExpiryDate: { type: "date" },
                        TaskCreationDate: { type: "date" },
                        Delay_Region: { type: "number" },
                        Creation_Desc: { type: "string" },
                        Creation_Remarks: { type: "string" },
                        Compliance_Nature: { type: "string" },
                        ComplianceStatus: { type: "string" }
                    }
                },
                data: function (response) {

                    var AllData = $.parseJSON(response.Data);
                    var Actdata = AllData.Actdata;
                    //$("#slideshow").append('<a id="prev" title="Previous Slide">Previous Slide</a><a id="next" title="Next Slide">Next Slide</a>');
                    var Componentdata = AllData.Componentdata;
                  
                    var DisplayTot = $(Actdata).filter(function (idx) {
                        return Actdata[idx].Compliance_nature == "Display";
                    });
                    var RegistrationTot = $(Actdata).filter(function (idx) {
                        return Actdata[idx].Compliance_nature == "Registration";
                    });
                    var RemittanceTot = $(Actdata).filter(function (idx) {
                        return Actdata[idx].Compliance_nature == "Remittance ";
                    });
                    var ReturnsTot = $(Actdata).filter(function (idx) {
                        return Actdata[idx].Compliance_nature == "Returns";
                    });
                    var StatuatoryTot = $(Actdata).filter(function (idx) {
                        return Actdata[idx].Compliance_nature == "Statuatory Records";
                    });

                        
                    var Display = $(Componentdata).filter(function (idx) {
                        return Componentdata[idx].Compliance_nature == "Display";
                        });
                    var Registration = $(Componentdata).filter(function (idx) {
                        return Componentdata[idx].Compliance_nature == "Registration";
                        });
                    var Remittance = $(Componentdata).filter(function (idx) {
                        return Componentdata[idx].Compliance_nature == "Remittance ";
                        });
                    var Returns = $(Componentdata).filter(function (idx) {
                        return Componentdata[idx].Compliance_nature == "Returns";
                        });
                    var Statuatory = $(Componentdata).filter(function (idx) {
                        return Componentdata[idx].Compliance_nature == "Statuatory Records";
                    });
                    $("#spnDisplayComp").html(0); $("#spnDisplayNComp").html(0); $("#spnDisplayInP").html(0);
                    $("#spnRegistrationComp").html(0); $("#spnRegistrationNComp").html(0); $("#spnRegistrationInP").html(0);
                    $("#spnRemittanceComp").html(0); $("#spnRemittanceNComp").html(0); $("#spnRemittanceInP").html(0);
                    $("#spnReturnsComp").html(0); $("#spnReturnsNComp").html(0); $("#spnReturnsInP").html(0);
                    $("#spnStatuatoryComp").html(0); $("#spnStatuatoryNComp").html(0); $("#spnStatuatoryInP").html(0);
                    $("#spnDisplayTot").html(0); $("#spnRegistrationTot").html(0); $("#spnRemittanceTot").html(0);
                    $("#spnReturnsTot").html(0); $("#spnStatuatoryTot").html(0);
                    if (ClickType != "Filter") {

                        if (Display.length > 0) {
                            $("#spnDisplayTot").html(DisplayTot[0].TotalCount);
                          

                            var DisPlayTotalComp = $(Display).filter(function (idx) {
                                return Display[idx].ComplianceStatus == "Compliant";
                            });
                            if (DisPlayTotalComp.length > 0)
                            {
                                $("#spnDisplayComp").html(DisPlayTotalComp[0].TotalCompliance);
                            }
                            var DisPlayTotalNonComp = $(Display).filter(function (idx) {
                                return Display[idx].ComplianceStatus == "Non-Compliant";
                            });
                            if (DisPlayTotalNonComp.length > 0) {
                                $("#spnDisplayNComp").html(DisPlayTotalNonComp[0].TotalCompliance);
                            }

                            var DisPlayTotalInProgress = $(Display).filter(function (idx) {
                                return Display[idx].ComplianceStatus == "In Progress";
                            });
                            if (DisPlayTotalInProgress.length > 0) {
                                $("#spnDisplayInP").html(DisPlayTotalInProgress[0].TotalCompliance);
                            }


                        }
                        if (Registration.length > 0) {
                            $("#spnRegistrationTot").html(RegistrationTot[0].TotalCount);

                            var RegistrationTotalComp = $(Registration).filter(function (idx) {
                                return Registration[idx].ComplianceStatus == "Compliant";
                            });
                            if (RegistrationTotalComp.length > 0) {
                                $("#spnRegistrationComp").html(RegistrationTotalComp[0].TotalCompliance);
                            }
                            var RegistrationTotalNonComp = $(Registration).filter(function (idx) {
                                return Registration[idx].ComplianceStatus == "Non-Compliant";
                            });
                            if (RegistrationTotalNonComp.length > 0) {
                                $("#spnRegistrationNComp").html(RegistrationTotalNonComp[0].TotalCompliance);
                            }

                            var RegistrationTotalInProgress = $(Registration).filter(function (idx) {
                                return Registration[idx].ComplianceStatus == "In Progress";
                            });
                            if (RegistrationTotalInProgress.length > 0) {
                                $("#spnRegistrationInP").html(RegistrationTotalInProgress[0].TotalCompliance);
                            }

                        }
                        if (Remittance.length > 0) {

                            $("#spnRemittanceTot").html(RemittanceTot[0].TotalCount);

                            //if (Remittance.length == 1) { $("#spnRemittanceComp").html(Remittance[0].TotalCompliance); }
                            //if (Remittance.length == 2) { $("#spnRemittanceComp").html(Remittance[0].TotalCompliance); $("#spnRemittanceNComp").html(Remittance[1].TotalCompliance); }
                            //if (Remittance.length == 3) {
                            //    $("#spnRemittanceComp").html(Remittance[0].TotalCompliance);
                            //    $("#spnRemittanceNComp").html(Remittance[1].TotalCompliance);
                            //    $("#spnRemittanceInP").html(Remittance[2].TotalCompliance);
                            //}

                            var RemittanceTotalComp = $(Remittance).filter(function (idx) {
                                return Remittance[idx].ComplianceStatus == "Compliant";
                            });
                            if (RemittanceTotalComp.length > 0) {
                                $("#spnRemittanceComp").html(RemittanceTotalComp[0].TotalCompliance);
                            }
                            var RemittanceTotalNonComp = $(Remittance).filter(function (idx) {
                                return Remittance[idx].ComplianceStatus == "Non-Compliant";
                            });
                            if (RemittanceTotalNonComp.length > 0) {
                                $("#spnRemittanceNComp").html(RemittanceTotalNonComp[0].TotalCompliance);
                            }

                            var RemittanceTotalInProgress = $(Remittance).filter(function (idx) {
                                return Remittance[idx].ComplianceStatus == "In Progress";
                            });
                            if (RemittanceTotalInProgress.length > 0) {
                                $("#spnRemittanceInP").html(RemittanceTotalInProgress[0].TotalCompliance);
                            }

                        }
                        if (Returns.length > 0) {
                            $("#spnReturnsTot").html(ReturnsTot[0].TotalCount);

                            //if (Returns.length == 1) { $("#spnReturnsComp").html(Returns[0].TotalCompliance); }
                            //if (Returns.length == 2) { $("#spnReturnsComp").html(Returns[0].TotalCompliance); $("#spnReturnsNComp").html(Returns[1].TotalCompliance); }
                            //if (Returns.length == 3) {
                            //    $("#spnReturnsComp").html(Returns[0].TotalCompliance);
                            //    $("#spnReturnsNComp").html(Returns[1].TotalCompliance);
                            //    $("#spnReturnsInP").html(Returns[2].TotalCompliance);
                            //}

                            var ReturnsTotalComp = $(Returns).filter(function (idx) {
                                return Returns[idx].ComplianceStatus == "Compliant";
                            });
                            if (ReturnsTotalComp.length > 0) {
                                $("#spnReturnsComp").html(ReturnsTotalComp[0].TotalCompliance);
                            }
                            var ReturnsTotalNonComp = $(Returns).filter(function (idx) {
                                return Returns[idx].ComplianceStatus == "Non-Compliant";
                            });
                            if (ReturnsTotalNonComp.length > 0) {
                                $("#spnReturnsNComp").html(ReturnsTotalNonComp[0].TotalCompliance);
                            }

                            var ReturnsTotalInProgress = $(Returns).filter(function (idx) {
                                return Returns[idx].ComplianceStatus == "In Progress";
                            });
                            if (ReturnsTotalInProgress.length > 0) {
                                $("#spnReturnsInP").html(ReturnsTotalInProgress[0].TotalCompliance);
                            }

                        }
                        if (Statuatory.length > 0) {
                            $("#spnStatuatoryTot").html(StatuatoryTot[0].TotalCount);
                            //if (Statuatory.length == 1) { $("#spnStatuatoryComp").html(Statuatory[0].TotalCompliance); }
                            //if (Statuatory.length == 2) { $("#spnStatuatoryComp").html(Statuatory[0].TotalCompliance); $("#spnStatuatoryNComp").html(Statuatory[1].TotalCompliance); }
                            //if (Statuatory.length == 3) {
                            //    $("#spnStatuatoryComp").html(Statuatory[0].TotalCompliance);
                            //    $("#spnStatuatoryNComp").html(Statuatory[1].TotalCompliance);
                            //    $("#spnStatuatoryInP").html(Statuatory[2].TotalComplaince);
                            //}
                            var StatuatoryTotalComp = $(Statuatory).filter(function (idx) {
                                return Statuatory[idx].ComplianceStatus == "Compliant";
                            });
                            if (StatuatoryTotalComp.length > 0) {
                                $("#spnStatuatoryComp").html(StatuatoryTotalComp[0].TotalCompliance);
                            }
                            var StatuatoryTotalNonComp = $(Statuatory).filter(function (idx) {
                                return Statuatory[idx].ComplianceStatus == "Non-Compliant";
                            });
                            if (StatuatoryTotalNonComp.length > 0) {
                                $("#spnStatuatoryNComp").html(StatuatoryTotalNonComp[0].TotalCompliance);
                            }

                            var StatuatoryTotalInProgress = $(Statuatory).filter(function (idx) {
                                return Statuatory[idx].ComplianceStatus == "In Progress";
                            });
                            if (StatuatoryTotalInProgress.length > 0) {
                                $("#spnStatuatoryInP").html(StatuatoryTotalInProgress[0].TotalCompliance);
                            }

                        }
                    }
                    $("#dialog").dialog("close");
                    //var res = JSON.parse(data.Data)
                    //var res = $.parseJSON(data.Data);
                    if (response.IsSuccess) {
                        //var res = JSON.parse(response.Data)
                        if (AllData.Data.length > 0) {
                            return AllData.Data || [];
                        }
                    }
                    else {
                        alert("Something went wrong");
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
            fileName: "Alert.xlsx",
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
                { command: [{ name: "View", text: "", imageClass: "k-icon k-view", click: ViewHandler, title: "View" }], title: "View", width: 60 },
                { template: '<a href="javascript:GetFile(#=DOCID#)">#=FileCount#</a>', field: "FileCount", title: "Attachment", width: 90, filterable: false, sortable: false },
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
                { field: "CompName", title: "Company", width: 120 },
                { field: "SiteName", title: "Site", width: 100 },
                { field: "Short_Name", title: "Act", width: 100 },
                { field: "ActivityName", title: "Activity", width: 150 },
                { field: "ContName", title: "Contractor", width: 120 },
                { field: "User_Name", title: "Curr User", width: 100 },
                { field: "CurrStatus", title: "Curr Status", width: 150 },
                { field: "Action_CompletionDate", title: "Completion Date", width: 150, type: "date", format: "{0:dd/MM/yyyy}" },
                { field: "ExpiryDate", title: "Expiry Date", width: 150, type: "date", format: "{0:dd/MM/yyyy}" },
                { field: "TaskCreationDate", title: "Created Date", width: 150, type: "date", format: "{0:dd/MM/yyyy}" },
                { field: "Delay_Region", title: "Delay Region", width: 100 },
                { field: "Creation_Desc", title: "Creation Desc", width: 150 },
                { field: "Creation_Remarks", title: "Creation Remarks", width: 150 },
                  { field: "Compliance_Nature", title: "Compliance Nature", width: 150 },
                  { field: "ComplianceStatus", title: "Compliance Status", width: 150 }
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
