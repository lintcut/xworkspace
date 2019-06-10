#######################################################
###				PACKAGE MAKEFILE					###
#######################################################

#-----------------------------------#
#			Package Info			#
#-----------------------------------#

# The package information that target belongs to
#	- name of package
PKGNAME=xvault
#	- modules in this package
PKGMODULES = app/xvault
#	- package root
export PKGROOT=$(shell pwd)

# Target CPU Arch:
#	- x86:		x86 cpu
#	- x64:		x64 cpu
#	- arm:		arm cpu
#	- arm64:	arm64 cpu
ifeq ($(BUILDARCH),)
    BUILDARCH=x86
else ifeq ($(BUILDARCH),x86)
else ifeq ($(BUILDARCH),x64)
else
    $(error xmake: BUILDARCH '$(BUILDARCH)' is invalid)
endif

# BuildType:
#	- debug:	debug build
#	- release:	release build
#	- noopt:	release, but without optimization
ifeq ($(BUILDTYPE),)
    BUILDTYPE=release
else ifeq ($(BUILDTYPE),release)
else ifeq ($(BUILDTYPE),noopt)
else ifeq ($(BUILDTYPE),debug)
else
    $(error xmake: BUILDTYPE is not defined)
endif

SRC=../src/hw/test.cpp
OBJ=$(addsuffix .o,$(subst /,&,$(subst .,@,$(basename $(SRC)))))

$(info OBJ: $(OBJ))

.PHONY: all
.PHONY: clean

all:
	@echo " "
	@echo ">>>>>>>>>>>>>>>> BUILD PACKAGE ($(PKGNAME)) <<<<<<<<<<<<<<<<"
	@echo "  Package: $(PKGNAME)"
	@echo "  BuildType: $(BUILDTYPE)"
	@echo "  BuildArch: $(BUILDARCH)"
	@for m in $(PKGMODULES) ; do \
		echo " " ; \
		echo "---------------- Build $$m ($(BUILDTYPE)/$(BUILDARCH)) ----------------" ; \
		cd $$m ; \
		make BUILDARCH=$(BUILDARCH) BUILDTYPE=$(BUILDTYPE); \
		cd $(PKGROOT) ; \
	done

clean:
	@echo " "
	@echo ">>>>>>>>>>>>>>>> CLEAN PACKAGE ($(PKGNAME)) <<<<<<<<<<<<<<<<"
	@for m in $(PKGMODULES) ; do \
		echo " " ; \
		echo "---------------- Clean $$m ($(BUILDTYPE)/$(BUILDARCH)) ----------------" ; \
		cd $$m ; \
		make clean BUILDARCH=$(BUILDARCH) BUILDTYPE=$(BUILDTYPE); \
		cd $(PKGROOT) ; \
	done