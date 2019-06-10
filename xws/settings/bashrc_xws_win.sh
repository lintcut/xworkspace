echo XWorkspace: Run Windows init scripts ...

##
##  Functions
##

xwsGetScriptDir(){
    scriptDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
    echo $scriptDir
}

xwsGetProgramFiles(){
    echo "/c/Program Files"
}

xwsGetProgramFiles86(){
    if [ -d "/c/Program Files (x86)" ]; then
        echo "/c/Program Files (x86)"
    else
        echo "/c/Program Files"
    fi
}

export dirProgramFiles=`echo \`xwsGetProgramFiles\``
echo "  ProgramFiles Directory: $dirProgramFiles"
export dirProgramFiles86=`echo \`xwsGetProgramFiles86\``
echo "  ProgramFilesX86 Directory: $dirProgramFiles86"

xwsGetRoot(){
    scriptDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
    rootDir=`echo $scriptDir | sed 's/\/[a-zA-Z]*\/[a-zA-Z]*$//'`
    echo $rootDir
}

export XWS=`echo \`xwsGetRoot\``
echo "  XWS Root Directory: $XWS"

xwsGetJava64Dir(){
    if [ -d "$dirProgramFiles64/Java" ]; then
        echo "$dirProgramFiles64/Java"
    else
        echo ""
    fi
}

echo "  Java64 Directory: `xwsGetJava64Dir`"

xwsGetJava32Dir(){
    if [ -d "$dirProgramFiles86/Java" ]; then
        echo "$dirProgramFiles86/Java"
    else
        echo ""
    fi
}
echo "  Java32 Directory: `xwsGetJava32Dir`"

xwsGetJdk64Dir(){
    java64Dir=`echo \`xwsGetJava64Dir\``
    if [ -d "$java64Dir" ]; then
        versions=`ls "$java64Dir" | grep -e "jdk-[\.0123456789]" | sed 's/\/$//' | sort -nr`
        arr=($versions)
        if [ -d "$java64Dir/${arr[0]}" ]; then
            echo "$java64Dir/${arr[0]}"
        fi
    fi
}

xwsGetJdk32Dir(){
    java32Dir=`echo \`xwsGetJava32Dir\``
    if [ -d "$java32Dir" ]; then
        versions=`ls "$java32Dir" | grep "jdk-" | grep -e "[\.0123456789]" | sed 's/\/$//' | sort -nr`
        arr=($versions)
        if [ -d "$java32Dir/${arr[0]}" ]; then
            echo "$java32Dir/${arr[0]}"
        fi
    fi
}

xwsGetJre64Dir(){
    java64Dir=`echo \`xwsGetJava64Dir\``
    if [ -d "$java64Dir" ]; then
        versions=`ls "$java64Dir" | grep "jre-" | grep -e "[\.0123456789]" | sed 's/\/$//' | sort -r`
        arr=($versions)
        if [ -d "$java64Dir/${arr[0]}" ]; then
            echo "$java64Dir/${arr[0]}"
        fi
    fi
}

xwsGetJre32Dir(){
    java32Dir=`echo \`xwsGetJava32Dir\``
    if [ -d "$java32Dir" ]; then
        versions=`ls "$java32Dir" | grep "jre-" | grep -e "[\.0123456789]" | sed 's/\/$//' | sort -r`
        arr=($versions)
        if [ -d "$java32Dir/${arr[0]}" ]; then
            echo "$java32Dir/${arr[0]}"
        fi
    fi
}

xwsGetVisualStudioVersions(){
    versions=`echo \`ls "$dirProgramFiles86" | grep "Microsoft Visual Studio " | sed "s/Microsoft Visual Studio //" | sort -nr\``
    for ver in $versions; do
        if [ -f "$dirProgramFiles86/Microsoft Visual Studio $ver/VC/bin/cl.exe" ]; then
            result=`echo $result $ver`
        fi
    done
    echo $result
}

xwsGetNewestVisualStudioVersion(){
    versions=`echo \`xwsGetVisualStudioVersions\``
    arr=($versions)
    echo ${arr[0]}
}

xwsGetVisualStudioVersion(){
    versions=`echo \`xwsGetVisualStudioVersions\``
    if [ $1. == . ]; then
        versions=`echo \`xwsGetVisualStudioVersions\``
        arr=($versions)
        echo ${arr[0]}
    else
        for ver in $versions; do
            if [ $ver. == $1. ]; then
                result=`echo $ver`
                echo $result
                break
            fi
        done
    fi
}

# get windows SDK version list
xwsGetWinSdkVersions(){
    dirProgramFiles86=`echo \`xwsGetProgramFiles86\``
    if [ -d "$dirProgramFiles86/Windows Kits" ]; then
        kitsVersions=`ls "$dirProgramFiles86/Windows Kits" | grep -e "[\.0123456789]" | sed 's/\/$//'`
        for ver in $kitsVersions; do
            if [ $ver. == 10. ]; then
                fullVersions=`ls "$dirProgramFiles86/Windows Kits/$ver/Include" | grep -e "[\.0123456789]" | sed 's/\/$//' | sort -r`
                for item in $fullVersions; do
                    if [ -d "$dirProgramFiles86/Windows Kits/$ver/Include/$item/um" ]; then
                        result=`echo $result $item`
                    fi
                done
            else
                if [ -d "$dirProgramFiles86/Windows Kits/$ver/Include/um" ]; then
                    result=`echo $result $ver`
                fi
            fi
        done
        echo $result
    else
        echo ""
    fi
}

xwsGetNewestWinSdkVersion(){
    versions=`echo \`xwsGetWinSdkVersions\``
    arr=($versions)
    echo ${arr[0]}
}

# get windows WDK version list
xwsGetWinWdkVersions(){
    dirProgramFiles86=`echo \`xwsGetProgramFiles86\``
    if [ -d "$dirProgramFiles86/Windows Kits" ]; then
        kitsVersions=`ls "$dirProgramFiles86/Windows Kits" | grep -e "[\.0123456789]" | sed 's/\/$//' | sort -nr`
        for ver in $kitsVersions; do
            if [ $ver. == 10. ]; then
                fullVersions=`ls "$dirProgramFiles86/Windows Kits/$ver/Include" | grep -e "[\.0123456789]" | sed 's/\/$//' | sort -nr`
                for item in $fullVersions; do
                    if [ ! -d "$dirProgramFiles86/Windows Kits/$ver/Include/$item/km" ]; then
                        continue
                    fi
                    if [ ! -d "$dirProgramFiles86/Windows Kits/$ver/Lib/$item/km" ]; then
                        continue
                    fi
                    result=`echo $result $item`
                done
            else
                if [ -d "$dirProgramFiles86/Windows Kits/$ver/Include/km" ]; then
                    result=`echo $result $ver`
                fi
            fi
        done
        echo $result
    else
        echo ""
    fi
}

xwsGetNewestWinWdkVersion(){
    versions=`echo \`xwsGetWinWdkVersions\``
    arr=($versions)
    echo ${arr[0]}
}

xwsSplitWinKitVersion(){
    echo "$1" | sed "y/\./ /"
}

xwsGetWinKitVersionMajor(){
    if [ $1. == . ]; then
        echo ""
    else
        versions=`echo \`xwsSplitWinKitVersion $1\``
        arr=($versions)
        echo ${arr[0]}
    fi
}

xwsGetWinKitDir(){
    if [ $1. == . ]; then
        echo ""
    else
        verMajor=`echo \`xwsGetWinKitVersionMajor $1\``
        if [ $verMajor. == 10. ]; then
            echo "$dirProgramFiles86/Windows Kits/10"
        elif [ $verMajor. == 8. ]; then
            echo "$dirProgramFiles86/Windows Kits/$1"
        else
            echo ""
        fi
    fi
}

##
##  Export Path/Settings
##
export XJDK32DIR=`echo \`xwsGetJdk32Dir\``
export XJDK64DIR=`echo \`xwsGetJdk64Dir\``
export XJRE32DIR=`echo \`xwsGetJre32Dir\``
export XJRE64DIR=`echo \`xwsGetJre64Dir\``

if [ ! -z "$XJDK64DIR" ]; then
	export XJDKHOME=`echo $XJDK64DIR`
elif [ ! -z "$XJDK32DIR" ]; then
	export XJDKHOME=`echo $XJDK32DIR`
else
	echo "JDK not installed"
fi

if [ ! -z "$XJDKHOME" ]; then
	export PATH=$PATH:"$XJDKHOME/bin"
fi

export XVSVER=`echo \`xwsGetNewestVisualStudioVersion\``
if [ -d "$dirProgramFiles86/Microsoft Visual Studio $XVSVER" ]; then
    export XVSDIR="$dirProgramFiles86/Microsoft Visual Studio $XVSVER"
fi

export XSDKVER=`echo \`xwsGetNewestWinSdkVersion\``
if [ $XSDKVER. == . ]; then
    echo "ERROR: Windows SDK not found!"
else
    export XSDKVERMAJOR=`echo \`xwsGetWinKitVersionMajor $XSDKVER\``
    if [ $XSDKVERMAJOR. == 10. ]; then
        export XSDKDIR="$dirProgramFiles86/Windows Kits/10"
        export XSDKINCDIR="$dirProgramFiles86/Windows Kits/10/Include/$XSDKVER"
        export XSDKLIBDIR="$dirProgramFiles86/Windows Kits/10/Lib/$XSDKVER"
    else
        export XSDKDIR="$dirProgramFiles86/Windows Kits/$XSDKVER"
        export XSDKINCDIR="$dirProgramFiles86/Windows Kits/$XSDKVER/Include"
        export XSDKLIBDIR="$dirProgramFiles86/Windows Kits/$XSDKVER/Lib"
    fi
fi

export XWDKVER=`echo \`xwsGetNewestWinWdkVersion\``
if [ $XWDKVER. == . ]; then
    echo "ERROR: Windows WDK not found!"
else
    export XWDKVERMAJOR=`echo \`xwsGetWinKitVersionMajor $XWDKVER\``
    if [ $XWDKVERMAJOR. == 10. ]; then
        export XWDKDIR="$dirProgramFiles86/Windows Kits/10"
        export XWDKINCDIR="$dirProgramFiles86/Windows Kits/10/Include/$XWDKVER"
        export XWDKLIBDIR="$dirProgramFiles86/Windows Kits/10/Lib/$XWDKVER"
    else
        export XWDKDIR="$dirProgramFiles86/Windows Kits/$XWDKVER"
        export XWDKINCDIR="$dirProgramFiles86/Windows Kits/$XWDKVER/Include"
        export XWDKLIBDIR="$dirProgramFiles86/Windows Kits/$XWDKVER/Lib"
    fi
fi

echo "  Visual Studio Version: $XVSVER"
echo "  Visual Studio Dir: $XVSDIR"
echo "  Windows SDK Version: $XSDKVER"
echo "  Windows SDK Version Major: $XSDKVERMAJOR"
echo "  Windows SDK Include: $XSDKINCDIR"
echo "  Windows SDK Lib: $XSDKLIBDIR"
echo "  Windows WDK Version: $XWDKVER"
echo "  Windows WDK Version Major: $XWDKVERMAJOR"
echo "  Windows WDK Include: $XWDKINCDIR"
echo "  Windows WDK Lib: $XWDKLIBDIR"
echo "  JDK (32 bits): $XJDK32DIR"
echo "  JDK (64 bits): $XJDK64DIR"
echo "  JRE (32 bits): $XJRE32DIR"
echo "  JRE (64 bits): $XJRE64DIR"
echo "  JDKHOME:       $XJDKHOME"

##
##  Alias
##

