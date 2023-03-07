$(document).ready(function () {
    //initMap();
    bindSite();
});
function bindSite() {
    var SMonth = GetParameterValues('SMonth');
    var TMonth = GetParameterValues('TMonth');
    var SYear = GetParameterValues('SYear');
    var TYear = GetParameterValues('TYear');
    //var Compid = $("#Company").val();
    var Compid = GetParameterValues('CompanyID');
    var str = { "CompanyID": Compid, "SMonth": SMonth, "SYear": SYear, "TMonth": TMonth, "TYear": TYear };
    $.ajax({
        type: "GET",
        url: GetDashBoardSiteWiseURL,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: str,
        success: function (response) {
            if (response.IsSuccess == true) {
                //$("#ldrSitewise").hide();
                var res = response.Data;
                //$("#dvMapNoData").hide();
                if (res == "[]") {
                    //$("#dvMapNoData").show();
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
                    obj.Performed = this.Performed;
                    obj.InProcess = this.InProcess;
                    obj["NotPerformed"] = this["NotPerformed"];
                    obj.PerPercentage = kendo.format('{0:n2}', (this.Performed / this.tot) * 100);
                    obj.NotPerPercentage = kendo.format('{0:n2}', (this["NotPerformed"] / this.tot) * 100);
                    obj.InProcessPercentage = kendo.format('{0:n2}', (this.InProcess / this.tot) * 100);
                    sites.push(obj);

                });
                drop();
            }
            else { FailResponse(response); }
            //$("#ldrSitewise").hide();
        },

        complete: function comp() {
            //$("#ldrSitewise").hide();
            //$("#dvMapNoData").hide();
        },
        error: function (err) {
            //$("#dvMapNoData").show();
        },
        failure: function (response) {
            //$("#dvMapNoData").show();


        }
        //Ajax call end here
    });
}

function GetParameterValues(param) {
    var url = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for (var i = 0; i < url.length; i++) {
        var urlparam = url[i].split('=');
        if (urlparam[0] == param) {
            return urlparam[1];
        }
    }
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
        zoom: 5,
        center: Country
        //center: { lat: 52.520, lng: 13.410 }
    });
    google.maps.event.trigger(map, 'resize');
    //drop();
    //  bindSite();
}
function addMarkerWithTimeout(obj, timeout) {
    var position = { lat: obj.lat, lng: obj.lng };
    window.setTimeout(function () {
        var contentString = '  <div id="sitewisewrapper1" class="gap1" ><h2>' + obj.Site + ' </h2>  Compliance  ' + '(Count :' + obj.Performed + ' )' + '<br /> ' +
            ' <div id="dvper1' + obj.SiteID + '" style="width: 100%;"></div>' +
            ' Non Compliance ' + '(Count :' + obj["NotPerformed"] + ' )' + '<br />  <div id="dvpafterdue1' + obj.SiteID + '" style="width: 100%;"></div>' +
            ' In Process ' + '(Count :' + obj.InProcess + ' )' + '<br /> <div id="dvinProcess1' + obj.SiteID + '" style="width: 100%;"></div> </div>'

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
            var PerProgress1 = "";
            var PerafterDueProgress1 = "";
            var InprocessProgress1 = "";

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
            if (InprocessProgress1 == "") {
                PerProgress1 = $("#dvper1" + obj.SiteID).kendoProgressBar({
                    type: "value",
                    change: onCompleteper1,
                    max: 100,
                }).data("kendoProgressBar");

                PerafterDueProgress1 = $("#dvpafterdue1" + obj.SiteID).kendoProgressBar({
                    type: "value",
                    change: onCompleteperaft1,
                    max: 100
                }).data("kendoProgressBar");

                InprocessProgress1 = $("#dvinProcess1" + obj.SiteID).kendoProgressBar({
                    type: "value",
                    change: onCompleteinproc1,
                    max: 100
                }).data("kendoProgressBar");
            }

            PerProgress1.value(obj.PerPercentage);
            PerafterDueProgress1.value(obj.NotPerPercentage);
            InprocessProgress1.value(obj.InProcessPercentage);
            PerProgress1.progressStatus.text(obj.PerPercentage + "% ");
            PerafterDueProgress1.progressStatus.text(obj.NotPerPercentage + "% ");
            InprocessProgress1.progressStatus.text(obj.InProcessPercentage + "%");
            PerProgress1.progressWrapper.css({
                "background-image": "none",
                "border-image": "none"
            });
            PerafterDueProgress1.progressWrapper.css({
                "background-image": "none",
                "border-image": "none"
            });
            InprocessProgress1.progressWrapper.css({
                "background-image": "none",
                "border-image": "none"
            });

            PerProgress1.progressWrapper.css({
                "background-color": "green",
                "border-color": "green"
            });

            PerafterDueProgress1.progressWrapper.css({
                "background-color": "red",
                "border-color": "red"
            });

            InprocessProgress1.progressWrapper.css({
                "background-color": "#FF9900",
                "border-color": "#FF9900"
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