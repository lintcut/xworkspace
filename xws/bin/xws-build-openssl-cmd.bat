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
    if %3 == debug (
        set VCFLAG=VC-WIN32
    ) else (
        set VCFLAG=debug-VC-WIN32
    )
) else (
    if %3 == debug (
        set VCFLAG=VC-WIN64A
    ) else (
        set VCFLAG=debug-VC-WIN64A
    )
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
perl Configure %VCFLAG% no-shared --prefix="%CurDir%\build.msvc\win_%CONFIGURATION%_%PLATFORM%"
REM ### For 1.0.xx ###
REM ms\do_ms
REM nmake.exe -f ms\nt.mak
REM nmake.exe -f ms\nt.mak install

REM ### For 1.1.xx ###
nmake.exe
