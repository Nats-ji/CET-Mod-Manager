#pragma once

#include "pch.h"

class Auth
{
public:
  void Initialize();
  void Uninitialize();
  bool Authenticate(std::string aAuthCode);
  std::string RandomizeName(std::string aClassName);
  const std::string GetClassName(std::string aClassName);

private:
  int m_randStrLength {12};
  std::unordered_map<std::string, std::string> m_randNames;
  std::string m_authCode;

  void genAuthCode();
  void writeAuthCodeToFile();
  void writeRandNamesToFile();
  void revertFiles();
};
