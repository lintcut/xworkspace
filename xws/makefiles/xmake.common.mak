#######################################################################
#
# XWORKSPACE MAKEFILE: COMMON
#
#     This file define common data, functions and rules
#
########################################################################


#-----------------------------------#
#			System Arguments		#
#-----------------------------------#

# Workspace Root Path
ifeq ($(XWSROOT),)
    $(error xmake.common: XWSROOT is not defined)
endif

# OS name (Windows, Mac, Linux)
ifeq ($(XOS),)
    $(error xmake.common: XOS is not defined, please make sure "bashrc_xws.sh" has been run)
endif

#-----------------------------------#
#			Target Arguments		#
#-----------------------------------#

ifeq ($(TARGETNAME),)
    $(error xmake.common: TARGETNAME is not defined)
endif

ifeq ($(TARGETTYPE),)
    $(error xmake.common: TARGETTYPE is not defined (console/gui/dll/lib/kdrv/klib))
endif

ifeq ($(BUILDTYPE),)
    $(error xmake.common: BUILDTYPE is not defined (debug/release))
endif

ifeq ($(BUILDTYPE),)
    $(error xmake.common: BUILDTYPE is not defined (debug/release))
endif

# There is a local settings file
ifneq (,$(wildcard $(XWSROOT)/xws/makefiles/xmake.local.settings.mak))
    $(info xmake.local.settings.mak is included)
    include $(XWSROOT)/xws/makefiles/xmake.local.settings.mak
endif

ifeq ($(BUILDCERT),)
    BUILDCERT=$(XBUILD_DEVCERT)
    BUILDCERTPSWD=$(XBUILD_DEVCERTPSWD)
    BUILDCERTTIMEURL=$(XBUILD_DEVCERTTTIMEURL)
endif

# signtool.exe sign -f <cert file> -p <password> -t <time server url>
BUILDSIGNARGS=
ifneq ($(BUILDCERT),)
    BUILDSIGNARGS = sign -f "$(BUILDCERT)" -p "$(BUILDCERTPSWD)"
    ifneq ($(BUILDCERTTIMEURL),)
        BUILDSIGNARGS += -t $(BUILDCERTTIMEURL)
    endif
    BUILDSIGNARGS += -td sha256 -fd sha256 -v
endif

# Check TARGETTYPE and set BUILDMODE (user/kernel), TARGETEXT and TARGET_SUBSYS
ifeq ($(TARGETTYPE),gui)
    TARGETEXT=.exe
    TARGETMODE=user
    TARGET_SUBSYS=WINDOWS
else ifeq ($(TARGETTYPE),console)
    TARGETEXT=.exe
    TARGETMODE=user
    TARGET_SUBSYS=CONSOLE
else ifeq ($(TARGETTYPE),lib)
    TARGETEXT=.lib
    TARGETMODE=user
    TARGET_SUBSYS=WINDOWS
else ifeq ($(TARGETTYPE),dll)
    TARGETEXT=.dll
    TARGETMODE=user
    TARGET_SUBSYS=WINDOWS
else ifeq ($(TARGETTYPE),klib)
    TARGETEXT=.lib
    TARGETMODE=kernel
    TARGET_SUBSYS=NATIVE
else ifeq ($(TARGETTYPE),kdrv)
    TARGETEXT=.sys
    TARGETMODE=kernel
    TARGET_SUBSYS=NATIVE
else
    $(error xmake.common: TGTTYPE ("$(TGTTYPE)") is unknown)
endif

# Check Target OS
ifeq ($(TARGET_MINOSVER), 0501)
    TARGET_MINOSNAME=WinXP
    TARGET_SUBSYSVER="5.01"
else ifeq ($(TARGET_MINOSVER), 0502)
    TARGET_MINOSNAME=Win2003
    TARGET_SUBSYSVER="5.02"
else ifeq ($(TARGET_MINOSVER), 0600)
    TARGET_MINOSNAME=WinVista
    TARGET_SUBSYSVER="6.00"
else ifeq ($(TARGET_MINOSVER), 0601)
    TARGET_MINOSNAME=Win7
    TARGET_SUBSYSVER="6.01"
else ifeq ($(TARGET_MINOSVER), 0602)
    TARGET_MINOSNAME=Win8
    TARGET_SUBSYSVER="6.02"
else ifeq ($(TARGET_MINOSVER), 0603)
    TARGET_MINOSNAME=Win8.1
    TARGET_SUBSYSVER="6.03"
else ifeq ($(TARGET_MINOSVER), 1000)
    TARGET_MINOSNAME=Win10
    TARGET_SUBSYSVER="10.00"
else
    TARGET_MINOSVER=0601
    TARGET_MINOSNAME=Win7
    TARGET_SUBSYSVER="6.01"
endif

#-----------------------------------#
#			Common Data				#
#-----------------------------------#

# Time
XTIME_START:=$(shell echo `date +%s`)
XTIME_CURRENT=$(shell echo `date +%s`)
XTIME_DURATION=$(shell echo $$(( $(XTIME_CURRENT) - $(XTIME_START) )))

# Directories
BUILD_OUTROOT=output
BUILD_OUTDIR=$(BUILD_OUTROOT)/$(BUILDTYPE)_$(BUILDARCH)
BUILD_INTDIR=$(BUILD_OUTROOT)/intermediate/$(TARGETNAME)/$(BUILDTYPE)_$(BUILDARCH)
