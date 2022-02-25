-- mod list

local enums = require ("cet_mod_manager/enums")

---@class mods
---@field m_data table<ENUM_MODTYPE, mod[]>
---@field m_api_data table
local mods = {
  m_data = {},
  m_api_data = {} -- const table for api
}

-- private functions

local function init()
  for i = 1, enums.MODTYPE:Count() do
    table.insert(mods.m_data, {})
  end
end

---@param lhs mod
---@param rhs mod
local function sort_algorithm(lhs, rhs)
  return lhs:GetName():upper() < rhs:GetName():upper()
end

---@param qry string
---@param lst mods
---@param all boolean
---@return mod[]
local function search_algorithm(qry, lst, all)
  local result = {}

  if not all then -- search single type

    for _, entry in ipairs(lst) do
      if string.match(entry:GetName(),qry) then
        table.insert(result, entry)
      end
    end

  else -- search all mods

    for mod_type, mod_list in pairs(lst) do
      for _, entry in ipairs(mod_list) do
        if string.match(entry:GetName(), qry) then
          table.insert(result, entry)
        end
      end
    end

    table.sort(result, sort_algorithm) -- sort result

  end

  return result
end

-- methods

---@param aMod mod
function mods.Add(aMod)
  table.insert(mods.m_data[aMod:GetType()], aMod)
end

---@param aMod mod
function mods.Remove(aMod)
  for idx, entry in ipairs(mods.m_data[aMod:GetType()]) do
    if entry:GetName() == aMod:GetName() then
      table.remove(mods.m_data[aMod:GetType()], idx)
      return true
    end
  end
  return false
end

function mods.Get()
  return mods.m_data
end

---@param aModType ENUM_MODTYPE
function mods.Clear(aModType)
  if aModType == nil then
    mods.m_data = {}
    init()
  else
    mods.m_data[aModType] = {}
  end
end

function mods.Dump()
  for mod_type, mod_list in ipairs(mods.m_data) do
    print(enums.MODTYPE:ToString(mod_type)..": ")
		if next(mod_list) ~= nil then
			for _, entry in ipairs(mod_list) do
				print("  " .. (entry:IsEnabled() and "[Enabled]  " or "[Disabled] ") .. entry:GetName())
			end
		else
      print("  No mod of this type.")
    end
	end
end

---@param aModType ENUM_MODTYPE
function mods.Sort(aModType)
  if aModType == nil then
    for mod_type, mod_list in ipairs(mods.m_data) do
      table.sort(mod_list, sort_algorithm)
    end
  else
    table.sort(mods.m_data[aModType], sort_algorithm)
  end
end

---@param aQuery string
---@param aType ENUM_MODTYPE
function mods.Search(aQuery, aType) -- string: aQuery, enums.MODTYPE: aType
  if aType ~= nil then
    return search_algorithm(aQuery, mods.m_data[aType])
  else
    return search_algorithm(aQuery, mods.m_data, true)
  end
end

function mods.GenerateAPIData()
  local formated_mods = {}
  for i = 1, enums.MODTYPE:Count() do
    local mod_list = {}
    for _, entry in ipairs(mods.m_data[i]) do
      local mod = {
        name = entry:GetName(),
        path = entry:GetPath():ToString(),
        enabled = entry:IsEnabled(),
        type = entry:GetTypeName(),
        formated_name = entry:GetFormatedName()
      }
      table.insert(mod_list, mod)
    end
    formated_mods[enums.MODTYPE:ToString(i)] = mod_list
  end
  mods.m_api_data = formated_mods
end

function mods.GetConstList()
  return mods.m_api_data
end

---@param aName string
---@param aType ENUM_MODTYPE
function mods.HasMod(aName, aType)
  for _, entry in ipairs(mods.m_data[aType]) do
    if entry:GetName() == aName then
      return {
        name = entry:GetName(),
        path = entry:GetPath():ToString(),
        enabled = entry:IsEnabled(),
        type = entry:GetTypeName(),
        formated_name = entry:GetFormatedName()
      }
    end
  end
  return false
end

-- init

init()

return mods