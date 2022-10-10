#include "pch.h"
#include "CETMM.h"

void CETMM::Initialize()
{
  // GetUpdate().UpdateModule();
  // GetMods().Scan();
  // GetFonts().Scan();
}

void CETMM::Shutdown()
{}

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