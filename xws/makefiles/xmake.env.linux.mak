###############################################################
######  	  	    LINUX BUILD ENVIRONMENT				#######
###############################################################

ifeq ($(XWSROOT),)
    $(error xmake: XWSROOT is not defined)
endif

ifneq ($(XOS),Linux)
	$(error Current OS is not Linux)
endif

ifeq ($(TGTPLATFORM),)
    TGTPLATFORM=linux
endif

# make sure target type is valid
ifeq ($(TGTTYPE),gui)
    TGTEXT=
else ifeq ($(TGTTYPE),console)
    TGTEXT=
else ifeq ($(TGTTYPE),lib)
    TGTEXT=.a
else ifeq ($(TGTTYPE),dll)
    TGTEXT=.so
else ifeq ($(TGTTYPE),drv)
    $(error xmake: TGTTYPE ("$(TGTTYPE)") is not supported)
else
    $(error xmake: TGTTYPE ("$(TGTTYPE)") is unknown)
endif

# Tools
CC=gcc
CXX=g++
LIB=ar
LINK=gcc

LFLAGS=-L$(OUTDIR) -L$(INTDIR)
SLFLAGS=-L$(OUTDIR) -L$(INTDIR)


#-----------------------------------#
#		Path: Includes, Libs		#
#-----------------------------------#

IFLAGS += $(foreach dir, $(TGTINCDIRS), $(addprefix -I, $(shell echo '$(dir)')))
IFLAGS+=-I/usr/include \
        -I$(XWSROOT)/xinclude

LFLAGS=-L$(OUTDIR) -L$(INTDIR)
LFLAGS += $(foreach dir, $(TGTLIBDIRS), $(addprefix -L,$(shell echo '$(dir)')))
LFLAGS += -L/usr/lib \
          -L/usr/local/lib

#-----------------------------------#
#	Options: Compiler				#
#-----------------------------------#

INFLAG=-c
COUTFLAG=-o
LOUTFLAG=-o

CFLAGS   += -std=c99 -fvisibility=hidden
CXXFLAGS += -std=c++14 -fvisibility=hidden

ifeq ($(BUILDARCH), x64)
    CFLAGS   += -march=x86-64 -m64
    CXXFLAGS += -march=x86-64 -m64
    LFLAGS += -march=x86-64 -m64
else ifeq ($(BUILDARCH), x86)
    CFLAGS   += -march=i386 -m32
    CXXFLAGS += -march=i386 -m32
    LFLAGS += -march=i386 -m32
endif

ifeq ($(BUILDTYPE),debug)
    CFLAGS   += -g3 -Og
    CXXFLAGS += -g3 -Og
else
    CFLAGS   += -g0 -Ofast
    CXXFLAGS += -g0 -Ofast
endif

ifeq ($(TGTTYPE),dll)
    CFLAGS   += -fPIC
    CXXFLAGS += -fPIC
    LFLAGS += -shared
endif
