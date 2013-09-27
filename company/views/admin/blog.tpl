<link rel="stylesheet" type="text/css" href="/css/flexigrid.css" />

<div id="content" class="span10">
    <!-- content starts -->
    <div>
        <ul class="breadcrumb">
            <li>
            <a href="/admin">Home</a> <span class="divider">/</span>
            </li>
            <li>
            <a href="/admin/blog"> Blog </a>
            </li>
        </ul>
    </div>
    <div class="row-fluid sortable">		
        <table class="flexme4">
        </table>
    </div>
    <!-- content ends -->
</div><!--/#content.span10-->

<script>
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

        $.post('/admin/blog/post',
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
        $.get('/admin/blog/info', { id: id }, function (data) {
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
            $.get('/admin/blog/delete', { ids : ids.join(",") }
            , function(){
                $(".flexme4").flexReload();
            });
        }
    }
    $(".flexme4").flexigrid({
        url : '/admin/blog/data',
        dataType : 'json',
        colModel : [ {
            display : 'id',
            name : 'id',
            width : 60,
            align : 'center'
            }, {
            display : 'title',
            name : 'title',
            width : 120,
            align : 'left'
            }, {
            display : 'view num',
            name : 'view',
            width : 80,
            align : 'center'
            }, {
            display : 'time',
            name : 'time',
            width : 140,
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
            display : 'title',
            name : '0'
        } ],
        sortname : "id",
        sortorder : "desc",
        usepager : true,
        title : 'Blog List',
        useRp : true,
        rp : 20,
        showTableToggleBtn : true,
        width : 1024,
        height : 520
    });
});
</script>
