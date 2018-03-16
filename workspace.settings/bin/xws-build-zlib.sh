#!/usr/bin/bash

# xwsGetZlibDownloadUrl($1)
# $1 - optional, version of target zlib (e.g. '1.2.4.4').
#      use empty string to get latest version.
# Return: download URL if call succeeds, empty otherwise
xwsGetZlibDownloadUrl(){
    allVersions=`curl --silent --get https://github.com/madler/zlib/releases | grep tar.gz | grep -Po 'href="\K[^"]*' | sort -r`
    if [ "$1" == "" ]; then
        arr=($allVersions)
        echo https://github.com${arr[0]}
    else
        echo https://github.com/madler/zlib/archive/v$1.tar.gz
    fi
}

TARGET_BOOST_URL=`xwsGetZlibDownloadUrl $1`

echo "You can download zlib from $TARGET_BOOST_URL"