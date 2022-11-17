#pragma once

#include "Mods.h"
#include "Fonts.h"
#include "Uninstall.h"

struct CETMMEXT : RED4ext::IScriptable
{
public:
  CETMMEXT() {};
  RED4ext::CClass *GetNativeType();

private:

};

namespace RED4ext_CETMM
{
  void GetMods(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, RED4ext::Handle<Mods>* aOut, int64_t a4);
  void GetFonts(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, RED4ext::Handle<Fonts>* aOut, int64_t a4);
  void GetUninstall(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, RED4ext::Handle<Uninstall>* aOut, int64_t a4);
  void OpenModsFolder(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, void* aOut, int64_t a4);
  void OpenDofilesFolder(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, void* aOut, int64_t a4);
  void OpenUrl(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, void* aOut, int64_t a4);
  void RestartGame(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, void* aOut, int64_t a4);

  void Register();
  void PostRegister();
}