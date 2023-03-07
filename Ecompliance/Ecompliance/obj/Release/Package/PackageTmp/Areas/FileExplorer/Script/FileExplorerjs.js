var treeview;
$(document).ready(function () {
    var form = $('#__AjaxAntiForgeryForm');
    var token = $('input[name="__RequestVerificationToken"]', form).val();
    $("#fileToUpload").kendoUpload({
        async: {
            saveUrl:UploadFileMetaDataURL,
            removeUrl: "remove",
            autoUpload: true
        },
        upload: function (e) {
            e.data = { __RequestVerificationToken: token };
        },
        select: function (event) {
            var notAllowed = false;
            $.each(event.files, function (index, value) {
                if ((value.extension != '.exe') && (value.extension != ".vb") && (value.extension != ".js") && (value.extension != ".cs") && (value.extension != ".html") && (value.extension != ".htm") && (value.extension != ".php")) {
                    notAllowed = false;
                }
                else {
                    alert("File type not supported!");
                    notAllowed = true;
                }
                if (value.size > 31457280 && notAllowed === false) {
                    alert("File Size not greater then 30 MB!");
                    notAllowed = true;
                }
            });
            var breakPoint = 0;
            if (notAllowed == true) event.preventDefault();
        },
        multiple: false,
        success: onSuccessUpload,
        //remove: onRemove,
        showFileList: false
    });

function onSuccessUpload(e) {
    if (e.operation == 'upload') {
        var responseData = e.response;
        if (responseData.IsSuccess == true) {
            var res = responseData.Data;
            var arrFileName = res.split('$')
            var Filename = arrFileName[0];
            var original = arrFileName[1];
            $("#hdnTempFileName").val(Filename);
            $("#hdnOriginalFileName").val(original);
        }
        else {
            $(".k-upload-files.k-reset").find("li").remove();
            $("#hdnTempFileName").val(Filename);
            $("#hdnOriginalFileName").val(original);
            alert(responseData.Message);
        }
    }
}
$("#listView").hide();
var datasource = new kendo.data.HierarchicalDataSource({
    transport: {
        read: function (options, e) {
            var id = options.data.CustID;
            var data = $('#dvTreeView').data('kendoTreeView');
            $.ajax({
                type: "GET",
                url: GetCustomerTreeViewURL,
                dataType: "json",
                data: { CustID: $("#hdnCustomerID").val(), FileID: options.data.id, ParentId: $("#hdnParentId").val(), hasChildren: options.data.hasChildren },
                success: function (result) {
                    options.success(result);
                },
                error: function (result) {
                    //alert(result);
                    options.error(result);
                }
            });
        }
    },
    schema: {
        model: {
            id: "id",
            hasChildren: "hasChildren",
            CustomerID: "CustomerID",
            ParentId: "ParentId",
            data: "data"
        }
    }
});
$("#dvTreeView").kendoTreeView({
    dataSource: datasource,
    dataTextField: "text",
    loadOnDemand: true,
    height: 500,
    select: onSelect,
    expand: function (e) {
        //e.preventDefault();
        var data = $('#dvTreeView').data('kendoTreeView').dataItem(e.node);
        $("#hdnCustomerID").val(data.CustomerID);
        $("#hdnParentId").val(data.ParentId);
        $("#listView").show();
        BindListView(data.CustomerID, data.id);

        //console.log("Collapsing", e.node);
    }
});
function onSelect(e) {
    //function onSelect(e) {
    //e.preventDefault();
    $(".toolbar-btn").removeClass("toolbar-btn");
    var data = $('#dvTreeView').data('kendoTreeView').dataItem(e.node);
    BindListView(data.CustomerID, data.id);
    $("#hdnCustomerID").val(data.CustomerID);
    $("#hdnParentId").val(data.ParentId);
    $("#hdnDeleteFolder").val(data.id);
    $("#listView").show();
    $("#dvDelete").removeClass("toolbar-btn");
    this.expand(e.node);
    //BindNevigation(data.id);
    BindMetaDeta(data.id, data.CustomerID, data.ParentID);
    var BreadCrum = {};
    Path = data.text;
    BreadCrum.id = data.id;
    BreadCrum.text = data.text;
    BreadCrum.uid = data.uid;
    var arrPath = [];
    arrPath.push(BreadCrum);

    if (data.id != 0) {
        var node = e.node;
        Parent = "";
        for (; ;) {

            if (Parent == "") {
                Parent = this.parent(e.node);
            }
            else {
                Parent = this.parent(Parent);
            }
            var MyNodeDataItem = $('#dvTreeView').data('kendoTreeView').dataItem(Parent);
            Path = Path + "|" + MyNodeDataItem.text;
            BreadCrum = { id: MyNodeDataItem.id, text: MyNodeDataItem.text, uid: MyNodeDataItem.uid };
            arrPath.push(BreadCrum);
            if (MyNodeDataItem.id == 0) {
                break;
            }

        }
        //$("#ulFolder").append("<li><a href='javascript:void(0)' class='breadcrumb-item'>" + dataItem.text + "</a></li>");
    }
    var arr = Path.split("|");
    $("#ulFolder").html("").append("<li><div class='icon-folder'></div></li>");
    for (var i = arrPath.length - 1; i >= 0; i--) {
        if (i == 0) {
            $("#ulFolder").append("<li><a id='anchbrd" + arrPath[i].id + "' href='javascript:void(0)' class='breadcrumb-item'>" + arrPath[i].text + "</a></li>");
        }
        else {
            $("#ulFolder").append("<li><a id='anchbrd" + arrPath[i].id + "' href='javascript:void(0)'>" + arrPath[i].text + "</a></li>");
        }
        $("#anchbrd" + arrPath[i].id).bind("click", { id: arrPath[i].id, uid: arrPath[i].uid }, BreadCrumEvent);
    }
}
function BreadCrumEvent(evt) {
    var treeview = $("#dvTreeView").data("kendoTreeView");
    var nodeDataItem = treeview.dataSource.get(evt.data.id);
    var node = treeview.findByUid(evt.data.uid);
    treeview.trigger('select', { node: node });
    treeview.select(node);
}
function BindMetaDeta(id, CustomerID, ParentID) {
    $("#DvMetaDetatype").html("");
    var data = { CustID: CustomerID, FileID: id, FileMetaID: 0 };
    $.ajax({
        type: "GET",
        url: GetFileMetaDataURL,
        contentType: "application/json; charset=utf-8",
        data: data,
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess) {
                var ds = JSON.parse(response.Data);
                if (ds.length > 0) {
                    $.each(ds, function () {
                        $("#DvMetaDetatype").append("<div id='dv" + this.FileMetaID + "' class='ex pull-left mgfl'><span class='credit-icon'></span> <label>" + this.FileTypeName + "</label></div>");
                        $("#dv" + this.FileMetaID).bind('click', { CustID: this.CustomerID, FMetaID: this.FileMetaID }, openMetaPopup)
                    });
                    //onclick = 'openMetaPopup(" + this.CustomerID + "," + this.FileMetaID + ")'
                }
            }
            else {
                if (response.Data == "-1")
                    alert("User not authorized.");
                else if (response.Data == "-2") {
                    alert("This folder not exists.");
                }
            }
        },
        error: function (data) {
            //alert('Error');
        }
    });
}
var arrMetaValue = {};
function openMetaPopup(evt) {
    $(".k-upload-empty").css("border-color", '');
    var CustomerID = evt.data.CustID, FileMetaID = evt.data.FMetaID;
    $(".appendDiv").html("");
    var data = { CustID: CustomerID, FileID: 0, FileMetaID: FileMetaID };
    $.ajax({
        type: "GET",
        url: GetFileMetaDataURL,
        contentType: "application/json; charset=utf-8",
        data: data,
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess) {
                var ds = JSON.parse(response.Data);
                if (ds.length > 0) {
                    var metaDeta = ds[0].MetaData;
                    var arrMetaData = metaDeta.split(',');
                    for (var i = 0; i < arrMetaData.length; i++) {
                        if (arrMetaData[i] != '') {
                            $(".appendDiv").append("<div class='col-xs-6 col-sm-4 col-md-4 allcreditionals'><label>" + arrMetaData[i] + "<sup>*</sup></label></div>" +
                                "<div class='col-xs-6 col-sm-8 col-md-8 allcreditionals'><input type='text' id='txt" + arrMetaData[i].replace(/ /g, '-') + "'  /></div>"
                                );
                        }
                    }
                    arrMetaValue.FMetaID = FileMetaID;
                    arrMetaValue.metaDeta = metaDeta;
                    arrMetaValue.CustomerID = CustomerID;
                    arrMetaValue.FileTypeName = ds[0].FileTypeName;
                    $("#dvMetaDeta").dialog({
                        width: 500,
                        title: ds[0].FileTypeName,
                        closeText: "",
                        modal: true,
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
                    //var arrMetaData = ds.MetaData.Spli
                }
            }
            else {
                if (response.Data == "-1")
                    alert("User not authorized.");
                else if (response.Data == "-2") {
                    alert("This folder not exists.");
                }
            }
        },
        error: function (data) {
            //alert('Error');
        }
    });
}
$("#dvOpen").bind('click', function () {
    if ($(this).hasClass("toolbar-btn")) {
        return;
    }
    var dbConnObj = $("#listView").data("kendoListView");
    if (dbConnObj != undefined) {
        var index = dbConnObj.select().index(),
        dataItem = dbConnObj.dataSource.view()[index];
        if (dataItem != undefined) {
            if (dataItem.FileType != 'File') {
                $("#hdnDeleteFolder").val(dataItem.id);
                var treeview = $("#dvTreeView").data("kendoTreeView");
                var nodeDataItem = treeview.dataSource.get(dataItem.id);
                var node = treeview.findByUid(nodeDataItem.uid);
                treeview.trigger('select', { node: node });
                treeview.select(node);
            }
        }
        else {
            createErrPOP('Please select folder');
        }
    }
});
$("#dvRename").click(function () {
    var dbConnObj = $("#listView").data("kendoListView");
    var treeview = $("#dvTreeView").data("kendoTreeView");
    var dataitem;
    var FileType = "";
    var node;
    var OldName = "";
    if (dbConnObj != undefined) {
        var index = dbConnObj.select().index(),
        dataitem = dbConnObj.dataSource.view()[index];
        if (dataitem != undefined) {
            OldName = dataitem.FileOriginalName;
            if (dataitem.FileType == 'Folder') {
                var nodeDataItem = treeview.dataSource.get(dataitem.id);
                node = treeview.findByUid(nodeDataItem.uid);
                FileType = dataitem.FileType
            }
            else {
                FileType = dataitem.FileType;
                node = "";
            }
        }
        else {
            FileType = 'Folder'
            node = treeview.select();
            dataitem = treeview.dataItem(node);
            OldName = dataitem.text;
        }
    }
    else {
        FileType = 'Folder'
        node = treeview.select();
        dataitem = treeview.dataItem(node);
        OldName = dataitem.text;
    }
    if (dataitem.id != 0) {
        $("#dvRenamePopup").dialog({
            width: 400,
            modal: true,
            title: 'Rename Item',
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

        $("#txtRename").val(OldName);
        $('#btnRename').unbind().bind('click', function () {
            var NewFile = $("#txtRename").val();
            if (OldName != NewFile) {
                var form = $('#__AjaxAntiForgeryForm');
                var token = $('input[name="__RequestVerificationToken"]', form).val();

                var data = { __RequestVerificationToken: token, CustID: dataitem.CustomerID, FileID: dataitem.id, OldName: OldName, NewName: NewFile, FileType: FileType };
                $.ajax({
                    type: "POST",
                    url:RenmaeFileURL,
                    contentType: "application/x-www-form-urlencoded",
                    data: data,
                    dataType: "json",
                    success: function (response) {
                        if (response.IsSuccess) {
                            if (node != "") {
                                //var parrentNode = treeview.dataItem(treeview.parent(node))
                                var parrentNode = treeview.dataItem(node);
                                var selnode = treeview.findByUid(parrentNode.uid);
                                treeview.text(node, NewFile);
                                selectedNode = treeview.select();
                                dataitem = treeview.dataItem(selectedNode);
                                selnode = treeview.findByUid(dataitem.uid);
                                treeview.trigger('select', { node: selnode });
                            }
                            else {
                                var selectedNode = treeview.select();
                                dataitem = treeview.dataItem(selectedNode);
                                selnode = treeview.findByUid(dataitem.uid);
                                treeview.trigger('select', { node: selnode });
                                //treeview.select(selectedNode);
                            }
                            $("#dvRenamePopup").dialog("close");
                        }
                        else {
                            if (response.Data == "-3")
                                createErrPOP("This folder already exists.");
                            else if (response.Data == "-2") {
                                alert("This folder not exists.");
                            }
                        }
                    },
                    error: function (data) {
                        //alert('Error');
                    }
                });
            }
            else {
                createErrPOP("File name and new file name do not same.");
            }
        });
    }
});

$("#dvViewFile").click(function () {
    $("#dvAppendFileInfo").html('');
    if ($(this).hasClass("toolbar-btn")) {
        return;
    }
    var dbConnObj = $("#listView").data("kendoListView");
    if (dbConnObj != undefined) {
        var index = dbConnObj.select().index(),
        dataItem = dbConnObj.dataSource.view()[index];
        if (dataItem != undefined) {
            if (dataItem.FileType == 'File') {
                var FileID = dataItem.id;
                var data = { FileID: FileID };
                $.ajax({
                    type: "GET",
                    url:GetFileInfoURL,
                    contentType: "application/json; charset=utf-8",
                data: data,
                dataType: "json",
                success: function (response) {
                    if (response.IsSuccess) {
                        var ds = JSON.parse(response.Data);
                        if (ds.length > 0) {
                            var MetaValue = ds[0].MetaValue;
                            var arrMetaColumn = MetaValue.split('$');
                            $("#dvAppendFileInfo").append("<div class='feedback-table col-xs-6 col-sm-4 col-md-4'><label class='headtag'>Download</label></div>" +
                                        "<div class='feedback-table col-xs-6 col-sm-8 col-md-8'><input id='btnInfoDownload' type='button' value='Download' class='button download mg'></div>");
                            if (MetaValue != "") {
                                if (arrMetaColumn.length > 0) {
                                    for (var i = 0; i < arrMetaColumn.length; i++) {
                                        var arrMetaValue = arrMetaColumn[i].split(':');
                                        $("#dvAppendFileInfo").append("<div class='feedback-table col-xs-6 col-sm-4 col-md-4'><label class='headtag'>" + arrMetaValue[0] + "</label></div>" +
                                            "<div class='feedback-table col-xs-6 col-sm-8 col-md-8'><label id='lblName' class='feedback_content'>" + arrMetaValue[1] + "</label></div>");
                                    }
                                }
                                else {
                                    var arrMetaValue = MetaValue.split(':');
                                    $("#dvAppendFileInfo").append("<div class='feedback-table col-xs-6 col-sm-4 col-md-4'><label class='headtag'>" + arrMetaValue[0] + "</label></div>" +
                                            "<div class='feedback-table col-xs-6 col-sm-8 col-md-8'><label id='lblName' class='feedback_content'>" + arrMetaValue[1] + "</label></div>");
                                }
                            }
                            $("#dvFile").dialog({
                                width: 600,
                                title: ds[0].FileTypeName,
                                closeText: "",
                                modal: true,
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
                            $('#btnInfoDownload').bind('click', function () {
                                $("#dvDownload").click();
                            });
                        }
                    }
                    else {
                        if (response.Data == "-1")
                            alert("User not authorized.");
                        else if (response.Data == "-2") {
                            alert("This folder not exists.");
                        }
                    }
                },
                error: function (data) {
                    //alert('Error');
                }
            });
        }
    }
    else {
        createErrPOP('Please select File');
    }
}
});
$("#btnSubmit").bind('click', function () {
    var FMetaID = arrMetaValue.FMetaID;
    var FMetaData = arrMetaValue.metaDeta;
    var CustomerID = arrMetaValue.CustomerID;
    var FileTypeName = arrMetaValue.FileTypeName;
    var arrMetaData = FMetaData.split(",");
                
    var MetaValue = "";
    var textboxvalue = "";
    var arrMsg =[];
    for (var i = 0; i < arrMetaData.length; i++) {
        if (arrMetaData[i] != "") {
            var valueid = arrMetaData[i].split(' ').join('-');
            var test = $("#txt" + valueid);
            $("#txt" + valueid).css('border-color', '');
            var value = test.val();
            textboxvalue = $("#txt" + valueid).val();
            if (textboxvalue == "") {
                var Msg = {};
                //alert("Please select " + arrMetaData[i]);
                Msg.columnName =arrMetaData[i];
                Msg.obj = $("#txt" + valueid);
                arrMsg.push(Msg);
                continue;
            }
            else {
                if (MetaValue == "")
                    MetaValue = arrMetaData[i] + ":" + textboxvalue;
                else
                    MetaValue += "$" + arrMetaData[i] + ":" + textboxvalue;
            }
        }
    }
    if ($("#hdnOriginalFileName").val() == "")
        $(".k-upload-empty").css("border-color", 'red');
    else
        $(".k-upload-empty").css("border-color", '');

    var originalFileName = $("#hdnOriginalFileName").val();
    var TempFileName = $("#hdnTempFileName").val();
    if (originalFileName != "" && arrMsg.length == 0) {
        var dbConnObj = $("#listView").data("kendoListView");
        var treeview = $("#dvTreeView").data("kendoTreeView");
        var dataitem;
        var node;
        var selectedNode = "";
        if (dbConnObj != undefined) {
            var index = dbConnObj.select().index(),
            dataitem = dbConnObj.dataSource.view()[index];
            if (dataitem != undefined) {
                if (dataitem.FileType == 'Folder') {
                    var nodeDataItem = treeview.dataSource.get(dataitem.id);
                    node = treeview.findByUid(nodeDataItem.uid);
                    treeview.select(node);
                    selectedNode = treeview.select();
                }
            }
            else {
                selectedNode = treeview.select();
            }
        }
        else {
            selectedNode = treeview.select();
        }
        //var treeview = $("#dvTreeView").data("kendoTreeView");
        //var selectedNode = treeview.select();
        var item = treeview.dataItem(selectedNode);
        var FileID = item.id;

        var form = $('#__AjaxAntiForgeryForm');
        var token = $('input[name="__RequestVerificationToken"]', form).val();

        var data = { __RequestVerificationToken: token, CustID: CustomerID, FileID: FileID, OriginalFileName: originalFileName, TempFileName: TempFileName, MetaValue: MetaValue, FileTypeName: FileTypeName };
        $.ajax({
            type: "POST",
            url:AddFileURL,
            contentType: "application/x-www-form-urlencoded",
            data: data,
            dataType: "json",
            success: function (response) {
                if (response.IsSuccess) {
                    if (response.Data > 0) {
                        createSuccessPOP("File created successfully");
                        $("#hdnOriginalFileName,#hdnTempFileName").val("");
                        $(".k-upload-files.k-reset").find("li").remove();
                        $('.k-upload').addClass('k-upload-empty');
                        $("#dvMetaDeta").dialog("close");
                        treeview.trigger('select', { node: selectedNode });
                    }
                }
                else {
                    if (response.Data == "-1")
                        alert("User not authorized.");
                    else if (response.Data == "-2") {
                        alert("This folder not exists.");
                    }
                    else if (response.Data == "-7") {
                        alert("Please upload file then process.");
                    }
                }
            },
            error: function (data) {
                //alert('Error');
            }
        });
    }
    else {
        if(arrMsg.length > 0)
        {
            //createErrPOP(arrMsg[0].columnName + " required.");
            $.each(arrMsg, function () {
                $(this.obj).css("border-color", 'red');
            });
        }
        else
        {
            $(".k-upload-empty").css("border-color", 'red');
            //createErrPOP("Please upload file");
        }
    }
});

function BindNevigation(id) {
    var treeView = $("#dvTreeView").data('kendoTreeView');

    // find node with data-id = id
    var nodeDataItem = treeView.dataSource.get(id);
    var node = treeView.findByUid(nodeDataItem.uid);
    //treeView.select(node);
    var dataItem = treeView.dataItem(node);

    $("#ulFolder").append("<li><a href='javascript:void(0)' class='breadcrumb-item'>" + dataItem.text + "</a></li>");
}
$("#dvNewFolder").click(function () {
    if ($(this).hasClass("toolbar-btn")) {
        return;
    }
    var dbConnObj = $("#listView").data("kendoListView");
    if (dbConnObj != undefined) {
        var index = dbConnObj.select().index(),
            dataitem = dbConnObj.dataSource.view()[index];
        if (dataitem != undefined) {
            if (dataitem.FileType == 'Folder') {
                OpenNewFolderPopup();
            }
            else {
                alert("Only folder allow");
            }
        }
        else {
            OpenNewFolderPopup();
        }
    }
    else {
        alert("Please select node");
    }
});
$("#btnAddNewFolder").click(function () {
    var NFoolder = $("#txtNewFolder").val();
    var dbConnObj = $("#listView").data("kendoListView");
    var treeview = $("#dvTreeView").data("kendoTreeView");
    var dataitem;
    var node;
    var selectedNode = "";
    if (dbConnObj != undefined) {
        var index = dbConnObj.select().index(),
        dataitem = dbConnObj.dataSource.view()[index];
        if (dataitem != undefined) {
            if (dataitem.FileType == 'Folder') {
                var nodeDataItem = treeview.dataSource.get(dataitem.id);
                node = treeview.findByUid(nodeDataItem.uid);
                treeview.select(node);
                selectedNode = treeview.select();
            }
        }
        else {
            selectedNode = treeview.select();
        }
    }
    else {
        selectedNode = treeview.select();
    }
    if (selectedNode != "") {
        var item = treeview.dataItem(selectedNode);
        var CustID = item.CustomerID;
        var FileID = item.id;
        var ParentID = item.ParentId;
        var SelectedText = item.Text;
        var form = $('#__AjaxAntiForgeryForm');
        var token = $('input[name="__RequestVerificationToken"]', form).val();
        var data = { __RequestVerificationToken: token, CustID: CustID, FileID: FileID, ParentID: ParentID, SelectedText: NFoolder };
        $.ajax({
            type: "POST",
            url:CreateNewFolderURL,
            contentType: "application/x-www-form-urlencoded",
            data: data,
            dataType: "json",
            success: function (response) {
                if (response.IsSuccess) {
                    treeview.append({
                        text: NFoolder,
                        id: CustID
                    }, selectedNode);
                    item.loaded(false);
                    item.load();
                    BindListView(CustID, FileID);
                    $("#dvCreateNewFolder").dialog('close');
                }
                else {
                    alert("This folder already exist.");
                }
            },
            error: function (data) {
                //alert('Error');
            }
        });
    }
});

$("#dvDelete").click(function () {
    if ($(this).hasClass("toolbar-btn")) {
        return;
    }
    var dbConnObj = $("#listView").data("kendoListView");
    var treeview = $("#dvTreeView").data("kendoTreeView");
    var dataitem;
    var FileType = "";
    var node;
    if (dbConnObj != undefined) {
        var index = dbConnObj.select().index(),
        dataitem = dbConnObj.dataSource.view()[index];
        if (dataitem != undefined) {
            if (dataitem.FileType == 'Folder') {
                var nodeDataItem = treeview.dataSource.get(dataitem.id);
                node = treeview.findByUid(nodeDataItem.uid);
                FileType = dataitem.FileType
            }
            else {
                FileType = dataitem.FileType;
                node = "";
            }
        }
        else {
            FileType = 'Folder'
            node = treeview.select();
            dataitem = treeview.dataItem(node);
        }
    }
    else {
        FileType = 'Folder'
        node = treeview.select();
        dataitem = treeview.dataItem(node);
    }
    if (!dataitem.hasChildren) {
        if (confirm("Are you sure delete this folder")) {

            var form = $('#__AjaxAntiForgeryForm');
            var token = $('input[name="__RequestVerificationToken"]', form).val();

            var data = { __RequestVerificationToken: token, CustID: dataitem.CustomerID, FileID: dataitem.id, ParentID: dataitem.PID, FileType: FileType };
            $.ajax({
                type: "POST",
                url: DeleteFolderURL,
                contentType: "application/x-www-form-urlencoded",
                data: data,
                dataType: "json",
                success: function (response) {
                    if (response.IsSuccess) {
                        if (node != "") {
                            var parrentNode = treeview.dataItem(treeview.parent(node))
                            var selnode = treeview.findByUid(parrentNode.uid);
                            treeview.select(selnode);
                            treeview.remove(node);
                            treeview.trigger('select', { node: selnode });
                        }
                        else {
                            var selectedNode = treeview.select();
                            treeview.trigger('select', { node: selectedNode });
                        }
                    }
                    else {
                        if (response.Data == "-1")
                            alert("User not authorized.");
                        else if (response.Data == "-2") {
                            alert("This folder not exists.");
                        }
                    }
                },
                error: function (data) {
                    //alert('Error');
                }
            });
        }
    }
    else {
        createErrPOP("Folder can not be deleted. please delete file and folder first.");
    }
});
$("#dvDownload").click(function () {
    if ($(this).hasClass("toolbar-btn")) {
        return;
    }
    var dbConnObj = $("#listView").data("kendoListView");
    var treeview = $("#dvTreeView").data("kendoTreeView");
    var dataitem;
    var node;
    var selectedNode = "";
    if (dbConnObj != undefined) {
        var index = dbConnObj.select().index(),
        dataitem = dbConnObj.dataSource.view()[index];
        if (dataitem != undefined) {
            if (dataitem.FileType == 'File') {
                //var nodeDataItem = treeview.dataSource.get(dataitem.id);
                //node = treeview.findByUid(nodeDataItem.uid);
                //treeview.select(node);
                selectedNode = treeview.select();
            }
        }
        else {
            selectedNode = treeview.select();
        }
    }
    else {
        selectedNode = treeview.select();
    }
    if (selectedNode != "") {
        var item = treeview.dataItem(selectedNode);
        var CustID = item.CustomerID;
        var FileID = item.id;
        var ParentID = item.ParentId;
        var SelectedText = item.Text;
        var data = { CustID: CustID, FileID: FileID };
        var URL = CreateZipAndDownloadURL + '?CustID=' + dataitem.CustomerID + '&FileID=' + dataitem.id;
        window.location = URL;
    }
});
function OpenNewFolderPopup() {
    $("#txtNewFolder").val("New Folder");
    $("#dvCreateNewFolder").dialog({
        //autoOpen: false,
        width: 400,
        modal: true,
        title: "Create New Folder",
        closeText: ""
    });
}
function BindListView(CustID, FileID) {
    var data = { CustID: CustID, FileID: FileID };
    $.ajax({
        type: "GET",
        url:GetAllChildFileURL,
        contentType: "application/json; charset=utf-8",
        data: data,
        dataType: "json",
        success: function (response) {
            if (response.IsSuccess) {
                var Data = JSON.parse(response.Data);
                BindList(Data);
            }
        },
        error: function (data) {
            //alert('Error');
        }
    });
}
function BindList(Data) {
    var Klist = $("#listView").data("kendoListView");
    if ($(Klist).length > 0) {
        $("#listView").data("kendoListView").destroy();
        $('#listView').empty();
    }
    var dataSource = new kendo.data.DataSource({
        data: Data,
        pageSize: 20
    });
    $("#listView").kendoListView({
        dataSource: dataSource,
        selectable: "single",
        dataBound: dbclick,
        //change: setItemDoubleClickEvent,
        //change: onChange,
        template: kendo.template($("#template").html()),

    });
    $("#listView").removeClass("k-widget k-listview");
}
function dbclick() {
    var items1 = $(".DoubleClick");
    items1.dblclick(function (e) {
        var dbConnObj = $("#listView").data("kendoListView");
        if (dbConnObj != undefined) {
            var index = dbConnObj.select().index(),
            dataItem = dbConnObj.dataSource.view()[index];
            $("#hdnDeleteFolder").val(dataItem.id);
            var treeview = $("#dvTreeView").data("kendoTreeView");
            var nodeDataItem = treeview.dataSource.get(dataItem.id);
            var node = treeview.findByUid(nodeDataItem.uid);
            treeview.trigger('select', { node: node });
            treeview.select(node);
            //expandAndSelectNode(dataItem.id);
        }
        //expandAndSelectNode(dataItem.FileID);
    });
}
function setItemDoubleClickEvent() {
    //e.preventDefault();
    var dbConnObj = $("#listView").data("kendoListView");
    if (dbConnObj != undefined) {
        var index = dbConnObj.select().index(),
        dataItem = dbConnObj.dataSource.view()[index];
        $("#hdnDeleteFolder").val(dataItem.id);
    }
    //e.preventDefault();
}
function expandAndSelectNode(id) {
    // get the Kendo TreeView widget by it's ID given by treeviewName
    var treeView = $("#dvTreeView").data('kendoTreeView');

    // find node with data-id = id
    var nodeDataItem = treeView.dataSource.get(id);
    var node = treeView.findByUid(nodeDataItem.uid);
    treeView.select(node);
    var dataItem = treeView.dataItem(node);
    var item = $("#dvTreeView").find("li[data-uid='" + nodeDataItem.uid + "']").find(".k-in");
    var isExpanded = $(node).attr("data-expanded");
    // expand all parent nodes
    if (dataItem.expanded === true || dataItem.hasChildren === false) {
        var item = treeView.dataItem(node);
        BindListView(item.CustomerID, item.id);
    }
    else {
        $(item).parentsUntil('.k-treeview').filter('.k-item').each(
                    function (index, element) {
                        $("#dvTreeView").data('kendoTreeView').expand($(this));
                    }
        );
    }
}
});
$(document).ready(function () {
    $("#dvSearch").click(function () {
        $("#dvSearchPopup").dialog({
            width: 500,
            title: 'Search File',
            modal: true,
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
    });
    $("#btnSearch").click(function () {
        var text = $("#txtSearch").val();
        var dbConnObj = $("#listView").data("kendoListView");
        var index = dbConnObj.select().index(),
        dataitem = dbConnObj.dataSource.view()[index];

        if (dataitem != undefined) {
            var CustID = dataitem.CustomerID;
            var FileID = dataitem.id;
            if (text != '') {
                var data = { CustID: CustID, FileID: FileID, text: text };
                $.ajax({
                    type: "GET",
                    url: GetMetaDetaFileForSearchURL,
                    contentType: "application/json; charset=utf-8",
                    data: data,
                    dataType: "json",
                    success: function (response) {
                        if (response.IsSuccess) {
                            if (response.Data == 1) {
                                var treeview = $("#dvTreeView").data("kendoTreeView");
                                var nodeDataItem = treeview.dataSource.get(FileID);
                                node = treeview.findByUid(nodeDataItem.uid);
                                treeview.select(node);
                                treeview.trigger('select', { node: node });
                                $("#dvSearchPopup").dialog("close");
                            }
                            else {
                                createErrPOP("File not exists.");
                            }
                        }
                        else {
                            if (response.Data == "-1")
                                alert("User not authorized.");
                            else if (response.Data == "-2") {
                                alert("This folder not exists.");
                            }
                        }
                    },
                    error: function (data) {
                        //alert('Error');
                    }
                });
            }
            else {
                createErrPOP("Please enter search text.");
            }
        }
        else {
            createErrPOP("Please select folder.")
        }

    });
});
$('.scrollbox3').enscroll({
    showOnHover: false,
    verticalTrackClass: 'track3',
    verticalHandleClass: 'handle3'
});
(function ($, window) {
    $.fn.contextMenu = function (settings) {
        return this.each(function () {
            // Open context menu
            $(this).on("contextmenu", function (e) {
                // return native menu if pressing control
                if (e.ctrlKey) return;
                //open menu
                var $menu = $(settings.menuSelector)
                    .data("invokedOn", $(e.target))
                    .show()
                    .css({
                        position: "absolute",
                        left: getMenuPosition(e.clientX, 'width', 'scrollLeft'),
                        top: getMenuPosition(e.clientY, 'height', 'scrollTop')
                    })
                    .off('click')
                    .on('click', 'a', function (e) {
                        $menu.hide();

                        var $invokedOn = $menu.data("invokedOn");
                        var $selectedMenu = $(e.target);

                        settings.menuSelected.call(this, $invokedOn, $selectedMenu);
                    });
                return false;
            });
            //make sure menu closes on any click
            $('body').click(function () {
                $(settings.menuSelector).hide();
            });
        });
        function getMenuPosition(mouse, direction, scrollDir) {
            var win = $(window)[direction](),
                scroll = $(window)[scrollDir](),
                menu = $(settings.menuSelector)[direction](),
                position = mouse + scroll;

            // opening menu would pass the side of the page
            if (mouse + menu > win && menu < mouse)
                position -= menu;

            return position;
        }

    };
})(jQuery, window);

$("#myTable div").contextMenu({
    menuSelector: "#contextMenu",
    menuSelected: function (invokedOn, selectedMenu) {
        var Menutext = selectedMenu.text();

        var dbConnObj = $("#listView").data("kendoListView");
        var index = dbConnObj.select().index(),
        dataItem = dbConnObj.dataSource.view()[index];

        if (Menutext == "New Folder") {
            //OpenNewFolderPopup();
            $("#dvNewFolder").click();
        }
        else if (Menutext == "Delete") {
            $("#hdnDeleteFolder").val(dataItem.id);
            //DeleteFileAndFolder();
            $("#dvDelete").click()
        }
        else if (Menutext == "Download") {
            $("#hdnDeleteFolder").val(dataItem.id);
            //DeleteFileAndFolder();
            $("#dvDownload").click()
        }
        else if (Menutext == "Open") {
            $('#dvOpen').click();
        }
        else if (Menutext == "Rename") {
            $('#dvRename').click();
        }
        else if (Menutext == "Paste") {

        }
        var msg = "You selected the menu item '" + selectedMenu.text() +
            "' on the value '" + invokedOn.text() + "'";
        //alert(msg);
    }
});