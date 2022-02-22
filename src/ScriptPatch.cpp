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
}

void ScriptPatch::RevertScript()
{
  m_script_lines.erase(std::remove(m_script_lines.begin(), m_script_lines.end(), m_CETMM_require), m_script_lines.end());
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

std::string ScriptPatch::GetModuleVersion()
{
  std::filesystem::path script_version_file = CETMM::GetPaths().CETMMASIRoot() / "scripts" / "modules" / "version.lua";
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

void ScriptPatch::UpdateModule()
{
  std::filesystem::create_directory(CETMM::GetPaths().CETMMASIRoot());
  std::filesystem::create_directory(CETMM::GetPaths().CETMMASIRoot() / "dofiles");

  // copy old dofiles from cet mods folder
  if (std::filesystem::exists(CETMM::GetPaths().CETMMRoot() / "dofiles"))
  {
    spdlog::info("Found old dofiles, copying to new location..");
    std::error_code ec_dofiles;
    std::filesystem::copy(CETMM::GetPaths().CETMMRoot() / "dofiles", CETMM::GetPaths().CETMMASIRoot() / "dofiles", ec_dofiles);

    if (ec_dofiles)
      spdlog::error("Failed to copy files from {} to {}. Error message: {}.", (CETMM::GetPaths().CETMMRoot() / "dofiles").string(), (CETMM::GetPaths().CETMMASIRoot() / "dofiles").string(), ec_dofiles.message());
  }

  // remove old files from cet mods folder
  if (std::filesystem::exists(CETMM::GetPaths().CETMMRoot()))
  {
    spdlog::info("Found old scripts, uninstalling..");
    if (!std::filesystem::remove_all(CETMM::GetPaths().CETMMRoot()))
      spdlog::error("Failed to remove old scripts at: {}.", CETMM::GetPaths().CETMMRoot().string());
  }

  // Extract scripts
  if (!std::filesystem::is_directory(m_scriptDir))
  {
    std::filesystem::create_directory(m_scriptDir);
    spdlog::info("Scripts doesn't exist, extracting scripts..", m_scriptDir.string());
    ExtractModule();
  }
  else if (GetModuleVersion() != CETMM::GetUpdate().GetVersion())
  {
    spdlog::info("Old scripts version found, updating scripts.");
    if (!std::filesystem::remove_all(m_scriptDir))
      spdlog::error("Failed to remove old scripts at: {}.", m_scriptDir.string());
    else
      ExtractModule();
  }
}

void ScriptPatch::CopyModule()
{
  const auto copyOptions = std::filesystem::copy_options::recursive | std::filesystem::copy_options::create_hard_links;

  // Copy core
  std::filesystem::create_directory(CETMM::GetPaths().CETScripts() / "cet_mod_manager");

  std::error_code ec_core;
  std::filesystem::copy(m_scriptDir / "modules" / "core", CETMM::GetPaths().CETScripts() / "cet_mod_manager", copyOptions, ec_core);

  if (ec_core)
    spdlog::error("Failed to create hardlinks from {} to {}. Error message: {}.", (m_scriptDir / "modules" / "core").string(), (CETMM::GetPaths().CETScripts() / "cet_mod_manager").string(), ec_core.message());

  // Copy imgui
  std::filesystem::create_directory(CETMM::GetPaths().CETMMRoot());

  std::error_code ec_imgui;
  std::filesystem::copy(m_scriptDir, CETMM::GetPaths().CETMMRoot(), copyOptions, ec_imgui);

  if (ec_imgui)
    spdlog::error("Failed to create hardlinks from {} to {}. Error message: {}.", m_scriptDir.string(), CETMM::GetPaths().CETMMRoot().string(), ec_imgui.message());

  // Copy log and config
  std::error_code ec_log;
  std::error_code ec_config;
  if (std::filesystem::exists(CETMM::GetPaths().CETMMASIRoot() / "cet_mod_manager_scripts.log"))
    std::filesystem::copy(CETMM::GetPaths().CETMMASIRoot() / "cet_mod_manager_scripts.log", CETMM::GetPaths().CETMMRoot() / "cet_mod_manager.log", std::filesystem::copy_options::create_hard_links, ec_log);
  if (ec_log)
    spdlog::error("Failed to create hardlinks from {} to {}. Error message: {}.", (CETMM::GetPaths().CETMMASIRoot() / "cet_mod_manager_scripts.log").string(), (CETMM::GetPaths().CETMMRoot() / "cet_mod_manager.log").string(), ec_log.message());

  if (std::filesystem::exists(CETMM::GetPaths().CETMMASIRoot() / "config.json"))
    std::filesystem::copy(CETMM::GetPaths().CETMMASIRoot() / "config.json", CETMM::GetPaths().CETMMRoot() / "config.json", std::filesystem::copy_options::create_hard_links, ec_config);
  if (ec_config)
    spdlog::error("Failed to create hardlinks from {} to {}. Error message: {}.", (CETMM::GetPaths().CETMMASIRoot() / "config.json").string(), (CETMM::GetPaths().CETMMRoot() / "config.json").string(), ec_config.message());
}

void ScriptPatch::RemoveModule()
{
  // create hardlink for log and config if not exist
  std::error_code ec_log;
  std::error_code ec_config;
  if (!std::filesystem::exists(CETMM::GetPaths().CETMMASIRoot() / "cet_mod_manager_scripts.log"))
    std::filesystem::copy(CETMM::GetPaths().CETMMRoot() / "cet_mod_manager.log", CETMM::GetPaths().CETMMASIRoot() / "cet_mod_manager_scripts.log", std::filesystem::copy_options::create_hard_links, ec_log);
  if (ec_log)
    spdlog::error("Failed to create hardlinks from {} to {}. Error message: {}.", (CETMM::GetPaths().CETMMRoot() / "cet_mod_manager.log").string(), (CETMM::GetPaths().CETMMASIRoot() / "cet_mod_manager_scripts.log").string(), ec_log.message());

  if (!std::filesystem::exists(CETMM::GetPaths().CETMMASIRoot() / "config.json"))
    std::filesystem::copy(CETMM::GetPaths().CETMMRoot() / "config.json", CETMM::GetPaths().CETMMASIRoot() / "config.json", std::filesystem::copy_options::create_hard_links, ec_config);
  if (ec_config)
    spdlog::error("Failed to create hardlinks from {} to {}. Error message: {}.", (CETMM::GetPaths().CETMMRoot() / "config.json").string(), (CETMM::GetPaths().CETMMASIRoot() / "config.json").string(), ec_config.message());

  // remove core
  if (!std::filesystem::remove_all(CETMM::GetPaths().CETScripts() / "cet_mod_manager"))
    spdlog::error("Failed to remove {}.", (CETMM::GetPaths().CETScripts() / "cet_mod_manager").string());
  
  // remove imgui
  if (!std::filesystem::remove_all(CETMM::GetPaths().CETMMRoot()))
    spdlog::error("Failed to remove {}.", CETMM::GetPaths().CETMMRoot().string());
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
    j_paths["cetmmAsiRoot"] = CETMM::GetPaths().CETMMASIRoot().string();
    j_paths["red4ext"] = CETMM::GetPaths().Red4Ext().string();
    j_paths["redscript"] = CETMM::GetPaths().RedScript().string();

    std::ofstream o(CETMM::GetPaths().CETScripts() / "cet_mod_manager" / "paths.json");
    o << std::setw(4) << j_paths << std::endl;
    o.close();
}

void ScriptPatch::Initialize()
{
  m_scriptDir = CETMM::GetPaths().CETMMASIRoot() / "scripts";
  UpdateModule();
  m_scriptPath = CETMM::GetPaths().CETScripts() / "autoexec.lua";
  m_readSuccess = ReadScript();
  if (m_readSuccess)
  {
    CopyModule();
    ExportPaths();
    PatchScript();
    WriteScript();
  }
}

void ScriptPatch::Shutdown()
{
  if (m_readSuccess)
  {
    RevertScript();
    WriteScript();
    RemoveModule();
  }
}
