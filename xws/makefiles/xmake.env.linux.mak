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
    TGTEXT=
else
    $(error xmake: TGTTYPE ("$(TGTTYPE)") is unknown)
endif

# Tools
CC=gcc
CXX=g++
LIB=ar
LINK=ld

LFLAGS=-L$(OUTDIR) -L$(INTDIR)
SLFLAGS=-L$(OUTDIR) -L$(INTDIR)
