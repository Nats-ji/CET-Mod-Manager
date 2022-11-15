#pragma once
#include "Mod.h"
#include "Mods.h"
#include "CETMMEXT.h"
#include "Fonts.h"

namespace TypeRegister
{
  void Register()
  {
    RED4ext_Mod::Register();
    RED4ext_Mods::Register();
    RED4ext_CETMM::Register();
    RED4ext_Fonts::Register();
  }

  void PostRegister()
  {
    RED4ext_Mod::PostRegister();
    RED4ext_Mods::PostRegister();
    RED4ext_CETMM::PostRegister();
    RED4ext_Fonts::PostRegister();
  }
}