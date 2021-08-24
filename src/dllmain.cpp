#include "pch.h"

HANDLE hMutexHandle = nullptr;

static void Initialize()
{
    try
    {
        //Single instance check
        hMutexHandle = CreateMutex(NULL, TRUE, L"CETMM");
        if (GetLastError() == ERROR_ALREADY_EXISTS)
        {
            return;
        }

        spdlog::set_default_logger(CreateLogger());
        CETMM::Initialize();
    }
    catch (...)
    {}
}

static void Shutdown()
{
    CETMM::Shutdown();

    if (hMutexHandle)
    {
        ReleaseMutex(hMutexHandle);
        CloseHandle(hMutexHandle);
    }
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
