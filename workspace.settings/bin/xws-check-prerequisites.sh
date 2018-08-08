#!/usr/bin/bash

echo "Checking prerequisites ..."

source xws-base.sh
source xws-appcheck.sh

OsName=`xwsGetOsName`
echo "  OS:             $OsName"

# Check global variables
if [ "$XWSROOT" == "" ]; then
    echo "  XWSROOT:        (Error: XWSROOT is not defined)"
    exit 1
else
    echo "  XWSROOT:        $XWSROOT"
fi

# Check python
VerPython=`xwsGetPythonVersion`
if [ "$VerPython" == "" ]; then
    echo "  Python:         (Error: Python is not found)"
    exit 1
else
    echo "  Python:         $VerPython"
fi

# Check perl
VerPerl=`xwsGetPerlVersion`
if [ "$VerPerl" == "" ]; then
    echo "  Perl:           (Error: Python is not found)"
    exit 1
else
    echo "  Perl:           $VerPerl"
fi

# Check GO
VerGO=`xwsGetGoVersion`
if [ "$VerGO" == "" ]; then
    echo "  GO:             (WARNING: GO is not found)"
else
    echo "  GO:             $VerGO"
fi

if [ "$OsName" == "Windows" ]; then
    # get Newest Visual Studio
    VerVisualStudio=`xwsGetNewestVisualStudioVersion`
    if [ "$VerVisualStudio" == "" ]; then
        echo "  Visual Studio:  (Error: Visual Studio is not found)"
        exit 1
    else
        echo "  Visual Studio:  Visual Studio $VerVisualStudio"
    fi

    # get WIn SDKs
    winSDKs=`xwsGetWinSdkVersions`
    if [ "$winSDKs" == "" ]; then
        echo "  Windows SDKs:   (WARNING: Windows SDK is not found)"
    else
        echo "  Windows SDKs:   $winSDKs"
    fi

    # get WIn WDKs
    winWDKs=`xwsGetWinWdkVersions`
    if [ "$winWDKs" == "" ]; then
        echo "  Windows WDKs:   (WARNING: Windows SDK is not found)"
    else
        echo "  Windows WDKs:   $winWDKs"
    fi
elif [ "$OsName" == "Mac" ]; then
    # check xcode version
    VerXcode=`xwsGetXcodeVersion`
    if [ "$VerXcode" == "" ]; then
        echo "  Xcode:          (Error: Xcode is not found)"
        exit 1
    else
        echo "  Xcode:          $VerXcode"
    fi
    # check xcode version
    macSDKs=`xwsGetXcodeFrameworkVersion`
    if [ "$macSDKs" == "" ]; then
        echo "  macSDK:        (Error: Xcode SDKs is not found)"
        exit 1
    else
        echo "  macSDK:        $macSDKs"
    fi
elif [ "$OsName" == "Linux" ]; then
    # check gcc version
    VerGcc=`xwsGetGccVersion`
    if [ "$VerGcc" == "" ]; then
        echo "  GCC:            (Error: gcc is not found)"
        exit 1
    else
        echo "  GCC:            $VerGcc"
    fi
    # check g++ version
    VerGpp=`xwsGetGppVersion`
    if [ "$VerGpp" == "" ]; then
        echo "  G++:            (Error: g++ is not found)"
        exit 1
    else
        echo "  G++:            $VerGpp"
    fi
else
    echo "Unsupported platform"
    exit 1
fi

# Final result
echo "Prerequisite check succeeded"