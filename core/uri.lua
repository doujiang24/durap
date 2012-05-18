-- Copyright

module("core.uri", package.seeall)

local strfind = string.find
local strgmatch = string.gmatch
local strsub = string.sub
local insert = table.insert
local concat = table.concat

local url_string = ngx.var.REQUEST_URI
local segments = {}


local function _fetch_url_string()
    local start= strfind(url_string, "?")
    local url = ( start and strsub(url_string, 0, start - 1) ) or url_string
    for v in string.gmatch(url, "/([^/]+)") do
        insert(segments, v)
    end
end

function get_module()
    _fetch_url_string()
    return concat(segments, ".")
end
