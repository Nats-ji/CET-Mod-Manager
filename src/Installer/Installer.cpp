#include "pch.h"
#include "Installer.h"

void Installer::Initialize()
{
  GetUpdate().UpdateModule();
}

void Installer::Shutdown()
{

}

Installer& Installer::Get()
{
  static Installer instance;
  return instance;
}

const Paths& Installer::GetPaths()
{
  return Get().m_paths;
}

Update& Installer::GetUpdate()
{
  return Get().m_update;
}