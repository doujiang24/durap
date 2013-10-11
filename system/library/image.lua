-- Copyright (C) 2013 doujiang24 @ MaMa, Inc.

local gd = require "gd"
local corehelper = require "helper.core"

local get_instance = get_instance
local pairs = pairs
local math_min = math.min
local math_max = math.max
local math_floor = math.floor
local strlen = string.len
local log_error = corehelper.log_error


local _M = { _VERSION = '0.01' }


local def_ptsize = 20
local largest_scale = 0.8
local func_typs = {
    createFromPng = 'png',
    createFromJpeg = 'jpeg',
    createFromGif = 'gif'
}

local function _loadimg(filename)
    for func, typ in pairs(func_typs) do
        local im = gd[func](filename)
        if im then
            return im, typ
        end
    end
    return nil, 'not supported image type'
end

local function _save(gdImg, typ, filename)
    local ok, err = gdImg[typ](gdImg, filename, 100)
    if not ok then
        log_error("failed to save image:", filename, "; maybe permission denied to overwrite")
    end
end

function _M.text_watermark(source, text, position)
    local position = position or "rightBottom"

    local srcImg, srcTyp = _loadimg(source)
    local srcW, srcH = srcImg:sizeXY()

    local color = srcImg:colorAllocate(0, 0, 0)
    local angle = 0
    local len = strlen(text)
    local ptsize = srcH > def_ptsize * 2 and def_ptsize or math_floor(srcH / 2)

    local x, y = 0, ptsize -- leftTop
    if position == "center" then
        x = math_floor( (srcW - ptsize * len) / 2 )
        y = math_floor( (srcH - ptsize) / 2 )
    elseif position == "rightBottom" then
        x = srcW - ptsize * len
        y = srcH - ptsize
    end

    gd.useFontConfig(true)
    srcImg:stringFT(color, "Comic Sans MS", ptsize, angle, x, y, text)

    --_save(srcImg, srcTyp, source)

    return srcImg
end

-- position: leftTop, center, rightBottom
function _M.watermark(source, logo, position)
    local position = position or "rightBottom"

    local srcImg, srcTyp = _loadimg(source)
    local logImg = _loadimg(logo)

    local srcW, srcH = srcImg:sizeXY()
    local logW, logH = logImg:sizeXY()

    local dstW, dstH = logW, logH
    local scale = math_min( logW / srcW, logH / srcH )
    if scale > largest_scale then
        dstW = math_floor(logW * largest_scale / scale)
        dstH = math_floor(logH * largest_scale / scale)
    end

    local dstX, dstY = 0, 0 -- leftTop
    if position == "center" then
        dstX = math_floor( (srcW - dstW) / 2 )
        dstY = math_floor( (srcH - dstH) / 2 )
    elseif position == "rightBottom" then
        dstX = srcW - dstW
        dstY = srcH - dstH
    end

    srcImg:copyResized(logImg, dstX, dstY, 0, 0, dstW, dstH, logW, logH)
    _save(srcImg, srcTyp, source)

    return srcImg
end

local function _calc()
    local dstW, dstH = srcW, srcH

    if width < srcW or height < srcH then
    end

    local srcScale = math_min( logW / srcW, logH / srcH )
    if scale > largest_scale then
        dstW = math_floor(logW * largest_scale / scale)
        dstH = math_floor(logH * largest_scale / scale)
    end

    local dstX, dstY = 0, 0 -- leftTop
    if position == "center" then
        dstX = math_floor( (srcW - dstW) / 2 )
        dstY = math_floor( (srcH - dstH) / 2 )
    elseif position == "rightBottom" then
        dstX = srcW - dstW
        dstY = srcH - dstH
    end
end

-- width means max width; height means max height
-- keep the full picture
function _M.thumb(source, destination, width, height)
    local position = position or "rightBottom"

    local srcImg, srcTyp = _loadimg(source)

    local srcW, srcH = srcImg:sizeXY()

    local dstW, dstH = srcW, srcH
    if width < srcW or height < srcH then
        local scale = math_max( srcW / width, srcH / height )
        dstW = srcW / scale
        dstH = srcH / scale
    end

    local img = gd.createPalette(dstW, dstH)
    img:copyResized(srcImg, 0, 0, 0, 0, dstW, dstH, srcW, srcH)

    _save(img, srcTyp, destination)
    return img
end

return _M
