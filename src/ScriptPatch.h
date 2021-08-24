#pragma once

struct ScriptPatch
{
  void Initialize();
  void Shutdown();

private:

  std::filesystem::path m_scriptPath;
  const std::string m_CETMM_require {"json.CETMM_fs = require 'cet_mod_manager/filesystem'"};
  bool m_readSuccess;
  std::vector<std::string> m_script_lines;

  bool ReadScript();
  void PatchScript();
  void RevertScript();
  void WriteScript();
  void CopyModule();
  void RemoveModule();
};