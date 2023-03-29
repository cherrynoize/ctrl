--[[
  ____ _        _
 / ___| |_ _ __| |
| |   | __| '__| | - Simple awesome wm widget library
| |___| |_| |  | | - https://github.com/cherrynoize/ctrl
 \____|\__|_|  |_| - cherry-noize
]]--

-- Ctrl init file

-- Path where Ctrl is installed
ctrl_path = "ctrl"

local ctrl = {
   -- Modules to export 
   battctl   = require(ctrl_path..".battctl"),
   soundctl  = require(ctrl_path..".soundctl"),
   lightctl  = require(ctrl_path..".lightctl"),
   winctl    = require(ctrl_path..".winctl"),
   tray      = require(ctrl_path..".tray"),
   spacer    = require(ctrl_path..".spacer"),
   container = require(ctrl_path..".container"),
   -- Intended for internal usage
   utils  = require(ctrl_path..".utils"),
   ui     = require(ctrl_path..".ui"),
   config = require(ctrl_path..".config"),
}

return ctrl
