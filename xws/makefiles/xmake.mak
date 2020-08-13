#################################################################
######  			XWORKSPACE MAKEFILE					  #######
#################################################################

#-----------------------------------#
#			Makefile Arguments		#
#-----------------------------------#
include $(XWSROOT)/xws/makefiles/xmake.common.mak
include $(XWSROOT)/xws/makefiles/xmake.envprep.mak
include $(XWSROOT)/xws/makefiles/xmake.targetprep.mak


#-----------------------------------#
#		  	Make Rules				#
#-----------------------------------#

# Rule for building ASM files
%.o: %.s
	@if [ -z '$(patsubst %/,%,$(dir $<))' ]; then \
		if [ ! -d $(BUILD_INTDIR) ] ; then \
			mkdir -p $(BUILD_INTDIR) ; \
		fi \
	else \
		if [ ! -d $(BUILD_INTDIR)/$(patsubst %/,%,$(dir $<)) ] ; then \
			mkdir -p $(BUILD_INTDIR)/$(patsubst %/,%,$(dir $<)) ; \
		fi \
	fi
	@if [ "$(VERBOSE)" = "yes" ]; then \
		echo '"$(TOOL_ML)" $(BUILD_MLFLAGS) -Fo "$(BUILD_INTDIR)/$@" -c $<' ; \
	fi
	@"$(TOOL_ML)" $(BUILD_MLFLAGS) -Fo "$(BUILD_INTDIR)/$@" -c $< || exit 1

%.o: %.asm
	@if [ -z '$(patsubst %/,%,$(dir $<))' ]; then \
		if [ ! -d $(BUILD_INTDIR) ] ; then \
			mkdir -p $(BUILD_INTDIR) ; \
		fi \
	else \
		if [ ! -d $(BUILD_INTDIR)/$(patsubst %/,%,$(dir $<)) ] ; then \
			mkdir -p $(BUILD_INTDIR)/$(patsubst %/,%,$(dir $<)) ; \
		fi \
	fi
	@if [ "$(VERBOSE)" = "yes" ] ; then \
		echo '"$(TOOL_ML)" $(BUILD_MLFLAGS) -Fo "$(BUILD_INTDIR)/$@" -c $<' ; \
	fi
	@"$(TOOL_ML)" $(BUILD_MLFLAGS) -Fo "$(BUILD_INTDIR)/$@" -c $< || exit 1

# Rule for building C files
%.o: %.c
	@if [ -z '$(patsubst %/,%,$(dir $<))' ]; then \
		if [ ! -d $(BUILD_INTDIR) ] ; then \
			mkdir -p $(BUILD_INTDIR) ; \
		fi \
	else \
		if [ ! -d $(BUILD_INTDIR)/$(patsubst %/,%,$(dir $<)) ] ; then \
			mkdir -p $(BUILD_INTDIR)/$(patsubst %/,%,$(dir $<)) ; \
		fi \
	fi
	@if [ "$(VERBOSE)" = "yes" ] ; then \
		echo '"$(TOOL_CC)" $(BUILD_CFLAGS) -c $< -Fo"$(BUILD_INTDIR)/$@"' ; \
	fi
	@"$(TOOL_CC)" $(BUILD_CFLAGS) -c $< -Fo"$(BUILD_INTDIR)/$@" || exit 1


# Rule for building C++ files
%.o: %.cpp
	@if [ -z '$(patsubst %/,%,$(dir $<))' ]; then \
		if [ ! -d $(BUILD_INTDIR) ] ; then \
			mkdir -p $(BUILD_INTDIR) ; \
		fi \
	else \
		if [ ! -d $(BUILD_INTDIR)/$(patsubst %/,%,$(dir $<)) ] ; then \
			mkdir -p $(BUILD_INTDIR)/$(patsubst %/,%,$(dir $<)) ; \
		fi \
	fi
	@if [ "$(VERBOSE)" = "yes" ]; then \
		echo '"$(TOOL_CXX)" $(BUILD_CXXFLAGS) $(USE_PCHFLAG) -c $< -Fo$(BUILD_INTDIR)/$@' ; \
	fi
	@"$(TOOL_CXX)" $(BUILD_CXXFLAGS) $(USE_PCHFLAG) -c $< -Fo$(BUILD_INTDIR)/$@ || exit 1

# Rule for Precompiled Header File
$(TARGETNAME).pch:
	@if [ ! -d $(BUILD_INTDIR) ] ; then \
		mkdir -p $(BUILD_INTDIR) ; \
	fi
	@if [ "$(TARGETMODE)" = "kernel" ] ; then \
		echo '#include "$(TARGET_PCHNAME)"' > $(BUILD_INTDIR)/$(TARGET_PCHBASENAME).c ; \
		if [ "$(VERBOSE)" = "yes" ] ; then \
			echo '"$(TOOL_CC)" $(BUILD_CXXFLAGS) $(CREATE_PCHFLAG) -c "$(BUILD_INTDIR)/$(TARGET_PCHBASENAME).c" -Fo"$(BUILD_INTDIR)/$(TARGET_PCHBASENAME).o"' ; \
		fi ; \
		"$(TOOL_CC)" $(BUILD_CXXFLAGS) $(CREATE_PCHFLAG) -c "$(BUILD_INTDIR)/$(TARGET_PCHBASENAME).c" -Fo"$(BUILD_INTDIR)/$(TARGET_PCHBASENAME).o" || exit 1 ; \
	else \
		echo '#include "$(TARGET_PCHNAME)"' > $(BUILD_INTDIR)/$(TARGET_PCHBASENAME).cpp ; \
		if [ "$(VERBOSE)" = "yes" ] ; then \
			echo '"$(TOOL_CXX)" $(BUILD_CXXFLAGS) $(CREATE_PCHFLAG) -c "$(BUILD_INTDIR)/$(TARGET_PCHBASENAME).cpp" -Fo"$(BUILD_INTDIR)/$(TARGET_PCHBASENAME).o"' ; \
		fi ; \
		"$(TOOL_CXX)" $(BUILD_CXXFLAGS) $(CREATE_PCHFLAG) -c "$(BUILD_INTDIR)/$(TARGET_PCHBASENAME).cpp" -Fo"$(BUILD_INTDIR)/$(TARGET_PCHBASENAME).o" || exit 1 ; \
	fi

# Rule for building the resources
%.res: %.rc
	@if [ -z '$(patsubst %/,%,$(dir $<))' ]; then \
		if [ ! -d $(BUILD_INTDIR) ] ; then \
			mkdir -p $(BUILD_INTDIR) ; \
		fi \
	else \
		if [ ! -d $(BUILD_INTDIR)/$(patsubst %/,%,$(dir $<)) ] ; then \
			mkdir -p $(BUILD_INTDIR)/$(patsubst %/,%,$(dir $<)) ; \
		fi \
	fi
	@if [ "$(VERBOSE)" = "yes" ] ; then \
		echo '"$(TOOL_RC)" $(BUILD_RCFLAGS) -Fo $(BUILD_INTDIR)/$@ $<' ; \
	fi
	@"$(TOOL_RC)" $(BUILD_RCFLAGS) -Fo $(BUILD_INTDIR)/$@ $< || exit 1

# Rule for building MIDL files
#	generate 4 files: %.tlb, %.h, %_i.c and %_p.c
%.tlb: %.idl
	@if [ -z '$(patsubst %/,%,$(dir $<))' ]; then \
		if [ ! -d $(BUILD_INTDIR) ] ; then \
			mkdir -p $(BUILD_INTDIR) ; \
		fi \
	else \
		if [ ! -d $(BUILD_INTDIR)/$(patsubst %/,%,$(dir $<)) ] ; then \
			mkdir -p $(BUILD_INTDIR)/$(patsubst %/,%,$(dir $<)) ; \
		fi \
	fi
	@if [ "$(VERBOSE)" = "yes" ] ; then \
		echo '"$(TOOL_MIDL)" $(BUILD_MIDLFLAGS) /out $(BUILD_INTDIR) $<' ; \
	fi
	@"$(TOOL_MIDL)" $(BUILD_MIDLFLAGS) /out $(BUILD_INTDIR) $< || exit 1

# Rule to build final target
$(TARGETNAME)$(TARGETEXT): $(ALLTARGETS)
	@echo "> Linking ..."
	@if [ ! -d $(BUILD_OUTDIR) ] ; then \
		mkdir -p $(BUILD_OUTDIR) ; \
	fi
	@if [ "$(TARGETTYPE)" = "lib" ] || [ "$(TARGETTYPE)" = "klib" ] ; then \
		if [ "$(VERBOSE)" = "yes" ] ; then \
			echo '"$(TOOL_LIB)" $(BUILD_SLFLAGS) -OUT:"$(BUILD_INTDIR)/$(TARGETNAME)$(TARGETEXT)"' ; \
		fi ; \
		"$(TOOL_LIB)" $(BUILD_SLFLAGS) -OUT:"$(BUILD_INTDIR)/$(TARGETNAME)$(TARGETEXT)" ; \
		echo "> Copying files ..." ; \
		cp "$(BUILD_INTDIR)/$(TARGETNAME)$(TARGETEXT)" "$(BUILD_OUTDIR)/$(TARGETNAME)$(TARGETEXT)" ; \
		echo "     $(BUILD_OUTDIR)/$(TARGETNAME)$(TARGETEXT)" ; \
	else \
		if [ "$(VERBOSE)" = "yes" ] ; then \
			echo '"$(TOOL_LINK)" $(BUILD_LFLAGS) -OUT:"$(BUILD_INTDIR)/$(TARGETNAME)$(TARGETEXT)"' ; \
		fi ; \
		"$(TOOL_LINK)" $(BUILD_LFLAGS) -OUT:"$(BUILD_INTDIR)/$(TARGETNAME)$(TARGETEXT)" ; \
		if [ -n '$(BUILDSIGNARGS)' ]; then \
		    echo '> Signing output ...' ; \
			if [ "$(VERBOSE)" = "yes" ] ; then \
		    	echo '"$(TOOL_SIGNTOOL)" $(BUILDSIGNARGS) "$(BUILD_INTDIR)/$(TARGETNAME)$(TARGETEXT)"' ; \
			fi ; \
			"$(TOOL_SIGNTOOL)" $(BUILDSIGNARGS) "$(BUILD_INTDIR)/$(TARGETNAME)$(TARGETEXT)"; \
		fi ; \
		echo "> Copying files ..." ; \
		cp "$(BUILD_INTDIR)/$(TARGETNAME)$(TARGETEXT)" "$(BUILD_OUTDIR)/$(TARGETNAME)$(TARGETEXT)" ; \
		echo "     $(BUILD_OUTDIR)/$(TARGETNAME)$(TARGETEXT)" ; \
		cp "$(BUILD_INTDIR)/$(TARGETNAME).pdb" "$(BUILD_OUTDIR)/$(TARGETNAME).pdb" ; \
		echo "     $(BUILD_OUTDIR)/$(TARGETNAME).pdb" ; \
	fi
	@if [ "$(TARGETTYPE)" = "dll" ] ; then \
		cp "$(BUILD_INTDIR)/$(TARGETNAME).lib" "$(BUILD_OUTDIR)/$(TARGETNAME).lib" ; \
		echo "     $(BUILD_OUTDIR)/$(TARGETNAME).lib" ; \
	fi

#-----------------------------------#
#		  FINAL MAKE TARGETS		#
#-----------------------------------#

.PHONY: buildenv

.PHONY: buildall
.PHONY: buildclean

buildenv:
	@echo " "
	@echo "----------------- Build Environment Check -----------------"
	@echo "> Build Args <"
	@echo "  BUILDTYPE: $(BUILDTYPE)"
	@echo "  BUILDARCH: $(BUILDARCH)"
	@echo "  BUILDSIGNARGS: $(BUILDSIGNARGS)"
	@echo "> Compiler <"
	@echo "  Version: Visual Studio $(XBUILD_VSVER)"
	@echo "  ToolsetVer: vc$(XBUILD_VCTOOLSETVER)"
	@echo "  VC Dir: $(XBUILD_VCROOTDIR)"
	@echo "  VC Bin Dir: $(XBUILD_VCBINDIR)"
	@echo "  VC Inc Dir: $(XBUILD_VCINCDIR)"
	@echo "  VC Lib Dir: $(XBUILD_VCLIBDIR)"
	@echo "  VC ATL/MFC Inc Dir: $(XBUILD_VCATLMFC_INCDIR)"
	@echo "  VC ATL/MFC Lib Dir: $(XBUILD_VCATLMFC_LIBDIR)"
	@echo "> Windows Kits <"
	@echo "  Root Dir: $(XBUILD_WINKITROOT)"
	@echo "  SDK Version: $(XBUILD_SDKVER)"
	@echo "  SDK Bin Dir: $(XBUILD_SDKBINDIR)"
	@echo "  SDK Inc Dir: $(XBUILD_SDKINCDIR)"
	@echo "  SDK Lib Dir: $(XBUILD_SDKLIBDIR)"
	@echo "  WDK Version: $(XBUILD_WDKVER)"
	@echo "  WDK Bin Dir: $(XBUILD_WDKBINDIR)"
	@echo "  WDK Inc Dir: $(XBUILD_WDKINCDIR)"
	@echo "  WDK Lib Dir: $(XBUILD_WDKLIBDIR)"
	@echo "> Build Tools <"
	@echo "  CC:       $(TOOL_CC)"
	@echo "  CXX:      $(TOOL_CXX)"
	@echo "  ML:       $(TOOL_ML)"
	@echo "  LIB:      $(TOOL_LIB)"
	@echo "  LINK:     $(TOOL_LINK)"
	@echo "  DUMPBIN:  $(TOOL_DUMPBIN)"
	@echo "  NMAKE:    $(TOOL_NMAKE)"
	@echo "  RC:       $(TOOL_RC)"
	@echo "  MC:       $(TOOL_MC)"
	@echo "  MT:       $(TOOL_MT)"
	@echo "  MIDL:     $(TOOL_MIDL)"
	@echo "  UUIDGEN:  $(TOOL_UUIDGEN)"
	@echo "  SIGNTOOL: $(TOOL_SIGNTOOL)"
	@echo "  STAMPINF: $(TOOL_STAMPINF)"
	@echo "  CERT2SPC: $(TOOL_CERT2SPC)"
	@echo "  PVK2PFX:  $(TOOL_PVK2PFX)"
	@echo "> Source Files <"
	@echo "  PCH: $(TARGET_PCH), $(BUILD_PCHFILE)"
	@echo "  Sources:"
	@for f in $(TARGET_SRCS) ; do echo "    $$f" ; done
	@echo "  Resources:"
	@for f in $(TARGET_RCS) ; do echo "    $$f" ; done
	@echo "  IDLs:"
	@for f in $(BTARGET_IDLS) ; do echo "    $$f" ; done
	@echo "  MANEFISTs:"
	@for f in $(TARGET_MANEFIST) ; do echo "    $$f" ; done
	@echo "  DEFs: $(TARGET_DEF)"
	@echo "  All Targets:"
	@for f in $(ALLTARGETS) ; do echo "    $$f" ; done

buildcheck:
	@echo '> Initializing ...'
	@if [ -z "$(BUILDARCH)" ]; then \
	    echo 'error: BUILDARCH ($(BUILDARCH)) is not defined' ; \
	    exit 1 ; \
	fi
	@if [ -z "$(BUILDTYPE)" ]; then \
	    echo 'error: BUILDTYPE ($(BUILDTYPE)) is not defined' ; \
	    exit 1 ; \
	fi

stageStart:
	@echo " "
	@echo "================== Building $(TARGETNAME)$(TARGETEXT) ($(BUILDTYPE)/$(BUILDARCH)) =================="
	@echo "Start at `date "+%Y-%m-%d %H:%M:%S"`"

stageCompiling:
	@echo "> Compiling ..."

buildall: stageStart buildcheck stageCompiling $(TARGETNAME)$(TARGETEXT)
	@echo "Build Succeed (Used: $(XTIME_DURATION) seconds)"

buildclean:
	@if [ -z '$(BUILDARCH)' ] || [ -z '$(BUILDTYPE)' ]; then \
	    echo 'Clean all' ; \
		echo '  - deleting "output" ...' ; \
		rm -rf output ; \
	else \
	    echo 'Clean $(BUILDTYPE)_$(BUILDARCH)' ; \
		echo '  - deleting "$(BUILD_INTDIR)" ...' ; \
		rm -rf "$(BUILD_INTDIR)" ; \
		echo '  - deleting "$(BUILD_OUTDIR)" ...' ; \
		rm -rf "$(BUILD_OUTDIR)" ; \
	fi
