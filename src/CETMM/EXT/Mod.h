#pragma once

enum class MODTYPE
{
  CET,
  ARCHIVE,
  REDSCRIPT,
  ASI,
  RED4EXT,
  REDMOD
};

struct Mod : RED4ext::IScriptable
{
public:
  RED4ext::CClass *GetNativeType();

  Mod() {};
  Mod(RED4ext::CString aName, std::filesystem::path aPath, bool aEnabled, MODTYPE aType);

  const RED4ext::CString GetName() const;
  const RED4ext::CString GetFormatedName() const;
  const std::filesystem::path GetPath() const;
  const bool IsEnabled() const;
  const MODTYPE GetType() const;
  const std::string GetTypeName();
  void SetName(RED4ext::CString aName);
  void SetPath(std::filesystem::path aPath);
  void SetEnabled(bool aEnabled);
  void SetType(MODTYPE aType);
  void Toggle();

private:
  RED4ext::CString m_name;
  RED4ext::CString m_formatedName;
  std::filesystem::path m_path;
  bool m_enabled;
  MODTYPE m_type;

  RED4ext::CString formatName(RED4ext::CString aName);
  bool changeCETModState(bool aEnable);
};

namespace RED4ext_Mod
{
  void Register();
  void PostRegister();
}