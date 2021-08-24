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

void ScriptPatch::CopyModule()
{
  if (!std::filesystem::create_directory(CETMM::GetPaths().CETScripts() / "cet_mod_manager"))
    spdlog::error("Failed to create directory at: {}.", (CETMM::GetPaths().CETScripts() / "cet_mod_manager").string());

  std::error_code ec;
  std::filesystem::create_hard_link(CETMM::GetPaths().CETMMRoot() / "scripts" / "filesystem.lua", CETMM::GetPaths().CETScripts() / "cet_mod_manager" / "filesystem.lua", ec);

  if (ec)
    spdlog::error("Failed to copy {} to {}. Error message: {}.", (CETMM::GetPaths().CETMMRoot() / "scripts" / "filesystem.lua").string(), (CETMM::GetPaths().CETScripts() / "cet_mod_manager" / "filesystem.lua").string(), ec.message());
}

void ScriptPatch::RemoveModule()
{
  if (!std::filesystem::remove_all(CETMM::GetPaths().CETScripts() / "cet_mod_manager"))
    spdlog::error("Failed to remove {}.", (CETMM::GetPaths().CETScripts() / "cet_mod_manager").string());
}

void ScriptPatch::Initialize()
{
  m_scriptPath = CETMM::GetPaths().CETScripts() / "autoexec.lua";
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
