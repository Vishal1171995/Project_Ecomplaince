$(document).ajaxStart(function () {
    createLoaderPOP();
});
$(document).ajaxStop(function () {
    closeLoaderPOP();
});
$(document).ajaxError(function (event, request, settings) {
    if ((request.status == "401")) {
        createErrPOP("Whooops! Session expired! :( Please re-login to continue!)");
        setTimeout(function () { $(window).attr('location', '/login') }, 3000);
    }
    else if ((request.status == "403")) {
        createErrPOP("Unauthorized IP address. Your IP is not authorized to access this account.");
    }
    else {
        createErrPOP("Please try again later!!! Error occured while  binding.");
    }
    closeLoaderPOP();
});

function createLoaderPOP() {
    var rlDiv = document.getElementById("popLoader");
    var objDiv = null;
    if (rlDiv == null) {
        var strHTML = "<div style='text-align:center; padding:15px;'>Please wait...<br/><img src='../../Content/images/preloader.gif' alt='Please wait...' /></div>";
        objDiv = document.createElement('div');
        objDiv.setAttribute('id', 'popLoader');
        objDiv.style.display = "none";
        //objDiv.setAttribute('overflow', 'hidden');
        objDiv.innerHTML = strHTML;
        document.body.appendChild(objDiv);
    }

    $("#popLoader").dialog({
        closeOnEscape: false,
        resizable: false,
        modal: true,
        width: 180,
        height: 100
    });
    $('#popLoader').prev('.ui-dialog-titlebar').hide();
    $('#popLoader').css('overflow', 'hidden');
    $('#popLoader').css('height', 'auto');
}

function closeLoaderPOP() {
    $("#popLoader").dialog('close');
}


function createErrPOP(strMsg) {
    var rlDiv = document.getElementById("popErrList");
    var objDiv = null;
    if (rlDiv == null) {
        var strHTML = "<div id=\"popErrList\" class=\"popError\" style=\"display: none;\">" +
                            "<div class='popwrapper'>" +
                                //"<div class=\"header\"><img src=\"../../content/images/iconError.png\" alt=\"\">Error</div>" +
                                "<div id=\"popErrListMsg\" style='padding-top: 41px; color: red; font-weight: bold;' class=\"errorList clear\">" + strMsg + "</div>" +
                            "</div>" +
                            "<div class='footer'>" +
                                //"<div class='tip'></div>" +
                                "<div><input name=\"\" type=\"button\" value=\"ok\" class=\"ok\" onclick=\"javascript:$('#popErrList').dialog('close');\"></div>" +
                            "</div>"+
                       "</div>";
        objDiv = document.createElement('div');
        objDiv.setAttribute('id', 'RLWrapper');
        objDiv.style.display = "none";
        objDiv.innerHTML = strHTML;
        document.body.appendChild(objDiv);
    }
    else {
        $('#popErrListMsg').html('');
        $('#popErrListMsg').html(strMsg);
    }

    $("#popErrList").dialog({
        closeOnEscape: false,
        modal: true,
        width: 425,
        title: "Error",
        /*,
        buttons: { 
        Ok: function () { $(this).dialog("close"); }
        }*/
    });
    $('#popErrList').parent().children().children('.ui-dialog-titlebar-close').hide();
}

function createGenericErrPOP(strMsg) {
    var rlDiv = document.getElementById("popErrGeneric");
    var objDiv = null;
    if (rlDiv == null) {
        var strHTML = "<div id=\"popErrGeneric\" class=\"popError\" style=\"display: none;\">" +
                            "<div class='popwrapper'>" +
                                "<div class=\"header\"><img src=\"../../content/images/iconError.png\" alt=\"\">Error</div>" +
                                "<div class='errorList clear' id=\"popGenericMsg\">" + strMsg + "</div>" +
                            "</div>" +
                            "<div class='footer'>" +
                                //"<div class='tip'></div>" +
                                "<div><input id=\"btnGenericOK\" type=\"button\" value=\"Ok\" class=\"ok\" onclick=\"javascript:$('#popErrGeneric').dialog('close');\" /></div>" +
                            "</div>" +
                        "</div>";
        objDiv = document.createElement('div');
        objDiv.setAttribute('id', 'RLWrapper');
        objDiv.style.display = "none";
        objDiv.innerHTML = strHTML
        document.body.appendChild(objDiv);
    }
    else {
        $('#popGenericMsg').html("");
        $('#popGenericMsg').html(strMsg);
    }
    $("#popErrGeneric").dialog({
        closeOnEscape: false,
        modal: true,
        width: 425
    });
    $('#popErrGeneric').parent().children().children('.ui-dialog-titlebar-close').hide();
}

function createSuccessPOP(strMsg) {
    debugger;
    var rlDiv = document.getElementById("popSuccess");
    var objDiv = null;
    if (rlDiv == null) {
        var strHTML = "<div id=\"popSuccess\" class=\"popError\" style=\"display: none;\">" +
                            "<div class='popwrapper'>" +
                                //"<div class=\"header sucMsg\"><img src=\"../../content/images/iconCheck.png\" alt=\"\">Success</div>" +
                                "<div></div><br/>"+
                                "<p style='margin:10px 0 40px 0; float:left; color: green; font-weight: bold;' id=\"popSucMsg\">" + strMsg + "</p>" +
                            "</div>" +
                            "<div class='footer'>" +
                                //"<div class='tip'></div>" +
                                "<div><input name=\"\" id=\"btnSuccessOK\" type=\"button\" value=\"Ok\" class=\"ok\" onclick=\"javascript:$('#popSuccess').dialog('close');\"></div>" +
                            "</div>" +
                      "</div>";
        objDiv = document.createElement('div');
        objDiv.setAttribute('id', 'RLWrapper');
        objDiv.style.display = "none";
        objDiv.innerHTML = strHTML;
        document.body.appendChild(objDiv);
    }
    else {
        $('#popSucMsg').html(strMsg);
    }
    $("#popSuccess").dialog({
        closeOnEscape: false,
        modal: true,
        title: "Success",
        width: 425
    });
    $('#popSuccess').parent().children().children('.ui-dialog-titlebar-close').hide();
}
function HandleResponse(res, modalID, resetButton,hdnID) {
    if (res.IsSuccess == true) {
        createSuccessPOP(res.Message);
        $("#" + resetButton).click();
        if(resetButton !="")
            $("#" + hdnID).val(0);
        if(modalID !="")
            setTimeout(function () { $('#' + modalID).dialog('close'); }, 3000);
    }
    else {
        createErrPOP(res.Message);
    }
}

//File Upload Code=====================================================
function FileUpload(fileID,url)
    {
    $(fileID).kendoUpload({
            async: {
                saveUrl: url,//"/Utills/FilesUpload",    //"@Url.RouteUrl("Files")"
                removeUrl: "remove",
                autoUpload: true
            },
            upload: function (e) {
                e.data = { Folder: "File" };
            },
            multiple: true,
            success: onSuccess,
            remove: onRemove,
            showFileList: false
        });
}

function onSuccess(e) {
        var name = this.name;
        var id = e.sender.element[0].id;
        var target = $("#" + id).attr("target-control");
        var targetOrignal = $("#" + id).attr("target-control-orignal");
        if (e.operation == 'upload') {
            var responseData = e.response;
            if (responseData.IsSuccess == true) {
                var res = $.parseJSON(responseData.Data);
                var Filename = res.new;
                var original = res.original;
                $("#" + target).val(Filename);
                $("#" + targetOrignal).val(original);
            }
            else {
                $(".k-upload-files.k-reset").find("li").remove();
                $("#" + target).val("");
                $("#" + targetOrignal).val("");
                alert(responseData.Message);
            }
        }
    }
    function onError(e) {
        $(".k-upload-files.k-reset").find("li").remove();
    }
    function onRemove(e) {
        var name = this.name;
        var target = $("#" + name).attr("target-control");
        $(".k-upload-files.k-reset").find("li").remove();
        $("#" + target).val("");
    }

    function FailResponse(res) {
        if (res.IsSuccess == false) {
            if (res.Data == "-1")
                createErrPOP(res.Message);
            else if (res.Data == "-2")
                createErrPOP(res.Message);
            else if (res.Data == "-3" || res.Data == "-4") {
                createErrPOP(res.Message);
                setTimeout(function () { $(window).attr('location', '/login') }, 3000);
            }
            else {
                createErrPOP(res.Message);
            }
        }
    }

