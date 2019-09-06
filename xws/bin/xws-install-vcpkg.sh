#!/usr/bin/bash

source xws-base.sh

xwsGetVcpkgDownloadUrl(){
    allVersions=`curl --silent --get https://github.com/microsoft/vcpkg/releases | grep "/microsoft/vcpkg/archive/" | grep tar.gz | cut -d '"' -f 2`
    if [ "$1" == "" ]; then
        arr=($allVersions)
        echo "https://github.com${arr[0]}"
    else
        for item in $allVersions; do
            if [ "$1" == $item ]; then
                echo "https://github.com$1"
                break
            fi
        done
    fi
}

xwsDownloadVcpkg(){
    if [ "$1" == "" ]; then
        echo "Bad URL"
    else
        curl -L -O $1
    fi
}

xwsUnpackVcpkg(){
    # Make sure file exist
    [ -f $1 ] || xwsAbort "Vcpkg package not exist"
    tar -xzf $1
}

#===============================================================================
# Execution starts here
#===============================================================================

if [ $XWSROOT. == . ]; then
    echo "XWSROOT is not defined"
    exit 1
fi

TARGET_VCPKG_URL=`xwsGetVcpkgDownloadUrl $1`
TARGET_VCPKG_FILE=`echo $TARGET_VCPKG_URL | sed 's/.*\///g'`
TARGET_VCPKG_VER=`echo $TARGET_VCPKG_FILE | sed 's/\.tar\.gz//'`
TARGET_VCPKG_DIR=`echo vcpkg-$TARGET_VCPKG_VER`

CURRENT_VCPKG_VER=
if [ -f $XWSROOT/external/vcpkg/vcpkg.ver ]; then
    CURRENT_VCPKG_VER=`cat $XWSROOT/external/vcpkg/vcpkg.ver`
fi

echo "Latest Vcpkg Version:  $TARGET_VCPKG_VER"
echo "Current Vcpkg Version: $CURRENT_VCPKG_VER"

if [ $CURRENT_VCPKG_VER. == $TARGET_VCPKG_VER. ]; then
    echo "VCPKG is up-to-date"
    exit 0
fi

echo "Target Vcpkg Version: $TARGET_VCPKG_VER"
echo "Target Vcpkg URL:     $TARGET_VCPKG_URL"
echo "Vcpkg FileName:       $TARGET_VCPKG_FILE"
echo "Vcpkg Unpack Dir:     $TARGET_VCPKG_DIR"

CURDIR=`xwsGetCurrentDir`

cd $XWSROOT
if [ ! -d temp/vcpkg ]; then
    mkdir -p temp/vcpkg
fi
cd temp/vcpkg

VCPKGROOT=`pwd`
echo "vcpkg root: $VCPKGROOT"

# download vcpkg source code
if [ ! -f $TARGET_VCPKG_FILE ]; then
    echo "Download Vcpkg ..."
    `xwsDownloadVcpkg $TARGET_VCPKG_URL`
fi

# unpack zip file
echo "Unzip vcpkg ..."
if [ -d $TARGET_VCPKG_DIR ]; then
    echo "vcpkg dir already exist, remove it ..."
    rm -rf $TARGET_VCPKG_DIR
fi
`xwsUnpackVcpkg $TARGET_VCPKG_FILE`

# build vcpkg
echo "Build vcpkg ..."
cd $TARGET_VCPKG_DIR
`echo $TARGET_VCPKG_VER > vcpkg.ver`
./bootstrap-vcpkg.bat

# build vcpkg
echo "Create triplets for VC2015 ..."
`cp triplets/x86-windows.cmake triplets/x86-windows-v140.cmake && echo "set(VCPKG_PLATFORM_TOOLSET v140)" >> triplets/x86-windows-v140.cmake`
`cp triplets/x64-windows.cmake triplets/x64-windows-v140.cmake && echo "set(VCPKG_PLATFORM_TOOLSET v140)" >> triplets/x64-windows-v140.cmake`
`cp triplets/x86-windows-static.cmake triplets/x86-windows-static-v140.cmake && echo "set(VCPKG_PLATFORM_TOOLSET v140)" >> triplets/x86-windows-static-v140.cmake`
`cp triplets/x64-windows-static.cmake triplets/x64-windows-static-v140.cmake && echo "set(VCPKG_PLATFORM_TOOLSET v140)" >> triplets/x64-windows-static-v140.cmake`

echo "Create triplets for VC2017 ..."
`cp triplets/x86-windows.cmake triplets/x86-windows-v141.cmake && echo "set(VCPKG_PLATFORM_TOOLSET v141)" >> triplets/x86-windows-v141.cmake`
`cp triplets/x64-windows.cmake triplets/x64-windows-v141.cmake && echo "set(VCPKG_PLATFORM_TOOLSET v141)" >> triplets/x64-windows-v141.cmake`
`cp triplets/x86-windows-static.cmake triplets/x86-windows-static-v141.cmake && echo "set(VCPKG_PLATFORM_TOOLSET v141)" >> triplets/x86-windows-static-v141.cmake`
`cp triplets/x64-windows-static.cmake triplets/x64-windows-static-v141.cmake && echo "set(VCPKG_PLATFORM_TOOLSET v141)" >> triplets/x64-windows-static-v141.cmake`

echo "Install vcpkg ..."
if [ -d $XWSROOT/external/vcpkg ]; then
    rm -rf $XWSROOT/external/vcpkg
fi
mkdir $XWSROOT/external/vcpkg
cp -rf $XWSROOT/temp/vcpkg/$TARGET_VCPKG_DIR/* $XWSROOT/external/vcpkg/

# clean up
echo "Cleanup ..."
rm -rf $XWSROOT/temp/vcpkg/$TARGET_VCPKG_DIR

cd $CURDIR
echo ""
echo "VCPKG Build Seccessfully"
