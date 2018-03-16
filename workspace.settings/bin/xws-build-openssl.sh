#!/usr/bin/bash


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