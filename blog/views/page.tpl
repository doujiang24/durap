<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="utf-8">
        <title><?lua= title ?></title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="">
        <meta name="keywords" content="">
        <meta name="author" content="">


        <!-- Stylesheets -->
        <link href="/style/bootstrap.css" rel="stylesheet">
        <link rel="stylesheet" href="/style/font-awesome.css">
        <link href="/style/prettyPhoto.css" rel="stylesheet">
        <!-- Parallax slider -->
        <link rel="stylesheet" href="/style/slider.css">
        <!-- Flexslider -->
        <link rel="stylesheet" href="/style/flexslider.css">

        <link href="/style/style.css" rel="stylesheet">

        <!-- Colors - Orange, Purple, Light Blue (lblue), Red, Green and Blue -->
        <link href="/style/green.css" rel="stylesheet">

        <link href="/style/bootstrap-responsive.css" rel="stylesheet">

        <!-- HTML5 Support for IE -->
        <!--[if lt IE 9]>
        <script src="/js/html5shim.js"></script>
        <![endif]-->

        <!-- Favicon -->
        <link rel="shortcut icon" href="/img/favicon/favicon.png">
    </head>

    <body>

        <!-- Header Starts -->
        <header>
        <div class="container">
            <div class="row">
                <div class="span6">
                    <div class="logo">
                        <h1><a href="/">Free <span class="color">Blog</span></a></h1>
                        <div class="hmeta">Just a demo power by durap</div>
                    </div>
                </div>
                <div class="span4 offset2">
                    <div class="user">
                        <?lua if current_user then ?>
                        <h3> Welcome <?lua= current_user.username ?> !  </h3>
                        <h3> <a href="/user/logout">Logout</a> </h3>
                        <?lua else ?>
                        <h3>
                            <a href="/user/login">Login</a>
                            <a class="offset1" href="/user/register">Register</a>
                        </h3>
                        <?lua end ?>
                    </div>
                    </div>
                </div>
            </div>
        </div>
        </header>

        <!-- Navigation bar starts -->
        <div class="navbar">
            <div class="navbar-inner">
                <div class="container">
                    <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                        <span>Menu</span>
                    </a>
                    <div class="nav-collapse collapse">
                        <ul class="nav">
                            <li><a href="/">Home </a></li>
                            <li><a href="/blog">Blog </a></li>
                            <li><a href="/blog/publish">Publish</a></li>
                            <li><a href="/home/about">About</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Navigation bar ends -->

        <script src="/js/jquery.js"></script>

        <?lua data = getfenv() ?>
        <?lua= get_instance().loader:view(_page_, data) ?>

        <!-- Social -->

        <div class="social-links">
            <div class="container">
                <div class="row">
                    <div class="span12">
                        <p class="big"><span>Follow Us On</span> <a href="#"><i class="icon-facebook"></i>Facebook</a> <a href="#"><i class="icon-twitter"></i>Twitter</a> <a href="#"><i class="icon-google-plus"></i>Google Plus</a> <a href="#"><i class="icon-linkedin"></i>LinkedIn</a></p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <footer>
        <div class="container">
            <div class="row">

                <div class="widgets">
                    <div class="span4">
                        <div class="fwidget">

                            <div class="col-l">
                                <h6>Downlaods</h6>
                                <ul>
                                    <li><a href="#">Condimentum</a></li>
                                    <li><a href="#">Etiam at</a></li>
                                    <li><a href="#">Fusce vel</a></li>
                                    <li><a href="#">Vivamus</a></li>
                                    <li><a href="#">Pellentesque</a></li>
                                </ul>
                            </div>

                            <div class="col-r">
                                <h6>Support</h6>
                                <ul>
                                    <li><a href="#">Condimentum</a></li>
                                    <li><a href="#">Etiam at</a></li>
                                    <li><a href="#">Fusce vel</a></li>
                                    <li><a href="#">Vivamus</a></li>
                                    <li><a href="#">Pellentesque</a></li>
                                </ul>
                            </div>

                        </div>
                    </div>

                    <div class="span4">
                        <div class="fwidget">
                            <h6>Categories</h6>
                            <ul>
                                <li><a href="#">Condimentum - Condimentum gravida</a></li>
                                <li><a href="#">Etiam at - Condimentum gravida</a></li>
                                <li><a href="#">Fusce vel - Condimentum gravida</a></li>
                                <li><a href="#">Vivamus - Condimentum gravida</a></li>
                                <li><a href="#">Pellentesque - Condimentum gravida</a></li>
                            </ul>
                        </div>
                    </div>

                    <div class="span4">
                        <div class="fwidget">
                            <h6>Recent Posts</h6>
                            <ul>
                                <li><a href="#">Sed eu leo orci, condimentum gravida metus</a></li>
                                <li><a href="#">Etiam at nulla ipsum, in rhoncus purus</a></li>
                                <li><a href="#">Fusce vel magna faucibus felis dapibus facilisis</a></li>
                                <li><a href="#">Vivamus scelerisque dui in massa</a></li>
                                <li><a href="#">Pellentesque eget adipiscing dui semper</a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="span12">
                    <div class="copy">
                        <h6>Free <span class="color">Blog</span></h6>
                        <p>Copyright &copy; <a href="/">durap</a> - <a href="/">Home</a> | <a href="/about">About</a></p>
                    </div>
                </div>
            </div>
            <div class="clearfix"></div>
        </div>
        </footer>

        <!-- JS -->
        <script src="/js/bootstrap.js"></script>
        <script src="/js/jquery.isotope.js"></script> <!-- Isotope for gallery -->
        <script src="/js/jquery.prettyPhoto.js"></script> <!-- prettyPhoto for images -->
        <script src="/js/jquery.cslider.js"></script> <!-- Parallax slider -->
        <script src="/js/modernizr.custom.28468.js"></script>
        <script src="/js/filter.js"></script> <!-- Filter for support page -->
        <script src="/js/cycle.js"></script> <!-- Cycle slider -->
        <script src="/js/jquery.flexslider-min.js"></script> <!-- Flex slider -->

        <script src="/js/easing.js"></script> <!-- Easing -->
        <script src="/js/custom.js"></script>
    </body>
</html>
