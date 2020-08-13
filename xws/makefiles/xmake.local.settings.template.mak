#######################################################
###				LOCAL SETTINGS TEMPLATE				###
#######################################################

# This is a template file for local settings.
# To enable local settings, copy this file to:
#     "$(XWSROOT)/xws/makefiles/xmake.local.settings.mak"
# The new file won't be tracked by git and is only available at local


#-----------------------------------#
#		  Code Signing				#
#-----------------------------------#

# Global dev certificate
XBUILD_DEVCERT=$(XWSROOT)/xws/certs/devcert.pfx
# Global dev certificate password
XBUILD_DEVCERTPSWD=YOUR-PASSWORD
# Global dev certificate time server url (optional)
XBUILD_DEVCERTTTIMEURL=