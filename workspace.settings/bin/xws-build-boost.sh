#!/usr/bin/bash

source xws-base.sh

xwsGetBoostVersion(){
    allVersions=`curl --silent --get http://www.boost.org/users/history/ | grep -Po 'Version \K[\.0123456789]*'`
    if [ "$1" == "" ]; then
        arr=($allVersions)
        echo ${arr[0]}
    else
        for item in $allVersions; do
            if [ "$1" == $item ]; then
                echo $1
                break
            fi
        done
    fi
}

xwsGetBoostDownloadUrl(){
    TargetVersion=`xwsGetBoostVersion $1`
    if [ "$TargetVersion" == "" ]; then
        echo ""
    else
        fileVersion=`echo $TargetVersion | sed -r "s/\./_/g"`
        fileName=`curl --silent --get https://dl.bintray.com/boostorg/release/$TargetVersion/source/ | grep "$fileVersion.tar.gz<" | grep -Po '">\K[^<]*'`
        echo "https://dl.bintray.com/boostorg/release/$TargetVersion/source/$fileName"
    fi
}

xwsDownloadBoost(){
    if [ "$1" == "" ]; then
        echo "Bad URL"
    else
        curl -L -O $1
    fi
}

xwsUnpackBoost(){
    # Make sure file exist
    [ -f $1 ] || xwsAbort "boost  package not exist"
    tar -xzf $1
}

#===============================================================================
# Execution starts here
#===============================================================================

TARGET_BOOST_VERSION=`xwsGetBoostVersion $1`
TARGET_BOOST_VERSION2=`echo $TARGET_BOOST_VERSION | sed 's/\./_/'g`
TARGET_BOOST_URL=`xwsGetBoostDownloadUrl $1`
TARGET_BOOST_FILE=`echo $TARGET_BOOST_URL | sed 's/.*\///g'`
TARGET_BOOST_DIR=`echo $TARGET_BOOST_FILE | sed 's/\.tar\.gz//'`

echo "Target Boost Version:  $TARGET_BOOST_VERSION"
echo "Target Boost Version2: $TARGET_BOOST_VERSION2"
echo "Target Boost URL:      $TARGET_BOOST_URL"
echo "Boost FileName:        $TARGET_BOOST_FILE"
echo "Boost Unzip Dir:       $TARGET_BOOST_DIR"

CURDIR=`xwsGetCurrentDir`
cd ../..
if [ ! -d temp/boost ]; then
    mkdir -p temp/boost
fi
cd temp/boost

# download boost source code
if [ ! -f $TARGET_BOOST_FILE ]; then
    echo "Download boost ..."
    `xwsDownloadBoost $TARGET_BOOST_URL`
fi

# unpack zip file
if [ ! -d $TARGET_BOOST_DIR ]; then
    echo "Unzip boost ..."
    xwsUnpackBoost $TARGET_BOOST_FILE
fi

cd $TARGET_BOOST_DIR

# build boostrap
echo ""
echo "Build boost static library (Release/x64):"
../../../workspace.settings/bin/xws-build-boost-cmd.bat 14.0 64 release static

echo ""
echo "Build boost static library (Release/x86):"
../../../workspace.settings/bin/xws-build-boost-cmd.bat 14.0 32 release static

echo ""
echo "Build boost static library (Debug/x64):"
../../../workspace.settings/bin/xws-build-boost-cmd.bat 14.0 64 debug static

echo ""
echo "Build boost static library (Debug/x86):"
../../../workspace.settings/bin/xws-build-boost-cmd.bat 14.0 32 debug static

echo ""
echo "Build boost DLL (Release/x64):"
../../../workspace.settings/bin/xws-build-boost-cmd.bat 14.0 64 release shared

echo ""
echo "Build boost DLL (Release/x86):"
../../../workspace.settings/bin/xws-build-boost-cmd.bat 14.0 32 release shared

echo ""
echo "Build boost DLL (Debug/x64):"
../../../workspace.settings/bin/xws-build-boost-cmd.bat 14.0 64 debug shared

echo ""
echo "Build boost DLL (Debug/x86):"
../../../workspace.settings/bin/xws-build-boost-cmd.bat 14.0 32 debug shared

echo ""
echo "Install ..."
echo "    - Headers"
if [ ! -d "../../../external/boost/$TARGET_BOOST_VERSION2/include" ]; then
    mkdir -p ../../../external/boost/$TARGET_BOOST_VERSION2/include
fi
cp -r boost ../../../external/boost/$TARGET_BOOST_VERSION2/include/

echo "    - Release/x64"
if [ ! -d "../../../external/boost/$TARGET_BOOST_VERSION2/libs/release_x64" ]; then
    mkdir -p ../../../external/boost/$TARGET_BOOST_VERSION2/libs/release_x64
fi
cp build.msvc/release_64/staged/lib/*.* ../../../external/boost/$TARGET_BOOST_VERSION2/libs/release_x64/

echo "    - Release/x86"
if [ ! -d "../../../external/boost/$TARGET_BOOST_VERSION2/libs/release_x86" ]; then
    mkdir -p ../../../external/boost/$TARGET_BOOST_VERSION2/libs/release_x86
fi
cp build.msvc/release_32/staged/lib/*.* ../../../external/boost/$TARGET_BOOST_VERSION2/libs/release_x86/

echo "    - Debug/x64"
if [ ! -d "../../../external/boost/$TARGET_BOOST_VERSION2/libs/debug_x64" ]; then
    mkdir -p ../../../external/boost/$TARGET_BOOST_VERSION2/libs/debug_x64
fi
cp build.msvc/debug_64/staged/lib/*.* ../../../external/boost/$TARGET_BOOST_VERSION2/libs/debug_x64/

echo "    - Debug/x86"
if [ ! -d "../../../external/boost/$TARGET_BOOST_VERSION2/libs/debug_x86" ]; then
    mkdir -p ../../../external/boost/$TARGET_BOOST_VERSION2/libs/debug_x86
fi
cp build.msvc/debug_32/staged/lib/*.* ../../../external/boost/$TARGET_BOOST_VERSION2/libs/debug_x86/

cd $CURDIR
echo ""
echo "Boost Build Seccessfully"
