#include "pch.h"
#include "CETMM.h"

void CETMM::Initialize()
{
  // GetFonts().Scan();
}

void CETMM::Shutdown()
{

  // final execute;
  if (ShouldRestart())
    Get().restartGame();
}

CETMM& CETMM::Get()
{
  static CETMM instance;
  return instance;
}

const Paths& CETMM::GetPaths()
{
  return Get().m_paths;
}

Mods& CETMM::GetMods()
{
  return Get().m_mods;
}

Fonts& CETMM::GetFonts()
{
  return Get().m_fonts;
}

CETMMEXT& CETMM::GetCETMMEXT()
{
  return Get().m_cetmmext;
}

const bool CETMM::ShouldRestart()
{
  return Get().m_restart;
}

void CETMM::SetRestart(bool aRestart)
{
  Get().m_restart = aRestart;
}


void CETMM::restartGame()
{
  STARTUPINFO lpStartupInfo;
  PROCESS_INFORMATION lpProcessInfo;

  ZeroMemory( &lpStartupInfo, sizeof( lpStartupInfo ) );
  lpStartupInfo.cb = sizeof( lpStartupInfo );
  ZeroMemory( &lpProcessInfo, sizeof( lpProcessInfo ) );

  LPWSTR cmdArgs = LPWSTR(L" -modded"); // launch game with redmod enabled
  CreateProcess( GetPaths().EXE().wstring().c_str(),
                  cmdArgs, NULL, NULL,
                  NULL, NULL, NULL, NULL,
                  &lpStartupInfo,
                  &lpProcessInfo
                  );
}

void CETMM::uninstall()
{
    STARTUPINFO lpStartupInfo;
    PROCESS_INFORMATION lpProcessInfo;

    ZeroMemory( &lpStartupInfo, sizeof( lpStartupInfo ) );
    lpStartupInfo.cb = sizeof( lpStartupInfo );
    ZeroMemory( &lpProcessInfo, sizeof( lpProcessInfo ) );

    auto path = GetPaths().Red4Ext() / "cet_mod_manager";

    wchar_t cmdArgs [2 * MAX_PATH];
    // some hax to self delete
    swprintf ( cmdArgs, 2 * MAX_PATH, L"/c ping localhost -n 5 > nul & rmdir /s /q \"%s\"", path.wstring().c_str());

    CreateProcess( L"C:\\Windows\\System32\\cmd.exe",
                    cmdArgs, NULL, NULL,
                    FALSE, CREATE_NO_WINDOW, NULL, NULL,
                    &lpStartupInfo,
                    &lpProcessInfo
                    );
    CloseHandle(lpProcessInfo.hThread);
    CloseHandle(lpProcessInfo.hProcess);
}