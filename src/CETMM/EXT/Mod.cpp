#include "pch.h"
#include "Mod.h"

std::string to_string(MODTYPE aEnum)
{
  switch (aEnum)
  {
  case MODTYPE::CET: return "CET";
  case MODTYPE::ARCHIVE: return "ARCHIVE";
  case MODTYPE::REDSCRIPT: return "REDSCRIPT";
  case MODTYPE::ASI: return "ASI";
  case MODTYPE::RED4EXT: return "RED4EXT";
  case MODTYPE::REDMOD: return "REDMOD";
  default: return "unknown";
  }
}

Mod::Mod(RED4ext::CString aName, std::filesystem::path aPath, bool aEnabled, MODTYPE aType)
  :m_name{ aName }, m_path{ aPath }, m_enabled{ aEnabled }, m_type{ aType }
{
  m_formatedName = formatName(m_name);
}

const RED4ext::CString Mod::GetName() const
{
  return m_name;
}

const RED4ext::CString Mod::GetFormatedName() const
{
  return m_formatedName;
}

const std::filesystem::path Mod::GetPath() const
{
  return m_path;
}

const bool Mod::IsEnabled() const
{
  return m_enabled;
}

const MODTYPE Mod::GetType() const
{
  return m_type;
}

const std::string Mod::GetTypeName()
{
  return to_string(m_type);
}

void Mod::SetName(RED4ext::CString aName)
{
  m_name = aName;
  m_formatedName = formatName(m_name);
}

void Mod::SetPath(std::filesystem::path aPath)
{
  m_path = aPath;
}

void Mod::SetEnabled(bool aEnabled)
{
  m_enabled = aEnabled;
}

void Mod::SetType(MODTYPE aType)
{
  m_type = aType;
}

void Mod::Toggle()
{
  if (m_type != MODTYPE::CET)
  {
    return;
  }
  switch (m_enabled)
  {
  case true:
    if (changeCETModState(false))
      m_enabled = false;
    break;
  
  case false:
    if (changeCETModState(true))
      m_enabled = true;
    break;
  }
}

RED4ext::CString Mod::formatName(RED4ext::CString aName)
{
  std::string name = std::string(aName.c_str());
  std::replace( name.begin(), name.end(), '_', ' ');
  std::replace( name.begin(), name.end(), '-', ' ');
  for (int x = 0; x < name.length(); x++)
	{
		if (x == 0)
		{
			name[x] = toupper(name[x]);
		}
		else if (name[x - 1] == ' ')
		{
			name[x] = toupper(name[x]);
		}
	}
  return RED4ext::CString(name.c_str());
}

bool Mod::changeCETModState(bool aEnable)
{
  std::filesystem::path enabled_filename = "init.lua";
  std::filesystem::path disabled_filename = "init.lua_disabled";
  std::error_code err;
  switch (aEnable)
  {
  case true:
    std::filesystem::rename(m_path / disabled_filename, m_path / enabled_filename, err);
    if (err) {
      return false;
    }
    return true;
  
  case false:
    std::filesystem::rename(m_path / enabled_filename, m_path / disabled_filename, err);
    if (err)
    {
      return false;
    }
    return true;
  }
}


// RED4ext impl

RED4ext::TTypedClass<Mod> cls("Mod");

RED4ext::CClass* Mod::GetNativeType()
{
    return &cls;
}

void red4ext_GetName(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, RED4ext::CString* aOut, int64_t a4)
{
    aFrame->code++;

    if (aOut)
    {
        *aOut =  reinterpret_cast<Mod*>(aContext)->GetName();
    }
}

void red4ext_GetFormatedName(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, RED4ext::CString* aOut, int64_t a4)
{
    aFrame->code++;

    if (aOut)
    {
        *aOut =  reinterpret_cast<Mod*>(aContext)->GetFormatedName();
    }
}

void red4ext_IsEnabled(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, bool* aOut, int64_t a4)
{
    aFrame->code++;

    if (aOut)
    {
        *aOut =  reinterpret_cast<Mod*>(aContext)->IsEnabled();
    }
}

void red4ext_Toggle(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, void* aOut, int64_t a4)
{
    aFrame->code++;

    reinterpret_cast<Mod*>(aContext)->Toggle();
}

void RED4ext_Mod::Register()
{
  RED4ext::CNamePool::Add("Mod");
  RED4ext::CNamePool::Add("handle:Mod");
  RED4ext::CRTTISystem::Get()->RegisterType(&cls);
}

void RED4ext_Mod::PostRegister()
{
  auto func_getName = RED4ext::CClassFunction::Create(&cls, "GetName", "GetName",
                                                       &red4ext_GetName, {.isNative = true});
  func_getName->SetReturnType("String");
  cls.RegisterFunction(func_getName);

  auto func_getFormatedName = RED4ext::CClassFunction::Create(&cls, "GetFormatedName", "GetFormatedName",
                                                       &red4ext_GetFormatedName, {.isNative = true});
  func_getFormatedName->SetReturnType("String");
  cls.RegisterFunction(func_getFormatedName);
  
  auto func_isEnabled = RED4ext::CClassFunction::Create(&cls, "IsEnabled", "IsEnabled",
                                                       &red4ext_IsEnabled, {.isNative = true});
  func_isEnabled->SetReturnType("Bool");
  cls.RegisterFunction(func_isEnabled);

  auto func_toggle = RED4ext::CClassFunction::Create(&cls, "Toggle", "Toggle",
                                                       &red4ext_Toggle, {.isNative = true});
  cls.RegisterFunction(func_toggle);
}