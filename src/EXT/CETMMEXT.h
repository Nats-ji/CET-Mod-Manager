#pragma once

struct CETMMEXT : RED4ext::IScriptable
{
public:
  CETMMEXT() {};
  RED4ext::CClass *GetNativeType();

private:

};

namespace RED4ext_CETMM
{
  void GetMods(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, Mods* aOut, int64_t a4);
  void OpenModsFolder(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, void* aOut, int64_t a4);
  void OpenDofilesFolder(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, void* aOut, int64_t a4);
  void OpenUpdateUrl(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, void* aOut, int64_t a4);

  void Register();
  void PostRegister();
}