#!/usr/bin/bash

source xws-base.sh

# get Python version
xwsGetPythonVersion(){
    echo `python -c "import sys;t='{v[0]}.{v[1]}.{v[2]}'.format(v=list(sys.version_info[:3]));sys.stdout.write(t)"`
}

# get Perl version
xwsGetPerlVersion(){
    echo `perl -v | grep subversion | grep -Po '\(v\K[^)]*'`
}

# get GO version
xwsGetGoVersion(){
    echo `go version | sed "s/go version //" | sed "s/ .*//" | sed "s/go//"`
}

# get Visual Studio versions
xwsGetVisualStudioVersions(){
    dirProgramFiles86=`xwsGetProgramFiles86`
    echo `ls "$dirProgramFiles86" | grep "Microsoft Visual Studio " | sort -r | sed "s/Microsoft Visual Studio //"`
}

xwsGetNewestVisualStudioVersion(){
    versions=`xwsGetVisualStudioVersions`
    if [ version. == . ]; then
        echo ""
    else
        arr=($versions)
        echo ${arr[0]}
    fi
}

# get windows SDK version list
xwsGetWinSdkVersions(){
    dirProgramFiles86=`xwsGetProgramFiles86`
    if [ -d "$dirProgramFiles86/Windows Kits" ]; then
        kitsVersions=`ls "$dirProgramFiles86/Windows Kits" | grep -e "[\.0123456789]"`
        for ver in $kitsVersions; do
            if [ $ver. == 10. ]; then
                fullVersions=`ls "$dirProgramFiles86/Windows Kits/$ver/Include" | grep -e "[\.0123456789]" | sort -r`
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

# get windows WDK version list
xwsGetWinWdkVersions(){
    dirProgramFiles86=`xwsGetProgramFiles86`
    if [ -d "$dirProgramFiles86/Windows Kits" ]; then
        kitsVersions=`ls "$dirProgramFiles86/Windows Kits" | grep -e "[\.0123456789]"`
        for ver in $kitsVersions; do
            if [ $ver. == 10. ]; then
                fullVersions=`ls "$dirProgramFiles86/Windows Kits/$ver/Include" | grep -e "[\.0123456789]" | sort -r`
                for item in $fullVersions; do
                    if [ -d "$dirProgramFiles86/Windows Kits/$ver/Include/$item/km" ]; then
                        result=`echo $result $item`
                    fi
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

# get gcc version
xwsGetGccVersion(){
    echo "None"
}

# get g++ version
xwsGetGppVersion(){
    echo "None"
}

# get clang version
xwsGetClangVersion(){
    echo "None"
}

# get xcode version
xwsGetXcodeVersion(){
    echo "None"
}

# get xcode framework version
xwsGetXcodeFrameworkVersion(){
    echo "None"
}