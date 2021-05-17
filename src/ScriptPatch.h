#pragma once

#include "pch.h"

struct ScriptPatch
{
  static void Initialize();
  static void Shutdown();

private:

  static std::filesystem::path m_cwd;
  static std::string m_scriptPath;
  static std::string m_CETMM_require;
  static bool m_readSuccess;
  static std::vector<std::string> m_script_lines;

  static bool ReadScript();
  static void PatchScript();
  static void RevertScript();
  static void WriteScript();
  static void CopyModule();
  static void RemoveModule();
};