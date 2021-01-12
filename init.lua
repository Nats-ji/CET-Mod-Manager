-- Copyright 2018-2020 Mingming Cui
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
	Hotkey = 0x43 -- Change Hotkey Here. You can find Key Codes at https://docs.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
	draw = false
	scanned = false
	showHelp = false
	wWidth, wHeight = GetDisplayResolution()
	theme = require "cet_mod_manager.theme"
	print("************************************************")
	print("* CyberEngineTWeaks Mod Manager Loaded...      *")
	print("* Press Ctrl + Shift + C to open.              *")
	print("************************************************")
end)

registerForEvent("onUpdate", function()
	if (ImGui.IsKeyDown(0x11) and ImGui.IsKeyDown(0x10) and ImGui.IsKeyPressed(Hotkey, false)) then
		draw = not draw
	end
	if btnScan then
		mods_data = get_mods_data()
		scanned = true
		print("[CETMM] Mod scan complete.")
	end
	if btnHelp then
		showHelp = not showHelp
	end
	if scanned then
		for i in pairs(mods_data) do
			if mods_data[i].pressed then
				toggleMod(mods_data[i].name, mods_data[i].state)
			end
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
		btnScan = ImGui.Button("Scan", 70, 25)
		ImGui.SameLine()
		btnHelp = ImGui.Button("?", 25, 25)
		ImGui.Spacing()
		if showHelp then
			ImGui.BeginChild("Help", ImGui.GetWindowWidth()-15, 145)
			pushstylecolor(ImGuiCol.Text, theme.Separator)
			ImGui.SetWindowFontScale(1.1)
			ImGui.TextWrapped('Press [Scan] to scan the CyberEngineTweaks mods you have installed.')
			ImGui.Spacing()
			ImGui.TextWrapped('Tick/untick the checkboxs to enable/disable mods.')
			ImGui.Spacing()
			ImGui.TextWrapped('Change [Whindowed Mode] in Game\'s [Settings] - [Video] to [Windows Borderless] to avoid being thrown out to desktop when pressing [Scan].')
			ImGui.Spacing()
			ImGui.TextWrapped('After Enabling/Disabling mods, press the [Reload ALL Mods] button on console to reload the mods.')
			ImGui.PopStyleColor(1)
			ImGui.EndChild()
			ImGui.Spacing()
		end
		if mods_data ~= nil then
			if showHelp then modlistH = 230 else modlistH = 75 end
			ImGui.BeginChild("Mod List", ImGui.GetWindowWidth()-15, ImGui.GetWindowHeight()-modlistH)
			draw_mod_list(mods_data)
			ImGui.EndChild()
		end
		ImGui.End()
		setThemeEnd()
    end
end)


function scan_mods()
	local i = 0
	local mod_names = {}
	for dir in io.popen([[dir "..\mods\" /b /ad]]):lines() do
		i = i + 1
		mod_names[i] = dir
	end
	return mod_names
end

function check_mod_state(mod) -- 1 == enabled, 2 == disabled, 3 == error
	local modpath = "./"..mod.."/init.lua"
	local disabled_modpath = "./"..mod.."/init.lua_disabled"
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

function toggleMod(mod, enable)
	if enable then
		local ok = os.rename ("./"..mod.."/init.lua_disabled", "./"..mod.."/init.lua")
		if ok then
			print("[CETMM] "..modNameConvert(mod).." has been enabled.")
		else
			print("Error")
		end
	elseif not enable then
		local ok = os.rename ("./"..mod.."/init.lua", "./"..mod.."/init.lua_disabled")
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
