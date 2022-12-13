-- build script for xmake
local package_path = vformat("$(buildir)/package")

-- embed settings
local embeds_path = "src/Installer/embeds"

local embed_files = {
  "LICENSE",
  "Third_Party_LICENSES",
  "README.md",
  "README_zh.md",
}

local function check_game_installation(install_path)
  assert(install_path, format("Install path not set.\n\tUse the follow command to set install path:\n\txmake f --installpath=%s", [["C:\Program Files (x86)\Steam\steamapps\common\Cyberpunk 2077"]]))
  local exe_path = path.join(install_path, "bin", "x64", "Cyberpunk2077.exe")
  assert(os.exists(exe_path), format("Can't find the game installation. Make sure the install path is set to game root directory.\n\tUse the follow command to set install path:\n\txmake f --installpath=%s", [["C:\Program Files (x86)\Steam\steamapps\common\Cyberpunk 2077"]]))
end

local function generate_version_lua(git_tag)
  local file = io.open("scripts/modules/version.lua", "w")

  assert(file, "can't open file scripts/modules/version.lua")
  local content = format([[return "%s"]], git_tag)
  file:write(content)
  file:close()
end

-- Export functions
function UpdateVersion()
  local git_tag = os.iorun("git describe --tags"):gsub("\n", "")
  generate_version_lua(git_tag)
  cprint("generating scripts\\modules\\version.lua ... ${bright green}ok")

  if os.exists("src/Common/Version.h.in") then
    local file = io.open("src/Common/Version.h.in", "r")
    local content = file:read("*a")
    file:close()
    cprint("generating src\\Common\\Version.h.in ... ${bright green}ok")
    content = content:gsub("${GIT_TAG}", git_tag)
    cprint("updating the git tag in src\\Common\\Version.h ... ${bright green}ok")
    file = io.open("src/Common/Version.h", "w")
    file:write(content)
    file:close()
  end
end

function GenerateEmbeds()
  -- clear embed directories
  if os.isdir(embeds_path) then
    os.tryrm(path.join(embeds_path, "**"))
  end

  -- create directories for embed files
  local embeds_lua_path = path.join(embeds_path, "lua")
  local embeds_red4ext_path = path.join(embeds_path, "red4ext")
  os.mkdir(embeds_lua_path)
  os.mkdir(embeds_red4ext_path)

  -- embed red4ext plugin
  import("core.project.config")
  config.load()
  import("core.project.project")
  local target = project.target("cet_mod_manager")
  print(target:targetfile())
  assert(os.exists(target:targetfile()), "target file for cet_mod_manager doesn't exist, run xmake build cet_mod_manager to build the target first.")
  os.exec([[.\vendor\bin2cpp\bin2cpp.exe --file=%s --managerfile=EmbedFileManager_Red4ExtPlugin.h --registerfile --namespace=bin2cppRed4ExtPlugin --output=%s --noheader]], target:targetfile(), path.translate(embeds_red4ext_path))

  -- embed loose files
  for _, file in ipairs(embed_files) do
    os.exec([[.\vendor\bin2cpp\bin2cpp.exe --file=%s --managerfile=EmbedFileManager_LooseFiles.h --registerfile --output=%s --namespace=bin2cppLooseFiles --noheader]], file, path.translate(embeds_lua_path))
  end

  -- embed lua files
  os.exec([[.\vendor\bin2cpp\bin2cpp.exe --dir=scripts --managerfile=EmbedFileManager_Lua.h --output=%s --namespace=bin2cppLua --keepdirs --noheader]], path.translate(embeds_lua_path))

  cprint("generating files for embedding to %s ... ${bright green}ok", embeds_path)
end

function Package(target)
  if os.tryrm(path.join(package_path, "**")) then
    cprint("cleaning old package files ... ${bright green}ok")
  else
    cprint("cleaning old package files ... ${bright red}failed")
  end
  local output_path = path.join(package_path, "bin/x64/plugins")
  os.mkdir(output_path)
  cprint("creating file structure ... ${bright green}ok")

  if target then
    os.cp(target:targetfile(), output_path)
    cprint("copying cet_mod_manager.asi ... ${bright green}ok")
  end
end

function Install()
  import("core.project.config")
  config.load()
  import("core.project.project")
  local target = project.target("installer")
  local install_path = config.get("installpath")
  cprint("${green bright}Installing CET Mod Manager ..")
  check_game_installation(install_path)
  assert(os.exists(target:targetfile()), "target file doesn't exist, run xmake to build the target first.")
  local output_dir = path.join(install_path, "bin/x64/plugins")
  os.cp(target:targetfile(), output_dir)
  cprint("CET Mod Manager installed at: ${underline}%s", output_dir)
end

function InstallLua()
  import("core.project.config")
  config.load()
  local install_path = config.get("installpath")
  cprint("${green bright}Installing CET Mod Manager Lua ..")
  check_game_installation(install_path)
  os.run([[xcopy "%s" "%s" /s /e /y /q]], path.translate("scripts"), path.translate(path.join(install_path, "bin/x64/plugins/cyber_engine_tweaks/mods/cet_mod_manager"))) -- Don't use os.cp(), it will remove the contents from the destination directory.
  cprint("CET Mod Manager Lua installed at: ${underline}%s", path.translate(path.join(install_path, "bin/x64/plugins/cyber_engine_tweaks/mods/cet_mod_manager")))
end

function InstallExt()
  import("core.project.config")
  config.load()
  import("core.project.project")
  local target = project.target("cet_mod_manager")
  local install_path = config.get("installpath")
  cprint("${green bright}Installing CET Mod Manager Red4ext plugin ..")
  check_game_installation(install_path)
  assert(os.exists(target:targetfile()), "target file doesn't exist, run xmake to build the target first.")
  local output_dir = path.join(install_path, "red4ext/plugins/cet_mod_manager")
  os.mkdir(output_dir)
  os.cp(target:targetfile(), output_dir)
  cprint("CET Mod Manager Lua installed at: ${underline}%s", path.translate(output_dir))
end

function Clean()
  if os.tryrm(path.join(embeds_path, "**")) then
    cprint("cleaning embed files ... ${bright green}ok")
  else
    cprint("cleaning embed files ... ${bright red}failed")
  end
    
  if os.tryrm(path.join(package_path, "**")) then
    cprint("cleaning package files ... ${bright green}ok")
  else
    cprint("cleaning package files ... ${bright red}failed")
  end
end

function BuildAll()
  os.execv("xmake", {"b", "cet_mod_manager"})
  GenerateEmbeds()
  os.execv("xmake", {"b", "installer"})
end