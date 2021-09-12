local helper = require "cet_mod_manager/helper"
local enums = require "cet_mod_manager/enums"

-- mod class

---@class mod
---@field m_name string
---@field m_path path
---@field m_enabled boolean
---@field m_type ENUM_MODTYPE
---@field m_formated_name string
local mod = {}
mod.__index = mod

-- mod constructor

setmetatable(mod, {
  __call = function (cls, ...)
    return cls.New(...)
  end,
})

---@param aName string
---@param aPath path
---@param aEnabled boolean
---@param aType number
function mod.New(aName, aPath, aEnabled, aType) -- string: aName, path: aPath, bool: aEnabled, enums.MODTYPE: aType
  local self = setmetatable({}, mod)
  self.m_name = aName
  self.m_path = aPath
  self.m_enabled = aEnabled
  self.m_type = aType
  self.m_formated_name = (aName == "cet_mod_manager") and "Cyber Engine Tweaks Mod Manager" or helper.format_name(aName)
  return self
end

-- mod methods

function mod.GetName(self)
  return self.m_name
end

function mod.GetFormatedName(self)
  return self.m_formated_name
end

function mod.GetPath(self)
  return self.m_path
end

function mod.IsEnabled(self)
  return self.m_enabled
end

function mod.GetType(self)
  return self.m_type
end

function mod.GetTypeName(self)
  return enums.MODTYPE:ToString(self.m_type)
end

---@param aName string
function mod.SetName(self, aName)
  self.m_name = aName
  self.m_formated_name = helper.format_name(aName)
end

---@param aPath path
function mod.SetPath(self, aPath)
  self.m_path = aPath
end

---@param aEnabled boolean
function mod.SetEnabled(self, aEnabled)
  self.m_enabled = aEnabled
end

function mod.Toggle(self)
  self.m_enabled = not self.m_enabled
end

---@param aType ENUM_MODTYPE
function mod.SetType(self, aType)
  self.m_type = aType
end

function mod.Dump(self)
  print(string.format("\nMods:\t\t%s\nFormated Name:\t%s\nPath:\t\t%s\nEnabled:\t%s\nType:\t\t%s", self.m_name, self.m_formated_name, self.m_path, self.m_enabled, self:GetTypeName()))
end

return mod