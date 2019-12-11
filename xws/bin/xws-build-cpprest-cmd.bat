@echo off

REM $1 = Visual Studio Version
set vsVer=%1
set PLATFORM=%2
set CONFIGURATION=%3

if %1 == 14.0 (
    set vsBat="C:/Program Files (x86)/Microsoft Visual Studio %vsVer%/VC/bin/vcvars32.bat"
) else (
    if %2 == 64 (
        FOR /F "tokens=* USEBACKQ" %%g IN (`"C:/Program Files (x86)/Microsoft Visual Studio/Installer/vswhere.exe" -latest -property installationPath`) DO (SET vsBat="%%g\VC\Auxiliary\Build\vcvars64.bat")
    ) else (
        FOR /F "tokens=* USEBACKQ" %%g IN (`"C:/Program Files (x86)/Microsoft Visual Studio/Installer/vswhere.exe" -latest -property installationPath`) DO (SET vsBat="%%g\VC\Auxiliary\Build\vcvars32.bat")
    )
)

if %2 == 32 (
    GPLATFORM=Win32
) else (
    GPLATFORM=x64
)

if %3 == debug (
    set CONFIGURATION=debug
) else (
    set CONFIGURATION=release
)

echo Run %vsBat% ...
call %vsBat%

echo "  TargetPlatform:  %PLATFORM%"
echo "  Configuration:   %CONFIGURATION%"
echo "  BuildLog:        build.msvc/build-%CONFIGURATION%-%PLATFORM%.log"

set CurDir=%cd%

cd build.msvc/win_%CONFIGURATION%_%PLATFORM%
cmake -DCMAKE_BUILD_TYPE=%CONFIGURATION% -DCMAKE_GENERATOR_PLATFORM=%GPLATFORM% -DCMAKE_INSTALL_PREFIX=build.msvc/win_%CONFIGURATION%_%PLATFORM% ../..
cmake --build . --config %CONFIGURATION% --target
cd %CurDir%
