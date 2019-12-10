echo XWorkspace: Run Linux init scripts ...

##
##  Functions
##

xwsGetScriptDir(){
    scriptDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
    echo $scriptDir
}

xwsGetRoot(){
    scriptDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
    rootDir=`echo $scriptDir | sed 's/\/[a-zA-Z]*\/[a-zA-Z]*$//'`
    echo $rootDir
}

##
##  Export Path/Settings
##

export XWS=`echo \`xwsGetRoot\``
echo "  XWS Root Directory: $XWS"
export XWSROOT=`echo \`xwsGetRoot\``
echo "  XWSROOT Root Directory: $XWSROOT"

##
##  Alias
##

