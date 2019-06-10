source ../libs/string.sh

testRot13(){
    echo " " >&2
    echo [Test Rot13] >&2
    rot13Plain=07224a87943eb754ff0ba347fb5bb97ea8d0ad3c
    echo "  Source:    $rot13Plain" >&2
    rot13Enc=$(xbRot13 $rot13Plain)
    echo "  Encrypted: $rot13Enc" >&2
    rot13Dec=$(xbRot13 $rot13Enc)
    echo "  Decrypted: $rot13Dec" >&2
    if ! [ $rot13Dec. == $rot13Plain. ]; then
        echo "  - Failed" >&2
        return 1
    fi
    echo "  - Succeeded" >&2
    return 0
}

testCharToInt(){
    echo " " >&2
    echo "[Test CharToInt]" >&2
    echo "  test 'A' ..." >&2
    v=$( xbCharToInt A )
    if ! [ $v. == 65. ]; then
        echo "  Failed ('A' ==> $v, should be 65)" >&2
        return 1
    fi
    echo "  test 'a' ..." >&2
    v=$( xbCharToInt a )
    if ! [ $v. == 97. ]; then
        echo "  Failed ('a' ==> $v, should be 97)" >&2
        return 1
    fi
    echo "  test '}' ..." >&2
    v=$( xbCharToInt } )
    if ! [ $v. == 125. ]; then
        echo "  Failed ('}' ==> $v, should be 125)" >&2
        return 1
    fi
    echo "  - Succeeded" >&2
    return 0
}

testIntToChar(){
    echo " " >&2
    echo "[Test CharToInt]" >&2
    echo "  test 65 ..." >&2
    v=$( xbIntToChar 65 )
    if ! [ $v. == A. ]; then
        echo "  Failed (65 ==> $v, should be A)" >&2
        return 1
    fi
    echo "  test 97 ..." >&2
    v=$( xbIntToChar 97 )
    if ! [ $v. == a. ]; then
        echo "  Failed (97 ==> $v, should be a)" >&2
        return 1
    fi
    echo "  test 125 ..." >&2
    v=$( xbIntToChar 125 )
    if ! [ $v. == "}." ]; then
        echo "  Failed (125 ==> $v, should be })" >&2
        return 1
    fi
    echo "  test 300 ..." >&2
    v=$( xbIntToChar 300 )
    if ! [ $v. == . ]; then
        echo "  Failed (300 ==> $v, should be '')" >&2
        return 1
    fi
    echo "  - Succeeded" >&2
    return 0
}

testToLower() {
    echo " " >&2
    echo "[Test toLower]" >&2
    v=$( xbToLower +AZ- )
    if ! [ $v. == +az-. ]; then
        echo "  Failed (+AZ- ==> $v, should be +az-)" >&2
        return 1
    fi
    v=$( xbToLower +az- )
    if ! [ $v. == +az-. ]; then
        echo "  Failed (+az- ==> $v, should be +az-)" >&2
        return 1
    fi
    echo "  - Succeeded" >&2
    return 0
}

testToUpper() {
    echo " " >&2
    echo "[Test toUpper]" >&2
    v=$( xbToUpper +AZ- )
    if ! [ $v. == +AZ-. ]; then
        echo "  Failed (+AZ- ==> $v, should be +AZ-)" >&2
        return 1
    fi
    v=$( xbToUpper +az- )
    if ! [ $v. == +AZ-. ]; then
        echo "  Failed (+az- ==> $v, should be +AZ-)" >&2
        return 1
    fi
    echo "  - Succeeded" >&2
    return 0
}

$( testCharToInt )
$( testIntToChar )
$( testToLower )
$( testToUpper )
$( testRot13 )