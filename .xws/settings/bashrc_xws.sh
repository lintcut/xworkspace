
##
##  Functions
##

# lower-case string
xwstolower(){
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

# upper-case string
xwstoupper(){
    echo "$1" | sed "y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/"
}

# get os name
xwsgetos(){
    UNAMESTR=`xwstoupper \`uname -s\``
    if [[ "$UNAMESTR" == MINGW* ]]; then
        echo Windows
    elif [[ "$UNAMESTR" == *LINUX* ]]; then
        echo Linux
    elif [ "{$UNAMESTR}" == "{FREEBSD}" ]; then
        echo FreeBSD
    elif [[ "$UNAMESTR" == DARWIN* ]]; then
        echo Mac
    else
        echo Unknown
    fi
}

# get XWSROOT
xwsgetroot(){
    CURDIR=`pwd`
    DOTXWS=`dirname $CURDIR`
    XWS=`dirname $DOTXWS`
    echo $XWS
}

##
##  Export Path/Settings
##
#  -> OS Name
export XWSROOT=`echo \`xwsgetroot\``
export XOS=`echo \`xwsgetos\``
#  -> Load OS-related files
if [ $XOS == Windows ]; then
    source $XWSROOT/.xws/settings/bashrc_xws_win.sh
elif [ $XOS == Linux ]; then
    source $XWSROOT/.xws/settings/bashrc_xws_linux.sh
elif [ $XOS == FreeBSD ]; then
    source $XWSROOT/.xws/settings/bashrc_xws_linux.sh
elif [ $XOS == Mac ]; then
    source $XWSROOT/.xws/settings/bashrc_xws_mac.sh
else
    echo Unknown OS, failed.
fi

##
##  Alias
##

# Common
alias cls='clear'
alias cdw='cd $XWSROOT'

# Git Alias
#  -> get status
alias gits='git status'
#  -> add all files
alias gitaa='git add -A'
#  -> commit
alias gitc='git commit -a -m'
#  -> show repo history
alias gith='git log --pretty=format:"%h - %an, %ar : %s"'
#  -> show file history
alias githf='git log --follow --pretty=format:"%h - %an, %ar : %s" --'