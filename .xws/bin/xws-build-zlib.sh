#!/usr/bin/bash


xwsGetZlibVersion(){
    allVersions=`curl --silent --get https://github.com/madler/zlib/releases | grep tar.gz | grep -Po 'href="\K[^"]*' | sort -r`
    arr=($allVersions)
    echo ${arr[0]}
}

# xwsGetZlibDownloadUrl($1)
# $1 - optional, version of target zlib (e.g. '1.2.4.4').
#      use empty string to get latest version.
# Return: download URL if call succeeds, empty otherwise
xwsGetZlibDownloadUrl(){
    verZlib=`xwsGetZlibVersion`
    echo https://github.com/madler/zlib/archive/v$verZlib.tar.gz
}

TARGET_BOOST_URL=`xwsGetZlibDownloadUrl $1`

echo "You can download zlib from $TARGET_BOOST_URL"