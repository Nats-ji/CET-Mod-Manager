#include "pch.h"
#include "Misc.h"
#include "CETMMEXT.h"
#include "RED4ext/Scripting/Natives/Generated/ink/ISystemRequestsHandler.hpp"

// RED4ext impl

RED4ext::TTypedClass<CETMMEXT> cls("CETMMEXT");

RED4ext::CClass* CETMMEXT::GetNativeType()
{
  return &cls;
}


// functions
void RED4ext_CETMM::GetMods(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, RED4ext::Handle<Mods>* aOut, int64_t a4)
{
  aFrame->code++;

  if (aOut)
  {
    RED4ext::Handle<Mods> handle(&CETMM::GetMods());
    auto type = RED4ext::CRTTISystem::Get()->GetType("handle:Mods");
    type->Assign(aOut, &handle);
  }
}

void RED4ext_CETMM::GetFonts(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, RED4ext::Handle<Fonts>* aOut, int64_t a4)
{
  aFrame->code++;

  if (aOut)
  {
    RED4ext::Handle<Fonts> handle(&CETMM::GetFonts());
    auto type = RED4ext::CRTTISystem::Get()->GetType("handle:Fonts");
    type->Assign(aOut, &handle);
  }
}

void RED4ext_CETMM::OpenModsFolder(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, void* aOut, int64_t a4)
{
  aFrame->code++;

  Misc::openFolder(CETMM::GetPaths().CETMods());
}

void RED4ext_CETMM::OpenDofilesFolder(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, void* aOut, int64_t a4)
{
  aFrame->code++;

  Misc::openFolder(CETMM::GetPaths().CETMMRoot() / "dofiles");
}

void RED4ext_CETMM::OpenUrl(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, void* aOut, int64_t a4)
{
  RED4ext::CString* url_name;
  RED4ext::GetParameter(aFrame, &url_name);

  aFrame->code++;

  if (*url_name == "update")
    Misc::openUrl("https://www.nexusmods.com/cyberpunk2077/mods/895?tab=files");
    
  if (*url_name == "coffee")
    Misc::openUrl("https://www.buymeacoffee.com/mingm");

  if (*url_name == "font_wiki")
    Misc::openUrl("https://wiki.redmodding.org/cyber-engine-tweaks/getting-started/configuration/change-font-and-font-size#how-to-display-non-english-characters");
}

void RED4ext_CETMM::RestartGame(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, void* aOut, int64_t a4)
{
  aFrame->code++;
  CETMM::SetRestart(true);
}


// register

void RED4ext_CETMM::Register()
{
  RED4ext::CNamePool::Add("CETMMEXT");
  cls.flags = {.isNative = true};
  RED4ext::CRTTISystem::Get()->RegisterType(&cls);
}

void RED4ext_CETMM::PostRegister()
{
  auto rtti = RED4ext::CRTTISystem::Get();

  auto func_getMods = RED4ext::CClassStaticFunction::Create(&cls, "GetMods", "GetMods", &GetMods, {.isNative = true, .isStatic = true});
  func_getMods->SetReturnType("handle:Mods");
  cls.RegisterFunction(func_getMods);

  auto func_getFonts = RED4ext::CClassStaticFunction::Create(&cls, "GetFonts", "GetFonts", &GetFonts, {.isNative = true, .isStatic = true});
  func_getFonts->SetReturnType("handle:Fonts");
  cls.RegisterFunction(func_getFonts);

  auto func_openModsFolder = RED4ext::CClassStaticFunction::Create(&cls, "OpenModsFolder", "OpenModsFolder", &OpenModsFolder, {.isNative = true, .isStatic = true});
  cls.RegisterFunction(func_openModsFolder);

  auto func_openDofilesFolder = RED4ext::CClassStaticFunction::Create(&cls, "OpenDofilesFolder", "OpenDofilesFolder", &OpenDofilesFolder, {.isNative = true, .isStatic = true});
  cls.RegisterFunction(func_openDofilesFolder);
  
  auto func_openUrl = RED4ext::CClassStaticFunction::Create(&cls, "OpenUrl", "OpenUrl", &OpenUrl, {.isNative = true, .isStatic = true});
  func_openUrl->AddParam("String", "URLName");
  cls.RegisterFunction(func_openUrl);

  auto func_restarGame = RED4ext::CClassStaticFunction::Create(&cls, "RestartGame", "RestartGame", &RestartGame, {.isNative = true, .isStatic = true});
  cls.RegisterFunction(func_restarGame);
}