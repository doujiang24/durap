-- Copyright (C) Dejiang Zhu (doujiang24)


local back_run  = require "system.library.timer" .run

--[[
--  we can start some background jobs like this:
--  back_run(5, "demo1", "welcome", "statistics")
--
--  this means will run function 'statistics' in contoller 'welcome' in application 'demo1' every 5 seconds
--]]
