-- Copyright

module("utils.file", package.seeall)

-- global variables
local open = io.open
local close = io.close

name = "foo"

function file_exists(filename)
    file = DURAP_HOME .. "/" .. filename
    --ngx.say(file)
    fp = open(file, "r")
    if fp then
        close(fp)
        return true
    else
        return false
    end
end
