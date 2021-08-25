#pragma once

struct ScanMods
{
public:
  void Scan();
  void Shutdown();

private:
  std::filesystem::path m_modlistPath;
  std::vector<std::string> m_archive;
  std::vector<std::string> m_asi;
  std::vector<std::string> m_cet;
  std::vector<std::string> m_red4ext;
  std::vector<std::string> m_redscript;

  std::vector<std::string> scan_mods(const std::filesystem::path aPath, const std::string aExtension, bool aCheckFolder = false, bool aCET = false);
  void save_modlist();
};