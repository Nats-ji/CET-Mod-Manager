#pragma once

struct Uninstall : RED4ext::IScriptable
{
public:
    RED4ext::CClass *GetNativeType();

    Uninstall() {};
    void Initialize();
    void Uninitialize();
    const bool IsAsiRemoved() const;
    void SetFilesToRemove(bool aRemove, bool aConfig = false, bool aDofiles = false);

private:
    bool m_asiExists {true};
    bool m_removeFiles {false};
    bool m_removeConfig {false};
    bool m_removeDofiles {false};
};

namespace RED4ext_Uninstall
{
  void Register();
  void PostRegister();
}