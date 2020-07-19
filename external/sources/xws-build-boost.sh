#!/usr/bin/bash

#===============================================================================
# Execution starts here
#===============================================================================

TARGET_BOOST_DIR=boost_1_73_0
VSVERSION=16.4

echo "Boost Dir:       $TARGET_BOOST_DIR"

cd $TARGET_BOOST_DIR

# build boostrap
echo ""
echo "Build boost static library (Release/x64):"
../xws-build-boost-cmd.bat $VSVERSION 64 release static

echo ""
echo "Build boost static library (Release/x86):"
../xws-build-boost-cmd.bat $VSVERSION 32 release static

echo ""
echo "Build boost static library (Debug/x64):"
../xws-build-boost-cmd.bat $VSVERSION 64 debug static

echo ""
echo "Build boost static library (Debug/x86):"
../xws-build-boost-cmd.bat $VSVERSION 32 debug static

#echo ""
#echo "Build boost DLL (Release/x64):"
#../../../xws/bin/xws-build-boost-cmd.bat 16.4 64 release shared
#
#echo ""
#echo "Build boost DLL (Release/x86):"
#../../../xws/bin/xws-build-boost-cmd.bat 16.4 32 release shared
#
#echo ""
#echo "Build boost DLL (Debug/x64):"
#../../../xws/bin/xws-build-boost-cmd.bat 16.4 64 debug shared
#
#echo ""
#echo "Build boost DLL (Debug/x86):"
#../../../xws/bin/xws-build-boost-cmd.bat 16.4 32 debug shared

echo ""
echo "Install ..."
echo "    - Headers"
if [ ! -d "$XWSROOT/external/include" ]; then
    mkdir -p $XWSROOT/external/include
fi
cp -r boost $XWSROOT/external/include/

echo "    - Release/x64"
if [ ! -d "$XWSROOT/external/libs/boost/release_x64" ]; then
    mkdir -p $XWSROOT/external/libs/boost/release_x64
fi
cp build.msvc/release_x64/staged/lib/*.* $XWSROOT/external/libs/boost/release_x64/

echo "    - Release/x86"
if [ ! -d "$XWSROOT/external/libs/boost/release_x86" ]; then
    mkdir -p $XWSROOT/external/libs/boost/release_x86
fi
cp build.msvc/release_x86/staged/lib/*.* $XWSROOT/external/libs/boost/release_x86/

echo "    - Debug/x64"
if [ ! -d "$XWSROOT/external/libs/boost/debug_x64" ]; then
    mkdir -p $XWSROOT/external/libs/boost/debug_x64
fi
cp build.msvc/debug_x64/staged/lib/*.* $XWSROOT/external/libs/boost/debug_x64/

echo "    - Debug/x86"
if [ ! -d "$XWSROOT/external/libs/boost/debug_x86" ]; then
    mkdir -p $XWSROOT/external/libs/boost/debug_x86
fi
cp build.msvc/debug_x86/staged/lib/*.* $XWSROOT/external/libs/boost/debug_x86/

cd $CURDIR
echo ""
echo "Boost Build Seccessfully"
