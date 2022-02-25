#include "pch.h"

#include "Update.h"
#include "embeds/EmbedFileManager.h"
#include "embeds/EmbedScriptFileManager.h"

void Update::LogVersion()
{
  spdlog::info("CETMM version: {}", m_version);
}

void Update::UpdateModule()
{
  std::filesystem::path scriptDir = CETMM::GetPaths().CETMMRoot();

  if (!std::filesystem::exists(scriptDir / "modules" / "version.lua"))
  {
    spdlog::info("Scripts doesn't exist, extracting scripts..", scriptDir.string());
    removeOldModule();
    extractModule();
  }
  else if (getModuleVersion() != m_version)
  {
    spdlog::info("Old scripts version found, updating scripts.");
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
  std::filesystem::path script_version_file = CETMM::GetPaths().CETMMRoot() / "modules" / "version.lua";
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
  std::filesystem::path scriptDir = CETMM::GetPaths().CETMMRoot();
  bin2cpp::FileManager& mgr = bin2cpp::FileManager::getInstance();
  bool saved = mgr.saveFiles(scriptDir.string().c_str());

  bin2cppScript::FileManager& mgr_script = bin2cppScript::FileManager::getInstance();
  bool saved_script = mgr_script.saveFiles(scriptDir.string().c_str());
  if (saved && saved_script)
    spdlog::info("Extracted script files to \"{}\"", scriptDir.string());
  else
    spdlog::error("Failed to extract script files to \"{}\"", scriptDir.string());
}

void Update::removeOldModule()
{
  std::vector<std::filesystem::path> exclude_files = {"dofiles", "config.json", "cet_mod_manager.log", "cet_mod_manager_asi.log"};
  for (auto const& dir_entry : std::filesystem::directory_iterator{CETMM::GetPaths().CETMMRoot()}) 
  {
    if (std::find(exclude_files.begin(), exclude_files.end(), dir_entry.path().filename()) == exclude_files.end())
    {
      if (!std::filesystem::remove_all(dir_entry.path()))
        spdlog::error("Failed to remove: {}.", dir_entry.path().string());
    }
  }
}