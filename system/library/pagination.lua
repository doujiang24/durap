-- Copyright (C) 2013 doujiang24 @ MaMa, Inc.

local tablhelper = require "helper.table"
local urlhelper = require "helper.url"

local get_instance = get_instance

local tmerge = tablhelper.merge
local tslice = tablhelper.slice
local tonumber = tonumber
local setmetatable = setmetatable
local error = error
local insert = table.insert
local concat = table.concat
local ceil = math.ceil
local site_url = urlhelper.site_url

module(...)

local mt = { __index = _M }

local default_conf = {
    base_url = '',
    suffix = '',
    total_rows = 0,
    per_page = 10,
    num_links = 2,
    cur_page = 1,
    next_link = 'Next',
    prev_link = 'Prev',
    uri_segment = 3,
    full_tag_open = '<div class="paging">',
    full_tag_close = '</div>',
    skip_tags = '<span class="dots">&hellip;</span>',
    cur_tag_open = '<span class="current">',
    cur_tag_close = '</span>'
}

local function _cur_page(conf)
    local segments = get_instance().router:get_segments()
    local uri_segment = conf.uri_segment
    if #segments >= uri_segment and
        concat(tslice(segments, 1, uri_segment - 1), "/") == conf.base_url then

        local page = ceil((tonumber(segments[uri_segment]) or 1) / conf.per_page) + 1
        return page <= conf.page and page or conf.page
    end
    return 1
end

function _anchor(conf, page, title)
    local offset = (page - 1) * conf.per_page
    return '<a href="' .. site_url(conf.base_url) .. "/" .. (offset > 0 and offset or '') .. conf.suffix .. '">' .. title .. "</a>"
end

function _links(conf)
    local ret = {}
    if conf.page <= 1 then
        return ''
    end

    insert(ret, conf.full_tag_open)

    get_instance().debug:json(conf)
    if conf.cur_page > 1 then
        insert(ret, _anchor(conf, conf.cur_page - 1, conf.prev_link))
        insert(ret, _anchor(conf, 1, '1'))
    else
        insert(ret, conf.cur_tag_open .. 1 .. conf.cur_tag_close)
    end

    if conf.cur_page > conf.num_links + 2 then
        insert(ret, conf.skip_tags)
        for i = conf.cur_page - conf.num_links, conf.cur_page - 1 do
            insert(ret, _anchor(conf, i, i))
        end
    else
        for i = 2, conf.cur_page - 1 do
            insert(ret, _anchor(conf, i, i))
        end
    end

    if conf.cur_page > 1 then
        insert(ret, conf.cur_tag_open .. conf.cur_page .. conf.cur_tag_close)
    end

    if conf.cur_page + conf.num_links + 1 < conf.page then
        for i = conf.cur_page + 1, conf.cur_page + conf.num_links do
            insert(ret, _anchor(conf, i, i))
        end
        insert(ret, conf.skip_tags)
        insert(ret, _anchor(conf, conf.page, conf.page))
    else
        for i = conf.cur_page + 1, conf.page do
            insert(ret, _anchor(conf, i, i))
        end
    end

    if conf.cur_page < conf.page then
        insert(ret, _anchor(conf, conf.cur_page + 1, conf.next_link))
    end

    insert(ret, conf.full_tag_close)

    return concat(ret, '')
end

function create_links(conf)
    local conf = conf and tmerge(default_conf, conf) or default_conf
    conf.page = ceil(conf.total_rows / conf.per_page)
    conf.cur_page = _cur_page(conf)

    return _links(conf)
end


local class_mt = {
    __index = get_instance().loader:core('controller'),
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

