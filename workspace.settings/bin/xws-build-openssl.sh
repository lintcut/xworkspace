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
xwsGetOpenSSLOldVersion(){
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
xwsGetOpenSSLVersion(){
    allVersions=`curl --silent --get http://openssl.skazkaforyou.com/source/ | grep 'openssl-' | grep -Po 'href="\K[^"]*' | grep '.tar.gz$' | grep -v 'fips' | grep -v 'pre' | sort -r`
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

echo `xwsGetOpenSSLVersion $1`

echo `xwsGetOpenSSLOldVersion $1`