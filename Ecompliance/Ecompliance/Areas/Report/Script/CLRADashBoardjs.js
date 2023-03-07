$(document).ready(function () {
    $("#menu_1").addClass("active-menu");
    $("#fromdtpicker,#todtpicker").datepicker({
        dateFormat: 'MM yy',
        changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        showButtonPanel: "both",
        beforeShow: function () {
            setTimeout(function () {
                $('.ui-datepicker').css('z-index', 99999999999999);
            }, 0);
        },
        onClose: function (dateText, inst) {
            var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
            var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
            $(this).val($.datepicker.formatDate('MM yy', new Date(year, month, 1)));
        }

    }).datepicker("setDate", new Date());
    $("#fromdtpicker,#todtpicker").focus(function () {
        $(".ui-datepicker-calendar").hide();
        //$("#ui-datepicker-div").position({
        //    my: "center top",
        //    at: "center bottom",
        //    of: $(this)
        //});
        $("#ui-datepicker-div div").eq(0).css('color', 'black');
    });
    $("#todtpicker").hide();
    $("#fromdtpicker").hide();
    $("#spnfrmDate").click(function () {
        $('#fromdtpicker').datepicker('show');
    });
    $("#spntoDate").click(function () {
        $('#todtpicker').datepicker('show');
    });

    $("#dvSearch").click(function () {
        var dialog = $("#dvfilter").dialog({
            autoOpen: false,
            modal: true,
            title: "Custom Filters",
            width: 700,
            closeText: ""
        });
        dialog.dialog("open");
        $("#todtpicker").show();
        $("#fromdtpicker").show();
    });
    filterDashBoard();
    GetDashBoardHomeCount('pageload')
    $("#btnViewMore").click(function () {
        openSiteWindow();
        return false;
    });
});
function GoToTask(type, PageName) {
    var eventType = $("#hdneventType").val();
    var Compid = 0, SMonth = 0, TMonth = 0, SYear = 0, TYear = 0;

    //if (eventType == "filter") {
    var Sdatepicker = $("#fromdtpicker").val();
    var Tdatepicker = $("#todtpicker").val();
    var monthnum = getMonthfromdatepicker(Tdatepicker.split(' ')[0]);

    SMonth = getMonthfromdatepicker(Sdatepicker.split(' ')[0]);
    TMonth = getMonthfromdatepicker(Tdatepicker.split(' ')[0]);
    SYear = Sdatepicker.split(' ')[1];//Sdatepicker.getFullYear();
    TYear = Tdatepicker.split(' ')[1];// Tdatepicker.getFullYear();
    Compid = $("#Company").val();
    //}
    if (PageName == "ViewTask") {
        if (type != 'MyAsNeeded') {
            var URL = "../../document/" + PageName + "?Type=" + type + "&compID=" + Compid + "&SMonth=" + SMonth + "&TMonth=" + TMonth + "&Syear=" + SYear + "&Tyear=" + TYear;
            window.location.href = URL;
        }
        else {
            var URL = "../../document/" + type + "?compID=" + Compid + "&SMonth=" + SMonth + "&TMonth=" + TMonth + "&Syear=" + SYear + "&Tyear=" + TYear;
            window.location.href = URL;
        }
    }
    else {
        var URL = "../../Report/" + PageName + "?Type=" + type + "&compID=" + Compid + "&SMonth=" + SMonth + "&TMonth=" + TMonth + "&Syear=" + SYear + "&Tyear=" + TYear;
        window.location.href = URL;
    }
}

function filterdash() {
    GetDashBoardHomeCount('filter');
    filterDashBoard();
}
function filterDashBoard() {
    $("#ldrCompany").show();
    $("#ldrActwise").show();
    $("#ldrSitewise").show();
    $("#ldrdvGrid").show();
    $("#ldrhomedet").show();
    $("#sitewisewrapper").hide();
    $("#actwisewrapper").hide();
    var Sdate = $("#fromdtpicker").val();
    var Tdate = $("#todtpicker").val();
    //$("#Company option:selected").text();

    $("#spnCompany").html($("#Company option:selected").text());
    $("#spnDateRange").html(Sdate + "   To  " + Tdate + " ");
    var dialog = $("#dvfilter").dialog();
    dialog.dialog("close");
    //GetDashBoardHomeCount();
    BinProgress();
    BindChart();
    $("#map").empty();
    sites = [];
    markers = [];
    //map;
    contentString = "";
    if (map != undefined)
        initMap();
    bindSite();
    $("#fromdtpicker").datepicker('hide');
    $("#todtpicker").datepicker('hide');
}
function getMonthfromdatepicker(MonthNm) {
    if (MonthNm == "January") { return 01; }
    else if (MonthNm == "February") { return 02; }
    else if (MonthNm == "March") { return 03; } else if (MonthNm == "April") { return 04; }
    else if (MonthNm == "May") { return 05; }
    else if (MonthNm == "June") { return 06; }
    else if (MonthNm == "July") { return 07; }
    else if (MonthNm == "August") { return 08; }
    else if (MonthNm == "September") { return 09; }
    else if (MonthNm == "October") { return 10; } else if (MonthNm == "November") { return 11; }
    else if (MonthNm == "December") { return 12; }
}
var sites = [];
var markers = [];
var map;
var contentString = "";
function drop() {
    var v1 = sites;
    clearMarkers();
    for (var i = 0; i < sites.length; i++) {
        addMarkerWithTimeout(sites[i], i * 200);
    }
}
function initMap() {
    //20.5937° N, 78.9629°
    var Country = { lat: 20.5937, lng: 78.9629 };
    map = new google.maps.Map(document.getElementById('map'), {
        zoom: 4,
        center: Country
        //center: { lat: 52.520, lng: 13.410 }
    });
    //drop();
    //  bindSite();
}

function addMarkerWithTimeout(obj, timeout) {
    var position = { lat: obj.lat, lng: obj.lng };
    window.setTimeout(function () {
        var contentString = '  <div id="sitewisewrapper1" class="gap1" ><h2>' + obj.Site + ' </h2>  Monthly Pending  ' + '(Count :' + obj.ManthlyPercentage + ' )' + '<br /> ' +
            ' <div id="dvMonthly' + obj.SiteID + '" style="width: 100%;"></div>' +
            ' Periodic Pending ' + '(Count :' + obj.PeriodicPercentage + ' )' + '<br />  <div id="dvPeriodic' + obj.SiteID + '" style="width: 100%;"></div>' +

            ' Completed ' + '(Count :' + obj.ComplitedPercentage + ' )' + '<br /> <div id="dvComplited' + obj.SiteID + '" style="width: 100%;"></div>' +
            '</div>';

        //var contentString = "<div>Site Name : " + obj.Site + "<br/>Performed:" + obj.Performed + "<br/>Delayed: " + obj.Delayed + "<br/>Performed After Due Date: " + obj["Performed After Due Date"] + "<div>";
        var infowindow = new google.maps.InfoWindow({
            content: contentString
        });
        var marker = new google.maps.Marker({
            position: position,
            map: map,
            animation: google.maps.Animation.DROP,
            title: obj.Site
        });
        marker.addListener('click', function () {
            infowindow.open(map, marker);
            var Monthly = "";
            var Periodic = "";
            var Complited = "";

            function onCompleteper1(e) {
                var preprog = $("#" + e.sender.wrapper[0].id).kendoProgressBar({}).data("kendoProgressBar");
                preprog.progressStatus.text(e.value + "%");
                preprog.progressWrapper.css({
                    "background-color": "green",
                    "border-color": "green"
                });
            }

            function onCompleteperaft1(e) {
                var preprogaf = $("#" + e.sender.wrapper[0].id).kendoProgressBar({}).data("kendoProgressBar");
                preprogaf.progressStatus.text(e.value + "%");
                preprogaf.progressWrapper.css({
                    "background-color": "green",
                    "border-color": "green"
                });
            }
            function onCompleteinproc1(e) {
                var preproginp = $("#" + e.sender.wrapper[0].id).kendoProgressBar({}).data("kendoProgressBar");
                preproginp.progressStatus.text(e.value + "%");
                preproginp.progressWrapper.css({
                    "background-color": "green",
                    "border-color": "green"
                });
            }
            if (Complited == "") {
                Monthly = $("#dvMonthly" + obj.SiteID).kendoProgressBar({
                    type: "value",
                    //change: onCompleteper1,
                    max: 100,
                }).data("kendoProgressBar");

                Periodic = $("#dvPeriodic" + obj.SiteID).kendoProgressBar({
                    type: "value",
                    //change: onCompleteperaft1,
                    max: 100
                }).data("kendoProgressBar");

                Complited = $("#dvComplited" + obj.SiteID).kendoProgressBar({
                    type: "value",
                    //change: onCompleteinproc1,
                    max: 100
                }).data("kendoProgressBar");
            }

            Monthly.value(obj.ManthlyPercentage);
            Periodic.value(obj.PeriodicPercentage);
            Complited.value(obj.ComplitedPercentage);
            Monthly.progressStatus.text(obj.ManthlyPercentage + "% ");
            Periodic.progressStatus.text(obj.PeriodicPercentage + "% ");
            Complited.progressStatus.text(obj.ComplitedPercentage + "%");
            Monthly.progressWrapper.css({
                "background-image": "none",
                "border-image": "none"
            });
            Periodic.progressWrapper.css({
                "background-image": "none",
                "border-image": "none"
            });
            Complited.progressWrapper.css({
                "background-image": "none",
                "border-image": "none"
            });

            Monthly.progressWrapper.css({
                "background-color": "green",
                "border-color": "green"
            });

            Periodic.progressWrapper.css({
                "background-color": "#60bcff",
                "border-color": "#60bcff"
            });

            Complited.progressWrapper.css({
                "background-color": "#4a366d",
                "border-color": "#4a366d"
            });
        });
        //infowindow.open(map, marker);
        markers.push(marker);
    }, timeout);
}

function clearMarkers() {
    for (var i = 0; i < markers.length; i++) {
        markers[i].setMap(null);
    }
    markers = [];
}


function GetDashBoardHomeCount(type) {
    $("#hdneventType").val(type);
    //if (type == 'pageload') {
    //var str = { "CompanyID": 0, "SMonth": "", "SYear": "", "TMonth": "", "TYear": "" };
    //}
    //else {

    var Sdatepicker = $("#fromdtpicker").val();
    var Tdatepicker = $("#todtpicker").val();
    var monthnum = getMonthfromdatepicker(Tdatepicker.split(' ')[0]);
    var SMonth = getMonthfromdatepicker(Sdatepicker.split(' ')[0]);
    var TMonth = getMonthfromdatepicker(Tdatepicker.split(' ')[0]);
    var SYear = Sdatepicker.split(' ')[1];
    var TYear = Tdatepicker.split(' ')[1];
    var Compid = $("#Company").val();
    var str = { "CompanyID": Compid, "SMonth": SMonth, "SYear": SYear, "TMonth": TMonth, "TYear": TYear };
    //}
    //  var Data = { FileName: fileName };
    $.ajax({
        type: "GET",
        url: GetDashBoardHomeCountURL,
        contentType: "application/json; charset=utf-8",
        data: str,
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess == true) {
                var Data = JSON.parse(response.Data)[0];
                $("#anchrNTA").html(Data["NTA"]);
                $("#anchrMyReq").html(Data["MyReq"]);
                $("#anchrHis").html(Data["History"]);

                $("#anchrPWM").html(Data["NTA"]);
                $("#anchrPWC").html(Data["MyReq"]);
                $("#anchrAsNeeded").html(Data["History"]);
                $("#anchrDue5").html(Data["DueIn5Days"]);
                $("#anchrExpired").html(Data["ExpiredSLA"]);
                $("#anchrDue").html(Data["Due"]);
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

var PerProgress = "";
var PerafterDueProgress = "";
var InprocessProgress = "";

function BinProgress() {
    var Sdatepicker = $("#fromdtpicker").val();
    var Tdatepicker = $("#todtpicker").val();
    var monthnum = getMonthfromdatepicker(Tdatepicker.split(' ')[0]);
    var SMonth = getMonthfromdatepicker(Sdatepicker.split(' ')[0]);
    var TMonth = getMonthfromdatepicker(Tdatepicker.split(' ')[0]);
    var SYear = Sdatepicker.split(' ')[1];
    var TYear = Tdatepicker.split(' ')[1];
    var Compid = $("#Company").val();
    var str = { "CompanyID": Compid, "SMonth": SMonth, "SYear": SYear, "TMonth": TMonth, "TYear": TYear };
    $.ajax({
        type: "GET",
        url: GetDashBoardCompTotURL,
        data: str,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (res) {
            if (res.IsSuccess == true) {
                $("#dvPNoData").hide();
                if (res.Data == "[]") {
                    $("#dvPNoData").show();
                    $("#sitewisewrapper").hide();
                    $("#ldrCompany").hide();
                    return;
                }
                if (res.Data != "") {
                    $("#dvPNoData").hide();
                    var data = JSON.parse(res.Data)[0];//.split(",");
                    $("#dvper").attr('title', "Monthly Pending: " + data.TotalManthlyPending);
                    $("#dvpafterdue").attr('title', "Periodic Pending: " + data.TotalPeriodicPending);
                    $("#dvinProcess").attr('title', "Completed: " + data.TotalComplited);
                    if (InprocessProgress == "") {
                        PerProgress = $("#dvper").kendoProgressBar({
                            type: "value",
                            max: 100,
                            change: onCompleteper,
                            //tooltip: {
                            //    visible: true,
                            //    template: "#= series.name # Percentage: #=kendo.format('{0:n2}', (value/category.split(':,')[2]) *100 ) #% <br/> #= series.name # Count : #= value#  "
                            //},
                        }).data("kendoProgressBar");

                        PerafterDueProgress = $("#dvpafterdue").kendoProgressBar({
                            type: "value",
                            max: 100,
                            change: onCompleteperaft
                        }).data("kendoProgressBar");

                        InprocessProgress = $("#dvinProcess").kendoProgressBar({
                            type: "value",
                            max: 100,
                            change: onCompleteinproc
                        }).data("kendoProgressBar");
                    }

                    function onCompleteper(e) {

                        PerProgress.progressStatus.text(e.value + "%");
                        PerProgress.progressWrapper.css({
                            "background-color": "green",
                            "border-color": "green"
                        });
                    }
                    function onCompleteperaft(e) {
                        PerafterDueProgress.progressStatus.text(e.value + "%");
                        PerafterDueProgress.progressWrapper.css({
                            "background-color": "#60bcff",
                            "border-color": "#60bcff"
                        });
                    }

                    function onCompleteinproc(e) {

                        InprocessProgress.progressStatus.text(e.value + "%");
                        InprocessProgress.progressWrapper.css({
                            "background-color": "#4a366d",
                            "border-color": "#4a366d"
                        });
                    }

                    PerProgress.progressWrapper.css({
                        "background-image": "none",
                        "border-image": "none"
                    });


                    PerafterDueProgress.progressWrapper.css({
                        "background-image": "none",
                        "border-image": "none"
                    });
                    //InprocessProgress.progressWrapper.css({
                    //    "background-image": "none",
                    //    "border-image": "none"
                    //});

                    PerProgress.progressWrapper.css({
                        "background-color": "green",
                        "border-color": "green"
                    });

                    PerafterDueProgress.progressWrapper.css({
                        "background-color": "red",
                        "border-color": "red"
                    });

                    //InprocessProgress.progressWrapper.css({
                    //    "background-color": "#FF9900",
                    //    "border-color": "#FF9900"
                    //});
                    PerProgress.value(data["ManthlyPending"]);
                    PerafterDueProgress.value(data["PeriodicPending"]);
                    InprocessProgress.value(data["Complited"]);
                    PerProgress.progressStatus.text(data["ManthlyPending"] + "%");
                    PerafterDueProgress.progressStatus.text(data["PeriodicPending"] + "%");
                    InprocessProgress.progressStatus.text(data["Complited"] + "%");
                    $("#sitewisewrapper").show();
                }
            }
            else { FailResponse(res); }
        },
        complete: function comp() {
            $("#ldrCompany").hide();
        },
        error: function (err) {
            $("#ldrCompany").hide();
        },
        failure: function (response) {
            $("#ldrCompany").hide();

        }
    });
}
function BindChart() {
    var Sdatepicker = $("#fromdtpicker").val();
    var Tdatepicker = $("#todtpicker").val();
    var monthnum = getMonthfromdatepicker(Tdatepicker.split(' ')[0]);
    var SMonth = getMonthfromdatepicker(Sdatepicker.split(' ')[0]);
    //alert(SMonth);
    var TMonth = getMonthfromdatepicker(Tdatepicker.split(' ')[0]);
    var SYear = Sdatepicker.split(' ')[1];
    var TYear = Tdatepicker.split(' ')[1];
    var Compid = $("#Company").val();
    var str = { "CompanyID": Compid, "SMonth": SMonth, "SYear": SYear, "TMonth": TMonth, "TYear": TYear };
    var winwidth = $("#actwisewrapper").width();
    var strid = "#dvActwise";
    $.ajax({
        type: "GET",
        url: GetDashBoardActWiseURL,
        data: str,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (res) {
            //dvGNoData actwisewrapper
            if (res.IsSuccess == true) {
                $("#dvGNoData").hide();
                var Data = JSON.parse(res.Data);
                var Series = Data.series1;
                var chart = $("#dvActwise").data("kendoChart");
                // detach events
                if (chart != undefined) {

                    if ($(strid).data("kendoChart") != undefined) {
                        $(strid).data("kendoChart").destroy();
                    }

                }

                var Category = Data.categoryAxis;

                if (Category == null || Category == "null") {
                    $("#actwisewrapper").hide();
                    $("#dvGNoData").show();
                    return;
                }
                if (Category.length == 0 || Category == null || Category == "null") {
                    $("#actwisewrapper").hide();
                    $("#dvGNoData").show();
                    if ($("#dvActwise").data("kendoChart") != undefined) {
                        $("#dvActwise").data("kendoChart").destroy();
                    }
                    return;

                }
                $("#actwisewrapper").show();
                var width = winwidth / Category.length;

                $(strid).empty();

                $(strid).kendoChart({
                    title: {
                    },
                    chartArea: {
                        height: 350,

                    },
                    legend: {
                        position: "bottom",
                        visible: true,
                    },
                    seriesDefaults: {
                        type: "column",
                        stack: true
                    },
                    majorGridLines: {
                        visible: false,
                    },
                    series: Series,
                    categoryAxis: {
                        categories: Category,


                        labels: {
                            rotation: -90,
                            template: "#=value.split(':,')[0]#",
                        }
                    },

                    valueAxis: {

                        labels: {
                            format: "{0}"
                        },
                        line: {
                            visible: false
                        }
                    },

                    tooltip: {
                        visible: true,

                        template: "#= series.name # Percentage: #=kendo.format('{0:n2}', (value/category.split(':,')[2]) *100 ) #% <br/> #= series.name # Count : #= value#  "
                    },
                    labels: {},
                    seriesClick: function seriesclick(e) {

                        $("#ldrdvGrid").show();
                        $("#dvGrid").empty();
                        BindGrid(Compid, e.category, e.series.name);


                        var dialog = $("#dvpopupgrid").dialog({
                            autoOpen: false,
                            modal: true,
                            title: "Document Details",
                            width: 909,
                            closeText: ""
                        });
                        dialog.dialog("open");

                    },
                });
            }
            else { FailResponse(res); }
        },
        complete: function comp() {
            //   $("#actwisewrapper").show();
            $("#ldrActwise").hide();
        },
        error: function (err) {
            $("#dvPNoData").show();
            $("#ldrActwise").show();
        },
        failure: function (response) {
            $("#dvPNoData").show();
            $("#ldrActwise").show();

        }
    });
}

function BindGrid(CompanyID, ActID, Status) {
    var Sdatepicker = $("#fromdtpicker").val();
    var Tdatepicker = $("#todtpicker").val();
    var monthnum = getMonthfromdatepicker(Tdatepicker.split(' ')[0]);
    var SMonth = getMonthfromdatepicker(Sdatepicker.split(' ')[0]);
    //alert(SMonth);
    var TMonth = getMonthfromdatepicker(Tdatepicker.split(' ')[0]);
    var SYear = Sdatepicker.split(' ')[1];
    var TYear = Tdatepicker.split(' ')[1];
    var actid1 = ActID.split(":,")[1];
    var Compid = $("#Company").val();
    var str = { "CompanyID": CompanyID, "ActID": actid1, "Status": Status, "SMonth": SMonth, "SYear": SYear, "TMonth": TMonth, "TYear": TYear };
    $.ajax({
        type: "GET",
        //GetDashBoardActClick
        url: GetDashBoardActClickURL,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: str,
        success: function (data) {
            if (data.IsSuccess == true) {
                var grid = $("#dvgrid").data("kendoGrid");
                // detach events
                if (grid != undefined) {
                    grid.destroy(); // destroy the Grid
                    $("#dvgrid").empty();
                }
                if (data.Data.length == 0) {
                    //  alert("No Record Found!");
                    // return;
                }
                else {
                    var StrData = $.parseJSON(data.Data);

                    $("#dvgrid").kendoGrid({
                        dataSource: {
                            data: StrData,
                        },
                        height: 400,
                        scrollable: true,
                        resizable: true,
                        reorderable: true,
                        //   groupable: true,
                        sortable: true,
                        filterable: true,
                        toolbar: [{ name: "excel" }],
                        excel: {
                            fileName: "Report_Company.xlsx",
                            filterable: true
                        },
                        //  columns: columns
                    });
                }
                $("#ldrdvGrid").hide();
            }
            else { FailResponse(data); }
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
        complete: function comp() { $("#ldrdvGrid").hide(); },
        error: function (data) {
            alert("Something went wrong please try again later!.");
            $("#ldrdvGrid").hide();
        }
    });
}

function bindSite() {
    var Sdatepicker = $("#fromdtpicker").val();
    var Tdatepicker = $("#todtpicker").val();
    var monthnum = getMonthfromdatepicker(Tdatepicker.split(' ')[0]);
    var SMonth = getMonthfromdatepicker(Sdatepicker.split(' ')[0]);
    var TMonth = getMonthfromdatepicker(Tdatepicker.split(' ')[0]);
    var SYear = Sdatepicker.split(' ')[1];
    var TYear = Tdatepicker.split(' ')[1];
    var Compid = $("#Company").val();
    var str = { "CompanyID": Compid, "SMonth": SMonth, "SYear": SYear, "TMonth": TMonth, "TYear": TYear };
    $.ajax({
        type: "GET",
        url: GetDashBoardSiteWiseURL,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: str,
        success: function (response) {
            if (response.IsSuccess == true) {
                $("#ldrSitewise").hide();
                var res = response.Data;
                $("#dvMapNoData").hide();
                if (res == "[]") {
                    $("#dvMapNoData").show();
                    return;
                }
                var Site = $.parseJSON(res);
                $.each(Site, function (i) {
                    var arr = this.LatLong.split(',');
                    var obj = { lat: 0, lng: 0 };
                    if (arr.length > 1) {
                        obj.lat = parseFloat(arr[0].trim());
                        obj.lng = parseFloat(arr[1].trim());
                    }
                    obj.Site = this.Site;
                    obj.SiteID = this.SiteID;
                    obj.ManthlyPending = this.ManthlyPending;
                    obj.PeriodicPending = this.PeriodicPending;
                    obj.Complited = this.Complited;
                    obj.ManthlyPercentage = kendo.format('{0:n2}', (this.ManthlyPending / this.tot) * 100);
                    obj.PeriodicPercentage = kendo.format('{0:n2}', (this.PeriodicPending / this.tot) * 100);
                    obj.ComplitedPercentage = kendo.format('{0:n2}', (this.Complited / this.tot) * 100);
                    
                    sites.push(obj);

                });
                drop();
            }
            else { FailResponse(response); }
            $("#ldrSitewise").hide();
        },

        complete: function comp() {
            $("#ldrSitewise").hide();
            $("#dvMapNoData").hide();
        },
        error: function (err) {
            $("#dvMapNoData").show();
        },
        failure: function (response) {
            $("#dvMapNoData").show();


        }
        //Ajax call end here
    });
}

function openSiteWindow() {
    var Sdatepicker = $("#fromdtpicker").val();
    var Tdatepicker = $("#todtpicker").val();
    var monthnum = getMonthfromdatepicker(Tdatepicker.split(' ')[0]);
    var SMonth = getMonthfromdatepicker(Sdatepicker.split(' ')[0]);
    var TMonth = getMonthfromdatepicker(Tdatepicker.split(' ')[0]);
    var SYear = Sdatepicker.split(' ')[1];
    var TYear = Tdatepicker.split(' ')[1];
    var Compid = $("#Company").val();
    var URL = "../../Report/SiteMapDashboard/?CompanyID=" + Compid + "&SMonth=" + SMonth + "&SYear=" + SYear + "&TMonth=" + TMonth + "&TYear=" + TYear;
    //var URL = '../../document/Task/' + DocID;
    OpenWindow(URL);

}
var new_window;
function OpenWindow(url) {
    var new_window = window.open(url, "List", "scrollbars=yes,resizable=yes,width=800,height=480");
    return false;
}