#######################################################
###					PACKAGE MAKEFILE				###
#######################################################

#-----------------------------------#
#		Target Package Info			#
#-----------------------------------#

# The package information that target belongs to
#	- name of package
PKGENAME=
#	- root path of package
PKGROOT:=$(shell pwd)
$(info PKGROOT: $(PKGROOT))

SUBDIRS:=$(shell find $(d) -maxdepth 20 -type d | sed 's/^\.\///' | grep -v '^\..*')
#$(info SUBDIRS: $(SUBDIRS))

MAKEFILES:=$(foreach dir, $(SUBDIRS), $(wildcard $(dir)/Makefile))
#$(info MAKEFILES: $(MAKEFILES))

MAKEFILEDIRS:=$(foreach f, $(MAKEFILES), $(patsubst %/,%,$(dir $(f))))
#$(info MAKEFILEDIRS: $(MAKEFILEDIRS))

.DEFAULT_GOAL := all

all: $(MAKEFILEDIRS)
	@cd $(PKGROOT)

$(MAKEFILEDIRS):
	@make -C $@ PKGROOT=$(PKGROOT)

.PHONY: all $(SUBDIRS)

