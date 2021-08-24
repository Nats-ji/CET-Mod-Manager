#include "pch.h"

#include "CETMM.h"

void CETMM::Initialize()
{
  GetScriptPatch().Initialize();
}

void CETMM::Shutdown()
{
  GetScriptPatch().Shutdown();
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

ScriptPatch& CETMM::GetScriptPatch()
{
  return Get().m_scriptPatch;
}