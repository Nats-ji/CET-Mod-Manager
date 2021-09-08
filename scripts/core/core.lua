local paths = require ("cet_mod_manager/paths")
local scan = require ("cet_mod_manager/scan")
local mods = require ("cet_mod_manager/mods")
local enums = require ("cet_mod_manager/enums")
local helper = require ("cet_mod_manager/helper")
local auth = require ("cet_mod_manager/auth")

local core = {}

core.scan = scan
core.mods = mods
core.enums = enums
core.helper = helper

function json.CETMM_core(op)
  if auth.Authenticate(op) then return core end
end

print("CETMM core loaded..")