-- Copyright (C) Dejiang Zhu (doujiang24)

local _show = get_instance().loader:core('controller')._show

local _M = {}

function _M.index()
    _show('index')
end

function _M.about()
    _show('about')
end


return _M
