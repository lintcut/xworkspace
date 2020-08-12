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
    if [ -d "/c/Program Files (x86)" ]; then
        if [ -d "$dirProgramFiles/Java" ]; then
            echo "$dirProgramFiles/Java"
        else
            echo ""
        fi
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

xwsGetVisualStudioVersionNew(){
    version=`"$dirProgramFiles86/Microsoft Visual Studio/Installer/vswhere.exe" | grep catalog_productDisplayVersion | cut -d ' ' -f 2`
    echo $version
}

xwsGetVisualStudioDirNew(){
    #windir=`"$dirProgramFiles86/Microsoft Visual Studio/Installer/vswhere.exe" | grep installationPath | sed 's/installationPath: //' | sed 's/://'`
    if [ -f "$dirProgramFiles86/Microsoft Visual Studio/Installer/vswhere.exe" ]; then
        windir=`"$dirProgramFiles86/Microsoft Visual Studio/Installer/vswhere.exe" -property installationPath | sed 's/://'`
        dir="/${windir//\\//}"
    fi
    echo $dir
}

# xwsGetVisualStudioRootDir(vsver)
#   - vsver: vs2015, vs2017 and vs2019
xwsGetVisualStudioRootDir(){
    #windir=`"$dirProgramFiles86/Microsoft Visual Studio/Installer/vswhere.exe" | grep installationPath | sed 's/installationPath: //' | sed 's/://'`
    if [ $1. == vs2015. ]; then
        if [ -f "$dirProgramFiles86/Microsoft Visual Studio 14.0/VC/bin/cl.exe" ]; then
            dir=`echo "$dirProgramFiles86/Microsoft Visual Studio 14.0" | sed 's/://'`
        fi
    elif [ $1. == vs2017. ]; then
        if [ -f "$dirProgramFiles86/Microsoft Visual Studio/Installer/vswhere.exe" ]; then
            windir=`"$dirProgramFiles86/Microsoft Visual Studio/Installer/vswhere.exe" -version "[15.0,16.0)" -property installationPath | sed 's/://'`
            if [ "$windir" != "" ]; then
                dir="/${windir//\\//}"
            fi
        fi
    elif [ $1. == vs2019. ]; then
        if [ -f "$dirProgramFiles86/Microsoft Visual Studio/Installer/vswhere.exe" ]; then
            windir=`"$dirProgramFiles86/Microsoft Visual Studio/Installer/vswhere.exe" -version "[16.0,17.0)" -property installationPath | sed 's/://'`
            if [ "$windir" != "" ]; then
                dir="/${windir//\\//}"
            fi
        fi
    else
        if [ -f "$dirProgramFiles86/Microsoft Visual Studio/Installer/vswhere.exe" ]; then
            windir=`"$dirProgramFiles86/Microsoft Visual Studio/Installer/vswhere.exe" -property installationPath | sed 's/://'`
            if [ "$windir" != "" ]; then
                dir="/${windir//\\//}"
            fi
        fi
    fi
    echo $dir
}

# xwsGetVisualStudioToolsDir(vsver, root)
#   - vsver: vs2015, vs2017 and vs2019
xwsGetVisualStudioToolsDir(){
    #windir=`"$dirProgramFiles86/Microsoft Visual Studio/Installer/vswhere.exe" | grep installationPath | sed 's/installationPath: //' | sed 's/://'`
    if [ $1. == . ]; then
        exit
    fi
    if [ ! -d "$2" ]; then
        exit
    fi
    if [ $1. == vs2015. ]; then
        echo $2/VC
    elif [ $1. == vs2017. ]; then
        toolsets=`ls "$2/VC/Tools/MSVC" | sort -r | sed 's/\/*$//g'`
        arrtoolsets=($toolsets)
        if [ ${arrtoolsets[0]}. != . ]; then
            dir="$2/VC/Tools/MSVC/${arrtoolsets[0]}"
        fi
    elif [ $1. == vs2019. ]; then
        toolsets=`ls "$2/VC/Tools/MSVC" | sort -r | sed 's/\/*$//g'`
        arrtoolsets=($toolsets)
        if [ ${arrtoolsets[0]}. != . ]; then
            dir="$2/VC/Tools/MSVC/${arrtoolsets[0]}"
        fi
    else
        toolsets=`ls "$2/VC/Tools/MSVC" | sort -r | sed 's/\/*$//g'`
        arrtoolsets=($toolsets)
        if [ ${arrtoolsets[0]}. != . ]; then
            dir="$2/VC/Tools/MSVC/${arrtoolsets[0]}"
        fi
    fi
    echo $dir
}

# xwsGetVisualStudioToolsBinDir(vsver, arch, toolsdir)
#   - vsver: vs2015, vs2017 and vs2019
#   - arch:  x86, x64
xwsGetVisualStudioToolsBinDir(){
    #windir=`"$dirProgramFiles86/Microsoft Visual Studio/Installer/vswhere.exe" | grep installationPath | sed 's/installationPath: //' | sed 's/://'`
    if [ $1. == . ]; then
        exit
    fi
    if [ ! -d "$3" ]; then
        exit
    fi
    if [ $1. == vs2015. ]; then
        if [ "$dirProgramFiles86" == "$dirProgramFiles" ]; then
            # OS is 32 bits
            if [ $2. == x64. ]; then
                echo $3/bin/x86_amd64
            else
                echo $3/bin
            fi
        else
            # OS is 64 bits
            if [ $2. == x64. ]; then
                echo $3/bin/amd64
            else
                echo $3/bin
            fi
        fi
    elif [ $1. == vs2017. ]; then
        if [ "$dirProgramFiles86" == "$dirProgramFiles" ]; then
            # OS is 32 bits
            if [ $2. == x64. ]; then
                dir="$3/bin/Hostx86/x64"
            else
                dir="$3/bin/Hostx86/x86"
            fi
        else
            # OS is 64 bits
            if [ $2. == x64. ]; then
                dir="$3/bin/Hostx64/x64"
            else
                dir="$3/bin/Hostx64/x86"
            fi
        fi
    elif [ $1. == vs2019. ]; then
        if [ "$dirProgramFiles86" == "$dirProgramFiles" ]; then
            # OS is 32 bits
            if [ $2. == x64. ]; then
                dir="$3/bin/Hostx86/x64"
            else
                dir="$3/bin/Hostx86/x86"
            fi
        else
            # OS is 64 bits
            if [ $2. == x64. ]; then
                dir="$3/bin/Hostx64/x64"
            else
                dir="$3/bin/Hostx64/x86"
            fi
        fi
    else
        if [ "$dirProgramFiles86" == "$dirProgramFiles" ]; then
            # OS is 32 bits
            if [ $2. == x64. ]; then
                dir="$3/bin/Hostx86/x64"
            else
                dir="$3/bin/Hostx86/x86"
            fi
        else
            # OS is 64 bits
            if [ $2. == x64. ]; then
                dir="$3/bin/Hostx64/x64"
            else
                dir="$3/bin/Hostx64/x86"
            fi
        fi
    fi
    echo $dir
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

# Check Visual Studio 2015
export XVS2015DIR=`echo \`xwsGetVisualStudioRootDir vs2015\``
if [ "$XVS2015DIR" == "" ]; then
    echo "[VS2015]"
    echo "  - Not Found"
else
    export XVS2015TOOLSDIR=`echo \`xwsGetVisualStudioToolsDir vs2015 "$XVS2015DIR"\``
    export XVS2015TOOLSBIN32DIR=`echo \`xwsGetVisualStudioToolsBinDir vs2015 x86 "$XVS2015TOOLSDIR"\``
    export XVS2015TOOLSBIN64DIR=`echo \`xwsGetVisualStudioToolsBinDir vs2015 x64 "$XVS2015TOOLSDIR"\``
    echo "[VS2015]"
    echo "  - Root:     $XVS2015DIR"
    echo "  - Toolset:  $XVS2015TOOLSDIR"
    echo "  - ToolsX86: $XVS2015TOOLSBIN32DIR"
    echo "  - ToolsX64: $XVS2015TOOLSBIN64DIR"
    export XVSVER="140"
    export XVCTOOLSETVER="140"
    export XVSDIR="$XVS2015DIR"
    export XVSTOOLSDIR="$XVS2015TOOLSDIR"
    export XVSTOOLSBIN32DIR="$XVS2015TOOLSBIN32DIR"
    export XVSTOOLSBIN64DIR="$XVS2015TOOLSBIN64DIR"
fi

# Check Visual Studio 2017
export XVS2017DIR=`echo \`xwsGetVisualStudioRootDir vs2017\``
if [ "$XVS2017DIR" == "" ]; then
    echo "[VS2017]"
    echo "  - Not Found"
else
    export XVS2017TOOLSDIR=`echo \`xwsGetVisualStudioToolsDir vs2017 "$XVS2017DIR"\``
    export XVS2017TOOLSBIN32DIR=`echo \`xwsGetVisualStudioToolsBinDir vs2017 x86 "$XVS2017TOOLSDIR"\``
    export XVS2017TOOLSBIN64DIR=`echo \`xwsGetVisualStudioToolsBinDir vs2017 x64 "$XVS2017TOOLSDIR"\``
    if [ -f "$XVS2017DIR/VC/Tools/Llvm/bin/clang.exe" ]; then
        export XVSLLVM2017DIR="$XVS2017DIR/VC/Tools/Llvm"
    fi
    echo "[VS2017]"
    echo "  - Root:      $XVS2017DIR"
    echo "  - Toolset:   $XVS2017TOOLSDIR"
    echo "  - ToolsX86:  $XVS2017TOOLSBIN32DIR"
    echo "  - ToolsX64:  $XVS2017TOOLSBIN64DIR"
    echo "  - ToolsLlvm: $XVSLLVM2017DIR"
    export XVSVER="150"
    export XVCTOOLSETVER="141"
    export XVSDIR="$XVS2017DIR"
    export XVSTOOLSDIR="$XVS2017TOOLSDIR"
    export XVSTOOLSBIN32DIR="$XVS2017TOOLSBIN32DIR"
    export XVSTOOLSBIN64DIR="$XVS2017TOOLSBIN64DIR"
    export XVSLLVMDIR="$XVSLLVM2017DIR"
fi

# Check Visual Studio 2019
export XVS2019DIR=`echo \`xwsGetVisualStudioRootDir vs2019\``
if [ "$XVS2019DIR" == "" ]; then
    echo "[VS2019]"
    echo "  - Not Found"
else
    export XVS2019TOOLSDIR=`echo \`xwsGetVisualStudioToolsDir vs2019 "$XVS2019DIR"\``
    export XVS2019TOOLSBIN32DIR=`echo \`xwsGetVisualStudioToolsBinDir vs2019 x86 "$XVS2019TOOLSDIR"\``
    export XVS2019TOOLSBIN64DIR=`echo \`xwsGetVisualStudioToolsBinDir vs2019 x64 "$XVS2019TOOLSDIR"\``
    if [ -f "$XVS2019DIR/VC/Tools/Llvm/bin/clang.exe" ]; then
        export XVSLLVM2019DIR="$XVS2019DIR/VC/Tools/Llvm"
    fi
    echo "[VS2019]"
    echo "  - Root:      $XVS2019DIR"
    echo "  - Toolset:   $XVS2019TOOLSDIR"
    echo "  - ToolsX86:  $XVS2019TOOLSBIN32DIR"
    echo "  - ToolsX64:  $XVS2019TOOLSBIN64DIR"
    echo "  - ToolsLlvm: $XVSLLVM2019DIR"
    export XVSVER="160"
    export XVCTOOLSETVER="142"
    export XVSDIR="$XVS2019DIR"
    export XVSTOOLSDIR="$XVS2019TOOLSDIR"
    export XVSTOOLSBIN32DIR="$XVS2019TOOLSBIN32DIR"
    export XVSTOOLSBIN64DIR="$XVS2019TOOLSBIN64DIR"
    export XVSLLVMDIR="$XVSLLVM2019DIR"
fi

echo "[Default Visual Studio]"
echo "  - Root:       $XVSDIR"
echo "  - ToolsetVer: $XVCTOOLSETVER"
echo "  - ToolsX86:   $XVSTOOLSBIN32DIR"
echo "  - ToolsX64:   $XVSTOOLSBIN64DIR"
echo "  - ToolsLlvm:  $XVSLLVMDIR"

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

echo "[Default SDK]"
echo "  - Version: $XSDKVER"
echo "  - Include: $XSDKINCDIR"
echo "  - Libs:    $XSDKLIBDIR"

echo "[Default WDK]"
echo "  - Version: $XWDKVER"
echo "  - Include: $XWDKINCDIR"
echo "  - Libs:    $XWDKLIBDIR"

echo "[JDK]"
echo "  - home: $XJDKHOME"
echo "  - x86:  $XJDK32DIR"
echo "  - x64:  $XJDK64DIR"

echo "[JRE]"
echo "  - x86: $XJRE32DIR"
echo "  - x64: $XJRE64DIR"

##
##  Alias
##

