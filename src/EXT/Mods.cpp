#include "pch.h"
#include "Mods.h"

void Mods::Scan()
{
  m_cet = scan_mods(MODTYPE::CET);
  // m_archive = scan_mods(MODTYPE::ARCHIVE);
  // m_redscript = scan_mods(MODTYPE::REDSCRIPT);
  // m_asi = scan_mods(MODTYPE::ASI);
  // m_red4ext = scan_mods(MODTYPE::RED4EXT);
  // m_redmod = scan_mods(MODTYPE::REDMOD);
}

RED4ext::DynArray<RED4ext::Handle<Mod>> &Mods::GetCETMods()
{
  return m_cet;
}

RED4ext::DynArray<RED4ext::Handle<Mod>> Mods::scan_mods(MODTYPE aType)
{
  RED4ext::DynArray<RED4ext::Handle<Mod>> mod_hnds;
  auto modType = RED4ext::CRTTISystem::Get()->GetClass("Mod");
  switch (aType)
  {
  case MODTYPE::CET:
    for (const auto& entry : std::filesystem::directory_iterator(CETMM::GetPaths().CETMods()))
    {
      if (entry.is_directory() && std::filesystem::exists(entry.path() / "init.lua"))
      {
        auto mod = reinterpret_cast<Mod*>(modType->AllocInstance());
        modType->ConstructCls(mod);
        mod->SetName(RED4ext::CString(entry.path().filename().string().c_str()));
        mod->SetPath(entry.path());
        mod->SetEnabled(true);
        mod->SetType(MODTYPE::CET);
        mod_hnds.EmplaceBack(mod);
      }

      else if (entry.is_directory() && std::filesystem::exists(entry.path() / "init.lua_disabled"))
      {
        auto mod = reinterpret_cast<Mod*>(modType->AllocInstance());
        modType->ConstructCls(mod);
        mod->SetName(RED4ext::CString(entry.path().filename().string().c_str()));
        mod->SetPath(entry.path());
        mod->SetEnabled(false);
        mod->SetType(MODTYPE::CET);
        mod_hnds.EmplaceBack(mod);
      }
    }
    break;

  case MODTYPE::ARCHIVE:
    break;

  case MODTYPE::REDSCRIPT:
    break;

  case MODTYPE::ASI:
    break;

  case MODTYPE::RED4EXT:
    break;

  case MODTYPE::REDMOD:
    break;
  }

  return mod_hnds;
}

// red4ext impl

RED4ext::TTypedClass<Mods> cls("Mods");

RED4ext::CClass* Mods::GetNativeType()
{
    return &cls;
}

void red4ext_Scan(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, void* aOut, int64_t a4)
{
    RED4EXT_UNUSED_PARAMETER(aContext);
    RED4EXT_UNUSED_PARAMETER(a4);
    RED4EXT_UNUSED_PARAMETER(aOut);
    RED4EXT_UNUSED_PARAMETER(aFrame);

    aFrame->code++;

    CETMM::GetMods().Scan();
}

void red4ext_GetCETMods(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, RED4ext::DynArray<Mod>* aOut, int64_t a4)
{
    aFrame->code++;

    if (aOut)
    {
      auto type = RED4ext::CRTTISystem::Get()->GetType("array:handle:Mod");
      type->Assign(aOut, &CETMM::GetMods().GetCETMods());
    }
}

void red4ext_GetMods(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, Mods* aOut, int64_t a4)
{
    RED4EXT_UNUSED_PARAMETER(aContext);
    RED4EXT_UNUSED_PARAMETER(a4);
    RED4EXT_UNUSED_PARAMETER(aFrame);

    aFrame->code++;

    if (aOut)
      *aOut = CETMM::GetMods();
}

void RED4ext_Mods::Register()
{
  RED4ext::CNamePool::Add("Mods");
  RED4ext::CNamePool::Add("handle:Mods");
  RED4ext::CNamePool::Add("array:handle:Mod");
  RED4ext::CRTTISystem::Get()->RegisterType(&cls);
}

void RED4ext_Mods::PostRegister()
{
  auto rtti = RED4ext::CRTTISystem::Get();
  auto func_scan = RED4ext::CClassStaticFunction::Create(&cls, "Scan", "Scan",
                                                       &red4ext_Scan, {.isNative = true, .isStatic = true});
  cls.RegisterFunction(func_scan);

  
  auto func_getCETMods = RED4ext::CClassStaticFunction::Create(&cls, "GetCETMods", "GetCETMods",
                                                       &red4ext_GetCETMods, {.isNative = true, .isStatic = true});
  func_getCETMods->SetReturnType("array:handle:Mod");
  cls.RegisterFunction(func_getCETMods);

  auto func_getMods = RED4ext::CGlobalFunction::Create("GetM", "GetM", &red4ext_GetMods);
  func_getMods->flags = {.isNative = true, .isStatic = true};
  func_getMods->SetReturnType("Mods");
  rtti->RegisterFunction(func_getMods);
}