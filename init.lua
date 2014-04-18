-- Copyright (C) Dejiang Zhu (doujiang24)


require "resty.core"

get_instance = function ()
    return ngx.ctx.dp
end
