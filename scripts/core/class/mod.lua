local helper = require "cet_mod_manager/helper"
local enums = require "cet_mod_manager/enums"

-- mod class

local mod = {}
mod.__index = mod

-- mod constructor

setmetatable(mod, {
  __call = function (cls, ...)
    return cls.New(...)
  end,
})

function mod.New(aName, aPath, aEnabled, aType) -- string: aName, path: aPath, bool: aEnabled, enums.MODTYPE: aType
  local self = setmetatable({}, mod)
  self.name = aName
  self.path = aPath
  self.enabled = aEnabled
  self.type = aType
  self.formated_name = helper.format_name(aName)
  return self
end

-- mod methods

function mod.GetName(self)
  return self.name
end

function mod.GetFormatedName(self)
  return self.formated_name
end

function mod.GetPath(self)
  return self.path
end

function mod.IsEnabled(self)
  return self.enabled
end

function mod.GetType(self)
  return self.type
end

function mod.GetTypeName(self)
  return enums.MODTYPE:ToString(self.type)
end

function mod.SetName(self, aName)
  self.name = aName
  self.formated_name = helper.format_name(aName)
end

function mod.SetPath(self, aPath)
  self.path = aPath
end

function mod.SetEnabled(self, aEnabled)
  self.enabled = aEnabled
end

function mod.SetType(self, aType)
  self.type = aType
end

function mod.Dump(self)
  print(string.format("\nMods:\t\t%s\nFormated Name:\t%s\nPath:\t\t%s\nEnabled:\t%s\nType:\t\t%s", self.name, self.formated_name, self.path, self.enabled, self:GetTypeName()))
end

return mod