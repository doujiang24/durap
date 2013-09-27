<div class="container">
    <form class="form-signin" method="post" action="/user/login" enctype="multipart/form-data">
        <h2 class="form-signin-heading">Please sign in</h2>
        <?lua if msg then ?>
        <h4><?lua= msg ?></h4>
        <?lua end ?>
        <input name="username" type="text" class="input-block-level" placeholder="Username">
        <input name="password" type="password" class="input-block-level" placeholder="Password">
        <button class="btn btn-large btn-primary" type="submit">Sign in</button>
    </form>

</div> <!-- /container -->
