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

RED4ext::DynArray<Mod> &Mods::GetCETMods()
{
  return m_cet;
}

RED4ext::DynArray<Mod> Mods::scan_mods(MODTYPE aType)
{
  RED4ext::DynArray<Mod> mod_list;
  switch (aType)
  {
  case MODTYPE::CET:
    for (const auto& entry : std::filesystem::directory_iterator(CETMM::GetPaths().CETMods()))
    {
      if (entry.is_directory() && std::filesystem::exists(entry.path() / "init.lua"))
      {
        mod_list.PushBack(Mod(RED4ext::CString(entry.path().filename().string().c_str()), entry.path(), true, MODTYPE::CET));
      } else if (entry.is_directory() && std::filesystem::exists(entry.path() / "init.lua_disabled"))
      {
        mod_list.PushBack(Mod(RED4ext::CString(entry.path().filename().string().c_str()), entry.path(), false, MODTYPE::CET));
      }
    }
    return mod_list;

  case MODTYPE::ARCHIVE:
    return mod_list;

  case MODTYPE::REDSCRIPT:
    return mod_list;

  case MODTYPE::ASI:
    return mod_list;

  case MODTYPE::RED4EXT:
    return mod_list;

  case MODTYPE::REDMOD:
    return mod_list;
  }
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

    Mods* mods;
    RED4ext::GetParameter(aFrame, &mods);

    aFrame->code++;

    mods->Scan();
}

void red4ext_GetCETMods(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, RED4ext::DynArray<Mod>* aOut, int64_t a4)
{
    RED4EXT_UNUSED_PARAMETER(aContext);
    RED4EXT_UNUSED_PARAMETER(a4);

    Mods* mods;
    RED4ext::GetParameter(aFrame, &mods);

    aFrame->code++;

    *aOut = mods->GetCETMods();
}

void red4ext_GetMods(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, Mods* aOut, int64_t a4)
{
    RED4EXT_UNUSED_PARAMETER(aContext);
    RED4EXT_UNUSED_PARAMETER(a4);
    RED4EXT_UNUSED_PARAMETER(aFrame);

    aFrame->code++;

    *aOut = CETMM::GetMods();
}

void RED4ext_Mods::Register()
{
  RED4ext::CNamePool::Add("Mods");
  RED4ext::CNamePool::Add("array:Mod");
  RED4ext::CRTTISystem::Get()->RegisterType(&cls);
}

void RED4ext_Mods::PostRegister()
{
  auto rtti = RED4ext::CRTTISystem::Get();
  auto func_scan = RED4ext::CClassFunction::Create(&cls, "Scan", "Scan",
                                                       &red4ext_Scan, {.isNative = true});
  func_scan->AddParam("Mods", "self");
  cls.RegisterFunction(func_scan);

  
  auto func_getCETMods = RED4ext::CClassFunction::Create(&cls, "GetCETMods", "GetCETMods",
                                                       &red4ext_GetCETMods, {.isNative = true});
  func_getCETMods->AddParam("Mods", "self");
  func_getCETMods->SetReturnType("array:Mod");
  cls.RegisterFunction(func_getCETMods);

  auto func_getMods = RED4ext::CGlobalFunction::Create("GetM", "GetM", &red4ext_GetMods);
  func_getMods->flags = {.isNative = true, .isStatic = true};
  func_getMods->SetReturnType("Mods");
  rtti->RegisterFunction(func_getMods);
}