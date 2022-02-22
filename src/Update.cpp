#include "pch.h"

#include "Update.h"

void Update::LogVersion()
{
  spdlog::info("CETMM version: {}", m_version);
}

void Update::RemoveOldFiles()
{
  if (!exists(CETMM::GetPaths().Config())) return;

  const std::string last_version = getLastVersion();

  if (last_version == m_version) return;

  // remove old files somehow
  
}

const std::string Update::GetVersion() const
{
  return m_version;
}

std::string Update::getLastVersion()
{
  std::string version;
  std::ifstream config_file(CETMM::GetPaths().Config());
  if (config_file)
  {
    nlohmann::json j = nlohmann::json::parse(config_file);
    version = j.value("version", version);
  }
  config_file.close();
  return version;
}