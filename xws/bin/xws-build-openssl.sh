#!/usr/bin/bash

# xwsGetOpenSSLOldGroups($1)
# $1 - optional, version group of openssl (e.g. '0.9.x', '1.0.2', '1.1.0').
#      use empty string to get latest version group.
# Return: a valid group name if call succeeds, empty otherwise
xwsGetOpenSSLOldGroups(){
    allGroups=`curl --silent --get http://openssl.skazkaforyou.com/source/old/ | grep '\[DIR\]' | grep -Po 'href="\K[^\/]*' | grep -v 'fips' | sort -r`
    if [ "$1" == "" ]; then
        arr=($allGroups)
        echo ${arr[0]}
    else
        for item in $allGroups; do
            if [ "$1" == "$item" ]; then
                echo $1
                break
            fi
        done
    fi
}

# xwsGetOpenSSLOldVersion($1)
# $1 - version group name of openssl (e.g. '0.9.x', '1.0.2', '1.1.0').
# Return: download file name of latest version in target group if call succeeds, empty otherwise
xwsGetOpenSSLOldVersionDownloadFileName(){
    group=`xwsGetOpenSSLOldGroups $1`
    if [ "$1" == "" ]; then
        echo ""
    else
        allVersions=`curl --silent --get http://openssl.skazkaforyou.com/source/old/$group/ | grep 'openssl-' | grep -Po 'href="\K[^"]*' | grep '.tar.gz$' | grep -v 'fips' | grep -v 'pre' | sort -r`
        arr=($allVersions)
        echo ${arr[0]}
    fi
}

# xwsGetOpenSSLVersion($1)
# $1 - optional, version of target openssl (e.g. '0.9.8g', '1.0.2n', '1.1.0f').
#      use empty string to get latest version.
# Return: a valid download file name of version if call succeeds, empty otherwise
xwsGetOpenSSLDownlaodFileName(){
    allVersions=`curl --silent --get http://openssl.skazkaforyou.com/source/ | grep 'openssl-' | grep -Po 'href="\K[^"]*' | grep '.tar.gz$' | grep -v 'fips' | grep -v 'pre' | sort -r`
    if [ "$1" == "" ]; then
        arr=($allVersions)
        echo ${arr[0]}
    else
        for item in $allVersions; do
            ver=`echo $item | sed 's/openssl-//' | sed 's/\.tart\.gz//'`
            if [ "$1" == "$ver" ]; then
                echo $item
                break
            fi
        done
    fi
}

xwsDownloadOpenSSL(){
    if [ "$1" == "" ]; then
        echo "Bad URL"
    else
        curl -L -O $1
    fi
}

xwsUnpackOpenSSL(){
    # Make sure file exist
    [ -f $1 ] || xwsAbort "OpenSSL package not exist"
    tar -xzf $1
}

xwsBuildOpenSSL(){
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

TARGET_OPENSSL_FILE=`xwsGetOpenSSLDownlaodFileName`
TARGET_OPENSSL_URL=http://openssl.skazkaforyou.com/source/$TARGET_OPENSSL_FILE
TARGET_OPENSSL_VERSION=`echo $TARGET_OPENSSL_FILE | sed 's/openssl-//' | sed 's/\.tar\.gz//'`
TARGET_OPENSSL_VERSION2=`echo $TARGET_OPENSSL_VERSION | sed 's/\./_/'g`
TARGET_OPENSSL_DIR=`echo $TARGET_OPENSSL_FILE | sed 's/\.tar\.gz//'`

echo "Target OpenSSL Version:  $TARGET_OPENSSL_VERSION"
echo "Target OpenSSL Version2: $TARGET_OPENSSL_VERSION2"
echo "Target OpenSSL URL:      $TARGET_OPENSSL_URL"
echo "OpenSSL FileName:        $TARGET_OPENSSL_FILE"
echo "OpenSSL Unzip Dir:       $TARGET_OPENSSL_DIR"

CURDIR=`xwsGetCurrentDir`
cd ../..
if [ ! -d temp/openssl ]; then
    mkdir -p temp/openssl
fi
cd temp/openssl

# download boost source code
if [ ! -f $TARGET_OPENSSL_FILE ]; then
    echo "Download OpenSSL ..."
    `xwsDownloadOpenSSL $TARGET_OPENSSL_URL`
fi

# unpack zip file
if [ ! -d $TARGET_OPENSSL_DIR ]; then
    echo "Unzip openssl ..."
    xwsUnpackOpenSSL $TARGET_OPENSSL_FILE
fi

cd $CURDIR

echo "OpenSSL has been downloaded"
