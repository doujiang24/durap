<div class="content">
    <div class="container">

        <div class="register">
            <div class="row">

                <div class="span12">
                    <div class="lrform">
                        <h5>Register for New Account</h5>
                        <?lua if msg then ?>
                        <h4><?lua= msg ?></h4>
                        <?lua end ?>
                        <div class="form">
                            <!-- Register form (not working)-->
                            <form class="form-horizontal" method="post" action="/user/register" enctype="application/x-www-form-urlencoded">
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
                                <!-- Checkbox -->
                                <div class="control-group">
                                    <div class="controls">
                                        <label class="checkbox inline">
                                            <input type="checkbox" id="inlineCheckbox1" value="agree"> Agree with Terms and Conditions
                                        </label>
                                    </div>
                                </div>

                                <!-- Buttons -->
                                <div class="form-actions">
                                    <!-- Buttons -->
                                    <button type="submit" class="btn">Register</button>
                                    <button type="reset" class="btn">Reset</button>
                                </div>
                            </form>
                            Already have an Account? <a href="/user/login">Login</a>
                        </div>
                    </div>

                </div>
            </div>
        </div>

    </div>
</div>
