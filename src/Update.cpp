#include "pch.h"

#include "Update.h"

void Update::LogVersion()
{
  spdlog::info(m_version);
  for(auto file : m_file_list)
  {
    spdlog::info(file);
  }
}

const std::string Update::GetVersion() const
{
  return m_version;
}