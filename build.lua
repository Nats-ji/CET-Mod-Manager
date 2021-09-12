-- build script for xmake
local package_path = vformat("$(buildir)/package")

local search_list = {
  "scripts",
  "dofiles",
  "lang",
  "init.lua",
  "LICENSE",
  "Third_Party_LICENSES",
  "README.md",
  "README_zh.md"
}

local function generate_version_lua(git_tag)
  local file = io.open("scripts/version.lua", "w")

  assert(file, "can't open file scripts/version.lua")
  local content = format([[return "%s"]], git_tag)
  file:write(content)
  file:close()
end

local function get_file_list()
  local file_list = {}
  for _, entry in ipairs(search_list) do
    file_list = table.join(file_list, os.filedirs(entry))
    if os.isdir(entry) then
      file_list = table.join(file_list, os.filedirs(entry .. "/**"))
    end
  end
  return file_list
end

-- Export functions

function UpdateVersion()
  local git_tag = os.iorun("git describe --tags"):gsub("\n", "")
  generate_version_lua(git_tag)
  cprint("generating scripts\\version.lua ... ${bright green}ok")

  local file_list_str = format("{ \"%s\" }", table.concat(get_file_list(), "\", \""):gsub("\\", "/"))
  if os.exists("src/Version.h.in") then
    local file = io.open("src/Version.h.in", "r")
    local content = file:read("*a")
    file:close()
    cprint("generating src\\Version.h.in ... ${bright green}ok")
    content = content:gsub("${GIT_TAG}", git_tag)
    cprint("updating the git tag in src\\Version.h ... ${bright green}ok")
    content = content:gsub("${FILE_LIST}", file_list_str)
    cprint("updating the file list in src\\Version.h ... ${bright green}ok")
    file = io.open("src/Version.h", "w")
    file:write(content)
    file:close()
  end
end


function Package(target)
  if os.tryrm(path.join(package_path, "**")) then
    cprint("clearing old package files ... ${bright green}ok")
  else
    cprint("clearing old package files ... ${bright red}failed")
  end
  os.mkdir(path.join(package_path, "bin/x64/plugins/cyber_engine_tweaks/mods/cet_mod_manager"))
  cprint("creating file structure ... ${bright green}ok")

  for _, entry in ipairs(search_list) do
    os.cp(entry, path.join(package_path, "bin/x64/plugins/cyber_engine_tweaks/mods/cet_mod_manager"))
  end
  cprint("copying lua files ... ${bright green}ok")
  os.cp(target:targetfile(), path.join(package_path, "bin/x64/plugins"))
  cprint("copying cet_mod_manager.asi ... ${bright green}ok")
end

function Install(install_path)
  cprint("${green bright}Installing CET Mod Manager ..")
  assert(install_path and os.isdir(install_path), format("The path in your configuration doesn't exist or isn't a directory.\n\tUse the follow command to set install path:\n\txmake f --installpath=%s", [["C:\Program Files (x86)\Steam\steamapps\common\Cyberpunk 2077"]]))
  os.run([[xcopy "%s" "%s" /s /e /y /q]], path.translate(package_path), path.translate(install_path)) -- Don't use os.cp(), it will remove the contents from the destination directory.
  cprint("CET Mod Manager installed at: ${underline}%s", "$(installpath)")
end