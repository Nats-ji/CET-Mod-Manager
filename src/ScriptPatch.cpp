#include "pch.h"
#include "ScriptPatch.h"

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
      spdlog::info("Found leftover patched script for previous version, repatching..");
    }
    if (m_script_lines[i] == m_CETMM_require)
    {
      found_CETMM_require = true;
      spdlog::info("Patched script already exists, skipping..");
    }
  }
  if (!found_CETMM_require)
  {
    m_script_lines.insert(m_script_lines.begin() + 1, m_CETMM_require);
    spdlog::info("Patching script..");
  }

  WriteScript();
}

void ScriptPatch::RevertScript()
{
  m_script_lines.erase(std::remove(m_script_lines.begin(), m_script_lines.end(), m_CETMM_require), m_script_lines.end());
  WriteScript();
}

bool ScriptPatch::IsFileSystemNTFS()
{
  std::filesystem::path root_path_name = CETMM::GetPaths().CETMMRoot().root_path();
  wchar_t file_system_name[MAX_PATH];
  if (!GetVolumeInformation((LPCWSTR)root_path_name.wstring().c_str(), NULL, 0, NULL, NULL, NULL, file_system_name, MAX_PATH))
    spdlog::error("Failed to get volume information.");
  std::wstring fsn(file_system_name);
  std::wstring ntfs = L"NTFS";
  if(fsn == ntfs)
  {
    spdlog::info("File System is NTFS. Using hardlink.");
    return true;
  }
  else
  {
    spdlog::info("File System not NTFS. Using copy.");
    return false;
  }
}

void ScriptPatch::CopyCoreModule()
{
  if (std::filesystem::exists(CETMM::GetPaths().CETScripts() / "cet_mod_manager"))
  {
    RemoveCoreModule();
    spdlog::info("Found old core module, removing..");
  }
  else
    std::filesystem::create_directory(CETMM::GetPaths().CETScripts() / "cet_mod_manager");

  std::error_code ec_core;

  // use hardlink if filesystem is NTFS
  if (IsFileSystemNTFS())
  {
    std::filesystem::copy(m_scriptDir / "modules" / "core", CETMM::GetPaths().CETScripts() / "cet_mod_manager", std::filesystem::copy_options::overwrite_existing | std::filesystem::copy_options::recursive | std::filesystem::copy_options::create_hard_links, ec_core);
    if (ec_core)
      spdlog::error("Failed to create hardlinks from {} to {}. Error message: {}.", (m_scriptDir / "modules" / "core").string(), (CETMM::GetPaths().CETScripts() / "cet_mod_manager").string(), ec_core.message());
  }
  else
  {
    std::filesystem::copy(m_scriptDir / "modules" / "core", CETMM::GetPaths().CETScripts() / "cet_mod_manager", std::filesystem::copy_options::overwrite_existing | std::filesystem::copy_options::recursive, ec_core);
    if (ec_core)
      spdlog::error("Failed to copy files from {} to {}. Error message: {}.", (m_scriptDir / "modules" / "core").string(), (CETMM::GetPaths().CETScripts() / "cet_mod_manager").string(), ec_core.message());
  }
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
