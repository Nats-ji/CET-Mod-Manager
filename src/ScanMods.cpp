#include "pch.h"

#include "ScanMods.h"

void ScanMods::Scan()
{
  m_modlistPath = CETMM::GetPaths().CETMMRoot() / "mod_list.json";
  m_archive = scan_mods(CETMM::GetPaths().Archives(), ".archive");
  m_asi = scan_mods(CETMM::GetPaths().Plugins(), ".asi");
  m_cet = scan_mods(CETMM::GetPaths().CETMods(), "init.lua", true, true);
  m_red4ext = scan_mods(CETMM::GetPaths().Red4Ext(), ".dll");
  m_redscript = scan_mods(CETMM::GetPaths().RedScript(), ".reds", true);
  save_modlist();
}

void ScanMods::Shutdown()
{
  if (!std::filesystem::remove(m_modlistPath))
    spdlog::error("Failed to remove {}.", (m_modlistPath).string());
}

std::vector<std::string> ScanMods::scan_mods(const std::filesystem::path aPath, const std::string aExtension, bool aCheckFolder, bool aCET)
{
  std::vector<std::string> mod_list;
  if (std::filesystem::is_directory(aPath))
  {
    for (const auto& entry : std::filesystem::directory_iterator(aPath))
    {
      if (aCheckFolder && entry.is_directory())
      {
        for (const auto& sub_entry : std::filesystem::directory_iterator(entry.path()))
        {
          if (aCET && sub_entry.is_regular_file() && sub_entry.path().filename() == aExtension)
          {
            mod_list.push_back(entry.path().filename().string());
            break;
          }
          else if (sub_entry.is_regular_file() && sub_entry.path().extension() == aExtension)
          {
            mod_list.push_back(entry.path().filename().string());
            break;
          }
        }
      }
      else if (!aCET && entry.is_regular_file() && entry.path().extension() == aExtension)
        mod_list.push_back(entry.path().filename().string());
    }
  }
  return mod_list;
}

void ScanMods::save_modlist()
{
  nlohmann::json j_modlist;
  j_modlist["archive"] = m_archive;
  j_modlist["asi"] = m_asi;
  j_modlist["cet"] = m_cet;
  j_modlist["red4ext"] = m_red4ext;
  j_modlist["redscript"] = m_redscript;

  std::ofstream o(m_modlistPath);
  o << std::setw(4) << j_modlist << std::endl;
  o.close();
}