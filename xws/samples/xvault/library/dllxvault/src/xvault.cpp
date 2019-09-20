#include "xpch.h"
#include <Windows.h>
#include <stdio.h>

BOOL WINAPI DllMain(HINSTANCE hDLL, DWORD dwReason, LPVOID lpvReserved)
{
    return TRUE;
}

int WINAPI XVaultGetVersion()
{
    return 0x00010000;
}
