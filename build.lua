-- build script for xmake
local package_path = vformat("$(buildir)/package")

local function generate_version_lua(git_tag)
  local file = io.open("scripts/modules/version.lua", "w")

  assert(file, "can't open file scripts/modules/version.lua")
  local content = format([[return "%s"]], git_tag)
  file:write(content)
  file:close()
end

local function check_game_installation(install_path)
  assert(install_path, format("Install path not set.\n\tUse the follow command to set install path:\n\txmake f --installpath=%s", [["C:\Program Files (x86)\Steam\steamapps\common\Cyberpunk 2077"]]))
  local exe_path = path.join(install_path, "bin", "x64", "Cyberpunk2077.exe")
  assert(os.exists(exe_path), format("Can't find the game installation. Make sure the install path is set to game root directory.\n\tUse the follow command to set install path:\n\txmake f --installpath=%s", [["C:\Program Files (x86)\Steam\steamapps\common\Cyberpunk 2077"]]))
end

-- Export functions

function GenerateEmbeds()
  local embeds_path = "src/embeds"
  if os.isdir(embeds_path) then
    os.tryrm(path.join(embeds_path, "**"))
  else
    os.mkdir(embeds_path)
  end
  os.run([[.\vendor\bin2cpp\bin2cpp.exe --dir=scripts --managerfile=EmbedFileManager.h --output=%s --keepdirs --noheader]], path.translate(embeds_path))
  cprint("generating files for embedding to %s ... ${bright green}ok", embeds_path)
end

function UpdateVersion()
  local git_tag = os.iorun("git describe --tags"):gsub("\n", "")
  generate_version_lua(git_tag)
  cprint("generating scripts\\modules\\version.lua ... ${bright green}ok")

  if os.exists("src/Version.h.in") then
    local file = io.open("src/Version.h.in", "r")
    local content = file:read("*a")
    file:close()
    cprint("generating src\\Version.h.in ... ${bright green}ok")
    content = content:gsub("${GIT_TAG}", git_tag)
    cprint("updating the git tag in src\\Version.h ... ${bright green}ok")
    file = io.open("src/Version.h", "w")
    file:write(content)
    file:close()
  end
end

function Package(target)
  if os.tryrm(path.join(package_path, "**")) then
    cprint("cleaning old package files ... ${bright green}ok")
  else
    cprint("cleaning old package files ... ${bright red}failed")
  end
  os.mkdir(path.join(package_path, "bin/x64/plugins/cyber_engine_tweaks/mods/cet_mod_manager"))
  cprint("creating file structure ... ${bright green}ok")

  if target then
    os.cp(target:targetfile(), path.join(package_path, "bin/x64/plugins"))
    cprint("copying cet_mod_manager.asi ... ${bright green}ok")
  end
end

function Install()
  import("core.project.config")
  import("core.project.project")
  local target = project.target("cet_mod_manager")
  config.load()
  local install_path = config.get("installpath")
  cprint("${green bright}Installing CET Mod Manager ..")
  check_game_installation(install_path)
  assert(os.exists(target:targetfile()), "target file doesn't exist, run xmake install to build the target first.")
  os.cp(target:targetfile(), path.join(install_path, "bin/x64/plugins"))
  cprint("CET Mod Manager installed at: ${underline}%s", "$(installpath)")
end

function Clean()
  if os.tryrm(path.join(package_path, "**")) then
    cprint("cleaning package files ... ${bright green}ok")
  else
    cprint("cleaning package files ... ${bright red}failed")
  end
end