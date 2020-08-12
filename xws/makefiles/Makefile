#######################################################
###					TARGET MAKEFILE					###
#######################################################

#-----------------------------------#
#		Target Properties			#
#-----------------------------------#

# The name/extension of target
TARGETNAME=

# The type of target:
#	console:console application
#	gui:	win32 application
#	dll:	dynamicly linked library (dll)
#	lib:	static library
#	kdrv:	kernel mode driver
#	klib:	kernel mode static library
TARGETTYPE=

# Sources
#    - If the value is empty, it automatically search files under TARGETSRCDIRS
#     Otherwise, it use listed files as source files
TARGETSOURCES=

#    - Auto search directories (if it is empty, use current dir), makefile will automatically search follwoing file under TARGETSRCDIRS:
#            * C/C++: .c, .cpp, .cxx
#            * ASM: .asm, .s
#            * COM: .idl
#            * Manifest: .manifest
#            * Resource: .rc
#            * DLL Define: .def
TARGETSRCDIRS=

# Additional Include dirs
TARGETINCDIRS=

# Additional Library dirs
TARGETLIBDIRS=

# Additional Libraries
TARGETLIBS=

# Precompile header file name (If it is empty, then no precompile header)
#    Generate:    $(TARGETNAME).pch
TARGET_PCH=src/xpch.h

############################################################
# Override Most Often Used Settings (Optional)
############################################################
# Extra Processor Defines
TARGET_CFLAGS_DEFINES=

# Warnings
#    - Ignored
TARGET_WARNS_IGNORED=
#    - Treat as error: yes or no. if empty, default to 'Treat All As Error'
TARGET_WARNS_ERRORS=

# The target minimal os version:
#    Windows:
#        0500    - Windows 2000
#        0501    - Windows XP
#        0502    - Windows Server 2003
#        0600    - Windows Vista or Windows Server 2008
#        0601    - Windows 7 or Windows Server 2008 R2 <== **DEFAULT**
#        0602    - Windows 8 or Windows Server 2012
#        0603    - Windows 8.1 or Windows Server 2012 R2
#        1000    - Windows 10 or Windows Server 2016
TARGET_MINOSVER=

# Target UAC Level: asInvoker (default), highestAvailable, requireAdministrator
TARGET_UACLEVEL=

############################################################
# Override Toolset/SDK/WDK version (Optional)
############################################################
TARGET_VSVER=
TARGET_SDKVER=
TARGET_WDKVER=

############################################################
# Override Compiler Options (Optional)
############################################################
#    - Debug Information Format
TARGET_CFLAGS_DBGINFOFMT=
#    - Warning Level: W0, W1, W2, W3, W4, Wall (Default is W3 for user mode and W4 for kernel mode)
TARGET_CFLAGS_WARNLEVEL=
#    - All Warning As Error: yes/no (Default is yes)
TARGET_CFLAGS_ALLWARNASERROR=
#    - Diagnostics Format: diagnostics:caret, diagnostics:column (default), diagnostics:classic
TARGET_CFLAGS_DIAGNOSTICSFMT=
#    - Multi-processor compilation
TARGET_CFLAGS_MPC=
#    - Enable Address Sanitizer
TARGET_CFLAGS_ASAN=
#    - Optimization: Od, O1, O2, Ox
TARGET_CFLAGS_OPTIMIZATION=
#    - Inline Functions Expansion: Ob0, Ob1, Ob2
TARGET_CFLAGS_INLINE_EXPANSION=
#    - Enable Intrinsic Functions
TARGET_CFLAGS_INTRINSIC=
#    - Omit Frame Pointers Oy, Oy-
TARGET_CFLAGS_OMITFRAMEPOINTERS=
#    - Whole Program Optimization: yes or no (empty)
TARGET_CFLAGS_WHOLEPROGRAMOPT=
#    - Enable String Pooling: empty (default), GF, GF-
TARGET_CFLAGS_STRPOOLING=
#    - C++ Exception: EHa, EHsc, EHs
TARGET_CFLAGS_CPPEXCEPTION=
#    - Runtime Libraries: MT (default), MD
TARGET_CFLAGS_RTL=
#    - Struct Member Alignment: Z1, Z2, Z4, Z8, Z16 or empty (default)
TARGET_CFLAGS_STRUCALIGN=
#    - Enable security cehck: GS (default) or GS-
TARGET_CFLAGS_GS=
#    - Enable control flow guard: yes or no (empty)
TARGET_CFLAGS_CFG=
#    - Enable function level linking
TARGET_CFLAGS_FLL=
#    - Enhanced instruction set: SSE, SSE2, AVX, AVX2, AVX512, IA32
TARGET_CFLAGS_EIS=
#    - Floating point model: precise, strict, fast
TARGET_CFLAGS_FPM=
#    - C++ language standard: c++14 (default), c++17
TARGET_CFLAGS_CSTD=
#    - Assembler Output: FA, FAc, FAs, FAcs (default)
TARGET_CFLAGS_FA=
#    - Calling Convention
TARGET_CFLAGS_CALLCONV=
#    - Force Include File
TARGET_CFLAGS_FINCLUDE=
#    - Enable Code Analysis on Build
TARGET_CFLAGS_ANALYZE=

############################################################
# Override Linker Options (Optional)
############################################################
#    - Enabe incremental linking
TARGET_LFLAGS_INCREMENTAL=
#    - Ignore all default libraries
TARGET_LFLAGS_IGNOREDEFULE=
#    - Delay loaded DLLs
TARGET_LFLAGS_DELAYLOAD_DLLS=
#    - Generate menifest
TARGET_LFLAGS_MENIFEST=
#    - Enable User Account Control
TARGET_LFLAGS_UAC=
#    - UAC Execution Level (asInvoker, highestAvailable, requireAdministrator)
TARGET_LFLAGS_UAC_LEVEL=
#    - UAC Bypass UI Protection
TARGET_LFLAGS_UAC_UIP=
#    - Generate debug information
TARGET_LFLAGS_DBGINFO=
#    - Generate program database file
TARGET_LFLAGS_PDBFILE=
#    - Generate map file
TARGET_LFLAGS_MAPFILE=
#    - Heap reserve size
TARGET_LFLAGS_HEAPRESERVE_SIZE=
#    - Heap commit size
TARGET_LFLAGS_HEAPCOMMIT_SIZE=
#    - Stack reserve size
TARGET_LFLAGS_STACKRESERVE_SIZE=
#    - Stack commit size
TARGET_LFLAGS_STACKCOMMIT_SIZE=
#    - Function order file
TARGET_LFLAGS_FUNCTION_ORDER_FILE=
#    - Link Time Code Generation
TARGET_LFLAGS_LTCG=
#    - Entry Point
TARGET_LFLAGS_ENTRYPOINT=
#    - Set checksum
TARGET_LFLAGS_SETCHECKSUM=
#    - Randomize base address
TARGET_LFLAGS_DYNAMICBASE=
#    - Data Execution Prevention
TARGET_LFLAGS_DEP=

# DON NOT CHANGE THIS LINE
include $(XWSROOT)/xws/makefiles/xmake.mak

.DEFAULT_GOAL := all

all: buildall
	@echo " "

clean: buildclean
	@echo " "
