#include "pch.h"
#include "version.h"
#include <regex>
#include "EXT/TypeRegister.h"

static void Initialize()
{
    try
    {
        spdlog::set_default_logger(CreateLogger());
        CETMM::Initialize();
    }
    catch (...)
    {}
}

static void Shutdown()
{
    CETMM::Shutdown();
}

RED4ext::v1::SemVer CETMM_Version()
{
    std::string version = CETMM_VERSION;
    std::regex rgx(R"((\d+)\.(\d+)\.(\d+)-*(\d+)*(?=-|$))");
    std::smatch matches;

    if(std::regex_search(version, matches, rgx)) {
        uint8_t major = std::stoi(matches[1].str());
        uint16_t minor = std::stoi(matches[2].str());
        uint32_t patch = std::stoi(matches[3].str());
        uint32_t prereleaseType = RED4EXT_V1_SEMVER_PRERELEASE_TYPE_NONE;
        uint32_t prereleaseNumber = 0;
        
        if (matches[4].length() != 0) {
            prereleaseType = RED4EXT_V1_SEMVER_PRERELEASE_TYPE_RC;
            prereleaseNumber = std::stoi(matches[4].str());
        }
        return RED4EXT_V1_SEMVER_EX(major, minor, patch, prereleaseType, prereleaseNumber);
    } else {
        return RED4EXT_V1_SEMVER(1, 0, 0);
    }
}

RED4EXT_C_EXPORT void RED4EXT_CALL RegisterTypes()
{
    TypeRegister::Register();
}

RED4EXT_C_EXPORT void RED4EXT_CALL PostRegisterTypes()
{
    TypeRegister::PostRegister();
}

RED4EXT_C_EXPORT bool RED4EXT_CALL Main(RED4ext::v1::PluginHandle aHandle, RED4ext::v1::EMainReason aReason,
                                        const RED4ext::v1::Sdk* aSdk)
{
    RED4EXT_UNUSED_PARAMETER(aHandle);
    RED4EXT_UNUSED_PARAMETER(aSdk);

    switch (aReason)
    {
    case RED4ext::v1::EMainReason::Load:
    {
        Initialize();

        RED4ext::CRTTISystem::Get()->AddRegisterCallback(RegisterTypes);
        RED4ext::CRTTISystem::Get()->AddPostRegisterCallback(PostRegisterTypes);

        break;
    }
    case RED4ext::v1::EMainReason::Unload:
    {
        Shutdown();
        break;
    }
    }

    return true;
}

RED4EXT_C_EXPORT void RED4EXT_CALL Query(RED4ext::v1::PluginInfo* aInfo)
{
    aInfo->name = L"CET Mod Manager";
    aInfo->author = L"Ming";
    aInfo->version = CETMM_Version();
    aInfo->runtime = RED4EXT_V1_RUNTIME_VERSION_INDEPENDENT;
    aInfo->sdk = RED4EXT_V1_SDK_VERSION_1_0_0_COMPAT_0_5_0;
}

RED4EXT_C_EXPORT uint32_t RED4EXT_CALL Supports()
{
    return RED4EXT_API_VERSION_1_COMPAT_0;
}