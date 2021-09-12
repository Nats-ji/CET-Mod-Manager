-- enums

local enum = require "cet_mod_manager/class/enum"

---@class enums
local enums = {}

---@class ENUM_MODTYPE : enum
---@field ARCHIVE ENUM_MODTYPE 1
---@field ASI ENUM_MODTYPE 2
---@field CET ENUM_MODTYPE 3
---@field RED4EXT ENUM_MODTYPE 4
---@field REDSCRIPT ENUM_MODTYPE 5
enums.MODTYPE = enum({
  "ARCHIVE",
  "ASI",
  "CET",
  "RED4EXT",
  "REDSCRIPT"
})

return enums