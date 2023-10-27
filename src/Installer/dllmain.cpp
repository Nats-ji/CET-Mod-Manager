#include "pch.h"

HANDLE hMutexHandle = nullptr;

static void Initialize()
{
    try
    {
        //Single instance check
        hMutexHandle = CreateMutex(NULL, TRUE, L"CETMM_Installer");
        if (GetLastError() == ERROR_ALREADY_EXISTS)
        {
            return;
        }
        
        spdlog::set_default_logger(CreateLogger());
        spdlog::flush_on(spdlog::level::info);
        Installer::Initialize();
    }
    catch (...)
    {}
}

static void Shutdown()
{
    Installer::Shutdown();
    spdlog::shutdown();
}

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
                     )
{
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
        Initialize();
        break;
    case DLL_PROCESS_DETACH:
        Shutdown();
        break;
    default:
        break;
    }
    return TRUE;
}