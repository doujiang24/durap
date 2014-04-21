-- Copyright (C) Dejiang Zhu (doujiang24)

local urlhelper = require "system.helper.url"
local imagelib = require "system.library.image"

local get_instance = get_instance
local redirect = urlhelper.redirect
local ipairs = ipairs
local insert = table.insert
local ngx = ngx
local _show = get_instance().loader:core('controller')._show
local _require_user = get_instance().loader:core('controller')._require_user
local _template = get_instance().loader:core('controller')._template
local _pagination = get_instance().loader:core('controller')._pagination

local _M = {}

function _M.view(id)
    local dp = get_instance()
    local loader = dp.loader

    local mblog = loader:model('mblog')
    local blog = mblog:get(id)

    if blog then
        local lists = mblog:lists(10)
        mblog:close()

        local muser = loader:model('muser')
        local author = muser:get(blog.uid)
        muser:close()
        local data = { blog = blog, author = author, lists = lists }
        return _show('view', data)
    end

    mblog:close()
    redirect('blog')
end

function lists(start)
    local dp = get_instance()
    local loader = dp.loader

    local start, size = start or 0, 4
    local mblog, muser = loader:model('mblog'), loader:model('muser')
    local num = mblog:count()
    local res = mblog:lists(size, start)
    if res then
        for i, blog in ipairs(res) do
            blog.author = muser:get(blog.uid)
        end
    end

    local recents = mblog:lists(10)

    mblog:close()
    muser:close()

    local page = _pagination('blog/lists', num, size)

    local data = { lists = res, recents = recents, page = page }
    _show('lists', data)
end
_M.lists = lists

function _M.index()
    return lists()
end

function _M.publish()
    local user = _require_user()

    local dp = get_instance()
    local loader, request = dp.loader, dp.request
    local posts = request:post()

    if posts.title and posts.content then
        local mblog = loader:model('mblog')
        local id = mblog:add(posts.title, posts.content, user.uid)
        redirect('blog/view/' .. id)
    end
    _show('publish')
end

function _M.image()
    local dp = get_instance()
    local loader, request = dp.loader, dp.request
    request:set_save_files(dp.APPPATH .. "static/images/")
    local inputs = request:input()

    local filename, err
    if inputs.upload and inputs.upload.savename then
        local base_dir = dp.APPPATH .. "static/images/"
        local savename = inputs.upload.savename
        filename = "/images/thumb_" .. savename
        local thumbname = dp.APPPATH .. "static" .. filename

        if imagelib.thumb(base_dir .. savename, thumbname, 600, 500) then
            imagelib.text_watermark(thumbname, 'free blog')
        else
            filename, err = nil, 'upload error'
        end
    end

    local data = { CKEditorFuncNum = inputs.CKEditorFuncNum, filename = filename, err = err }
    _template('image', data)
end

return _M
