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

SUBDIRS:=$(foreach d, $(TGTSRCDIRS), $(shell find $(d) -maxdepth $(SEARCH_DEPTH) -type d | sed 's/^\.\///' | grep -v '^\..*'))
$(info SUBDIRS: $(SUBDIRS))

MAKEFILES:=$(shell find . -maxdepth 20 -type f | grep -v '\\Makefile')
MAKEFILES:=$(filter-out Makefile,$(SOURCES))

$(info MAKEFILES: $(MAKEFILES))

.DEFAULT_GOAL := all

all:
	@echo " "
