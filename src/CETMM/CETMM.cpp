#include "pch.h"
#include "CETMM.h"

void CETMM::Initialize()
{
  // GetFonts().Scan();
  GetUninstall().Initialize();
}

void CETMM::Shutdown()
{

  // final execute;
  if (ShouldRestart())
    Get().restartGame();

  GetUninstall().Uninitialize();
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

Uninstall& CETMM::GetUninstall()
{
  return Get().m_uninstall;
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