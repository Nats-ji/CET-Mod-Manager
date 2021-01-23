-- Copyright 2021 Mingming Cui
--
-- This file is part of CyberEngineTWeaks Mod Manager.
--
-- CyberEngineTWeaks Mod Manager is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- CyberEngineTWeaks Mod Manager is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with Foobar.  If not, see <https://www.gnu.org/licenses/>.

registerForEvent("onInit", function()
	rootPath = {
		Require = ".plugins.cyber_engine_tweaks.mods.cet_mod_manager.",
		ModsIO = nil,
		IO = nil,
		Execute = nil
	}
	readRootPath()
	mods_data = get_mods_data()
	dofile_names = scan_dofiles()
	theme = require(rootPath.Require.."theme")
	draw = false
	showHelp = false
	showDofileMods = false
	wWidth, wHeight = GetDisplayResolution()
	print("************************************************")
	print("* CyberEngineTWeaks Mod Manager Loaded...      *")
	print("* Press Ctrl+Shift+C to open mod manager.      *")
	print("* Press Ctrl+Shift+F to open dofile mods.      *")
	print("************************************************")
end)

registerHotkey("mod_manager_interface", "Mod Manager Interface", function()
	draw = not draw
	showDofileMods = false
end)

registerHotkey("dofile_interface", "Dofile Interface", function()
	draw = not draw
	showDofileMods = true
end)

registerForEvent("onUpdate", function()
	if btnScan then
		mods_data = get_mods_data()
		dofile_names = scan_dofiles()
		print("[CETMM] Mod rescan complete.")
	end
	if btnOpenMods then
		os.execute("start explorer "..rootPath.Execute)
	end
	if btnOpenDofiles then
		os.execute("start explorer "..rootPath.Execute.."cet_mod_manager\\dofiles")
	end

	if btnDofiles then
		showDofileMods = not showDofileMods
	end
	if btnHelp then
		showHelp = not showHelp
	end
	if btnRun ~= nil then
		for i in pairs(btnRun) do
			if btnRun[i] then
				print("[CETMM] Executing "..modNameConvert(dofile_names[i]:match("(.+)%.lua$"))..".")
				dofile(rootPath.IO.."dofiles/"..dofile_names[i])
				print("[CETMM] Done.")
			end
		end
	end
	for i in pairs(mods_data) do
		if mods_data[i].pressed then
			toggleMod(mods_data[i].name, mods_data[i].state)
		end
	end
end)

registerForEvent("onDraw", function()
    if draw then
		setThemeBegin()
		draw = ImGui.Begin("CyberEngineTWeaks Mod Manager", draw, ImGuiWindowFlags.NoResize)
		ImGui.SetWindowPos(wWidth/2-200, wHeight/2-200, ImGuiCond.FirstUseEver)
		ImGui.SetWindowSize(400, 600, ImGuiCond.FirstUseEver)
		ImGui.Spacing()
		btnToggleStyleBegin(showDofileMods)
		btnDofiles = ImGui.Button("Dofile Mods", 90, 25)
		btnToggleStyleEnd()
		ImGui.SameLine(285)
		btnScan = ImGui.Button("Re-Scan", 75, 25)
		ImGui.SameLine(365)
		btnToggleStyleBegin(showHelp)
		btnHelp = ImGui.Button("?", 25, 25)
		btnToggleStyleEnd()
		ImGui.Spacing()

		ImGui.BeginChild("Mod List", 385, 497)

		if showHelp then
			if not showDofileMods then
				pushstylecolor(ImGuiCol.Text, theme.Separator)
				ImGui.TextWrapped('Press [Scan] to scan the CyberEngineTweaks mods you have installed.')
				ImGui.Spacing()
				ImGui.TextWrapped('Tick/untick the checkbox to enable/disable mods.')
				ImGui.Spacing()
				ImGui.TextWrapped('Change [Windowed Mode] in Game\'s [Settings] - [Video] to [Windows Borderless] to avoid being thrown out to desktop when pressing [Scan].')
				ImGui.Spacing()
				ImGui.TextWrapped('After Enabling/Disabling mods, press the [Reload ALL Mods] button on console to reload the mods.')
				ImGui.Spacing()
				ImGui.TextWrapped('Press [Auto Scan] button to enable auto scan when the mod manager is loaded.')
				ImGui.PopStyleColor(1)
			else
				ImGui.TextWrapped('You can run your favorite "dofile()" lua mods here with a press of button')
				ImGui.Spacing()
				ImGui.TextWrapped('To use this feature, press the [Dofile Folder] button on the button to open the folder. Copy your *.lua mod that runs with "dofile()" in here.')
				ImGui.Spacing()
				ImGui.TextWrapped('Press [Scan] button to refresh the mod list.')
				ImGui.Spacing()
				ImGui.TextWrapped('After the mod list has been loaded, press the [Run] button in front of them to run them with a press of button. No moar dofile()!')
				ImGui.Spacing()
				ImGui.TextWrapped('You can delete the example dofile modes if you want.')
			end
			ImGui.Spacing()
		end

		if showDofileMods then
			if dofile_names[1] ~= nil then
				btnRun = draw_dofile_list(dofile_names)
			else
				ImGui.Spacing()
				ImGui.Text("You don't have any dofile mods...")
			end
		else
			draw_mod_list(mods_data)
		end

		ImGui.EndChild()
		btnOpenMods = ImGui.Button("Mods Folder", 90, 25)
		ImGui.SameLine()
		btnOpenDofiles = ImGui.Button("Dofile Folder", 105, 25)
		ImGui.End()
		setThemeEnd()
    end
end)


function scan_mods()
	local i = 0
	local mod_names = {}
	local dir_list = io.popen("dir "..rootPath.Execute.." /b /ad")
	for dir in dir_list:lines() do
		i = i + 1
		mod_names[i] = dir
	end
	dir_list:close()
	return mod_names
end

function scan_dofiles()
	local dofile_names = {}
	local dofile_list = io.popen("dir "..rootPath.Execute.."cet_mod_manager\\dofiles\\ /b /a-d")
	for lua in dofile_list:lines() do
		if lua:match("(.+)%.lua$") then
			table.insert(dofile_names, lua)
		end
	end
	dofile_list:close()
	return dofile_names
end

function check_mod_state(mod)
	local modpath = rootPath.ModsIO..mod.."/init.lua"
	local disabled_modpath = rootPath.ModsIO..mod.."/init.lua_disabled"
	if file_exists(modpath) then
		return true
	elseif not file_exists(modpath) and file_exists(disabled_modpath) then
		return false
	else
		return nil
	end
end

function get_mods_data()
	local mods_data = {}
	local modList = scan_mods()
	for i in pairs(modList) do
		local mod_entry = {}
		mod_entry.name = modList[i]
		mod_entry.state = check_mod_state(modList[i])
		table.insert(mods_data, mod_entry)
	end
	return mods_data
end

function draw_mod_list(mods_data)
	for i in pairs(mods_data) do
		ImGui.Spacing()
		ImGui.PushID(i)
		if mods_data[i].name == "cet_mod_manager" then
			pushstylecolor(ImGuiCol.Text, theme.TextDisabled)
			pushstylecolor(ImGuiCol.FrameBg, theme.FrameBgDisabled)
			pushstylecolor(ImGuiCol.FrameBgHovered, theme.FrameBgHoveredDisabled)
			pushstylecolor(ImGuiCol.FrameBgActive, theme.FrameBgActiveDisabled)
			pushstylecolor(ImGuiCol.CheckMark, theme.CheckMarkTrueDisabled)
			ImGui.Checkbox("CyberEngineTWeaks Mod Manager", true)
			ImGui.PopStyleColor(5)
		elseif mods_data[i].state == true then
			mods_data[i].state, mods_data[i].pressed = ImGui.Checkbox(modNameConvert(mods_data[i].name), mods_data[i].state)
		elseif mods_data[i].state == false then
			mods_data[i].state, mods_data[i].pressed = ImGui.Checkbox(modNameConvert(mods_data[i].name), mods_data[i].state)
		else
			pushstylecolor(ImGuiCol.Text, theme.TextDisabled)
			pushstylecolor(ImGuiCol.FrameBg, theme.FrameBgDisabled)
			pushstylecolor(ImGuiCol.FrameBgHovered, theme.FrameBgHoveredDisabled)
			pushstylecolor(ImGuiCol.FrameBgActive, theme.FrameBgActiveDisabled)
			pushstylecolor(ImGuiCol.CheckMark, theme.CheckMarkFalseDisabled)
			ImGui.Checkbox(modNameConvert(mods_data[i].name), false)
			ImGui.PopStyleColor(5)
		end
		ImGui.PopID()
	end
end

function draw_dofile_list(dofile_names)
	local btnRun = {}
	for i in pairs(dofile_names) do
		ImGui.Spacing()
		ImGui.PushID(i)
		pushstylecolor(ImGuiCol.Text, theme.CustomToggleOnText)
		pushstylecolor(ImGuiCol.Button, theme.CustomToggleOn)
		pushstylecolor(ImGuiCol.ButtonHovered, theme.CustomToggleOnHovered)
		pushstylecolor(ImGuiCol.ButtonActive, theme.CustomToggleOn)
		btnRun[i] = ImGui.Button("Run", 40, 20)
		ImGui.PopStyleColor(4)
		ImGui.PopID()
		ImGui.SameLine()
		ImGui.PushID(i)
		pushstylecolor(ImGuiCol.Text, theme.Separator)
		ImGui.Text(modNameConvert(dofile_names[i]:match("(.+)%.lua$")))
		ImGui.PopStyleColor(1)
		ImGui.PopID()
	end
	return btnRun
end

function toggleMod(mod, enable)
	if enable then
		local ok = os.rename(rootPath.ModsIO..mod.."/init.lua_disabled", rootPath.ModsIO..mod.."/init.lua")
		if ok then
			print("[CETMM] "..modNameConvert(mod).." has been enabled.")
		else
			print("Error")
		end
	elseif not enable then
		local ok = os.rename(rootPath.ModsIO..mod.."/init.lua", rootPath.ModsIO..mod.."/init.lua_disabled")
		if ok then
			print("[CETMM] "..modNameConvert(mod).." has been disabled.")
		else
			print("[CETMM] Error when trying to enable/disable "..modNameConvert(mod))
		end
	end
end


function print_table(tble)
	for i in pairs(tble) do
		if type(tble[i])=="table" then
			for t in pairs(tble[i]) do
				print(tble[i][t])
			end
		else
			print(tble[i])
		end
	end
end

function file_exists(name)
   local f=io.open(name,"r")
   if (f~=nil) then io.close(f) return true else return false end
end

function pushstylecolor(style, color)
	ImGui.PushStyleColor(style, color[1], color[2], color[3], color[4])
end

function setThemeBegin()
	pushstylecolor(ImGuiCol.TitleBg,				theme.TitleBg)
	pushstylecolor(ImGuiCol.TitleBgCollapsed,		theme.TitleBgCollapsed)
	pushstylecolor(ImGuiCol.TitleBgActive,			theme.TitleBgActive)
	pushstylecolor(ImGuiCol.Border,					theme.Border)
	pushstylecolor(ImGuiCol.WindowBg,				theme.WindowBg)
	pushstylecolor(ImGuiCol.ScrollbarBg,			theme.ScrollbarBg)
	pushstylecolor(ImGuiCol.ScrollbarGrab,			theme.ScrollbarGrab)
	pushstylecolor(ImGuiCol.ScrollbarGrabHovered,	theme.ScrollbarGrabHovered)
	pushstylecolor(ImGuiCol.ScrollbarGrabActive,	theme.ScrollbarGrabActive)
	pushstylecolor(ImGuiCol.ResizeGrip, 			theme.ResizeGrip)
	pushstylecolor(ImGuiCol.ResizeGripHovered, 		theme.ResizeGripHovered)
	pushstylecolor(ImGuiCol.ResizeGripActive,		theme.ResizeGripActive)
	pushstylecolor(ImGuiCol.Text,					theme.Text)
	pushstylecolor(ImGuiCol.Header,					theme.Header)
	pushstylecolor(ImGuiCol.HeaderHovered,			theme.HeaderHovered)
	pushstylecolor(ImGuiCol.HeaderActive,			theme.HeaderActive)
	pushstylecolor(ImGuiCol.CheckMark,				theme.CheckMark)
	pushstylecolor(ImGuiCol.FrameBg,				theme.FrameBg)
	pushstylecolor(ImGuiCol.FrameBgHovered,			theme.FrameBgHovered)
	pushstylecolor(ImGuiCol.FrameBgActive,			theme.FrameBgActive)
	pushstylecolor(ImGuiCol.Button,					theme.Button)
	pushstylecolor(ImGuiCol.ButtonHovered,			theme.ButtonHovered)
	pushstylecolor(ImGuiCol.ButtonActive,			theme.ButtonActive)
	pushstylecolor(ImGuiCol.Separator,				theme.Separator)
end

function setThemeEnd()
	ImGui.PopStyleColor(24)
end

function modNameConvert(name)
	if string.find(name, "_") then
		return string.gsub(" "..string.gsub(name, "_" , " "), "%W%l", string.upper):sub(2)
	elseif string.find(name, "-") then
		return string.gsub(" "..string.gsub(name, "-" , " "), "%W%l", string.upper):sub(2)
	else
		return string.gsub(" "..name, "%W%l", string.upper):sub(2)
	end
end

function btnToggle(onname, offname, state, width, height)
	if onname ~= nil and offname ~= nil and state ~= nil then
		if type(width) == "number" and type(height) == "number" then
			if state then
				return ImGui.Button(onname, width, height)
			else
				return ImGui.Button(offname, width, height)
			end
		else
			if state then
				return ImGui.Button(onname)
			else
				return ImGui.Button(offname)
			end
		end
	end
end

function btnToggleStyleBegin(state)
	if state then
		pushstylecolor(ImGuiCol.Button, theme.CustomToggleOn)
		pushstylecolor(ImGuiCol.ButtonHovered, theme.CustomToggleOnHovered)
		pushstylecolor(ImGuiCol.Text, theme.CustomToggleOnText)
	else
		pushstylecolor(ImGuiCol.Button, theme.Button)
		pushstylecolor(ImGuiCol.ButtonHovered, theme.ButtonHovered)
		pushstylecolor(ImGuiCol.Text, theme.Text)
	end
end

function btnToggleStyleEnd()
	ImGui.PopStyleColor(3)
end

function readRootPath()
  local f = io.popen"cd"
  local path = f:read'*l'
  local current_dir = path:match("([^\\]+)$")
  if current_dir == "Cyberpunk 2077" then
    rootPath.ModsIO = "./bin/x64/plugins/cyber_engine_tweaks/mods/"
    rootPath.IO = "./bin/x64/plugins/cyber_engine_tweaks/mods/cet_mod_manager/"
    rootPath.Execute = ".\\bin\\x64\\plugins\\cyber_engine_tweaks\\mods\\"
  elseif current_dir == "x64" then
    rootPath.ModsIO = "./plugins/cyber_engine_tweaks/mods/"
    rootPath.IO = "./plugins/cyber_engine_tweaks/mods/cet_mod_manager/"
    rootPath.Execute = ".\\plugins\\cyber_engine_tweaks\\mods\\"
  elseif  current_dir == "mods" then
    rootPath.ModsIO = "./"
    rootPath.IO = "./cet_mod_manager/"
    rootPath.Execute = ".\\"
  end
  f:close()
end
