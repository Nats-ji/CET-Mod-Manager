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

std::string Auth::RandomizeName(std::string aFuncName)
{
  if (m_randNames.find(aFuncName) != m_randNames.end())
    return m_randNames[aFuncName];
  else
  {
    std::string rand_name = Utilities::random_string(m_randStrLength);
    m_randNames.insert({aFuncName, rand_name});
    return rand_name;
  }
}

void Auth::genAuthCode()
{
  m_authCode = Utilities::random_string(m_randStrLength);
}

void Auth::writeAuthCodeToFile() {}
void Auth::writeRandNamesToFile() {}
void Auth::revertFiles() {
  CETMM::GetPaths().AuthCode();
  CETMM::GetPaths().RandNames();
}