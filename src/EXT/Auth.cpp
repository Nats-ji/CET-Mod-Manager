#include "Auth.h"


void Auth::Initialize() {
  genAuthCode();
  writeAuthCodeToFile();
  writeRandNamesToFile();
}

void Auth::Uninitialize() {
  revertFiles();
}

bool Auth::Authenticate(std::string aAuthCode) {
  return aAuthCode == m_authCode;
}

std::string Auth::RandomizeName(std::string aClassName)
{
  if (m_randNames.find(aClassName) != m_randNames.end())
    return m_randNames[aClassName];
  else
  {
    std::string rand_name = Utilities::random_string(m_randStrLength);
    m_randNames.insert({aClassName, rand_name});
    return rand_name;
  }
}

const std::string Auth::GetClassName(std::string aClassName)
{
  if (m_randNames.find(aClassName) != m_randNames.end())
  {
    return m_randNames[aClassName];
  }
  else
    spdlog::error("Can't get the hash of class: {}.", aClassName);
}

void Auth::genAuthCode()
{
  m_authCode = Utilities::random_string(m_randStrLength);
}

void Auth::writeAuthCodeToFile() {}
void Auth::writeRandNamesToFile() {
  std::string file_content = fmt::format(\
R"(local CETMMEXT = {{
  OpenFolder = {CETMM}.OpenFolder,
  OpenUrl = {CETMM}.OpenUrl,
}}

return CETMMEXT)",
          fmt::arg("CETMM", GetClassName("CETMM")));
  std::filesystem::path file_path = CETMM::GetPaths().RandNames();
  // write to file
}
void Auth::revertFiles() {
  // remove this file
  CETMM::GetPaths().RandNames();
}