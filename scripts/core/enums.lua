-- enums

local enum = require "cet_mod_manager/class/enum"

local enums = {}

enums.MODTYPE = enum({
  "ARCHIVE",
  "ASI",
  "CET",
  "RED4EXT",
  "REDSCRIPT"
})

return enums