#include "pch.h"
#include "CETMM.h"

void CETMM::Initialize()
{
  // GetUpdate().UpdateModule();
  // GetMods().Scan();
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

Update& CETMM::GetUpdate()
{
  return Get().m_update;
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