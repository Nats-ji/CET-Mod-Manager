#include "pch.h"
#include "Misc.h"

void Misc::openFolder(std::filesystem::path aFolder)
{
  ShellExecute(NULL, NULL, aFolder.wstring().c_str(), NULL, NULL, SW_SHOWNORMAL);
}

void Misc::openUrl(std::string aUrl)
{
  ShellExecuteA(NULL, NULL, aUrl.c_str(), NULL, NULL , SW_SHOWNORMAL);
}