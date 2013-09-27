<div id="content" class="span10">
    <!-- content starts -->
    <div>
        <ul class="breadcrumb">
            <li>
            <a href="/admin">Home</a> <span class="divider">/</span>
            </li>
            <li>
            <a href="/admin/user/profile"> Profile </a>
            </li>
        </ul>
    </div>
    <div class="row-fluid sortable">
        <div class="box span12">
            <div class="box-header well" data-original-title>
                <h2><i class="icon-edit"></i> User Profile </h2>
            </div>
            <div class="box-content">
                <form class="form-horizontal">
                    <fieldset>
                        <div class="control-group">
                            <label class="control-label" for="prependedInput"> Username </label>
                            <div class="controls">
                                <label class="radio">
                                    <?lua= admin_user.username ?>
                                </label>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="appendedInput"> Password </label>
                            <div class="controls">
                                <label class="radio">
                                    ******
                                </label>
								<button class="btn btn-info btn-setting"  data-toggle="modal" data-target="#modal"> Change </button>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="appendedInput"> Add Time </label>
                            <div class="controls">
                                <label class="radio">
                                    <?lua= admin_user.time ?>
                                </label>
                            </div>
                        </div>
                    </fieldset>
                </form>
            </div>
        </div><!--/span-->

    </div><!--/row-->

    <!-- content ends -->
</div><!--/#content.span10-->

<div class="modal hide fade" id="modal">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">×</button>
        <h3> Change Password </h3>
    </div>
    <div class="modal-body">
        <div class="row-fluid">
            <div class="span9">
                <h5>Old Password</h5>
                <p><input name="password" type="password" class="span12" /></p>
                <h5>New Password</h5>
                <p><input name="newpassword" type="password" class="span12" /></p>
            </div>
        </div>
    </div>
    <div class="modal-footer">
        <a href="#" class="btn" data-dismiss="modal">Close</a>
        <a href="#" class="btn btn-primary">Save changes</a>
    </div>
</div>

<script>
$(document).ready(function () {
    var $modal = $('#modal');
    function post() {
        var password = $modal.find("[name=password]").val(),
            newpassword = $modal.find("[name=newpassword]").val();

        if (newpassword.length <= 3) {
            alert('new password is short');
            return false;
        }

        $.post('/admin/user/password',
            { password : password, newpassword : newpassword },
            function (data) {
                console.log(data)
                tmpvar = data
                if (parseInt(data.status) > 0) {
                    $modal.modal('toggle');
                    alert('change success');
                } else {
                    alert('failed;' + data.errmsg || '');
                }
            }, 'json'
        );

    }
    $modal.on('click', '.btn-primary', function(){
        post();
    });
});
</script>
