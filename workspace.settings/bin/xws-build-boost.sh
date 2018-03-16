#!/usr/bin/bash

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

TARGET_BOOST_VERSION=`xwsGetBoostVersion $1`
TARGET_BOOST_URL=`xwsGetBoostDownloadUrl $1`

echo "Target Boost is $TARGET_BOOST_VERSION"
echo "You can download from $TARGET_BOOST_URL"