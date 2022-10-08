#include "pch.h"
#include "Misc.h"
#include "CETMMEXT.h"

// RED4ext impl

RED4ext::TTypedClass<CETMMEXT> cls("CETMM");

RED4ext::CClass* CETMMEXT::GetNativeType()
{
  return &cls;
}


// functions
void RED4ext_CETMM::GetMods(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, Mods* aOut, int64_t a4)
{
  RED4EXT_UNUSED_PARAMETER(aContext);
  RED4EXT_UNUSED_PARAMETER(aFrame);
  RED4EXT_UNUSED_PARAMETER(a4);

  aFrame->code++;

  *aOut = CETMM::GetMods();
}

void RED4ext_CETMM::OpenModsFolder(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, void* aOut, int64_t a4)
{
  RED4EXT_UNUSED_PARAMETER(aContext);
  RED4EXT_UNUSED_PARAMETER(aFrame);
  RED4EXT_UNUSED_PARAMETER(aOut);
  RED4EXT_UNUSED_PARAMETER(a4);

  aFrame->code++;

  Misc::openFolder(CETMM::GetPaths().CETMods());
}

void RED4ext_CETMM::OpenDofilesFolder(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, void* aOut, int64_t a4)
{
  RED4EXT_UNUSED_PARAMETER(aContext);
  RED4EXT_UNUSED_PARAMETER(aFrame);
  RED4EXT_UNUSED_PARAMETER(aOut);
  RED4EXT_UNUSED_PARAMETER(a4);

  aFrame->code++;

  Misc::openFolder(CETMM::GetPaths().CETMMRoot() / "dofiles");
}

void RED4ext_CETMM::OpenUpdateUrl(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, void* aOut, int64_t a4)
{
  RED4EXT_UNUSED_PARAMETER(aContext);
  RED4EXT_UNUSED_PARAMETER(aFrame);
  RED4EXT_UNUSED_PARAMETER(aOut);
  RED4EXT_UNUSED_PARAMETER(a4);

  aFrame->code++;

  Misc::openUrl("https://www.nexusmods.com/cyberpunk2077/mods/895?tab=files");
}

// register

void RED4ext_CETMM::Register()
{
  RED4ext::CNamePool::Add("CETMM");
  cls.flags = {.isNative = true};
  RED4ext::CRTTISystem::Get()->RegisterType(&cls);
}

void RED4ext_CETMM::PostRegister()
{
  auto rtti = RED4ext::CRTTISystem::Get();

  auto func_getMods = RED4ext::CClassStaticFunction::Create(&cls, "GetMods", "GetMods", &GetMods, {.isNative = true, .isStatic = true});
  func_getMods->SetReturnType("Mods");
  cls.RegisterFunction(func_getMods);

  auto func_openModsFolder = RED4ext::CClassStaticFunction::Create(&cls, "OpenModsFolder", "OpenModsFolder", &OpenModsFolder, {.isNative = true, .isStatic = true});
  cls.RegisterFunction(func_openModsFolder);

  auto func_openDofilesFolder = RED4ext::CClassStaticFunction::Create(&cls, "OpenDofilesFolder", "OpenDofilesFolder", &OpenDofilesFolder, {.isNative = true, .isStatic = true});
  cls.RegisterFunction(func_openDofilesFolder);
  
  auto func_openUpdateUrl = RED4ext::CClassStaticFunction::Create(&cls, "OpenUpdateUrl", "OpenUpdateUrl", &OpenUpdateUrl, {.isNative = true, .isStatic = true});
  cls.RegisterFunction(func_openUpdateUrl);
}