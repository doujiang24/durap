-- Copyright (C) 2013 MaMa

local urlhelper = require "helper.url"
local filehelper = require "helper.file"

local get_instance = get_instance
local setmetatable = setmetatable
local error = error
local redirect = urlhelper.redirect
local ipairs = ipairs
local insert = table.insert
local ngx = ngx
local ftmpname = filehelper.tmpname
local move = filehelper.move

local _M = getfenv()

function index()
    return lists()
end

function view(id)
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

function publish()
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

function image()
    local dp = get_instance()
    local loader, request = dp.loader, dp.request
    local inputs = request:input()

    local filename, err
    if inputs.upload and inputs.upload.filename then
        filename = "/images/" .. ftmpname(inputs.upload.filename)
        if not move(inputs.upload.tmpname, request.apppath .. "static" .. filename) then
            filename, err = nil, 'upload error'
        end
    end

    local data = { CKEditorFuncNum = inputs.CKEditorFuncNum, filename = filename, err = err }
    _template('image', data)
end

local class_mt = {
    __index = get_instance().loader:core('controller'),
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

