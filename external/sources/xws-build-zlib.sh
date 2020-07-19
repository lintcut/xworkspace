#!/usr/bin/bash

CURDIR=`pwd`
echo "CurrentDir = $CURDIR"

cd zlib-1.2.11

make -f xws-build-zlib.mak BUILDARCH=x86 BUILDTYPE=release
make -f xws-build-zlib.mak BUILDARCH=x64 BUILDTYPE=release
make -f xws-build-zlib.mak BUILDARCH=x86 BUILDTYPE=debug
make -f xws-build-zlib.mak BUILDARCH=x64 BUILDTYPE=debug


mkdir -p $XWSROOT/external/libs/zlib/release_x86
mkdir -p $XWSROOT/external/libs/zlib/release_x64
mkdir -p $XWSROOT/external/libs/zlib/debug_x86
mkdir -p $XWSROOT/external/libs/zlib/debug_x64
mkdir -p $XWSROOT/external/include/zlib

cp -p output/win32_release_x86/zlib.lib $XWSROOT/external/libs/zlib/release_x86/
cp -p output/win32_release_x64/zlib.lib $XWSROOT/external/libs/zlib/release_x64/
cp -p output/win32_debug_x86/zlib.lib $XWSROOT/external/libs/zlib/debug_x86/
cp -p output/win32_debug_x64/zlib.lib $XWSROOT/external/libs/zlib/debug_x64/
cp -p zlib.h $XWSROOT/external/include/zlib/
cp -p zconf.h $XWSROOT/external/include/zlib/

cd ..
