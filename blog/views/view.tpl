<div class="content">
    <div class="container">
        <!-- Blog starts -->

        <div class="blog">
            <div class="row">
                <div class="span12">

                    <!-- Blog Posts -->
                    <div class="row">
                        <div class="span8">
                            <div class="posts">

                                <!-- Each posts should be enclosed inside "entry" class" -->
                                <!-- Post one -->
                                <div class="entry">
                                    <h2><?lua= blog.title ?></h2>

                                    <!-- Meta details -->
                                    <div class="meta">
                                        <i class="icon-calendar"></i> <?lua= blog.time ?>
                                        <span class="pull-right">
                                            <i class="icon-user"></i> <?lua= author.username ?>
                                        </span>
                                    </div>

                                    <!-- Thumbnail -->
                                    <div>
                                        <?lua= blog.content ?>
                                    </div>
                                </div>

                                <div class="post-foot well">
                                    <!-- Social media icons -->
                                    <div class="social">
                                        <h6>Sharing is Sexy: </h6>
                                        <a href="#"><i class="icon-facebook facebook"></i></a>
                                        <a href="#"><i class="icon-twitter twitter"></i></a>
                                        <a href="#"><i class="icon-linkedin linkedin"></i></a>
                                        <a href="#"><i class="icon-pinterest pinterest"></i></a>
                                        <a href="#"><i class="icon-google-plus google-plus"></i></a>
                                    </div>
                                </div>

                                <hr />

                                <!-- Navigation -->

                                <div class="navigation button">
                                    <div class="pull-left"><a href="/blog/view/<?lua= blog.id-1 ?>">&laquo; Previous Post</a></div>
                                    <div class="pull-right"><a href="/blog/view/<?lua= blog.id+1 ?>">Next Post &raquo;</a></div>
                                    <div class="clearfix"></div>
                                </div>

                                <div class="clearfix"></div>

                            </div>
                        </div>
                        <div class="span4">
                            <div class="sidebar">
                                <!-- Widget -->
                                <div class="widget">
                                    <h4>Recent Posts</h4>
                                    <ul>
                                        <?lua for i, v in ipairs(lists) do ?>
                                        <li><a href="/blog/view/<?lua= v.id?>"><?lua= v.title ?></a></li>
                                        <?lua end ?>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <hr />

    </div>
</div>
