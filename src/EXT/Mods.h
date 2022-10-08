#pragma once

#include "Mod.h"

struct Mods : RED4ext::IScriptable
{
public:
  Mods() {};
  RED4ext::CClass *GetNativeType();
  void Scan();
  RED4ext::DynArray<Mod> &GetCETMods();

private:
  RED4ext::DynArray<Mod> m_archive;
  RED4ext::DynArray<Mod> m_asi;
  RED4ext::DynArray<Mod> m_red4ext;
  RED4ext::DynArray<Mod> m_redscript;
  RED4ext::DynArray<Mod> m_cet;
  RED4ext::DynArray<Mod> m_redmod;

  RED4ext::DynArray<Mod> scan_mods(MODTYPE aType);
};

namespace RED4ext_Mods
{
  void Register();
  void PostRegister();
}