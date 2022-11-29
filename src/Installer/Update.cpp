#include "pch.h"

#include "Update.h"
#include "embeds/lua/EmbedFileManager_LooseFiles.h"
#include "embeds/lua/EmbedFileManager_Lua.h"
#include "embeds/red4ext/EmbedFileManager_Red4ExtPlugin.h"

void Update::LogVersion()
{
  spdlog::info("CETMM version: {}", m_version);
}

void Update::UpdateModule()
{
  std::filesystem::path scriptDir = Installer::GetPaths().CETMMRoot();
  std::string installed_version = getModuleVersion();
  // need to deal when red4ext plugin doesn't exist
  if (!std::filesystem::exists(scriptDir / "modules" / "version.lua"))
  {
    spdlog::info("Scripts doesn't exist, extracting scripts..", scriptDir.string());
    removeOldModule();
    extractModule();
  }
  else if (installed_version != m_version)
  {
    spdlog::info("Old scripts version({}) found, updating scripts.", installed_version);
    removeOldModule();
    extractModule();
  }
  std::filesystem::create_directory(scriptDir / "dofiles");
}

const std::string Update::GetVersion() const
{
  return m_version;
}

std::string Update::getModuleVersion()
{
  std::filesystem::path script_version_file = Installer::GetPaths().CETMMRoot() / "modules" / "version.lua";
  std::string line;
  std::ifstream file (script_version_file);

  if (!file.is_open())
  {
    spdlog::error("Couldn't open version.lua at: {}.", script_version_file.string());
    return "";
  }
  std::getline(file, line);
  file.close();

  std::size_t pos1 = line.find("\"");
  std::size_t pos2 = line.find("\"", pos1 + 1);
  std::string version = line.substr(pos1 + 1, pos2 - pos1 - 1);
  return version;
}

void Update::extractModule()
{
  spdlog::info("Extracting red4ext plugin..");
  std::filesystem::path pluginDir = Installer::GetPaths().Red4Ext() / "cet_mod_manager";
  bin2cppRed4ExtPlugin::FileManager& mgr_ext = bin2cppRed4ExtPlugin::FileManager::getInstance();
  bool saved_ext = mgr_ext.saveFiles(pluginDir.string().c_str());
  if (saved_ext)
    spdlog::info("Extracted Red4ext plugin file to \"{}\"", pluginDir.string());
  else
    spdlog::error("Failed to Red4ext plugin file to \"{}\"", pluginDir.string());

  spdlog::info("Extracting scripts..");
  std::filesystem::path scriptDir = Installer::GetPaths().CETMMRoot();
  bin2cppLooseFiles::FileManager& mgr_loose = bin2cppLooseFiles::FileManager::getInstance();
  bool saved_loose = mgr_loose.saveFiles(scriptDir.string().c_str());

  bin2cppLua::FileManager& mgr_lua = bin2cppLua::FileManager::getInstance();
  bool saved_lua = mgr_lua.saveFiles(scriptDir.string().c_str());
  if (saved_loose && saved_lua)
  {
    spdlog::info("Extracted script files to \"{}\"", scriptDir.string());
    setConfig(); // white update
  }
  else
    spdlog::error("Failed to extract script files to \"{}\"", scriptDir.string());
}

void Update::removeOldModule()
{
  spdlog::info("Removing old files..");

  {
    std::filesystem::path pluginPath = Installer::GetPaths().Red4Ext() / "cet_mod_manager" / "cet_mod_manager.dll";
    std::error_code ec;
    std::filesystem::remove(pluginPath, ec);
    if (ec)
      spdlog::error("Failed to remove: {}. Error: {}", pluginPath.string(), ec.message());
    spdlog::info("Removed: {}", pluginPath.string());
  }

  std::vector<std::filesystem::path> exclude_files = {"dofiles", "config.json", "cet_mod_manager.log", "cet_mod_manager_asi.log"};
  for (auto const& dir_entry : std::filesystem::directory_iterator{Installer::GetPaths().CETMMRoot()}) 
  {
    if (std::find(exclude_files.begin(), exclude_files.end(), dir_entry.path().filename()) == exclude_files.end())
    {
      std::error_code ec;
      std::filesystem::remove_all(dir_entry.path(), ec);
      if (ec)
        spdlog::error("Failed to remove: {}. Error: {}", dir_entry.path().string(), ec.message());
      spdlog::info("Removed: {}", dir_entry.path().string());
    }
  }
}

void Update::setConfig()  // white update
{
  spdlog::info("Updating theme config..");

  std::filesystem::path configPath = Installer::GetPaths().CETMMRoot() / "config.json";

  std::fstream file;
  file.open(configPath, std::fstream::in | std::fstream::out);
  if (!file.is_open()) return;

  nlohmann::json cetmm_config = nlohmann::json::parse(file);
  std::filesystem::resize_file(configPath, 0);
  file.seekg(0);
  
  cetmm_config["theme"] = "white";

  file << cetmm_config.dump() << std::endl;
  file.close();
}