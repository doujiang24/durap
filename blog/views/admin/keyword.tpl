<link rel="stylesheet" type="text/css" href="/css/flexigrid.css" />

<script>
var a = "aa";
$(document).ready(function () {
    function set_form(data) {
        var $modal = $('#ajax-modal');
        $modal.find("[name=id]").val(data && data.id ? data.id : 0),
        $modal.find("[name=type]").val(data && data.type ? data.type : 0),
        $modal.find("[name=keyword]").val(data && data.keyword ? data.keyword : ''),
        $modal.find("[name=operate]").val(data && data.operate ? data.operate : 1),
        $modal.find("[name=replace]").val(data && data.replace ? data.replace : '');
    }

    function post_add() {
        var $modal = $('#ajax-modal');
        var type = $modal.find("[name=type]").val(),
            id = $modal.find("[name=id]").val(),
            keyword = $modal.find("[name=keyword]").val(),
            operate = $modal.find("[name=operate]").val(),
            replace = $modal.find("[name=replace]").val();

        if (keyword.trim().length <= 1) {
            alert('keyword is short');
            return false;
        }

        $.post('/admin/keyword/post',
            { id: id, type: type, keyword: keyword, operate: operate, replace: replace },
            function (data) {
                if (parseInt(data.status) > 0) {
                    $modal.modal('toggle');
                    $(".flexme4").flexReload();
                } else {
                    alert('failed;' + data.msg | '');
                }
            }, 'json'
        );

    }
    var $modal = $('#ajax-modal');
    $modal.on('click', '.btn-primary', function(){
        post_add();
    });

    function add(com, grid) {
        var $modal = $('#ajax-modal');

        $modal.modal();
        set_form();
    }
    function edit(com, grid) {
        var length = $('.trSelected', grid).length;
        if (length != 1) {
            alert('please select one item; no more no less');
            return false;
        }

        var id = parseInt($('.trSelected', grid)[0].firstChild.innerText);
        $('body').modalmanager('loading');
        var $modal = $('#ajax-modal');
        $.get('/admin/keyword/info', { id: id }, function (data) {
            if (parseInt(data.status) > 0) {
                $modal.modal();
                set_form(data.data);
            } else {
                alert("cann't get item");
            }
        }, 'json');
    }
    function del(com, grid) {
        var length = $('.trSelected', grid).length;
        if (length <= 0) {
            alert('no selected item');
            return false;
        }
        var conf = confirm('Delete ' + length + ' items?')
        if(conf){
            var ids = [];
            $.each($('.trSelected', grid),
            function(key, value){
                ids.push(parseInt(value.firstChild.innerText));
            });
            $.get('/admin/keyword/delete', { ids : ids.join(",") }
            , function(){
                $(".flexme4").flexReload();
            });
        }
    }
    $(".flexme4").flexigrid({
        url : '/admin/keyword/data',
        dataType : 'json',
        colModel : [ {
            display : 'id',
            name : 'id',
            width : 60,
            align : 'center'
            }, {
            display : '关键词类型',
            name : 'type',
            width : 120,
            align : 'center'
            }, {
            display : '关键词',
            name : 'keyword',
            width : 220,
            align : 'center'
            }, {
            display : '操作',
            name : 'operate',
            width : 100,
            align : 'center',
            }, {
            display : '替换内容',
            name : 'replace',
            width : 80,
            align : 'center'
            }, {
            display : '操作时间',
            name : 'time',
            width : 140,
            align : 'center'
            }, {
            display : '操作人',
            name : 'admin_user',
            width : 100,
            align : 'center'
        } ],
        buttons : [ {
            name : 'Add',
            bclass : 'add',
            onpress : add
        } , {
            name : 'Edit',
            bclass : 'edit',
            onpress : edit
        } , {
            name : 'Delete',
            bclass : 'delete',
            onpress : del
        } , {
            separator : true
        } ],
        searchitems : [ {
            display : '全部词',
            name : '0'
            },{
            display : '禁止词',
            name : '1'
            },{
            display : '审核词',
            name : '2'
            },{
            display : '过滤词',
            name : '3'
        } ],
        sortname : "id",
        sortorder : "desc",
        usepager : true,
        title : 'keywords',
        useRp : true,
        rp : 20,
        showTableToggleBtn : true,
        width : 980,
        height : 520
    });
});
</script>

<div class="row-fluid">
    <div class="span3">
        <div class="well sidebar-nav">
            <ul class="nav nav-list">
                <li class="nav-header">管理功能表</li>
                <li class="active"><a href="/admin/keyword">关键词过滤</a></li>
                <li><a href="#">**没有了**</a></li>
            </ul>
        </div><!--/.well -->
    </div><!--/span-->

    <div class="span9">
        <table class="flexme4" style="display: none"></table>
    </div><!--/span-->
</div><!--/row-->

<div id="ajax-modal" class="modal hide fade" tabindex="-1">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h3>keyword</h3>
    </div>
    <div class="modal-body">
        <div class="row-fluid">
            <div class="span9">
                <input type="hidden" name="id">
                <h5>关键词类型</h5>
                <div class="controls">
                    <select class="input-xlarge" name="type">
                        <?lua for i, v in pairs(types) do ?>
                        <option value="<?lua= i ?>"><?lua= v ?></option>
                        <?lua end ?>
                    </select>
                </div>
                <h5>关键词</h5>
                <p><input name="keyword" type="text" class="span12" /></p>
                <h5>操作</h5>
                <div class="controls">
                    <select class="input-xlarge" name="operate">
                        <?lua for i, v in pairs(operates) do ?>
                        <option value="<?lua= i ?>"><?lua= v ?></option>
                        <?lua end ?>
                    </select>
                </div>
                <h5>替换内容</h5>
                <p><input name="replace" type="text" class="span12" /></p>
            </div>
        </div>
    </div>
    <div class="modal-footer">
        <button type="button" data-dismiss="modal" class="btn">Close</button>
        <button type="button" class="btn btn-primary">Save changes</button>
    </div>
</div>
