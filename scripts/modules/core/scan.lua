-- scan mods

local enums = require ("cet_mod_manager/enums")
local filesystem = require ("cet_mod_manager/filesystem")
local paths = require ("cet_mod_manager/paths")
local mod = require ("cet_mod_manager/class/mod")
local mods = require ("cet_mod_manager/mods")

local mod_state_name = {
  enabled = {},
  disabled = {}
}

mod_state_name.enabled[enums.MODTYPE.ARCHIVE] = ".archive"
mod_state_name.disabled[enums.MODTYPE.ARCHIVE] = ".disabled_archive"
mod_state_name.enabled[enums.MODTYPE.ASI] = ".asi"
mod_state_name.disabled[enums.MODTYPE.ASI] = ".disabled_asi"
mod_state_name.enabled[enums.MODTYPE.CET] = "init.lua"
mod_state_name.disabled[enums.MODTYPE.CET] = "init.lua_disabled"
mod_state_name.enabled[enums.MODTYPE.RED4EXT] = ".dll"
mod_state_name.disabled[enums.MODTYPE.RED4EXT] = ".disabled_dll"
mod_state_name.enabled[enums.MODTYPE.REDSCRIPT] = ".reds"
mod_state_name.disabled[enums.MODTYPE.REDSCRIPT] = ".disabled_reds"


---@class scan
local scan = {}

---@param aPath path
---@param aModType ENUM_MODTYPE
local function is_mod_enabled(aPath, aModType)
  local state = nil
  if aModType == enums.MODTYPE.CET then
    if filesystem.FileExists(aPath / mod_state_name.enabled[aModType]) then
      state = true
    elseif filesystem.FileExists(aPath / mod_state_name.disabled[aModType]) then
      state = false
    end
  elseif aModType == enums.MODTYPE.REDSCRIPT then
    -- need to implement later
    state = true
  else
    if aPath:Extension():ToString() == mod_state_name.enabled[aModType] then
      state = true
    elseif aPath:Extension():ToString() == mod_state_name.disabled[aModType] then
      state = false
    end
  end

  return state -- nil means mod doesn't exist
end

---@param aModType ENUM_MODTYPE
local function scan_imp(aModType)
  local scan_dir
  local scan_mode = nil
  local scan_filter = nil

  if aModType == enums.MODTYPE.ARCHIVE then
    scan_dir = paths.archive
    scan_mode = true
    scan_filter = {mod_state_name.enabled[aModType], mod_state_name.disabled[aModType]}

  elseif aModType == enums.MODTYPE.ASI then
    scan_dir = paths.plugins
    scan_mode = true
    scan_filter = {mod_state_name.enabled[aModType], mod_state_name.disabled[aModType]}

  elseif aModType == enums.MODTYPE.CET then
    scan_dir = paths.cetmods
    scan_mode = false

  elseif aModType == enums.MODTYPE.RED4EXT then
    scan_dir = paths.red4ext
    scan_mode = true
    scan_filter = {mod_state_name.enabled[aModType], mod_state_name.disabled[aModType]}

  elseif aModType == enums.MODTYPE.REDSCRIPT then
    scan_dir = paths.redscript
    scan_filter = {mod_state_name.enabled[aModType], mod_state_name.disabled[aModType]}
  end

  local file_list = filesystem.List(scan_dir, scan_mode, scan_filter)

  mods.Clear(aModType) -- clear old mod list

  for _, entry in ipairs(file_list) do
    local state = is_mod_enabled(entry, aModType)
    if state ~= nil then
      local _mod = mod(entry:FileName():ToString(), entry, state, aModType)
      mods.Add(_mod)
    end
  end

  mods.Sort(aModType)
end

-- output to mods

function scan.ScanALL()
  -- for modtype = 1, enums.MODTYPE:Count() do
  --   scan_imp(modtype)
  -- end
  scan_imp(enums.MODTYPE.CET)
  mods.GenerateAPIData() -- recreate the const table
end

function scan.ScanCET()
  scan_imp(enums.MODTYPE.CET)
  mods.GenerateAPIData() -- recreate the const table
end

---@param aModType ENUM_MODTYPE
function scan.Scan(aModType)
  scan_imp(aModType)
  mods.GenerateAPIData() -- recreate the const table
end

---@param aMod mod
function scan.UpdateModState(aMod)
  aMod:SetEnabled(is_mod_enabled(aMod:GetPath(), aMod:GetType()))
  mods.GenerateAPIData() -- recreate the const table
end

return scan