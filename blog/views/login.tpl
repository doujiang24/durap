<div class="container">

</div> <!-- /container -->

<div class="content">
    <div class="container">

        <div class="register">
            <div class="row">

                <div class="span12">
                    <div class="lrform">
                        <h5>Login to your Account</h5>
                        <?lua if msg then ?>
                        <h4><?lua= msg ?></h4>
                        <?lua end ?>
                        <div class="form">
                            <!-- Login form (not working)-->
                            <form class="form-horizontal" method="post" action="/user/login" enctype="multipart/form-data">
                                <!-- Username -->
                                <div class="control-group">
                                    <label class="control-label" for="username">Username</label>
                                    <div class="controls">
                                        <input name="username" type="text" class="input-large" id="username" placeholder="Username">
                                    </div>
                                </div>
                                <!-- Password -->
                                <div class="control-group">
                                    <label class="control-label" for="email">Password</label>
                                    <div class="controls">
                                        <input name="password" type="password" class="input-large" id="password" placeholder="Password">
                                    </div>
                                </div>
                                <!-- Buttons -->
                                <div class="form-actions">
                                    <!-- Buttons -->
                                    <button type="submit" class="btn">Login</button>
                                    <button type="reset" class="btn">Reset</button>
                                </div>
                            </form>
                            Don't have Account? <a href="/user/register">Register</a>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>
