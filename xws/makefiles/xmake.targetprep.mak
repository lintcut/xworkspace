#######################################################################
#
# XWORKSPACE MAKEFILE: TARGETS PREP
#
#     This file will find all sources, generate inte and prepare environment settings, software and
#     so on
#
########################################################################

#-----------------------------------#
#		VARIABLES EXPORT			#
#-----------------------------------#
TARGET_SRCS=
TARGET_OBJS=
TARGET_RCS=
TARGET_RES=
TARGET_IDLS=
TARGET_TLBS=
TARGET_MANEFIST=
TARGET_DEF=
BUILD_TARGETS=

#-----------------------------------#
#				Sources				#
#-----------------------------------#
ifeq ($(TARGETSOURCES),)
    ifeq ($(TARGETSRCDIRS),)
		TARGETSRCDIRS=.
	endif
	# Search
	#	- C/C++: .c, .cpp, .cxx
	#	- ASM: .asm, .s
	#	- COM: .idl
	#	- Manifest: .manifest
	#	- Resource: .rc
	#	- DLL Define: .def
    SEARCH_TYPES=c cpp cxx asm s idl manifest rc def
    SEARCH_DEPTH=10
	# Prepare Source Dirs List
    TARGETSRCDIRS:=. $(foreach d, $(TARGETSRCDIRS), $(shell find $(d) -maxdepth $(SEARCH_DEPTH) -type d | sed 's/^\.\///g' | grep -v '^\..*' | grep -v '^output\/*'))
    $(info Searching directories $(TARGETSRCDIRS))
    TARGETSOURCES = $(foreach dir, $(TARGETSRCDIRS), $(foreach pattern, $(SEARCH_TYPES), $(wildcard $(dir)/*.$(pattern))))
endif

ifeq ($(TARGETSOURCES),)
    $(error xmake.mak: TARGETSOURCES is empty)
endif

# Filter out resource file
TARGET_RCS:=$(filter %.rc, $(TARGETSOURCES))
ifneq ($(TARGET_RCS),)
    TARGETSOURCES := $(filter-out $(TARGET_RCS),$(TARGETSOURCES))
endif

# Filter out IDL file
TARGET_IDLS:=$(filter %.idl, $(TARGETSOURCES))
ifneq ($(TARGET_IDLS),)
    TARGETSOURCES := $(filter-out $(TARGET_IDLS),$(TARGETSOURCES))
endif

# Filter out MANEFIST file
TARGET_MANEFIST:=$(filter %.manifest, $(TARGETSOURCES))
ifneq ($(TARGET_MANEFIST),)
    TARGETSOURCES := $(filter-out $(TARGET_MANEFIST),$(TARGETSOURCES))
endif

# Filter out DEF file
TARGET_DEF:=$(filter %.def, $(TARGETSOURCES))
ifneq ($(TARGET_DEF),)
    TARGETSOURCES := $(filter-out $(TARGET_DEF),$(TARGETSOURCES))
    ifeq ($(TARGETTYPE),dll)
        TARGET_LFLAGS += -DEF:$(TARGET_DEF)
    endif
endif

ifeq ($(TARGETSOURCES),)
    $(error xmake.mak: TARGETSOURCES is empty)
endif
TARGET_SRCS:=$(TARGETSOURCES)

# Check precompiled header file
ifneq ($(TARGET_PCH),)
    PCH_FILE=$(wildcard $(TARGET_PCH))
    ifeq ($(PCH_FILE),)
        $(error Cannot find precompiled header file "$(TARGET_PCH)")
	endif
endif

# Make sure VPATH include intermediate dir so we can find IDL generated _i.c/_p.c files
#VPATH := $(BUILD_INTDIR)

# Generate objs file list
#BUILD_OBJS = $(foreach f, $(SOURCES), $(addsuffix .o,$(basename $(notdir $f))))   		<-- This line remove dir, but we want to keep dir in intermediate folder
BUILD_OBJS = $(foreach f, $(TARGET_SRCS), $(addsuffix .o,$(basename $f)))

# Generate res file list
ifneq ($(TARGET_RCS),)
    #BUILD_RES = $(foreach f, $(RESOURCES), $(addsuffix .res,$(basename $(notdir $f))))	<-- This line remove dir, but we want to keep dir in intermediate folder
    BUILD_RES = $(foreach f, $(TARGET_RCS), $(addsuffix .res,$(basename $f)))
endif

# Generate TLB file list
# Each IDL file generates 4 files: %.tlb, %.h, %_i.c and %_p.c
ifneq ($(BUILD_IDLS),)
    BUILD_TLBS = $(foreach f, $(TARGTET_IDLS), $(addsuffix .tlb,$(basename $(notdir $f))))
	# IDL files also generate *_i.c and *_p.c
    TARGET_SRCS += $(foreach f, $(TARGTET_IDLS), $(addsuffix _i.c,$(basename $(notdir $f))))
    TARGET_SRCS += $(foreach f, $(TARGTET_IDLS), $(addsuffix _p.c,$(basename $(notdir $f))))
    BUILD_OBJS += $(foreach f, $(TARGTET_IDLS), $(addsuffix _i.o,$(basename $(notdir $f))))
    BUILD_OBJS += $(foreach f, $(TARGTET_IDLS), $(addsuffix _p.o,$(basename $(notdir $f))))
endif

#-----------------------------------#
#				Targets				#
#-----------------------------------#

# Precompiled header (if any)
ifneq ($(BUILD_PCHFILE),)
    ALLTARGETS += $(BUILD_PCHFILE)
endif

# IDL files (if any)
ifneq ($(BUILD_TLBS),)
    ALLTARGETS += $(BUILD_TLBS)
endif

# Resource Files (if any)
ifneq ($(BUILD_RES),)
    ALLTARGETS += $(BUILD_RES)
    BUILD_LFLAGS += $(BUILD_RES)
endif

ALLTARGETS += $(BUILD_OBJS)
BUILD_LFLAGS += $(BUILD_OBJS)
