<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title><?lua= title ?></title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!-- Le styles -->
        <link href="/css/bootstrap.css" rel="stylesheet">
        <link href="/css/bootstrap-responsive.css" rel="stylesheet">
        <link href="/css/style.css" rel="stylesheet">
        <link href="/css/prettify.css" rel="stylesheet" />
        <link href="/css/bootstrap-modal.css" rel="stylesheet" />

        <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
        <!--[if lt IE 9]>
        <script src="//cdnjs.bootcss.com/ajax/libs/html5shiv/3.6.2/html5shiv.js"></script>
        <![endif]-->

        <script src="/js/jquery.js"></script>
        <script src="/js/bootstrap.js"></script>
        <script src="/js/flexigrid.js"></script>
        <script src="/js/prettify.js"></script>
        <script src="/js/bootstrap-modalmanager.js"></script>
        <script src="/js/bootstrap-modal.js"></script>
    </head>

    <body>

        <div class="navbar navbar-inverse navbar-fixed-top">
            <div class="navbar-inner">
                <div class="container-fluid">
                    <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="brand" href="/"> FREE BLOG </a>
                    <div class="nav-collapse collapse">
                        <p class="navbar-text pull-right">
                        <?lua if current_user then ?>
                        Welcome <?lua= current_user.username ?> !
                        <a href="/user/logout" class="navbar-link">Logout</a>
                        <?lua else ?>
                        <a href="/user/login" class="navbar-link">Login</a>
                        <?lua end ?>
                        </p>
                        <ul class="nav">
                            <li class="active"><a href="/">Home</a></li>
                            <li><a href="/blog/publish">Publish</a></li>
                        </ul>
                    </div><!--/.nav-collapse -->
                </div>
            </div>
        </div>

        <div class="container-fluid">
        <?lua data = getfenv() ?>
        <?lua= get_instance().loader:view(_page_, data) ?>

            <hr>
            <footer>
                <p>&copy; Company 2013</p>
            </footer>
        </div><!--/.fluid-container-->

    </body>
</html>
