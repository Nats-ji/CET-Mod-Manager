#include "pch.h"

#include "CETMM.h"

void CETMM::Initialize()
{
  GetScriptPatch().Initialize();
  GetScanMods().Scan();
  GetUpdate().LogVersion();
}

void CETMM::Shutdown()
{
  GetScriptPatch().Shutdown();
  GetScanMods().Shutdown();
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

ScanMods& CETMM::GetScanMods()
{
  return Get().m_scanMods;
}

ScriptPatch& CETMM::GetScriptPatch()
{
  return Get().m_scriptPatch;
}

Update& CETMM::GetUpdate()
{
  return Get().m_update;
}