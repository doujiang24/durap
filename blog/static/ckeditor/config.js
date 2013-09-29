/**
 * @license Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.html or http://ckeditor.com/license
 */
CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
    config.contentsCss = ['/style/bootstrap.css', '/style/bootstrap-responsive.css', '/style/style.css'];
    config.font_names = 'Arial/Arial, Helvetica, sans-serif;Courier New/Courier New, Courier, monospace;Times New Roman/Times New Roman, Times, serif;Verdana/Verdana, Geneva, sans-serif;微软雅黑, 宋体, 黑体';
    config.height = "400px";
    config.fontSize_defaultLabel = '14px';
    config.fontSize_sizes ='12/12px;14/14px;16/16px;24/24px;';

    config.filebrowserUploadUrl = '/blog/image';

    config.toolbar = 'blog';
    config.toolbar_blog = [
        ['Source','-','NewPage'],
        ['Copy','Paste','PasteText','PasteFromWord'],
        ['Undo','Redo','-','SelectAll','RemoveFormat'],
        ['Styles','Format','Font','FontSize'],
        ['TextColor','BGColor'],
        '/',
        ['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
        ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
        ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
        ['Link','Unlink','Anchor'],
        ['Image','Flash','Table','HorizontalRule','Smiley']
    ];
};
