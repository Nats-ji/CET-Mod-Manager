#pragma once

#include "Version.h"

class Update
{
public:
  void LogVersion();
  void RemoveOldFiles();
  const std::string GetVersion() const;

private:
  const std::string m_version = CETMM_VERSION;
  const std::vector<std::string> m_file_list = CETMM_FILE_LIST;
  const std::vector<std::string> m_ignore_list = {"config.json", "dofiles"};

  std::string getLastVersion();
};