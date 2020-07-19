@echo off

REM $1 = Visual Studio Version
set vsVer=%1
set BPLATFORM=%2
set CONFIGURATION=%3
set LINKTYPE=%4

if %1 == 14.0 (
    set vsBat="C:/Program Files (x86)/Microsoft Visual Studio %vsVer%/VC/bin/vcvars32.bat"
) else (
    if %2 == 64 (
        FOR /F "tokens=* USEBACKQ" %%g IN (`"C:/Program Files (x86)/Microsoft Visual Studio/Installer/vswhere.exe" -latest -property installationPath`) DO (SET vsBat="%%g\VC\Auxiliary\Build\vcvars64.bat")
    ) else (
        FOR /F "tokens=* USEBACKQ" %%g IN (`"C:/Program Files (x86)/Microsoft Visual Studio/Installer/vswhere.exe" -latest -property installationPath`) DO (SET vsBat="%%g\VC\Auxiliary\Build\vcvars32.bat")
    )
)

if %2 == 64 (
    set PLATFORM=x64
    set BPLATFORM=64
) else (
    set PLATFORM=x86
    set BPLATFORM=32
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
@echo on
call %vsBat%
@echo off

echo "  TargetPlatform:  %PLATFORM%"
echo "  Configuration:   %CONFIGURATION%"
echo "  LinkType:        %LINKTYPE%"
echo "  BuildDir:        build.msvc/%CONFIGURATION%_%PLATFORM%"
echo "  StagedDir:       build.msvc/%CONFIGURATION%_%PLATFORM%/staged"
echo "  BuildLog:        build.msvc/build-%CONFIGURATION%-%PLATFORM%-%LINKTYPE%.log"

if not exist build.msvc (
    mkdir build.msvc
)

if not exist b2.exe (
    echo "Build bootstrap ..."
    call bootstrap.bat >>  build.msvc/build-%CONFIGURATION%-%PLATFORM%-%LINKTYPE%.log
)

REM Build Options
REM    --prefix=                    // Install dir
REM    --build-dir=                 // Where to put all build intermediate files
REM    --stagedir=                  // Where to put staged libraries
REM    --build-type=complete        // Build everything
REM    --toolset=msvc               // Buils toolset is Microsoft Visual Studio
REM    --layout=versioned           // versioned - Names of boost binaries include the Boost version number, name and version of the compiler and encoded build properties.
REM                                 //             Boost headers are installed in a subdirectory of <HDRDIR> whose name contains the Boost version number.
REM                                 // tagged - Library file name contains build options, but without toolset name or boost version
REM                                 // system - Binaries names do not include the Boost version number or the name and version number of the compiler
REM                                 //             Boost headers are installed in a subdirectory of <HDRDIR> whose name contains the Boost version number.
REM    variant=release/debug        // Debug/Release build
REM    address-model=32/64          // 32Bits/64Bits
REM    link=static/shared           // Static library or DLL
REM    runtime-link=static/shared   // Link to static/dynamic runtime libs
REM    threading=multi              // Multi-threads
b2 -j8 --build-dir=build.msvc/%CONFIGURATION%_%PLATFORM% --stagedir=build.msvc/%CONFIGURATION%_%PLATFORM%/staged --build-type=complete --toolset=msvc --layout=versioned variant=%CONFIGURATION% address-model=%BPLATFORM% link=%LINKTYPE% runtime-link=%LINKTYPE% threading=multi stage >> build.msvc/build-%CONFIGURATION%-%PLATFORM%-%LINKTYPE%.log
