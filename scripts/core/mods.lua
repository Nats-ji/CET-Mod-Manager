-- mod list

local enums = require ("cet_mod_manager/enums")
local helper = require ("cet_mod_manager/helper")

local mods = {
  data = {},
  api_data = {} -- const table for api
}

-- private functions

local function init()
  for i = 1, enums.MODTYPE:Count() do
    table.insert(mods.data, {})
  end
end

local function sort_algorithm(lhs, rhs)
  return lhs:GetName():upper() < rhs:GetName():upper()
end

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

function mods.Add(aMod)
  table.insert(mods.data[aMod:GetType()], aMod)
end

function mods.Remove(aMod)
  for idx, entry in ipairs(mods.data[aMod:GetType()]) do
    if entry:GetName() == aMod:GetName() then
      table.remove(mods.data[aMod:GetType()], idx)
      return true
    end
  end
  return false
end

function mods.Get()
  return mods.data
end

function mods.Clear(aModType)
  if aModType == nil then
    mods.data = {}
    init()
  else
    mods.data[aModType] = {}
  end
end

function mods.Dump()
  for mod_type, mod_list in ipairs(mods.data) do
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

function mods.Sort(aModType)
  if aModType == nil then
    for mod_type, mod_list in ipairs(mods.data) do
      table.sort(mod_list, sort_algorithm)
    end
  else
    table.sort(mods.data[aModType], sort_algorithm)
  end
end

function mods.Search(aQuery, aType) -- string: aQuery, enums.MODTYPE: aType
  if aType ~= nil then
    return search_algorithm(aQuery, mods.data[aType])
  else
    return search_algorithm(aQuery, mods.data, true)
  end
end

function mods.GenerateAPIData()
  local formated_mods = {}
  for i = 1, enums.MODTYPE:Count() do
    local mod_list = {}
    for _, entry in ipairs(mods.data[i]) do
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
  mods.api_data = formated_mods
end

function mods.GetConstList()
  return mods.api_data
end

function mods.HasMod(aName, aType)
  for _, entry in ipairs(mods.data[aType]) do
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