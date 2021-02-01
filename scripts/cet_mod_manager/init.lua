local CETMM = {}

local function file_exists(name)
   local f=io.open(name,"r")
   if (f~=nil) then io.close(f) return true else return false end
end

local function getModsPath()
  local modspath
  if  file_exists("./cet_mod_manager/init.lua") then
    modspath = ".\\"
  elseif file_exists("./bin/x64/plugins/cyber_engine_tweaks/mods/cet_mod_manager/init.lua") then
    modspath = ".\\bin\\x64\\plugins\\cyber_engine_tweaks\\mods\\"
  elseif file_exists("./plugins/cyber_engine_tweaks/mods/cet_mod_manager/init.lua") then
    modspath = ".\\plugins\\cyber_engine_tweaks\\mods\\"
  end
  return modspath
end

local function scan_mods()
  local ModsPath = getModsPath()
	local i = 0
	local mod_list = {}
	local dir_list = io.popen("dir "..ModsPath.." /b /ad")
	for dir in dir_list:lines() do
		i = i + 1
		mod_list[i] = {
      name = dir,
      path = ModsPath..dir
    }
	end
	dir_list:close()
	return mod_list
end

local function check_mod_state(modpath)
	local initpath = modpath.."\\init.lua"
	local init_disabledpath = modpath.."\\init.lua_disabled"
	if file_exists(initpath) then
		return true
	elseif not file_exists(initpath) and file_exists(init_disabledpath) then
		return false
	else
		return nil
	end
end

function CETMM.GetModsData()
	local mods_data = {}
	local modList = scan_mods()
	for i in pairs(modList) do
		local mod_entry = {}
		mod_entry.name = modList[i].name
    mod_entry.path = modList[i].path
		mod_entry.state = check_mod_state(modList[i].path)
		table.insert(mods_data, mod_entry)
	end
	return mods_data
end

function CETMM.ToggleMod(mod_entry)
  local mod_name = mod_entry.name
  local mod_path = mod_entry.path
  local enable = mod_entry.state
	if enable then
		local ok = os.rename(mod_path.."/init.lua_disabled", mod_path.."/init.lua")
    if ok then return 1 else return 2 end
	elseif not enable then
		local ok = os.rename(mod_path.."/init.lua", mod_path.."/init.lua_disabled")
    if ok then return 3 else return 4 end
	end
end

function CETMM.OpenFolder(folder)
  local ModsPath = getModsPath()
  if folder == "mods" then
    os.execute("start explorer "..ModsPath)
  elseif folder == "dofiles" then
    os.execute("start explorer "..ModsPath.."cet_mod_manager\\dofiles")
  end
end

return CETMM
