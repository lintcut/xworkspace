###############################################################
######  		WINDOWS BUILD ENVIRONMENT				#######
###############################################################

ifeq ($(XWSROOT),)
    $(error xmake: XWSROOT is not defined)
endif

ifneq ($(XOS),Mac)
	$(error Current OS is not Mac)
endif

ifeq ($(TGTPLATFORM),)
    TGTPLATFORM=mac
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