#######################################################
###					TARGET MAKEFILE					###
#######################################################

#-----------------------------------#
#		Target Properties			#
#-----------------------------------#

# The name/extension of target
TGTNAME=xvault
#    -> By default, leave target extension empty here, makefile will set it base on target type and platform
TGTEXT=

# The target platform: win32, linux, mac, ios, android
TGTPLATFORM=

# The target minimal os version:
#	Windows:
#		0500	- Windows 2000
#		0501	- Windows XP
#		0502	- Windows Server 2003
#		0600	- Windows Vista or Windows Server 2008
#		0601	- Windows 7 or Windows Server 2008 R2
#		0602	- Windows 8 or Windows Server 2012
#		0603	- Windows 8.1 or Windows Server 2012 R2
#		1000	- Windows 10 or Windows Server 2016
TGTMINOSVER=

# The type of target: console-app, gui-app, kernel-app, kernel-dll
#	console:console application
#	gui:	application
#	dll:	dll
#	lib:	library
#	drv:	driver (*.sys on windows)
TGTTYPE=gui

# The type of target: console-app, gui-app, kernel-app, kernel-dll
#	user:	user mode
#	kernel:	kernel mode
TGTMODE=user

# The thread mode of target: if not defined, use `mt` by default
#	mt:		multi-thread
#	md:		multi-thread, dll version
THREADMODE=mt

# Sources
#	- Dirs, all source files under this dir will be compiled automatically
#		Source files include:
#			* C/C++: .c, .cpp, .cxx
#			* ASM: .asm
#			* C#: .cs
#			* COM: .idl
#			* Manifest: .manifest
#			* Resource: .rc
TGTSRCDIRS=src
#	- Single files
TGTSOURCES=

# Include/Library dirs
TGTINCDIRS=inc src
TGTLIBDIRS=

# Additional Libraries
TGTLIBS=

# Precompile file name (If it is empty, then no precompile header)
#	Generated:	$(TGTNAME).pch
TGTPCHNAME=xpch

# Warnings
#	- Ignored
WARNS_IGNORED=
#	- Treat as error: if empty, default to 'Treat All As Error'
WARNS_AS_ERROR=

#######################################################
### 		DON NOT CHANGE BELOW THIS LINE			###
#######################################################
include $(XWSROOT)/xws/makefiles/xmake.mak

.DEFAULT_GOAL := all

all: buildall
	@echo " "

clean: buildclean
	@echo Done
