local scan = require ("cet_mod_manager/scan")
local paths = require ("cet_mod_manager/paths")
local dofiles = require ("cet_mod_manager/dofiles")
local mods = require ("cet_mod_manager/mods")
local modopex = require ("cet_mod_manager/modopex")
local enums = require ("cet_mod_manager/enums")
local helper = require ("cet_mod_manager/helper")
local auth = require ("cet_mod_manager/auth")

---@class core
---@field scan scan
---@field dofiles dofiles
---@field mods mods
---@field enums enums
---@field helper helper
---@field modopex modopex
---@field paths paths
local core = {}

core.scan = scan
core.dofiles = dofiles
core.mods = mods
core.enums = enums
core.helper = helper
core.modopex = modopex
core.paths = paths

---@param op number|string|nil
function json.CETMM_core(op)
  if auth.Authenticate(op) then return core end
end

print("CETMM core loaded..")