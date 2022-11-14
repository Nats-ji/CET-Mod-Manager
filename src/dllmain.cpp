#include "pch.h"
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

bool BaseInit_OnEnter(RED4ext::CGameApplication* aApp)
{
    CETMM::GetFonts().LoadSystemFonts();
    CETMM::GetFonts().LoadFontFromCET();
    return true;
}

bool BaseInit_OnUpdate(RED4ext::CGameApplication* aApp)
{
    return true;
}

bool BaseInit_OnExit(RED4ext::CGameApplication* aApp)
{
    return true;
}

RED4EXT_C_EXPORT void RED4EXT_CALL RegisterTypes()
{
    TypeRegister::Register();
}

RED4EXT_C_EXPORT void RED4EXT_CALL PostRegisterTypes()
{
    TypeRegister::PostRegister();
}

RED4EXT_C_EXPORT bool RED4EXT_CALL Main(RED4ext::PluginHandle aHandle, RED4ext::EMainReason aReason,
                                        const RED4ext::Sdk* aSdk)
{
    RED4EXT_UNUSED_PARAMETER(aHandle);
    RED4EXT_UNUSED_PARAMETER(aSdk);

    switch (aReason)
    {
    case RED4ext::EMainReason::Load:
    {
        Initialize();
        RED4ext::RTTIRegistrator::Add(RegisterTypes, PostRegisterTypes);
    
        // RED4ext::GameState initState;
        // initState.OnEnter = &BaseInit_OnEnter;
        // initState.OnUpdate = &BaseInit_OnUpdate;
        // initState.OnExit = &BaseInit_OnExit;
        // aSdk->gameStates->Add(aHandle, RED4ext::EGameStateType::BaseInitialization, &initState);

        break;
    }
    case RED4ext::EMainReason::Unload:
    {
        Shutdown();
        break;
    }
    }

    return true;
}

RED4EXT_C_EXPORT void RED4EXT_CALL Query(RED4ext::PluginInfo* aInfo)
{
    aInfo->name = L"CET Mod Manager";
    aInfo->author = L"Ming";
    aInfo->version = RED4EXT_SEMVER(1, 0, 0); // Set your version here.
    aInfo->runtime = RED4EXT_RUNTIME_LATEST;
    aInfo->sdk = RED4EXT_SDK_LATEST;
}

RED4EXT_C_EXPORT uint32_t RED4EXT_CALL Supports()
{
    return RED4EXT_API_VERSION_LATEST;
}