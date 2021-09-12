#pragma once

class Update
{
public:
  void LogVersion();

private:
  const std::string m_version = CETMM_VERSION;
  const std::vector<std::string> m_file_list = CETMM_FILE_LIST;
};