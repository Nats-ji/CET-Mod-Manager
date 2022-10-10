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

void Misc::restartGame()
{
  spdlog::info("restarting game: {}", CETMM::GetPaths().EXE().string().c_str());
  STARTUPINFO lpStartupInfo;
  PROCESS_INFORMATION lpProcessInfo;

  ZeroMemory( &lpStartupInfo, sizeof( lpStartupInfo ) );
  lpStartupInfo.cb = sizeof( lpStartupInfo );
  ZeroMemory( &lpProcessInfo, sizeof( lpProcessInfo ) );

  LPWSTR cmdArgs = LPWSTR(L" -modded");
  CreateProcess( CETMM::GetPaths().EXE().wstring().c_str(),
                  cmdArgs, NULL, NULL,
                  NULL, NULL, NULL, NULL,
                  &lpStartupInfo,
                  &lpProcessInfo
                  );
}