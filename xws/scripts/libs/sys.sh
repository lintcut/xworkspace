# Bash Lib for System

# get caller script dir, no matter how it is called
xbGetScriptDir(){
    scriptDir=$( cd "$(dirname "$0")" >/dev/null 2>&1 && pwd -P )
    echo $scriptDir
}

# get this script dir, no matter how it is called
xbGetXwsScriptsLibsDir(){
    xwsScriptsLibDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
    echo $xwsScriptsLibDir
}

# get xws root
xbGetXwsRootDir(){
    xwsRootDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd ../../ && pwd )
    echo $xwsRootDir
}

# get Workspace root
xbGetWorkspaceRootDir(){
    wsRootDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd ../../../ && pwd )
    echo $wsRootDir
}

xbGetOS(){
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