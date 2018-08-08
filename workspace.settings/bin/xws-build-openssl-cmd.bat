@echo off

REM $1 = Visual Studio Version
set vsVer=%1
set vsBat="C:/Program Files (x86)/Microsoft Visual Studio %vsVer%/VC/bin/vcvars32.bat"
set PLATFORM=%2
set CONFIGURATION=%3
set LINKTYPE=%4

if %2 == 64 (
    set PLATFORM=64
) else (
    set PLATFORM=32
)

if %3 == debug (
    set CONFIGURATION=debug
) else (
    set CONFIGURATION=release
)

if %4 == shared (
    set LINKTYPE=shared
) else (
    set LINKTYPE=static
)

echo Run %vsBat% ...
call %vsBat%

echo "  TargetPlatform:  %PLATFORM%"
echo "  Configuration:   %CONFIGURATION%"
echo "  LinkType:        %LINKTYPE%"
echo "  BuildDir:        build.msvc/%CONFIGURATION%_%PLATFORM%"
echo "  StagedDir:       build.msvc/%CONFIGURATION%_%PLATFORM%/staged"
echo "  BuildLog:        build.msvc/build-%CONFIGURATION%-%PLATFORM%-%LINKTYPE%.log"

set CurDir=%cd% 
perl Configure VC-WIN32 no-shared --prefix="%CurDir%\build.msvc\debug_32"
ms\do_ms
nmake.exe -f ms\nt.mak 
nmake.exe -f ms\nt.mak install
