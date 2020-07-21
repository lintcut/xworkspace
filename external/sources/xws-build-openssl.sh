#!/usr/bin/bash

#===============================================================================
# Execution starts here
#===============================================================================

TARGET_OPENSSL_SRC=openssl-1.1.1g

echo "OpenSSL:  $TARGET_OPENSSL_SRC"

#-----------------------------------------------------
# Build openssl static library (Release/x64)
#-----------------------------------------------------
echo ""
echo "Build openssl static library (Release/x64):"
TARGET_OPENSSL_TEMPDIR=openssl-release-x64
#       Prepare temp folder
if [ -d $TARGET_OPENSSL_TEMPDIR ]; then
    rm -rf $TARGET_OPENSSL_TEMPDIR
fi
echo "cp -ar $TARGET_OPENSSL_SRC $TARGET_OPENSSL_TEMPDIR"
cp -ar $TARGET_OPENSSL_SRC $TARGET_OPENSSL_TEMPDIR

# Build
cd $TARGET_OPENSSL_TEMPDIR
../xws-build-openssl-cmd.bat 16.4 64 release

# Copy files
if [ ! -d "$XWSROOT/external/include/openssl" ]; then
    mkdir -p "$XWSROOT/external/include/openssl"
fi
cp -r include/openssl $XWSROOT/external/include/

if [ ! -d "$XWSROOT/external/libs/openssl/release_x64" ]; then
    mkdir -p $XWSROOT/external/libs/openssl/release_x64
fi
cp *.lib $XWSROOT/external/libs/openssl/release_x64/

if [ ! -d "$XWSROOT/external/bin/x64" ]; then
    mkdir -p $XWSROOT/external/bin/x64
fi
cp apps/*.exe $XWSROOT/external/bin/x64/
# Quit
cd ..
rm -rf $TARGET_OPENSSL_TEMPDIR


#-----------------------------------------------------
# Build openssl static library (Release/x86)
#-----------------------------------------------------
echo ""
echo "Build openssl static library (Release/x86):"
TARGET_OPENSSL_TEMPDIR=openssl-release-x86
#       Prepare temp folder
if [ -d $TARGET_OPENSSL_TEMPDIR ]; then
    rm -rf $TARGET_OPENSSL_TEMPDIR
fi
echo "cp -ar $TARGET_OPENSSL_SRC $TARGET_OPENSSL_TEMPDIR"
cp -ar $TARGET_OPENSSL_SRC $TARGET_OPENSSL_TEMPDIR

# Build
cd $TARGET_OPENSSL_TEMPDIR
../xws-build-openssl-cmd.bat 16.4 32 release

# Copy files
if [ ! -d "$XWSROOT/external/libs/openssl/release_x86" ]; then
    mkdir -p $XWSROOT/external/libs/openssl/release_x86
fi
cp *.lib $XWSROOT/external/libs/openssl/release_x86/

if [ ! -d "$XWSROOT/external/bin/x86" ]; then
    mkdir -p $XWSROOT/external/bin/x86
fi
cp apps/*.exe $XWSROOT/external/bin/x86/
# Quit
cd ..
rm -rf $TARGET_OPENSSL_TEMPDIR


#-----------------------------------------------------
# Build openssl static library (Debug/x64)
#-----------------------------------------------------
echo ""
echo "Build openssl static library (Debug/x64):"
TARGET_OPENSSL_TEMPDIR=openssl-debug-x64
#       Prepare temp folder
if [ -d $TARGET_OPENSSL_TEMPDIR ]; then
    rm -rf $TARGET_OPENSSL_TEMPDIR
fi
echo "cp -ar $TARGET_OPENSSL_SRC $TARGET_OPENSSL_TEMPDIR"
cp -ar $TARGET_OPENSSL_SRC $TARGET_OPENSSL_TEMPDIR

# Build
cd $TARGET_OPENSSL_TEMPDIR
../xws-build-openssl-cmd.bat 16.4 64 debug

# Copy files
if [ ! -d "$XWSROOT/external/libs/openssl/debug_x64" ]; then
    mkdir -p $XWSROOT/external/libs/openssl/debug_x64
fi
cp *.lib $XWSROOT/external/libs/openssl/debug_x64/
cp *.pdb $XWSROOT/external/libs/openssl/debug_x64/

# Quit
cd ..
rm -rf $TARGET_OPENSSL_TEMPDIR


#-----------------------------------------------------
# Build openssl static library (Debug/x86)
#-----------------------------------------------------
echo ""
echo "Build openssl static library (Debug/x86):"
TARGET_OPENSSL_TEMPDIR=openssl-debug-x86
#       Prepare temp folder
if [ -d $TARGET_OPENSSL_TEMPDIR ]; then
    rm -rf $TARGET_OPENSSL_TEMPDIR
fi
echo "cp -ar $TARGET_OPENSSL_SRC $TARGET_OPENSSL_TEMPDIR"
cp -ar $TARGET_OPENSSL_SRC $TARGET_OPENSSL_TEMPDIR

# Build
cd $TARGET_OPENSSL_TEMPDIR
../xws-build-openssl-cmd.bat 16.4 32 debug

# Copy files
if [ ! -d "$XWSROOT/external/libs/openssl/debug_x86" ]; then
    mkdir -p $XWSROOT/external/libs/openssl/debug_x86
fi
cp *.lib $XWSROOT/external/libs/openssl/debug_x86/
cp *.pdb $XWSROOT/external/libs/openssl/debug_x86/

# Quit
cd ..
rm -rf $TARGET_OPENSSL_TEMPDIR


echo "OpenSSL has been built successfully"
