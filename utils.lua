--[[
 _   _ _   _ _
| | | | |_(_) |___  -- Ctrl-utils
| | | | __| | / __| -- Tools library for Ctrl.
| |_| | |_| | \__ \ -- https://github.com/cherrynoize/ctrl
 \___/ \__|_|_|___/ -- cherry-noize
]]--

-- Module imports.
local naughty = require("naughty")

-- Utils.
local utils = {}

-- Re-implementation of the unpack function.
function utils.unpack(t, i)
   if not t then return nil end
   if #t <= 1 then return t[1] end
   i = i or 1
   if t[i] ~= nil then
      return t[i], unpack(t, i + 1)
   end
end

-- Returns true if file exists.
function utils.file_exists(file)
   local f=io.open(file,"r")
   if f~=nil then io.close(f) return true else return false end
end

-- Recursively return the first file found in the arguments.
function utils.anyfile(file, ...)
   -- Stop if file is nil.
   if not file then return nil end
   -- If file doesn't exist
   if not utils.file_exists(file) then
      -- Try the next one.
      return utils.anyfile(...)
   end
   -- Return file if it exists.
   return file
end

-- Implementation of a scandir function.
function utils.scandir(directory)
   local i, t, popen = 0, {}, io.popen
   local pfile = popen('ls -a "'..directory..'"')
   for filename in pfile:lines() do
      i = i + 1
      t[i] = filename
   end
   pfile:close()
   return t
end

-- Read file contents.
function utils.read(path)
   local file = io.open(path, "rb") -- r read mode and b binary mode
   if not file then return nil end
   local content = file:read "*a" -- *a or *all reads the whole file
   file:close()
   return content
end

-- Write over file.
function utils.write(path, text)
   local file = io.open(path, "w")
   if file then
      io.output(file)
      io.write(text)
      io.close(file)
   else
      naughty.notify({title = 'Error: failed to write to file (did you overwrite default permissions in `/etc/udev/rules.d/backlight.rules`?)'})
   end
end

-- Capture shell command output.
function utils.capture(cmd, raw)
   local f = assert(io.popen(cmd, 'r'))
   local s = assert(f:read('*a'))
   f:close()
   if raw then return s end
   s = string.gsub(s, '^%s+', '')
   s = string.gsub(s, '%s+$', '')
   s = string.gsub(s, '[\n\r]+', ' ')
   return s
end

-- Returns ratio as percentage number.
function utils.percent(part, tot)
   return 100 * part / tot
end

return utils
