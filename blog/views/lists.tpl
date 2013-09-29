<div class="container">

</div> <!-- /container -->

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
                                <?lua for i, blog in ipairs(lists) do ?>
                                <div class="entry">
                                    <h2><a href="/blog/view/<?lua= blog.id ?>"><?lua= blog.title ?></a></h2>

                                    <!-- Meta details -->
                                    <div class="meta">
                                        <i class="icon-calendar"></i> <?lua= blog.time ?>
                                        <span class="pull-right">
                                            <i class="icon-user"></i> <?lua= blog.author.username ?>
                                        </span>
                                    </div>

                                    <div>
                                        <?lua= blog.content ?>
                                    </div>

                                    <div class="button"><a href="/blog/view/<?lua= blog.id ?>">Read More...</a></div>
                                    <div class="clearfix"></div>
                                </div>
                                <?lua end ?>

                                <!-- Pagination -->
                                <?lua= page ?>

                                <div class="clearfix"></div>

                            </div>
                        </div>
                        <div class="span4">
                            <div class="sidebar">
                                <div class="widget">
                                    <h4>Recent Posts</h4>
                                    <ul>
                                        <?lua for i, v in ipairs(recents) do ?>
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

    </div>
</div>
