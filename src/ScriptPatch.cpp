#include "ScriptPatch.h"

std::filesystem::path ScriptPatch::m_cwd;
std::string ScriptPatch::m_scriptPath;
std::string ScriptPatch::m_CETMM_require;
bool ScriptPatch::m_readSuccess;
std::vector<std::string> ScriptPatch::m_script_lines;

bool ScriptPatch::ReadScript()
{
  std::string line;
  std::ifstream file (m_cwd / m_scriptPath);

  if (!file.is_open())
  {
    spdlog::error("Couldn't open autoexec.lua at: {}.", (m_cwd / m_scriptPath).string());
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
  std::ofstream file (m_cwd / m_scriptPath);
  if (file.fail())
  {
    spdlog::error("Couldn't write to autoexec.lua at: {}", (m_cwd / m_scriptPath).string());
    return;
  }

  for (unsigned int i = 0; i < m_script_lines.size(); i++)
  {
    file << m_script_lines[i] << "\n";
    std::cout << m_script_lines[i] << "\n";
  }

  file.close();
}

void ScriptPatch::CopyModule()
{
  if (!std::filesystem::create_directory(m_cwd / "cyber_engine_tweaks/scripts/cet_mod_manager"))
    spdlog::error("Failed to create directory at: {}.", (m_cwd / "cyber_engine_tweaks/scripts/cet_mod_manager").string());

  std::error_code ec;
  std::filesystem::copy(m_cwd / "cyber_engine_tweaks/mods/cet_mod_manager/scripts/filesystem.lua", m_cwd / "cyber_engine_tweaks/scripts/cet_mod_manager/filesystem.lua", ec);

  if (ec)
    spdlog::error("Failed to copy {} to {}. Error message: {}.", (m_cwd / "cyber_engine_tweaks/mods/cet_mod_manager/scripts/filesystem.lua").string(), (m_cwd / "cyber_engine_tweaks/scripts/cet_mod_manager/filesystem.lua").string(), ec.message());
}

void ScriptPatch::RemoveModule()
{
  if (!std::filesystem::remove_all(m_cwd / "cyber_engine_tweaks/scripts/cet_mod_manager"))
    spdlog::error("Failed to remove {}.", (m_cwd / "cyber_engine_tweaks/scripts/cet_mod_manager").string());
}

void ScriptPatch::Initialize()
{
  m_cwd = std::filesystem::current_path();
  m_scriptPath = "cyber_engine_tweaks/scripts/autoexec.lua";
  m_CETMM_require = "json.CETMM_fs = require 'cet_mod_manager/filesystem'";
  m_readSuccess = ReadScript();
  if (m_readSuccess)
  {
    CopyModule();
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
