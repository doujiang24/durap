-- Copyright (C) 2013 MaMa
-- Copyright (c) 2013 CloudFlare, Inc.

local utf8 = require "helper.utf8"
local utf8_len = utf8.len
local utf8_sub = utf8.sub
local utf8_iter = utf8.iter
local remove = table.remove
local insert = table.insert
local pairs = pairs
local setmetatable = setmetatable
local error = error

module(...)

local root = ""

-- make: creates a new entry in t for the given string c with
-- optional fail state
local function make(t, c, f)
    t[c]      = {}
    t[c].to   = {}
    t[c].fail = f
    t[c].hit  = root
    t[c].word = false
end

-- build: builds the Aho-Corasick data structure from an array of
-- strings
function build(m)
    local t = {}
    make(t, root, root)

    for i = 1, #m do
        local current = root

        for j = 1, utf8_len(m[i]) do
            local c = utf8_sub(m[i], j, j)
            local path = current .. c

            if t[current].to[c] == nil then
                t[current].to[c] = path

                if current == root then
                    make(t, path, root)
                else
                    make(t, path)
                end
            end

            current = path
        end

        t[m[i]].word = true
    end

    -- Build the fails which show how to backtrack when a fail matches
    -- and build the hits which connect nodes to suffixes that are
    -- words

    local q = { root }

    while #q > 0 do
        local path = remove(q, 1)

        for c, p in pairs(t[path].to) do
            insert(q, p)

            local fail = utf8_sub(p, 2)
            while fail ~= root and t[fail] == nil do
                fail = utf8_sub(fail, 2)
            end
            if fail == root then fail = root end
            t[p].fail = fail

            local hit = utf8_sub(p, 2)
            while hit ~= "" and (t[hit] == nil or not t[hit].word) do
                hit = utf8_sub(hit, 2)
            end
            if hit == root then hit = root end
            t[p].hit = hit
        end
    end

    return t
end

-- match: checks to see if the passed in string matches the passed
-- in tree created with build. If all is true (the default) an
-- array of all matches is returned. If all is false then only the
-- first match is returned.
-- disturb is the disturn char set, that will be skip in the match
function match(t, str, disturb, all)
    disturb = disturb or {}
    all = (all == nil) and true or all

    local path = root
    local hits = {}

    for c in utf8_iter(str) do
        if not disturb[c] then
            while t[path].to[c] == nil and path ~= root do
                path = t[path].fail
            end

            local n = t[path].to[c]

            if n ~= nil then
                path = n

                if t[n].word then
                    insert(hits, n)
                end

                while t[n].hit ~= root do
                    n = t[n].hit
                    insert(hits, n)
                end

                if all == false and next(hits) ~= nil then
                    return hits
                end
            end
        end
    end

    return hits
end

-- match: checks to see if the passed in string matches the passed
-- in tree created with build. If all is true (the default) an
-- array of all matches is returned. If all is false then only the
-- first match is returned.
-- disturb is the disturn char set, that will be skip in the match
-- skip is the num that will skip in two matched char
function smatch(t, str, disturb, skip)
    disturb = disturb or {}
    skip = skip or 0

    if skip == 0 then
        return match(t, str, disturb)
    end

    local ret = {}
    local pathtbl = { [root] = 0 }

    local i = 1
    for c in utf8_iter(str) do
        if not disturb[c] then
            local newpathtbl = {}

            for path, level in pairs(pathtbl) do

                if path ~= root and level+1 <= skip then
                    newpathtbl[path] = level + 1
                end

                if level == 0 then
                    -- not match
                    while t[path].to[c] == nil and path ~= root do
                        path = t[path].fail
                        if path ~= root then
                            newpathtbl[path] = 1
                        end
                    end
                end

                local n = t[path].to[c]

                if n ~= nil then
                    newpathtbl[n] = 0

                    if t[n].word then
                        insert(ret, n)
                    end

                    while t[n].hit ~= root do
                        n = t[n].hit
                        insert(ret, n)
                    end
                else
                    newpathtbl[root] = 0
                end
            end

            pathtbl = newpathtbl
        end
    end

    return ret
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

