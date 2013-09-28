<div class="container">
<?lua for i, blog in ipairs(lists) do ?>
    <div class="box span9 offset1">
        <div class="box-header" data-original-title>
            <h2> <a href="/blog/view/<?lua= blog.id ?>"><?lua= blog.title ?></a></h2>
        </div>
        <div class="box-content">
        <?lua= blog.content ?>
        </div>
    </div>
<?lua end ?>

</div> <!-- /container -->
