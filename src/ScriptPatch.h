#pragma once

struct ScriptPatch
{
  void Initialize();
  void Shutdown();

private:

  std::filesystem::path m_scriptDir;
  std::filesystem::path m_scriptPath;
  const std::string m_CETMM_require {"require 'cet_mod_manager/core'"};

  bool m_readSuccess;
  std::vector<std::string> m_script_lines;

  bool ReadScript();
  void PatchScript();
  void RevertScript();
  void WriteScript();
  std::string GetModuleVersion();
  void ExtractModule();
  void UpdateModule();
  void CopyModule();
  void RemoveModule();
  void ExportPaths();
};