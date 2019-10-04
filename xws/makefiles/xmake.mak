#################################################################
######  			XWORKSPACE MAKEFILE					  #######
#################################################################

#-----------------------------------#
#			Makefile Arguments		#
#-----------------------------------#

# Target CPU Arch:
#	- x86:		x86 cpu
#	- x64:		x64 cpu
#	- arm:		arm cpu
#	- arm64:	arm64 cpu
#ifeq ($(BUILDARCH),)
#    $(error xmake: BUILDARCH is not defined)
#endif

# BuildType:
#	- debug:	debug build
#	- release:	release build
#	- noopt:	release, but without optimization
#ifeq ($(BUILDTYPE),)
#    $(error xmake: BUILDTYPE is not defined)
#endif

ifeq ($(TGTNAME),)
    $(error xmake: TGTNAME is not defined)
endif

ifeq ($(THREADMODE),)
    THREADMODE=mt
endif

ifeq ($(WARNS_AS_ERROR),)
    WARNS_AS_ERROR=all
endif

ifeq ($(TGTTYPE),drv)
    ifneq ($(TGTMODE),kernel)
        $(error xmake: Driver must be kernel mode)
    endif
endif


#-----------------------------------#
#			System Arguments		#
#-----------------------------------#

# Workspace Root Path
ifeq ($(XWSROOT),)
    $(error xmake: XWSROOT is not defined)
endif

# OS name (Windows, Mac, Linux)
ifeq ($(XOS),)
    $(error xmake: XOS is not defined, please make sure "bashrc_xws.sh" has been run)
endif

ifeq ($(XOS),Windows)
    include $(XWS)/xws/makefiles/xmake.env.win.mak
else ifeq ($(XOS),Mac)
    include $(XWS)/xws/makefiles/xmake.env.mac.mak
else ifeq ($(XOS),Linux)
    include $(XWS)/xws/makefiles/xmake.env.linux.mak
else
    $(error xmake: XOS ("$(XOS)") is unknown)
endif

TMSTART:=$(shell echo `date +%s`)
CURSECONDS=$(shell echo `date +%s`)
DURATION=$(shell echo $$(( $(CURSECONDS) - $(TMSTART) )))

#-----------------------------------#
#		Names and Paths				#
#-----------------------------------#

OUTDIRNAME=$(TGTPLATFORM)_$(BUILDTYPE)_$(BUILDARCH)_$(THREADMODE)
INTDIR=output/intermediate/$(TGTNAME)/$(OUTDIRNAME)
OUTDIR=output/$(OUTDIRNAME)


#-----------------------------------#
#				Sources				#
#-----------------------------------#
SOURCETYPES=c* asm
SEARCH_DEPTH=10
ifeq (,$(TGTSRCDIRS))
    TGTSRCDIRS=.
endif

# 1. Prepare Source Dirs List
TGTSRCDIRS:=$(foreach d, $(TGTSRCDIRS), $(shell find $(d) -maxdepth $(SEARCH_DEPTH) -type d | sed 's/^\.\///' | grep -v '^\..*'))
# 2. Get c/cpp/cxx/asm files
#		- enum files
SOURCES = $(foreach dir, $(TGTSRCDIRS), $(foreach pattern, c* asm s, $(wildcard $(dir)/*.$(pattern))))
# 		- exclude precompile header source file
ifneq (,$(TGTPCHNAME))
    TGTPCHSRC:=$(filter %$(TGTPCHNAME).cpp, $(SOURCES))
    ifeq ($(TGTPCHSRC),)
        TGTPCHSRC:=$(filter %$(TGTPCHNAME).c, $(SOURCES))
	endif
    ifeq ($(TGTPCHSRC),)
        $(error 'Precompiled source file not found $(TGTPCHSRC)')
	endif
    SOURCES := $(filter-out $(TGTPCHSRC),$(SOURCES))
else

endif
# 2. Get resource file
RESOURCES = $(foreach dir, $(TGTSRCDIRS), $(foreach pattern, rc, $(wildcard $(dir)/*.$(pattern))))
# 3. Get manifest file
MANIFESTS = $(foreach dir, $(TGTSRCDIRS), $(foreach pattern, manifest, $(wildcard $(dir)/*.$(pattern))))
# 4. Get IDL file (for COM)
IDLS = $(foreach dir, $(TGTSRCDIRS), $(foreach pattern, idl, $(wildcard $(dir)/*.$(pattern))))
ifneq (,$(IDLS))
    SOURCES := $(SOURCES) $(foreach idl, $(IDLS), $(basename $(notdir $(idl)))_i.c $(basename $(notdir $(idl)))_p.c)
endif
# 5. DEF file (used by DLL)
ifeq (dll,$(TGTTYPE))
    DEFFILE:=$(foreach dir, $(TGTSRCDIRS), $(wildcard $(dir)/*.def))
    DEFFILE:=$(shell echo $(DEFFILE))
    ifneq (,$(DEFFILE))
        COUNT_OF_DEFFILES := $(words $(DEFFILE))
        ifneq (1, $(COUNT_OF_DEFFILES))
            $(error "xmake: Too many *.def files > $(DEFFILE)")
        endif
		LFLAGS+=-DEF:$(DEFFILE)
    endif
endif

# Make sure VPATH include all source dirs
#VPATH := $(sort $(TGTSRCDIRS))

# Generate Obj files list
#OBJS = $(foreach f, $(SOURCES), $(addsuffix .o,$(basename $(notdir $f))))   		<-- This line remove dir, but we want to keep dir in intermediate folder
OBJS = $(foreach f, $(SOURCES), $(addsuffix .o,$(basename $f)))
ifneq (,$(TGTPCHNAME))
    PCHOBJ += $(TGTPCHNAME).o
endif

# Generate res files list
#RCOBJS = $(foreach f, $(RESOURCES), $(addsuffix .res,$(basename $(notdir $f))))	<-- This line remove dir, but we want to keep dir in intermediate folder
RCOBJS = $(foreach f, $(RESOURCES), $(addsuffix .res,$(basename $f)))

#-----------------------------------#
#				Includes			#
#-----------------------------------#

# Additional Include paths

# Additional Lib paths
ADDITIONAL_LIBDIRS=

# Additional Lib paths
ADDITIONAL_LIBS=

#-----------------------------------#
#				Flags				#
#-----------------------------------#

# Compiler flags
ADDITIONAL_CFLAGS=
ADDITIONAL_CXXFLAGS=
# Linker flags
ADDITIONAL_LFLAGS=

#-----------------------------------#
#			Build Rules				#
#-----------------------------------#

ifeq (,$(INFLAG))
    $(error xmake: Compiler's INFLAG is not defined)
endif

ifeq (,$(COUTFLAG))
    $(error xmake: Compiler's OUTFLAG is not defined)
endif

ifeq (,$(LOUTFLAG))
    $(error xmake: Linker's OUTFLAG is not defined)
endif

# Rule for building ASM files
%.o: %.s
	@if [ $(patsubst %/,%,$(dir $<)) == . ]; then \
		if [ ! -d $(INTDIR) ] ; then \
			mkdir -p $(INTDIR) ; \
		fi \
	else \
		if [ ! -d $(INTDIR)/$(patsubst %/,%,$(dir $<)) ] ; then \
			mkdir -p $(INTDIR)/$(patsubst %/,%,$(dir $<)) ; \
		fi \
	fi
	@if [ $(VERBOSE). == yes. ] ; then \
		echo '"$(ML)" $(MLFLAGS) $(COUTFLAG) $(INTDIR)/$@ $(INFLAG) $<' ; \
	fi
	@"$(ML)" $(MLFLAGS) $(COUTFLAG) $(INTDIR)/$@ $(INFLAG) $< || exit 1

%.o: %.asm
	@if [ $(patsubst %/,%,$(dir $<)) == . ]; then \
		if [ ! -d $(INTDIR) ] ; then \
			mkdir -p $(INTDIR) ; \
		fi \
	else \
		if [ ! -d $(INTDIR)/$(patsubst %/,%,$(dir $<)) ] ; then \
			mkdir -p $(INTDIR)/$(patsubst %/,%,$(dir $<)) ; \
		fi \
	fi
	@if [ $(VERBOSE). == yes. ] ; then \
		echo '"$(ML)" $(MLFLAGS) $(COUTFLAG) $(INTDIR)/$@ $(INFLAG) $<' ; \
	fi
	@"$(ML)" $(MLFLAGS) $(COUTFLAG) $(INTDIR)/$@ $(INFLAG) $< || exit 1

# Rule for building C files
%.o: %.c
	@if [ $(patsubst %/,%,$(dir $<)) == . ]; then \
		if [ ! -d $(INTDIR) ] ; then \
			mkdir -p $(INTDIR) ; \
		fi \
	else \
		if [ ! -d $(INTDIR)/$(patsubst %/,%,$(dir $<)) ] ; then \
			mkdir -p $(INTDIR)/$(patsubst %/,%,$(dir $<)) ; \
		fi \
	fi
	@if [ $(VERBOSE). == yes. ] ; then \
		echo '"$(CC)" $(CFLAGS) $(IFLAGS) $(INFLAG) $< $(COUTFLAG)$(INTDIR)/$@' ; \
	fi
	@"$(CC)" $(CFLAGS) $(IFLAGS) $(INFLAG) $< $(COUTFLAG)$(INTDIR)/$@ || exit 1


# Rule for building C++ files
%.o: %.cpp
	@if [ $(patsubst %/,%,$(dir $<)) == . ]; then \
		if [ ! -d $(INTDIR) ] ; then \
			mkdir -p $(INTDIR) ; \
		fi \
	else \
		if [ ! -d $(INTDIR)/$(patsubst %/,%,$(dir $<)) ] ; then \
			mkdir -p $(INTDIR)/$(patsubst %/,%,$(dir $<)) ; \
		fi \
	fi
	@if [ $(VERBOSE). == yes. ] ; then \
		echo '"$(CXX)" $(CXXFLAGS) $(PCHUFLAGS) $(IFLAGS) $(INFLAG) $< $(COUTFLAG)$(INTDIR)/$@' ; \
	fi
	@"$(CXX)" $(CXXFLAGS) $(PCHUFLAGS) $(IFLAGS) $(INFLAG) $< $(COUTFLAG)$(INTDIR)/$@ || exit 1

# Rule for Precompiled Header File  // $(TGTPCHNAME).cpp
$(TGTNAME).pch: $(TGTPCHSRC)
	@if [ $(patsubst %/,%,$(dir $<)) == . ]; then \
		if [ ! -d $(INTDIR) ] ; then \
			mkdir -p $(INTDIR) ; \
		fi \
	else \
		if [ ! -d $(INTDIR)/$(patsubst %/,%,$(dir $<)) ] ; then \
			mkdir -p $(INTDIR)/$(patsubst %/,%,$(dir $<)) ; \
		fi \
	fi
	@if [ $(VERBOSE). == yes. ] ; then \
		echo '"$(CXX)" $(CXXFLAGS) $(PCHCFLAGS) $(IFLAGS) $(INFLAG) $< $(COUTFLAG)$(INTDIR)' ; \
	fi
	@"$(CXX)" $(CXXFLAGS) $(PCHCFLAGS) $(IFLAGS) $(INFLAG) $< $(COUTFLAG)$(INTDIR)/$(TGTPCHNAME).o || exit 1

# Rule for building the resources
%.res: %.rc
	@if [ $(patsubst %/,%,$(dir $<)) == . ]; then \
		if [ ! -d $(INTDIR) ] ; then \
			mkdir -p $(INTDIR) ; \
		fi \
	else \
		if [ ! -d $(INTDIR)/$(patsubst %/,%,$(dir $<)) ] ; then \
			mkdir -p $(INTDIR)/$(patsubst %/,%,$(dir $<)) ; \
		fi \
	fi
	@if [ $(VERBOSE). == yes. ] ; then \
		echo '"$(RC)" $(RCFLAGS) $(IFLAGS) $(COUTFLAG) $(INTDIR)/$@ $<' ; \
	fi
	@"$(RC)" $(RCFLAGS) $(IFLAGS) $(COUTFLAG) $(INTDIR)/$@ $< || exit 1

# Rule for building MIDL files
#	generate 4 files: %.tlb, %.h, %_i.c and %_p.c
%.tlb: %.idl
	@if [ $(patsubst %/,%,$(dir $<)) == . ]; then \
		if [ ! -d $(INTDIR) ] ; then \
			mkdir -p $(INTDIR) ; \
		fi \
	else \
		if [ ! -d $(INTDIR)/$(patsubst %/,%,$(dir $<)) ] ; then \
			mkdir -p $(INTDIR)/$(patsubst %/,%,$(dir $<)) ; \
		fi \
	fi
	@if [ $(VERBOSE). == yes. ] ; then \
		echo '"$(MIDL)" $(MIDL_CFLAGS) $(MIDL_DFLAGS) $(IFLAGS) /out $(INTDIR) $<' ; \
	fi
	@"$(MIDL)" $(MIDL_CFLAGS) $(MIDL_DFLAGS) $(IFLAGS) /out $(INTDIR) $< || exit 1

#
#  OUTPUT
#

# Rule for Output: Library
$(TGTNAME).lib: $(OBJS) $(RCOBJS)
	@echo "> Linking ..."
	@if [ $(VERBOSE). == yes. ] ; then \
		echo '"$(LIB)" $(SLFLAGS) $^ $(LOUTFLAG)"$(INTDIR)/$(TGTNAME).lib" $(TGTLIBS)' ; \
	fi
	@"$(LIB)" $(SLFLAGS) $(LOUTFLAG)"$(INTDIR)/$(TGTNAME).lib" $^ $(PCHOBJ) $(TGTLIBS)
	@if [ ! -d $(OUTDIR) ] ; then \
	  mkdir -p $(OUTDIR) ; \
	fi
	@mv -f "$(INTDIR)/$(TGTNAME).lib" "$(OUTDIR)/$(TGTNAME).lib"
	@if [ ! $(PKGROOT). == . ] ; then \
		if [ ! -d $(PKGROOT)/$(OUTDIR) ] ; then \
			mkdir -p $(PKGROOT)/$(OUTDIR) ; \
		fi ; \
	  	cp -f "$(OUTDIR)/$(TGTNAME).exe" "$(PKGROOT)/$(OUTDIR)/$(TGTNAME).lib" ; \
	fi

$(TGTNAME).a: $(OBJS) $(RCOBJS)
	@echo "> Linking ..."
	@if [ ! -d $(OUTDIR) ] ; then \
	  mkdir -p $(OUTDIR) ; \
	fi

# Rule for Output: Dll
$(TGTNAME).dll: $(OBJS) $(RCOBJS)
	@echo "> Linking ..."
	@if [ $(VERBOSE). == yes. ] ; then \
		echo '"$(LINK)" $(LFLAGS) $^ $(PCHOBJ) $(TGTLIBS) $(LOUTFLAG)"$(INTDIR)/$(TGTNAME).dll"' ; \
	fi
	@"$(LINK)" $(LFLAGS) $^ $(TGTLIBS) $(LOUTFLAG)"$(INTDIR)/$(TGTNAME).dll"
	@if [ ! -d $(OUTDIR) ] ; then \
	  mkdir -p $(OUTDIR) ; \
	fi
	@mv -f "$(INTDIR)/$(TGTNAME).dll" "$(OUTDIR)/$(TGTNAME).dll"
	@mv -f "$(INTDIR)/$(TGTNAME).lib" "$(OUTDIR)/$(TGTNAME).lib"
	@if [ $(XOS). == Windows. ] ; then \
	  	mv -f "$(INTDIR)/$(TGTNAME).pdb" "$(OUTDIR)/$(TGTNAME).pdb" ; \
	fi
	@if [ ! $(PKGROOT). == . ] ; then \
		if [ ! -d $(PKGROOT)/$(OUTDIR) ] ; then \
			mkdir -p $(PKGROOT)/$(OUTDIR) ; \
		fi ; \
	  	cp -f "$(OUTDIR)/$(TGTNAME).dll" "$(PKGROOT)/$(OUTDIR)/$(TGTNAME).dll" ; \
	  	cp -f "$(OUTDIR)/$(TGTNAME).lib" "$(PKGROOT)/$(OUTDIR)/$(TGTNAME).lib" ; \
	  	cp -f "$(OUTDIR)/$(TGTNAME).pdb" "$(PKGROOT)/$(OUTDIR)/$(TGTNAME).pdb" ; \
	fi

$(TGTNAME).so: $(OBJS) $(RCOBJS)
	@echo "> Linking ..."
	@if [ ! -d $(OUTDIR) ] ; then \
	  mkdir -p $(OUTDIR) ; \
	fi

$(TGTNAME).dynlib: $(OBJS) $(RCOBJS)
	@echo "> Linking ..."
	@if [ ! $(XOS). == Mac. ]; then \
	    echo 'error: Dynlib file is only for MacOS' ; \
	    exit 1 ; \
	fi
	@if [ ! -d $(OUTDIR) ] ; then \
	  mkdir -p $(OUTDIR) ; \
	fi

# Rule for Output: Executable
$(TGTNAME).exe: $(OBJS) $(RCOBJS)
	@echo "> Linking ..."
	@if [ $(VERBOSE). == yes. ] ; then \
		echo '"$(LINK)" $(LFLAGS) $(TGTLIBS) $^ $(PCHOBJ) $(LOUTFLAG)"$(INTDIR)/$(TGTNAME).exe"' ; \
	fi
	@"$(LINK)" $(LFLAGS) $(TGTLIBS) $^ $(PCHOBJ) $(LOUTFLAG)"$(INTDIR)/$(TGTNAME).exe"
	@if [ ! -d $(OUTDIR) ] ; then \
	  mkdir -p $(OUTDIR) ; \
	fi
	@mv -f "$(INTDIR)/$(TGTNAME).exe" "$(OUTDIR)/$(TGTNAME).exe"
	@if [ $(XOS). == Windows. ] ; then \
	  	mv -f "$(INTDIR)/$(TGTNAME).pdb" "$(OUTDIR)/$(TGTNAME).pdb" ; \
	fi
	@if [ ! $(PKGROOT). == . ] ; then \
		if [ ! -d $(PKGROOT)/$(OUTDIR) ] ; then \
			mkdir -p $(PKGROOT)/$(OUTDIR) ; \
		fi ; \
	  	cp -f "$(OUTDIR)/$(TGTNAME).exe" "$(PKGROOT)/$(OUTDIR)/$(TGTNAME).exe" ; \
	  	cp -f "$(OUTDIR)/$(TGTNAME).pdb" "$(PKGROOT)/$(OUTDIR)/$(TGTNAME).pdb" ; \
	fi

$(TGTNAME): $(OBJS) $(RCOBJS)
	@echo "> Linking ..."
	@if [ ! -d $(OUTDIR) ] ; then \
	  mkdir -p $(OUTDIR) ; \
	fi

# Rule for Output: Sys
$(TGTNAME).sys: $(OBJS) $(RCOBJS)
	@echo "> Linking ..."
	@if [ ! $(XOS). == Windows. ]; then \
	    echo 'error: SYS file is only for Windows' ; \
	    exit 1 ; \
	fi
	@if [ ! -d $(OUTDIR) ] ; then \
	  mkdir -p $(OUTDIR) ; \
	fi

.PHONY: printsrcs
.PHONY: printobjs

.PHONY: buildall
.PHONY: buildclean

printsrcs:
	@echo 'PCH:'
	@echo "  $(TGTPCHSRC)"
	@echo 'Sources:'
	@for f in $(SOURCES) ; do echo "  $$f" ; done
	@echo 'Resources:'
	@for f in $(RESOURCES) ; do echo "  $$f" ; done
	@echo 'IDLs:'
	@for f in $(IDLS) ; do echo "  $$f" ; done
	@if [ $(TGTTYPE). == dll. ]; then \
		echo 'DEF: $(DEFFILE)' ; \
	fi
	@echo 'MANIFESTSs:'
	@for f in $(MANIFESTS) ; do echo "  $$f" ; done

printobjs:
	@echo 'OBJs:'
	@echo "  $(PCHFILE)"
	@for f in $(OBJS) ; do echo "  $$f" ; done
	@for f in $(RCOBJS) ; do echo "  $$f" ; done

buildcheck:
	@echo '> Initializing ...'
	@if [ $(BUILDARCH). == . ]; then \
	    echo 'error: BUILDARCH is not defined' ; \
	    exit 1 ; \
	fi
	@if [ $(BUILDTYPE). == . ]; then \
	    echo 'error: BUILDTYPE is not defined' ; \
	    exit 1 ; \
	fi

stageStart:
	@echo " "
	@echo "================== Building $(TGTNAME)$(TGTEXT) ($(BUILDTYPE)/$(BUILDARCH)) =================="
	@echo "Start at `date "+%Y-%m-%d %H:%M:%S"`"

stageCompiling:
	@echo "> Compiling ..."

buildall: stageStart buildcheck stageCompiling $(PCHFILE) $(TGTNAME)$(TGTEXT)
	@echo "Build Succeed (Used: $(DURATION) seconds)"

buildclean:
	@if [[ $(BUILDARCH). == . || $(BUILDTYPE). == . ]]; then \
	    echo 'Clean all' ; \
		echo '  - deleting "output" ...' ; \
		rm -rf output ; \
		echo '  - deleting "$(PKGROOT)/output" ...' ; \
		rm -rf "$(PKGROOT)/output" ; \
	else \
	    echo 'Clean $(OUTDIRNAME)' ; \
		echo '  - deleting "$(INTDIR)" ...' ; \
		rm -rf "$(INTDIR)" ; \
		echo '  - deleting "$(OUTDIR)" ...' ; \
		rm -rf "$(OUTDIR)" ; \
	fi
