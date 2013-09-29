<div class="content">
    <div class="container">

        <div class="row make-post">

            <div class="">
                <form method="post" action="/blog/publish" enctype="multipart/form-data" id="publish-form">
                <div class="well">
                    <h6>Title</h6>
                    <hr />
                    <input name="title" type="text" class="span7" placeholder="Enter Title">
                    <br />
                    <hr />

                    <h6>Content</h6>
                    <textarea name="content" id="editor" class="span7"></textarea>
                    <hr />

                    <button class="offset4 btn btn-primary">Publish</button>
                </div>
                </form>
            </div>

        </div>

    </div>
</div>

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
