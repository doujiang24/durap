<div class="container">
    <div class="box span9 offset1">
        <div class="box-header" data-original-title>
            <h2> Blog Publish</h2>
        </div>
        <form class="box-content" method="post" action="/blog/publish" enctype="multipart/form-data" id="publish-form">
            <fieldset>
                <input name="title" class="span8" type="text" placeholder="Blog Title">
                <textarea name="content" id="editor">default value</textarea>
                <button name="submit" type="submit" class="btn">Submit</button>
            </fieldset>
        </form>
    </div>

</div> <!-- /container -->

<script>
$( document ).ready( function() {
    $( 'textarea#editor' ).ckeditor();
    $("#publish-form").find("input[name=title]").focus();
    $("#publish-form").on("submit", function () {
        if ($("#publish-form").find("input[name=title]").val().length <= 5) {
            alert('title too short');
            return false;
        };
    });
} );
</script>
<script src="/ckeditor/ckeditor.js"></script>
<script src="/ckeditor/adapters/jquery.js"></script>
