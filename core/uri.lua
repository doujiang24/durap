-- Copyright

module("core.uri", package.seeall)

-- global variables
local strfind = string.find
local strgmatch = string.gmatch
local strsub = string.sub
local insert = table.insert
local concat = table.concat
--local file_exists = utils.file.file_exists

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
    local mod = concat(segments, ".")
    if file_exists(mod .. ".lua") then
        return mod
    else
        return "notfound"
    end
end
