<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title><?lua= title ?></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Charisma, a fully featured, responsive, HTML5, Bootstrap admin template.">
    <meta name="author" content="Muhammad Usman">

	<!-- The styles -->
	<link id="bs-css" href="/css/bootstrap-journal.css" rel="stylesheet">
    <style type="text/css">
        body {
            padding-bottom: 40px;
        }
        .sidebar-nav {
            padding: 9px 0;
        }
	</style>
	<link href="/css/bootstrap-responsive.css" rel="stylesheet">
	<link href="/css/charisma-app.css" rel="stylesheet">
	<link href="/css/jquery-ui-1.8.21.custom.css" rel="stylesheet">
	<link href='/css/fullcalendar.css' rel='stylesheet'>
	<link href='/css/fullcalendar.print.css' rel='stylesheet'  media='print'>
	<link href='/css/chosen.css' rel='stylesheet'>
	<link href='/css/uniform.default.css' rel='stylesheet'>
	<link href='/css/colorbox.css' rel='stylesheet'>
	<link href='/css/jquery.cleditor.css' rel='stylesheet'>
	<link href='/css/jquery.noty.css' rel='stylesheet'>
	<link href='/css/noty_theme_default.css' rel='stylesheet'>
	<link href='/css/elfinder.min.css' rel='stylesheet'>
	<link href='/css/elfinder.theme.css' rel='stylesheet'>
	<link href='/css/jquery.iphone.toggle.css' rel='stylesheet'>
	<link href='/css/opa-icons.css' rel='stylesheet'>
	<link href='/css/uploadify.css' rel='stylesheet'>

	<!-- The HTML5 shim, for IE6-8 support of HTML5 elements -->
	<!--[if lt IE 9]>
	  <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->

	<!-- The fav icon -->
	<link rel="shortcut icon" href="/img/favicon.ico">
		
</head>

<body>
    <!-- topbar starts -->
    <div class="navbar">
        <div class="navbar-inner">
            <div class="container-fluid">
                <a class="btn btn-navbar" data-toggle="collapse" data-target=".top-nav.nav-collapse,.sidebar-nav.nav-collapse">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </a>
                <a class="brand" href="/admin"> <img alt="Charisma Logo" src="/img/logo20.png" /> <span>Charisma</span></a>

                <!-- user dropdown starts -->
                <div class="btn-group pull-right" >
                    <?lua if admin_user then ?>
                    <a class="btn dropdown-toggle" data-toggle="dropdown" href="#">
                        <i class="icon-user"></i><span class="hidden-phone"><?lua= admin_user.username ?></span>
                        <span class="caret"></span>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a href="/admin/user/profile">Profile</a></li>
                        <li class="divider"></li>
                        <li><a href="/admin/user/logout">Logout</a></li>
                    </ul>
                    <?lua else ?>
                    <a class="btn" href="/admin/user/login">
                        <i class="icon-user"></i><span class="hidden-phone"> Login </span>
                    </a>
                    <?lua end ?>
                </div>
                <!-- user dropdown ends -->

            </div>
        </div>
    </div>
    <!-- topbar ends -->
    <div class="container-fluid">
        <div class="row-fluid">
        <?lua if _uri ~= "admin/user/login" then ?>
        <?lua= get_instance().loader:view('admin/left') ?>
        <?lua end ?>

        <?lua= get_instance().loader:view('admin/js') ?>

        <?lua data = getfenv() ?>
        <?lua= get_instance().loader:view(_page_, data) ?>

        </div><!--/fluid-row-->

        <hr>
        <footer>
        <p class="pull-left">&copy; <a href="http://usman.it" target="_blank">Muhammad Usman</a> 2012</p>
        <p class="pull-right">Powered by: <a href="http://usman.it/free-responsive-admin-template">Charisma</a></p>
        </footer>

    </div><!--/.fluid-container-->


</body>
</html>
