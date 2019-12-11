#!/usr/bin/bash

source xws-base.sh

xwsGetVersion(){
    allVersions=`curl --silent --get https://github.com/google/brotli/releases | grep -Po '\Kv\d*\.\d*\.\d*\.tar\.gz' | grep -Po '\d*\.\d*\.\d*' | sort -r`
    if [ "$1" == "" ]; then
        arr=($allVersions)
        echo ${arr[0]}
    else
        for item in $allVersions; do
            if [ "$1" == "$item" ]; then
                echo $1
                break
            fi
        done
    fi
}

xwsGetDownloadUrl(){
    TargetVersion=`xwsGetVersion $1`
    if [ "$TargetVersion" == "" ]; then
        echo ""
    else
        echo "https://github.com/google/brotli/archive/v$TargetVersion.tar.gz"
    fi
}

xwsDownloadFile(){
    if [ "$1" == "" ]; then
        echo "Invalid Version"
    else
        curl -L -O $1
    fi
}

xwsUnpackFile(){
    # Make sure file exist
    [ -f $1 ] || xwsAbort "package not exist"
    tar -xzf $1
}

#===============================================================================
# Execution starts here
#===============================================================================

TARGET_VERSION=`xwsGetVersion $1`
TARGET_VERSION2=`echo $TARGET_VERSION | sed 's/\./_/'g`
TARGET_URL=`xwsGetDownloadUrl $TARGET_VERSION`
TARGET_FILE=`echo $TARGET_URL | sed 's/.*\///g'`
TARGET_DIR=brotli-$TARGET_VERSION

echo "TARGET_VERSION:   $TARGET_VERSION"
echo "TARGET_VERSION2:  $TARGET_VERSION2"
echo "TARGET_URL:       $TARGET_URL"
echo "TARGET_FILE:      $TARGET_FILE"
echo "TARGET_DIR:       $TARGET_DIR"

xwsBuild(){
    # $1: Platform 32 or 64
    #
    #
    PLATFORM=32
    if [ "$1" == "64" ]; then
        PLATFORM=64
    fi
    CONFIG=release
    if [ "$2" == "debug" ]; then
        CONFIG=debug
    fi
    LINKTYPE=no-shared
    if [ "$3" == "shared" ]; then
        LINKTYPE=shared
    fi
    # perl Configure VC-WIN32 no-shared --prefix=build.msvc/debug_32
    # perl Configure debug-VC-WIN32 --prefix=C:\Build-OpenSSL-VC-32-dbg
    # perl Configure VC-WIN64A --prefix=C:\Build-OpenSSL-VC-64
    # perl Configure debug-VC-WIN64A --prefix=C:\Build-OpenSSL-VC-64-dbg
}

#===============================================================================
# Execution starts here
#===============================================================================

CURDIR=`xwsGetCurrentDir`
cd ../..
if [ ! -d temp/brotli ]; then
    mkdir -p temp/brotli
fi
cd temp/brotli

BUILDDIR=`xwsGetCurrentDir`
# download boost source code
if [ ! -f $TARGET_FILE ]; then
    echo "Download brotli ..."
    `xwsDownloadFile $TARGET_URL`
fi


echo ""
echo "Build openssl static library (Release/x64):"
rm -rf $TARGET_DIR
xwsUnpackFile $TARGET_FILE
cd $TARGET_DIR


echo Build win_release_x86 ...
mkdir -p build.msvc/win_release_x86
../../../xws/bin/xws-build-brotli-cmd.bat 16.4 32 release
echo Build win_release_x64 ...
mkdir -p build.msvc/win_release_x64
../../../xws/bin/xws-build-brotli-cmd.bat 16.4 64 release
echo Build win_debug_x86 ...
mkdir -p build.msvc/win_debug_x86
../../../xws/bin/xws-build-brotli-cmd.bat 16.4 32 debug
echo Build win_debug_x64 ...
mkdir -p build.msvc/win_debug_x64
../../../xws/bin/xws-build-brotli-cmd.bat 16.4 64 debug

echo Copy win_release_x86 ...
mkdir -p ../../../external/brotli/$TARGET_VERSION/bin/win_release_x86
mkdir -p ../../../external/brotli/$TARGET_VERSION/libs/win_release_x86
cp -f build.msvc/win_release_x86/release/brotli.exe ../../../external/brotli/$TARGET_VERSION/bin/win_release_x86/
cp -f build.msvc/win_release_x86/release/*.dll ../../../external/brotli/$TARGET_VERSION/libs/win_release_x86/
cp -f build.msvc/win_release_x86/release/*.lib ../../../external/brotli/$TARGET_VERSION/libs/win_release_x86/
cp -f build.msvc/win_release_x86/release/*.pdb ../../../external/brotli/$TARGET_VERSION/libs/win_release_x86/

echo Copy win_release_x64 ...
mkdir -p ../../../external/brotli/$TARGET_VERSION/bin/win_release_x64
mkdir -p ../../../external/brotli/$TARGET_VERSION/libs/win_release_x64
cp -f build.msvc/win_release_x64/release/brotli.exe ../../../external/brotli/$TARGET_VERSION/bin/win_release_x64/
cp -f build.msvc/win_release_x64/release/*.dll ../../../external/brotli/$TARGET_VERSION/libs/win_release_x64/
cp -f build.msvc/win_release_x64/release/*.lib ../../../external/brotli/$TARGET_VERSION/libs/win_release_x64/
cp -f build.msvc/win_release_x64/release/*.pdb ../../../external/brotli/$TARGET_VERSION/libs/win_release_x64/

echo Copy win_debug_x86 ...
mkdir -p ../../../external/brotli/$TARGET_VERSION/bin/win_debug_x86
mkdir -p ../../../external/brotli/$TARGET_VERSION/libs/win_debug_x86
cp -f build.msvc/win_debug_x86/debug/brotli.exe ../../../external/brotli/$TARGET_VERSION/bin/win_debug_x86/
cp -f build.msvc/win_debug_x86/debug/*.dll ../../../external/brotli/$TARGET_VERSION/libs/win_debug_x86/
cp -f build.msvc/win_debug_x86/debug/*.lib ../../../external/brotli/$TARGET_VERSION/libs/win_debug_x86/
cp -f build.msvc/win_debug_x86/debug/*.pdb ../../../external/brotli/$TARGET_VERSION/libs/win_debug_x86/

echo Copy win_debug_x64 ...
mkdir -p ../../../external/brotli/$TARGET_VERSION/bin/win_debug_x64
mkdir -p ../../../external/brotli/$TARGET_VERSION/libs/win_debug_x64
cp -f build.msvc/win_debug_x64/debug/brotli.exe ../../../external/brotli/$TARGET_VERSION/bin/win_debug_x64/
cp -f build.msvc/win_debug_x64/debug/*.dll ../../../external/brotli/$TARGET_VERSION/libs/win_debug_x64/
cp -f build.msvc/win_debug_x64/debug/*.lib ../../../external/brotli/$TARGET_VERSION/libs/win_debug_x64/
cp -f build.msvc/win_debug_x64/debug/*.pdb ../../../external/brotli/$TARGET_VERSION/libs/win_debug_x64/

echo "brotli has been built successfully"
