#!/usr/bin/bash

# lower-case string
xwstolower(){
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

# upper-case string
xwstoupper(){
    echo "$1" | sed "y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/"
}

# get os name
xwsGetOsName(){
    UNAMESTR=`xwstoupper \`uname -s\``
    if [[ "$UNAMESTR" == MINGW* ]]; then
        echo Windows
    elif [[ "$UNAMESTR" == *LINUX* ]]; then
        echo Linux
    elif [ "{$UNAMESTR}" == "{FREEBSD}" ]; then
        echo FreeBSD
    elif [[ "$UNAMESTR" == DARWIN* ]]; then
        echo Mac
    else
        echo Unknown
    fi
}

# get current directory
xwsGetCurrentDir(){
    echo `pwd`
}

# get windows Program File (x86) directory
xwsGetProgramFiles86(){
    if [ -d "/c/Program Files (x86)" ]; then
        echo "/c/Program Files (x86)"
    else
        echo "/c/Program Files"
    fi
}