var treeview;
$(document).ready(function () {
    var datasource = new kendo.data.HierarchicalDataSource({
        transport: {
            read: function (options, e) {
                var id = options.data.CustID;
                var PayDate = $("#ddlPaydate").val();
                var Hub = $("#ddlState").text();
                var Location = $("#ddlLocation").text();
                var data = $('#dvTreeView').data('kendoTreeView');
                $.ajax({
                    type: "GET",
                    url: GetReportTreeViewURL,
                    dataType: "json",
                    data: { Location: Location, FileID: options.data.id, PayDate: PayDate, Hub: Hub },
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
        //schema: {
        //    model: {
        //        id: "id",
        //        hasChildren: "hasChildren",
        //        CustomerID: "CustomerID",
        //        ParentId: "ParentId",
        //        data: "data"
        //    }
        //}
    });
    $("#ddlLocation").change(function () {
        var PayDate = $("#ddlPaydate").val();
        var Hub = $("#ddlState option:selected").text();
        var Location = $("#ddlLocation option:selected").text();
      $.ajax({
        type: 'POST',
        url: GetReportTreeViewURL,
        data: { Location: Location, PayDate: PayDate, Hub: Hub },
        success: function (data) {
            $('#dvTreeView').html(data) ;
         //$('#dvTreeView').append(data) ;
        }
    });
    });

    //$("#anchorID").on('click', function (event) {
    // event.preventDefault();
    //    var a = SiteUrl;
    //    var b = $("#lblDir").val();
    //    $.ajax({
    //        type: 'POST',
    //        url: SiteUrl,
    //        data: { Dictory: b },
    //        success: function (data) {
    //            var c = data;
    //            //$('#dvTreeView').append(data) ;
    //        }
    //    });
  
    //});
    function onSelect(e) {
        //function onSelect(e) {
        //e.preventDefault();
        $(".toolbar-btn").removeClass("toolbar-btn");
        var data = $('#dvTreeView').data('kendoTreeView').dataItem(e.node);
        //BindListView(data.CustomerID, data.id);
        // $("#hdnCustomerID").val(data.CustomerID);
        //$("#hdnParentId").val(data.ParentId);
        $("#hdnDeleteFolder").val(data.id);
        $("#listView").show();
        // $("#dvDelete").removeClass("toolbar-btn");
        this.expand(e.node);
        //BindNevigation(data.id);
        //BindMetaDeta(data.id, data.CustomerID, data.ParentID);
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

    function BindNevigation(id) {
        var treeView = $("#dvTreeView").data('kendoTreeView');

        // find node with data-id = id
        var nodeDataItem = treeView.dataSource.get(id);
        var node = treeView.findByUid(nodeDataItem.uid);
        //treeView.select(node);
        var dataItem = treeView.dataItem(node);

        $("#ulFolder").append("<li><a href='javascript:void(0)' class='breadcrumb-item'>" + dataItem.text + "</a></li>");
    }


    function BindListView(CustID, FileID) {
        var data = { Folder: CustID, ParentName: FileID };
        $.ajax({
            type: "GET",
            url: GetReportAllChildFileURL,
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
            var URL = RepCreateZipAndDownloadURL + '?CustID=' + dataitem.CustomerID + '&FileID=' + dataitem.id;
            window.location = URL;
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
                        url: GetReportFileInfoURL,
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
});