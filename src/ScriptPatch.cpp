#include "pch.h"
#include "ScriptPatch.h"
#include "embeds/EmbedFileManager.h"

bool ScriptPatch::ReadScript()
{
  std::string line;
  std::ifstream file (m_scriptPath);

  if (!file.is_open())
  {
    spdlog::error("Couldn't open autoexec.lua at: {}.", m_scriptPath.string());
    return false;
  }

  while (std::getline(file, line))
  {
    m_script_lines.push_back(line);
  }

  file.close();
  return true;
}

void ScriptPatch::WriteScript()
{
  std::ofstream file (m_scriptPath);
  if (file.fail())
  {
    spdlog::error("Couldn't write to autoexec.lua at: {}", m_scriptPath.string());
    return;
  }

  for (unsigned int i = 0; i < m_script_lines.size(); i++)
  {
    file << m_script_lines[i] << "\n";
    std::cout << m_script_lines[i] << "\n";
  }

  file.close();
}

void ScriptPatch::PatchScript()
{
  bool found_CETMM_require = false;
  for (unsigned int i = 0; i < m_script_lines.size(); i++)
  {
      if (m_script_lines[i].find("CETMM") != std::string::npos && m_script_lines[i] != m_CETMM_require)
      {
          m_script_lines[i] = m_CETMM_require;
      }
      if (m_script_lines[i] == m_CETMM_require)
          found_CETMM_require = true;
  }
  if (!found_CETMM_require)
      m_script_lines.insert(m_script_lines.begin() + 1, m_CETMM_require);

  WriteScript();
}

void ScriptPatch::RevertScript()
{
  m_script_lines.erase(std::remove(m_script_lines.begin(), m_script_lines.end(), m_CETMM_require), m_script_lines.end());
  WriteScript();
}

std::string ScriptPatch::GetModuleVersion()
{
  std::filesystem::path script_version_file = m_scriptDir / "modules" / "version.lua";
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

void ScriptPatch::ExtractModule()
{
  bin2cpp::FileManager& mgr = bin2cpp::FileManager::getInstance();
  bool saved = mgr.saveFiles(m_scriptDir.string().c_str());
  if (saved)
    spdlog::info("Extracted script files to \"{}\"", m_scriptDir.string());
  else
    spdlog::error("Failed to extract script files to \"{}\"", m_scriptDir.string());
}

void ScriptPatch::RemoveOldModule()
{
  std::vector<std::filesystem::path> exclude_files = {"dofiles", "config.json", "cet_mod_manager.log", "cet_mod_manager_asi.log"};
  for (auto const& dir_entry : std::filesystem::directory_iterator{m_scriptDir}) 
  {
    if (std::find(exclude_files.begin(), exclude_files.end(), dir_entry.path().filename()) == exclude_files.end())
    {
      if (!std::filesystem::remove_all(dir_entry.path()))
        spdlog::error("Failed to remove: {}.", dir_entry.path().string());
    }
  }
}

void ScriptPatch::UpdateModule()
{
  std::filesystem::create_directory(m_scriptDir / "dofiles");

  if (!std::filesystem::exists(m_scriptDir / "modules" / "version.lua"))
  {
    spdlog::info("Scripts doesn't exist, extracting scripts..", m_scriptDir.string());
    RemoveOldModule();
    ExtractModule();
  }
  else if (GetModuleVersion() != CETMM::GetUpdate().GetVersion())
  {
    spdlog::info("Old scripts version found, updating scripts.");
    RemoveOldModule();
    ExtractModule();
  }
}

void ScriptPatch::CopyCoreModule()
{
  const auto copyOptions = std::filesystem::copy_options::recursive | std::filesystem::copy_options::create_hard_links;

  std::filesystem::create_directory(CETMM::GetPaths().CETScripts() / "cet_mod_manager");

  std::error_code ec_core;
  std::filesystem::copy(m_scriptDir / "modules" / "core", CETMM::GetPaths().CETScripts() / "cet_mod_manager", copyOptions, ec_core);

  if (ec_core)
    spdlog::error("Failed to create hardlinks from {} to {}. Error message: {}.", (m_scriptDir / "modules" / "core").string(), (CETMM::GetPaths().CETScripts() / "cet_mod_manager").string(), ec_core.message());
}

void ScriptPatch::RemoveCoreModule()
{
  if (!std::filesystem::remove_all(CETMM::GetPaths().CETScripts() / "cet_mod_manager"))
    spdlog::error("Failed to remove {}.", (CETMM::GetPaths().CETScripts() / "cet_mod_manager").string());
}

void ScriptPatch::ExportPaths()
{
    nlohmann::json j_paths;
    j_paths["gameRoot"] = CETMM::GetPaths().GameRoot().string();
    j_paths["archive"] = CETMM::GetPaths().Archives().string();
    j_paths["plugins"] = CETMM::GetPaths().Plugins().string();
    j_paths["cetmods"] = CETMM::GetPaths().CETMods().string();
    j_paths["cetscripts"] = CETMM::GetPaths().CETScripts().string();
    j_paths["cetmmRoot"] = CETMM::GetPaths().CETMMRoot().string();
    j_paths["red4ext"] = CETMM::GetPaths().Red4Ext().string();
    j_paths["redscript"] = CETMM::GetPaths().RedScript().string();

    std::ofstream o(CETMM::GetPaths().CETScripts() / "cet_mod_manager" / "paths.json");
    o << std::setw(4) << j_paths << std::endl;
    o.close();
}

void ScriptPatch::Initialize()
{
  m_scriptDir = CETMM::GetPaths().CETMMRoot();
  UpdateModule();
  m_scriptPath = CETMM::GetPaths().CETScripts() / "autoexec.lua";
  m_readSuccess = ReadScript();
  if (m_readSuccess)
  {
    CopyCoreModule();
    ExportPaths();
    PatchScript();
  }
}

void ScriptPatch::Shutdown()
{
  if (m_readSuccess)
  {
    RevertScript();
    RemoveCoreModule();
  }
}
