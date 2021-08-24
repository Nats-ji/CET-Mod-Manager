#pragma once

#include "Paths.h"
#include "ScriptPatch.h"

class CETMM
{
public:
  static void Initialize();
  static void Shutdown();
  static CETMM& Get();

  static const Paths& GetPaths();
  static ScriptPatch& GetScriptPatch();

  CETMM(const CETMM&) = delete;
  CETMM(CETMM&&) = delete;
  CETMM& operator=(const CETMM&) = delete;
  CETMM& operator=(CETMM&&) = delete;

private:
  CETMM() {}
  ~CETMM() {}

  Paths m_paths;
  ScriptPatch m_scriptPatch;
};