#include "pch.h"
#include "Uninstall.h"

void Uninstall::Initialize()
{
    auto asi_path = CETMM::GetPaths().Plugins() / "cet_mod_manager.asi";
    m_asiExists = std::filesystem::exists(asi_path);
}

void Uninstall::Uninitialize()
{
    if (m_removeFiles)
    {
        // generate remove cmd
        std::vector<std::filesystem::path> dirs_to_del = {};
        std::vector<std::filesystem::path> files_to_del = {};

        auto ext_path = CETMM::GetPaths().Red4Ext() / "cet_mod_manager";
        if (std::filesystem::exists(ext_path))
        dirs_to_del.push_back(ext_path);

        auto lua_path = CETMM::GetPaths().CETMMRoot();
        if (std::filesystem::exists(lua_path))
        {
        if (m_removeConfig && m_removeDofiles)
            dirs_to_del.push_back(lua_path);
        else
        {
            for (auto const& dir_entry : std::filesystem::directory_iterator{lua_path})
            {
            if (dir_entry.is_directory())
            {
                if (!m_removeDofiles && dir_entry.path().filename() == "dofiles") continue;
                dirs_to_del.push_back(dir_entry.path());
            }
            if (dir_entry.is_regular_file())
            {
                if (!m_removeConfig && dir_entry.path().filename() == "config.json") continue;
                files_to_del.push_back(dir_entry.path());
            }
            }
        }
        }

        std::wstring rmdir_str = L"";
        std::wstring del_str = L"";

        for (auto const& dir : dirs_to_del)
        {
        rmdir_str += L" \"" + dir.wstring() + L"\"";
        }
        
        for (auto const& file : files_to_del)
        {
        del_str += L" \"" + file.wstring() + L"\"";
        }

        if (dirs_to_del.size() > 0)
        rmdir_str = fmt::format(L" & rd /s /q{}", rmdir_str);
        if (files_to_del.size() > 0)
        del_str = fmt::format(L" & del{} /f /q", del_str);

        std::wstring cmdArgs = fmt::format(L"/c ping localhost -n 5 > nul{}{}", rmdir_str, del_str);

        // remove red4ext plugin
        STARTUPINFO lpStartupInfo;
        PROCESS_INFORMATION lpProcessInfo;

        ZeroMemory( &lpStartupInfo, sizeof( lpStartupInfo ) );
        lpStartupInfo.cb = sizeof( lpStartupInfo );
        ZeroMemory( &lpProcessInfo, sizeof( lpProcessInfo ) );

        CreateProcess( L"C:\\Windows\\System32\\cmd.exe",
                        cmdArgs.data(), NULL, NULL,
                        FALSE, CREATE_NO_WINDOW, NULL, NULL,
                        &lpStartupInfo,
                        &lpProcessInfo
                        );
        CloseHandle(lpProcessInfo.hThread);
        CloseHandle(lpProcessInfo.hProcess);
    }
}

const bool Uninstall::IsAsiRemoved() const
{
    return !m_asiExists;
}

void Uninstall::SetFilesToRemove(bool aRemove, bool aConfig, bool aDofiles)
{
    m_removeFiles = aRemove;
    m_removeConfig = aConfig;
    m_removeDofiles = aDofiles;
}

// red4ext impl

RED4ext::TTypedClass<Uninstall> cls("Uninstall");

RED4ext::CClass* Uninstall::GetNativeType()
{
    return &cls;
}

void red4ext_IsAsiRemoved(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, bool* aOut, int64_t a4)
{
    aFrame->code++;

    if (aOut)
    {
      *aOut = CETMM::GetUninstall().IsAsiRemoved();
    }
}

void red4ext_SetFilesToRemove(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, void* aOut, int64_t a4)
{
    bool removeFiles;
    bool removeConfig;
    bool removeDofiles;
    RED4ext::GetParameter(aFrame, &removeFiles);
    RED4ext::GetParameter(aFrame, &removeConfig);
    RED4ext::GetParameter(aFrame, &removeDofiles);
    aFrame->code++;
    CETMM::GetUninstall().SetFilesToRemove(removeFiles, removeConfig, removeDofiles);
}

void RED4ext_Uninstall::Register()
{
    RED4ext::CNamePool::Add("Uninstall");
    RED4ext::CNamePool::Add("handle:Uninstall");
    RED4ext::CRTTISystem::Get()->RegisterType(&cls);
}

void RED4ext_Uninstall::PostRegister()
{
    auto func_IsAsiRemoved = RED4ext::CClassStaticFunction::Create(&cls, "IsAsiRemoved", "IsAsiRemoved",
                                                       &red4ext_IsAsiRemoved, {.isNative = true, .isStatic = true});
    func_IsAsiRemoved->SetReturnType("Bool");
    cls.RegisterFunction(func_IsAsiRemoved);

    auto func_SetFilesToRemove = RED4ext::CClassStaticFunction::Create(&cls, "SetFilesToRemove", "SetFilesToRemove",
                                                       &red4ext_SetFilesToRemove, {.isNative = true, .isStatic = true});
    func_SetFilesToRemove->AddParam("Bool", "removeFiles");
    func_SetFilesToRemove->AddParam("Bool", "removeConfig");
    func_SetFilesToRemove->AddParam("Bool", "removeDofiles");
    cls.RegisterFunction(func_SetFilesToRemove);
}