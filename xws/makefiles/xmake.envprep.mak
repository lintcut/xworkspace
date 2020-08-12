#######################################################################
#
# XWORKSPACE MAKEFILE: ENVIRONMENT PREP
#
#     This file check and prepare environment settings, software and
#     so on
#
########################################################################

#
#  Check default software, sdk, wdk, etc.
#
ifeq ($(dirProgramFiles),)
    $(error xmake.envprep: Dir ProgramFiles is not found)
endif

ifeq ($(dirProgramFiles86),)
    $(error xmake.envprep: Dir ProgramFilesX86 is not found)
endif

ifeq ($(XVSVER),)
    $(error xmake.envprep: Default Visual Studio version is not defined, run $(XWSROOT)/xws/settings/bashrc_xws_win.sh first)
endif

ifeq ($(XVSDIR),)
    $(error xmake.envprep: Visual Studio is not found)
endif

ifeq ($(XSDKVER),)
    $(error xmake.envprep: Default Windows SDK version is not defined, run $(XWSROOT)/xws/settings/bashrc_xws_win.sh first)
endif

ifeq ($(XSDKDIR),)
    $(error xmake.envprep: Default SDK is not found)
endif

ifeq ($(TARGETMODE),kernel)
    ifeq ($(XWDKVER),)
        $(error xmake.envprep: Default Windows WDK version is not defined, run $(XWSROOT)/xws/settings/bashrc_xws_win.sh first)
    endif
    ifeq ($(XWDKDIR),)
        $(error xmake.envprep: Default WDK is not found)
    endif
endif

#
#  Override software, sdk, wdk, etc.
#
XBUILD_VSVER=$(TARGET_VSVER)
XBUILD_VCTOOLSETVER=
XBUILD_VCROOTDIR=
XBUILD_VCBINDIR=
XBUILD_VCINCDIR=
XBUILD_VCLIBDIR=
XBUILD_VCATLMFC_INCDIR=
XBUILD_VCATLMFC_LIBDIR=

# User define a different VC version other than default one
ifneq ($(XBUILD_VSVER),$(XVSVER))
    # Check VS2015
    ifeq ($(XBUILD_VSVER),140)
        ifneq ($(XVS2015TOOLSDIR),)
            XBUILD_VCTOOLSETVER=140
            XBUILD_VCROOTDIR=$(XVS2015DIR)
            XBUILD_VCINCDIR=$(XVS2015TOOLSDIR)/include
            XBUILD_VCATLMFC_INCDIR=$(XVS2015TOOLSDIR)/atlmfc/include
            ifeq ($(BUILDARCH), x86)
                XBUILD_VCBINDIR=$(XVS2015TOOLSBIN32DIR)
                XBUILD_VCLIBDIR=$(XVS2015TOOLSDIR)/lib/x86
                XBUILD_VCATLMFC_LIBDIR=$(XVS2015TOOLSDIR)/atlmfc/lib/x86
            else
                XBUILD_VCBINDIR=$(XVS2015TOOLSBIN64DIR)
                XBUILD_VCLIBDIR=$(XVS2015TOOLSDIR)/lib/x64
                XBUILD_VCATLMFC_LIBDIR=$(XVS2015TOOLSDIR)/atlmfc/lib/x64
            endif
        else
            $(info xmake.envprep: VS2015 is not found, use latest Visual Studio instead)
        endif
    endif
    # Check VS2017
    ifeq ($(XBUILD_VSVER),150)
        ifneq ($(XVS2017TOOLSDIR),)
            XBUILD_VCTOOLSETVER=141
            XBUILD_VCROOTDIR=$(XVS2017TOOLSDIR)
            XBUILD_VCINCDIR=$(XVS2017TOOLSDIR)/include
            XBUILD_VCATLMFC_INCDIR=$(XVS2017TOOLSDIR)/atlmfc/include
            ifeq ($(BUILDARCH), x86)
                XBUILD_VCBINDIR=$(XVS2017TOOLSBIN32DIR)
                XBUILD_VCLIBDIR=$(XVS2017TOOLSDIR)/lib/x86
                XBUILD_VCATLMFC_LIBDIR=$(XVS2017TOOLSDIR)/atlmfc/lib/x86
            else
                XBUILD_VCBINDIR=$(XVS2017TOOLSBIN64DIR)
                XBUILD_VCLIBDIR=$(XVS2017TOOLSDIR)/lib/x64
                XBUILD_VCATLMFC_LIBDIR=$(XVS2017TOOLSDIR)/atlmfc/lib/x64
            endif
        else
            $(info xmake.envprep: VS2017 is not found, use latest Visual Studio instead)
        endif
    endif
    # Check VS2019
    ifeq ($(XBUILD_VSVER),160)
        ifneq ($(XVS2019TOOLSDIR),)
            XBUILD_VCTOOLSETVER=142
            XBUILD_VCROOTDIR=$(XVS2019DIR)
            XBUILD_VCINCDIR=$(XVS2019TOOLSDIR)/include
            XBUILD_VCATLMFC_INCDIR=$(XVS2019TOOLSDIR)/atlmfc/include
            ifeq ($(BUILDARCH), x86)
                XBUILD_VCBINDIR=$(XVS2019TOOLSBIN32DIR)
                XBUILD_VCLIBDIR=$(XVS2019TOOLSDIR)/lib/x86
                XBUILD_VCATLMFC_LIBDIR=$(XVS2019TOOLSDIR)/atlmfc/lib/x86
            else
                XBUILD_VCBINDIR=$(XVS2019TOOLSBIN64DIR)
                XBUILD_VCLIBDIR=$(XVS2019TOOLSDIR)/lib/x64
                XBUILD_VCATLMFC_LIBDIR=$(XVS2019TOOLSDIR)/atlmfc/lib/x64
            endif
        else
            $(info xmake.envprep: VS2019 is not found, use latest Visual Studio instead)
        endif
    endif
endif

ifeq ($(XBUILD_VCROOTDIR),)
    XBUILD_VSVER=$(XVSVER)
    XBUILD_VCTOOLSETVER=$(XVCTOOLSETVER)
    XBUILD_VCROOTDIR=$(XVSDIR)
    XBUILD_VCINCDIR=$(XVSTOOLSDIR)/include
    XBUILD_VCATLMFC_INCDIR=$(XVSTOOLSDIR)/atlmfc/include
    ifeq ($(BUILDARCH), x86)
        XBUILD_VCBINDIR=$(XVSTOOLSBIN32DIR)
        XBUILD_VCLIBDIR=$(XVSTOOLSDIR)/lib/x86
        XBUILD_VCATLMFC_LIBDIR=$(XVSTOOLSDIR)/atlmfc/lib/x86
    else
        XBUILD_VCBINDIR=$(XVSTOOLSBIN64DIR)
        XBUILD_VCLIBDIR=$(XVSTOOLSDIR)/lib/x64
        XBUILD_VCATLMFC_LIBDIR=$(XVSTOOLSDIR)/atlmfc/lib/x64
    endif
endif

# Always use latest SDK/WDK
XBUILD_WINKITROOT=
XBUILD_SDKVER=
XBUILD_SDKBINDIR=
XBUILD_SDKINCDIR=
XBUILD_SDKLIBDIR=
XBUILD_WDKVER=
XBUILD_WDKBINDIR=
XBUILD_WDKINCDIR=
XBUILD_WDKLIBDIR=

WINKIT10FOLDER=$(shell ls -F '$(dirProgramFiles86)/Windows Kits' 2> /dev/null | grep / | grep 10 | cut -d / -f 1)
ifeq ($(WINKIT10FOLDER),)
    $(error Windows Kits 10 is not found)
endif
XBUILD_WINKITROOT=$(dirProgramFiles86)/Windows Kits/10

ifneq ($(TARGET_SDKVER),)
    SDKLIBX86DIR=$(shell ls -F '$(XBUILD_WINKITROOT)/Lib/$(TARGET_SDKVER)/um' 2> /dev/null | grep / | grep x86 | cut -d / -f 1)
    ifeq ($(SDKLIBX86DIR),)
        $(error Windows SDK $(TARGET_SDKVER) is not installed)
    endif
    XBUILD_SDKVER=$(TARGET_SDKVER)
else
    XBUILD_SDKVER=$(XSDKVER)
endif
ifeq ($(XBUILD_SDKVER),)
    $(error SDK is not installed)
endif
XBUILD_SDKINCDIR=$(XBUILD_WINKITROOT)/Include/$(XBUILD_SDKVER)
ifeq ($(BUILDARCH), x86)
    XBUILD_SDKBINDIR=$(XBUILD_WINKITROOT)/bin/$(XBUILD_SDKVER)/x86
    XBUILD_SDKLIBDIR=$(XBUILD_WINKITROOT)/Lib/$(XBUILD_SDKVER)/um/x86
else
    XBUILD_SDKBINDIR=$(XBUILD_WINKITROOT)/bin/$(XBUILD_SDKVER)/x64
    XBUILD_SDKLIBDIR=$(XBUILD_WINKITROOT)/Lib/$(XBUILD_SDKVER)/um/x64
endif

# Check WDK only when build kernel mode module
ifneq ($(TARGET_WDKVER),)
    WDKLIBX86DIR=$(shell ls -F '$(XBUILD_WINKITROOT)/Lib/$(TARGET_WDKVER)/km' 2> /dev/null | grep / | grep x86 | cut -d / -f 1)
    ifeq ($(WDKLIBX86DIR),)
        $(error Windows WDK $(TARGET_WDKVER) is not installed)
    endif
    XBUILD_WDKVER=$(TARGET_WDKVER)
else
    XBUILD_WDKVER=$(XWDKVER)
endif
ifeq ($(TARGETMODE),kernel)
    ifeq ($(XBUILD_WDKVER),)
        $(error WDK is not installed)
    endif
    ifneq ($(XBUILD_WDKVER),$(XBUILD_SDKVER))
        $(info Warning: Windows Kits version doesn't match (SDK: $(XBUILD_SDKVER) / WDK: $(XBUILD_WDKVER))
    endif
endif
XBUILD_WDKINCDIR=$(XBUILD_WINKITROOT)/Include/$(XBUILD_WDKVER)
ifeq ($(BUILDARCH), x86)
    XBUILD_WDKBINDIR=$(XBUILD_WINKITROOT)/bin/$(XBUILD_WDKVER)/x86
    XBUILD_WDKLIBDIR=$(XBUILD_WINKITROOT)/Lib/$(XBUILD_WDKVER)/km/x86
else
    XBUILD_WDKBINDIR=$(XBUILD_WINKITROOT)/bin/$(XBUILD_WDKVER)/x64
    XBUILD_WDKLIBDIR=$(XBUILD_WINKITROOT)/Lib/$(XBUILD_WDKVER)/km/x64
endif


#-----------------------------------#
#            Path: Tools                #
#-----------------------------------#
TOOL_CC=
TOOL_CXX=
TOOL_ML=
TOOL_LIB=
TOOL_LINK=
TOOL_DUMPBIN=
TOOL_NMAKE=
TOOL_RC=
TOOL_MC=
TOOL_MT=
TOOL_MIDL=
TOOL_UUIDGEN=
TOOL_SIGNTOOL=
TOOL_STAMPINF=
TOOL_CERT2SPC=
TOOL_PVK2PFX=

TOOL_CC=$(XBUILD_VCBINDIR)/cl.exe
TOOL_CXX=$(XBUILD_VCBINDIR)/cl.exe
TOOL_ML=$(XBUILD_VCBINDIR)/ml.exe
TOOL_LIB=$(XBUILD_VCBINDIR)/lib.exe
TOOL_LINK=$(XBUILD_VCBINDIR)/link.exe
ifeq ($(XBUILD_VSVER),140)
    TOOL_DUMPBIN=$(XVS2015TOOLSBIN32DIR)/dumpbin.exe
    TOOL_NMAKE=$(XVS2015TOOLSBIN32DIR)/nmake.exe
else
    TOOL_DUMPBIN=$(XBUILD_VCBINDIR)/dumpbin.exe
    TOOL_NMAKE=$(XBUILD_VCBINDIR)/nmake.exe
endif
TOOL_RC=$(XBUILD_SDKBINDIR)/rc.exe
TOOL_MC=$(XBUILD_SDKBINDIR)/mc.exe
TOOL_MT=$(XBUILD_SDKBINDIR)/mt.exe
TOOL_MIDL=$(XBUILD_SDKBINDIR)/midl.exe
TOOL_UUIDGEN=$(XBUILD_SDKBINDIR)/uuidgen.exe
TOOL_SIGNTOOL=$(XBUILD_VCBINDIR)/signtool.exe
TOOL_STAMPINF=$(XBUILD_SDKBINDIR)/stampinf.exe
TOOL_CERT2SPC=$(XBUILD_SDKBINDIR)/cert2spc.exe
TOOL_PVK2PFX=$(XBUILD_SDKBINDIR)/pvk2pfx.exe

BUILD_CFLAGS=
BUILD_CXXFLAGS=
BUILD_RCFLAGS=
BUILD_MIDLFLAGS=
BUILD_MLFLAGS=

#-----------------------------------#
#            C/C++ Flags            #
#-----------------------------------#

ifeq ($(TARGET_MINOSVER),)
    TARGET_MINOSVER=0601
endif

ifeq ($(BUILDARCH), x64)
    TARGET_SUBSYS += -D_X64_=1 -Damd64=1 -D_WIN64=1 -D_AMD64_=1 -DAMD64=1
else
    BUILD_CFLAGS += -D_X86_=1 -Di386=1 -Dx86=1
    BUILD_CXXFLAGS += -D_X86_=1 -Di386=1 -Dx86=1
endif

BUILD_INCDIRS=-I"$(BUILD_INTDIR)"
ifneq ($(TARGETINCDIRS),)
    BUILD_INCDIRS += $(foreach dir, $(TARGETINCDIRS), $(addprefix -I, $(shell echo '$(dir)' | sed 's/\\\\/\\//'g)))
endif

ifeq ($(TARGETMODE),kernel)
    BUILD_INCDIRS+=-I"$(XBUILD_WDKINCDIR)/shared"
    BUILD_INCDIRS+=-I"$(XBUILD_WDKINCDIR)/km"
    BUILD_INCDIRS+=-I"$(XBUILD_WDKINCDIR)/km/crt"
else
    BUILD_INCDIRS+=-I"$(XBUILD_SDKINCDIR)/shared"
    BUILD_INCDIRS+=-I"$(XBUILD_SDKINCDIR)/um" \
                   -I"$(XBUILD_SDKINCDIR)/ucrt" \
                   -I"$(XBUILD_VCINCDIR)" \
                   -I"$(XBUILD_VCATLMFC_INCDIR)"
endif

###  General ###
BUILD_CFLAGS=-nologo -D_WIN32_WINNT=0x$(TARGET_MINOSVER) -DWINVER=0x$(TARGET_MINOSVER) -DWINNT=1 -DNTDDI_VERSION=0x$(TARGET_MINOSVER)0000 -DNOMINMAX
BUILD_CXXFLAGS=-nologo -D_WIN32_WINNT=0x$(TARGET_MINOSVER) -DWINVER=0x$(TARGET_MINOSVER) -DWINNT=1 -DNTDDI_VERSION=0x$(TARGET_MINOSVER)0000 -DNOMINMAX
ifeq ($(TARGETMODE),kernel)
    BUILD_CFLAGS+=-analyze -analyze:"stacksize1024" -GR- -kernel -DKERNELMODE=1 -DSTD_CALL -DALLOC_PRAGMA -DUNICODE -D_UNICODE
    BUILD_CXXFLAGS+=-analyze -analyze:"stacksize1024" -GR- -kernel -DKERNELMODE=1 -DSTD_CALL -DALLOC_PRAGMA -DUNICODE -D_UNICODE
else
    BUILD_CFLAGS+=-DWIN32_LEAN_AND_MEAN -DUNICODE -D_UNICODE
    BUILD_CXXFLAGS+=-DWIN32_LEAN_AND_MEAN -DUNICODE -D_UNICODE
endif

ifeq ($(BUILDARCH), x64)
    BUILD_CFLAGS += -D_X64_=1 -Damd64=1 -D_WIN64=1 -D_AMD64_=1 -DAMD64=1
    BUILD_CXXFLAGS += -D_X64_=1 -Damd64=1 -D_WIN64=1 -D_AMD64_=1 -DAMD64=1
else
    BUILD_CFLAGS += -D_X86_=1 -Di386=1 -Dx86=1
    BUILD_CXXFLAGS += -D_X86_=1 -Di386=1 -Dx86=1
endif

ifeq ($(BUILDTYPE),debug)
    BUILD_CFLAGS += -D_DEBUG -DDBG=1
    BUILD_CXXFLAGS += -D_DEBUG
else
    BUILD_CFLAGS += -DNDEBUG
    BUILD_CXXFLAGS += -DNDEBUG
endif

ifeq ($(TARGETTYPE),dll)
    BUILD_CFLAGS += -D_USRDLL -D_WINDLL
    BUILD_CXXFLAGS += -D_USRDLL -D_WINDLL
endif

# > Processor Defines
ifneq ($(TARGET_CFLAGS_DEFINES),)
    BUILD_CFLAGS+=$(addprefix -D, $(TARGET_CFLAGS_DEFINES))
    BUILD_CXXFLAGS+=$(addprefix -D, $(TARGET_CFLAGS_DEFINES))
endif


# > Include Dir
BUILD_CFLAGS+=$(BUILD_INCDIRS)
BUILD_CXXFLAGS+=$(BUILD_INCDIRS)

# > Debug Information Format
ifeq ($(BUILDTYPE),debug)
    BUILD_CFLAGS += -ZI
    BUILD_CXXFLAGS += -ZI
else
    BUILD_CFLAGS += -Zi
    BUILD_CXXFLAGS += -Zi
endif

# > Support Just-My-Code debugging
ifeq ($(BUILDTYPE),debug)
    BUILD_CFLAGS += -JMC
    BUILD_CXXFLAGS += -JMC
endif

# > Warning Level: W0, W1, W2, W3, W4, Wall
ifeq ($(TARGET_CFLAGS_WARNLEVEL),)
    BUILD_CFLAGS += -W3
    BUILD_CXXFLAGS += -W3
else
    BUILD_CFLAGS += -$(TARGET_CFLAGS_WARNLEVEL)
    BUILD_CXXFLAGS += -$(TARGET_CFLAGS_WARNLEVEL)
endif

# > Warning As Error
ifeq ($(TARGET_CFLAGS_ALLWARNASERROR),)
    TARGET_CFLAGS_ALLWARNASERROR=yes
endif
ifeq ($(TARGET_CFLAGS_ALLWARNASERROR),yes)
    BUILD_CFLAGS += -WX
    BUILD_CXXFLAGS += -WX
else
    BUILD_CFLAGS += -WX-
    BUILD_CXXFLAGS += -WX-
endif

# > Diagnostics Format: diagnostics:caret, diagnostics:column (default), diagnostics:classic
ifeq ($(TARGET_CFLAGS_DIAGNOSTICSFMT),)
    BUILD_CFLAGS += -diagnostics:column
    BUILD_CXXFLAGS += -diagnostics:column
else
    BUILD_CFLAGS += -$(TARGET_CFLAGS_DIAGNOSTICSFMT)
    BUILD_CXXFLAGS += -$(TARGET_CFLAGS_DIAGNOSTICSFMT)
endif

# > Multi-processor compilation
ifeq ($(TARGET_CFLAGS_MPC),)
    TARGET_CFLAGS_MPC=yes
endif
ifeq ($(TARGET_CFLAGS_MPC),yes)
    BUILD_CFLAGS += -MP
    BUILD_CXXFLAGS += -MP
endif

# > Multi-processor compilation
ifeq ($(TARGET_CFLAGS_ASAN),)
    TARGET_CFLAGS_ASAN=no
endif
ifeq ($(TARGET_CFLAGS_ASAN),yes)
    BUILD_CFLAGS += -fsanitize=address
    BUILD_CXXFLAGS += -fsanitize=address
endif

###  Optimization ###

# > Optimization Level
ifeq ($(BUILDTYPE),debug)
    BUILD_CFLAGS += -Od
    BUILD_CXXFLAGS += -Od
else
    ifeq ($(TARGET_CFLAGS_OPTIMIZATION),)
        TARGET_CFLAGS_OPTIMIZATION=O2
    endif
    BUILD_CFLAGS += -$(TARGET_CFLAGS_OPTIMIZATION)
    BUILD_CXXFLAGS += -$(TARGET_CFLAGS_OPTIMIZATION)
endif

# > inline function expansion
ifeq ($(BUILDTYPE),debug)
    BUILD_CFLAGS += -Ob0
    BUILD_CXXFLAGS += -Ob0
else
    ifeq ($(TARGET_CFLAGS_INLINE_EXPANSION),)
        TARGET_CFLAGS_INLINE_EXPANSION=Ob1
    endif
    BUILD_CFLAGS += -$(TARGET_CFLAGS_INLINE_EXPANSION)
    BUILD_CXXFLAGS += -$(TARGET_CFLAGS_INLINE_EXPANSION)
endif

# > Enable Intrinsic Functions
ifeq ($(BUILDTYPE),release)
    BUILD_CFLAGS += -Oi
    BUILD_CXXFLAGS += -Oi
else
    ifneq ($(TARGET_CFLAGS_INTRINSIC),)
        BUILD_CFLAGS += -$(TARGET_CFLAGS_INTRINSIC)
        BUILD_CXXFLAGS += -$(TARGET_CFLAGS_INTRINSIC)
    endif
endif

# > Omit Frame Pointers
ifneq ($(TARGET_CFLAGS_OMITFRAMEPOINTERS),)
    BUILD_CFLAGS += -$(TARGET_CFLAGS_OMITFRAMEPOINTERS)
    BUILD_CXXFLAGS += -$(TARGET_CFLAGS_OMITFRAMEPOINTERS)
endif

# > Whole Program Optimization
ifeq ($(TARGET_CFLAGS_WHOLEPROGRAMOPT),yes)
    BUILD_CFLAGS += -GL
    BUILD_CXXFLAGS += -GL
endif

###  Code Generation ###

# > Enable String Pooling
ifneq ($(TARGET_CFLAGS_STRPOOLING),)
    BUILD_CFLAGS += -$(TARGET_CFLAGS_STRPOOLING)
    BUILD_CXXFLAGS += -$(TARGET_CFLAGS_STRPOOLING)
endif

# > Enable Minimal build
ifeq ($(BUILD_VSVER),140)
    ifeq ($(BUILDTYPE),debug)
        BUILD_CFLAGS += -Gm-
        BUILD_CXXFLAGS += -Gm-
    else
        BUILD_CFLAGS += -Gm
        BUILD_CXXFLAGS += -Gm
    endif
endif

# > C++ exception
ifeq ($(TARGET_CFLAGS_CPPEXCEPTION),)
    BUILD_CFLAGS += -EHa
    BUILD_CXXFLAGS += -EHa
else
    BUILD_CFLAGS += -$(TARGET_CFLAGS_CPPEXCEPTION)
    BUILD_CXXFLAGS += -$(TARGET_CFLAGS_CPPEXCEPTION)
endif

# > Run-time Libraries
ifeq ($(TARGET_CFLAGS_RTL),)
    ifeq ($(BUILDTYPE),debug)
        BUILD_CFLAGS += -MTd
        BUILD_CXXFLAGS += -MTd
    else
        BUILD_CFLAGS += -MT
        BUILD_CXXFLAGS += -MT
    endif
else
    ifeq ($(BUILDTYPE),debug)
        BUILD_CFLAGS += -$(TARGET_CFLAGS_RTL)d
        BUILD_CXXFLAGS += -$(TARGET_CFLAGS_RTL)d
    else
        BUILD_CFLAGS += -$(TARGET_CFLAGS_RTL)
        BUILD_CXXFLAGS += -$(TARGET_CFLAGS_RTL)
    endif
endif

# > Struct Member Alignment
ifeq ($(TARGETMODE),kernel)
    TARGET_CFLAGS_STRUCALIGN=Zp8
endif
ifneq ($(TARGET_CFLAGS_STRUCALIGN),)
    BUILD_CFLAGS += -$(TARGET_CFLAGS_STRUCALIGN)
    BUILD_CXXFLAGS += -$(TARGET_CFLAGS_STRUCALIGN)
endif

# > Enable Security Check
ifeq ($(TARGETMODE), kernel)
    BUILD_CFLAGS += -GS-
    BUILD_CXXFLAGS += -GS-
else
    ifeq ($(TARGET_CFLAGS_GS),)
        BUILD_CFLAGS += -GS
        BUILD_CXXFLAGS += -GS
    else
        BUILD_CFLAGS += -$(TARGET_CFLAGS_GS)
        BUILD_CXXFLAGS += -$(TARGET_CFLAGS_GS)
    endif
endif

# > Enable Control Flow Guard
ifeq ($(TARGET_CFLAGS_CFG),yes)
    BUILD_CFLAGS += -guard:cf
    BUILD_CXXFLAGS += -guard:cf
endif

# > Enable function level linking
ifneq ($(TARGET_CFLAGS_FLL),)
    BUILD_CFLAGS += -Gy
    BUILD_CXXFLAGS += -Gy
else
    BUILD_CFLAGS += -Gy-
    BUILD_CXXFLAGS += -Gy-
endif

# > Enhanced instruction set: SSE, SSE2, AVX, AVX2, AVX512, IA32
ifneq ($(TARGET_CFLAGS_EIS),)
    BUILD_CFLAGS += -arch:$(TARGET_CFLAGS_EIS)
    BUILD_CXXFLAGS += -arch:$(TARGET_CFLAGS_EIS)
endif

# > Floating point model: precise, strict, fast
ifneq ($(TARGET_CFLAGS_FPM),)
    BUILD_CFLAGS += -fp:$(TARGET_CFLAGS_FPM)
    BUILD_CXXFLAGS += -fp:$(TARGET_CFLAGS_FPM)
else
    BUILD_CFLAGS += -fp:precise
    BUILD_CXXFLAGS += -fp:precise
endif

###  Language ###

# > Treat WChar_t as built-in type
# > Force Conformance in For Loop Scope
# > Remove unreferenced code and data
BUILD_CFLAGS += -Zc:wchar_t -Zc:forScope -Zc:inline
BUILD_CXXFLAGS += -Zc:wchar_t -Zc:forScope -Zc:inline

# > C++ language standard: c++14, c++17
ifneq ($(TARGET_CFLAGS_CSTD),)
    BUILD_CFLAGS += -std:$(TARGET_CFLAGS_CSTD)
    BUILD_CXXFLAGS += -std:$(TARGET_CFLAGS_CSTD)
else
    BUILD_CFLAGS += -std:c++14
    BUILD_CXXFLAGS += -std:c++14
endif


###  PreCompile Header ###
TARGET_PCHNAME=
BUILD_PCHFILE=
TARGET_PCHDIR=
CREATE_PCHFLAG=
USE_PCHFLAG=
ifneq ($(TARGET_PCH),)
    TARGET_PCHNAME=$(notdir $(TARGET_PCH))
    TARGET_PCHBASENAME=$(basename $(TARGET_PCHNAME))
    TARGET_PCHDIR=$(patsubst %/,%,$(dir $(TARGET_PCH)))
    BUILD_PCHFILE=$(TARGETNAME).pch
    CREATE_PCHFLAG=-Yc"$(TARGET_PCHNAME)" -I"$(TARGET_PCHDIR)" -Fp"$(BUILD_INTDIR)/$(TARGETNAME).pch"
    USE_PCHFLAG=-Yu"$(TARGET_PCHNAME)" -I"$(TARGET_PCHDIR)" -Fp"$(BUILD_INTDIR)/$(TARGETNAME).pch"
endif


###  Output Files ###

# > Assembler Output
ifneq ($(TARGET_CFLAGS_FA),)
    BUILD_CFLAGS += -$(TARGET_CFLAGS_FA)
    BUILD_CXXFLAGS += -$(TARGET_CFLAGS_FA)
else
    BUILD_CFLAGS += -FAcs
    BUILD_CXXFLAGS += -FAcs
endif

# Program Database File Name
BUILD_CFLAGS += -Fd"$(BUILD_INTDIR)/vc$(XBUILD_VCTOOLSETVER).pdb"
BUILD_CXXFLAGS += -Fd"$(BUILD_INTDIR)/vc$(XBUILD_VCTOOLSETVER).pdb"

###  Advanced ###

# > Calling Convention: Gd (__cedcl), Gr (__fastcall), Gz (__stdcall)
ifeq ($(TARGETMODE),kernel)
    # __stdcall
    BUILD_CFLAGS += -Gz
    BUILD_CXXFLAGS += -Gz
else
    ifneq ($(TARGET_CFLAGS_CALLCONV),)
        BUILD_CFLAGS += -$(TARGET_CFLAGS_CALLCONV)
        BUILD_CXXFLAGS += -$(TARGET_CFLAGS_CALLCONV)
    else
        # __cdecl
        BUILD_CFLAGS += -Gd
        BUILD_CXXFLAGS += -Gd
    endif
endif

# > Disable warnings
ifneq ($(TARGET_WARNS_IGNORED),)
    BUILD_CFLAGS += $(addprefix -wd, $(TARGET_WARNS_IGNORED))
    BUILD_CXXFLAGS += $(addprefix -wd, $(TARGET_WARNS_IGNORED))
endif

# > Treat warnings as errors
ifneq ($(TARGET_WARNS_ERRORS),)
    ifneq ($(TARGET_CFLAGS_ALLWARNASERROR),yes))
        BUILD_CFLAGS += $(addprefix -we, $(TARGET_WARNS_ERRORS))
        BUILD_CXXFLAGS += $(addprefix -we, $(TARGET_WARNS_ERRORS))
    endif
endif

# > Internal Compiler Error Reporting
BUILD_CFLAGS += -errorReport:prompt
BUILD_CXXFLAGS += -errorReport:prompt

#-----------------------------------#
#            Link Flags             #
#-----------------------------------#
BUILD_LFLAGS=
BUILD_SLFLAGS=

BUILD_LIBDIRS=-LIBPATH:"$(BUILD_OUTDIR)" -LIBPATH:"$(BUILD_INTDIR)"
BUILD_LIBDIRS=-LIBPATH:"$(BUILD_OUTDIR)" -LIBPATH:"$(BUILD_INTDIR)"
ifneq ($(TARGETINCDIRS),)
    BUILD_LIBDIRS += $(foreach dir, $(TARGETLIBDIRS), $(addprefix -LIBPATH:,$(shell echo '$(dir)' | sed 's/\\\\/\\//'g)))
endif
ifeq ($(TARGETMODE),kernel)
    BUILD_LIBDIRS += -LIBPATH:"$(XBUILD_WDKLIBDIR)"
else
    BUILD_LIBDIRS += -LIBPATH:"$(XBUILD_VCLIBDIR)" -LIBPATH:"$(XBUILD_VCATLMFC_LIBDIR)" -LIBPATH:"$(XBUILD_SDKLIBDIR)"
endif

ifeq ($(BUILDARCH), x64)
    BUILD_LFLAGS  += -MACHINE:X64
    BUILD_SLFLAGS += -MACHINE:X64
else ifeq ($(BUILDARCH), x86)
    BUILD_LFLAGS  += -MACHINE:X86
    BUILD_SLFLAGS += -MACHINE:X86
endif

ifeq ($(BUILDTYPE),debug)
    BUILD_LFLAGS  += -DEBUG
else
    BUILD_LFLAGS  += -OPT:REF -OPT:ICF -RELEASE
endif

ifeq ($(TARGET_UACLEVEL),)
    TARGET_UACLEVEL=asInvoker
endif

ifeq ($(TARGETMODE), kernel)
	# Windows Kernel Mode Module
    BUILD_LFLAGS += -kernel -MANIFEST:NO -PROFILE -Driver -PDB:$(BUILD_INTDIR)/$(TARGETNAME).pdb -VERSION:"$(TARGET_SUBSYSVER)" -DEBUG -WX -OPT:REF -INCREMENTAL:NO \
	            -SUBSYSTEM:$(TARGET_SUBSYS),$(TARGET_SUBSYSVER) -OPT:ICF -ERRORREPORT:PROMPT -MERGE:"_TEXT=.text;_PAGE=PAGE" -NOLOGO -NODEFAULTLIB -SECTION:"INIT,d" -IGNORE:4078
    BUILD_LIBS=fltmgr.lib BufferOverflowK.lib ntoskrnl.lib hal.lib wmilib.lib Ntstrsafe.lib
    BUILD_SLFLAGS += -NOLOGO
    ifeq ($(BUILDARCH), x64)
        BUILD_LFLAGS  += -ENTRY:"GsDriverEntry"
    else ifeq ($(BUILDARCH), x86)
        BUILD_LFLAGS  += -ENTRY:"GsDriverEntry@8"
    endif
else
	# Windows User Mode Module
    BUILD_LFLAGS += -NOLOGO -PROFILE -LTCG -DYNAMICBASE -NXCOMPAT -ERRORREPORT:PROMPT -PDB:"$(BUILD_INTDIR)/$(TARGETNAME).pdb" -LTCG:incremental -TLBID:1 -SUBSYSTEM:$(TARGET_SUBSYS),$(TARGET_SUBSYSVER) \
                    -MANIFEST -MANIFESTUAC:"level='$(TARGET_UACLEVEL)' uiAccess='false'" -ManifestFile:"$(BUILD_INTDIR)/$(TARGETNAME)$(TARGETEXT).intermediate.manifest"
    BUILD_LIBS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib
    BUILD_SLFLAGS += -NOLOGO -LTCG -SUBSYSTEM:WINDOWS
    ifeq ($(TARGETTYPE),dll)
        BUILD_LFLAGS += -DLL
    endif
endif

# Default Linked Libraried
ifneq ($(TARGETLIBS),)
    BUILDLIBS+=$(TARGETLIBS)
endif
BUILD_LFLAGS+=$(BUILDLIBS)


#-----------------------------------#
#              RC Flags             #
#-----------------------------------#
ifeq ($(BUILDARCH), x64)
    BUILD_RCFLAGS += -nologo -D_X64_=1 -Damd64=1 -D_WIN64=1 -D_AMD64_=1 -DAMD64=1
else ifeq ($(BUILDARCH), x86)
    BUILD_RCFLAGS  += -nologo -D_X86_=1 -Di386=1 -Dx86=1
endif

ifeq ($(TARGETMODE), kernel)
    BUILD_RCFLAGS += -I"$(XBUILD_SDKINCDIR)/um" $(BUILD_INCDIRS) -DSTD_CALL
endif

BUILD_RCFLAGS += $(BUILD_INCDIRS) -DSTD_CALL

#-----------------------------------#
#              MIDL Flags           #
#-----------------------------------#
ifeq ($(BUILDARCH), x64)
    BUILD_MIDLFLAGS = -char signed -win64 -x64 -env x64 -Oicf -error all $(BUILD_INCDIRS)
else ifeq ($(BUILDARCH), x86)
    BUILD_MIDLFLAGS = -char signed -win32 -Oicf -error all $(BUILD_INCDIRS)
endif

#-----------------------------------#
#               ML Flags            #
#-----------------------------------#
ifeq ($(BUILDARCH), x64)
    BUILD_MLFLAGS = -nologo -Cx
else ifeq ($(BUILDARCH), x86)
    BUILD_MLFLAGS = -nologo -Cx -coff
endif

ifeq ($(BUILDTYPE),debug)
    BUILD_MLFLAGS += -Zd
endif

BUILD_MLFLAGS += $(BUILD_INCDIRS)