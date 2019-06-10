# Bash Lib for String

xbCharToInt(){
    if [ $1. == . ]; then
        echo 0
        return 1;
    fi
    echo `printf %d \'$1\'`
}

xbIntToChar(){
    if [ $1. == . ]; then
        return 1;
    elif [[ $1 -gt 127 ]]; then
        return 1;
    fi
    echo `printf "\x$(printf %x $1)"`
}


xbRot13(){
    if [ $1. == . ]; then
        return 1;
    fi
    input=$1
    output=
    for (( i=0; i<${#input}; i++ )); do
        c=${input:$i:1}
        v=$(xbCharToInt $c)
        #echo $v
        if [[ $v -gt 64 && $v -lt 78 ]]; then
            ((v+=13))
            c=`printf "\x$(printf %x $v)"`
        elif [[ $v -gt 77 && $v -lt 91 ]]; then
            ((v-=13))
            c=`printf "\x$(printf %x $v)"`
        elif [[ $v -gt 96 && $v -lt 109 ]]; then
            ((v+=13))
            c=`printf "\x$(printf %x $v)"`
        elif [[ $v -gt 108 && $v -lt 123 ]]; then
            ((v-=13))
            c=`printf "\x$(printf %x $v)"`
        fi
        output+=$c
    done
    echo $output
    return 0
}

xbToLower(){
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

xbToUpper(){
    echo "$1" | sed "y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/"
}