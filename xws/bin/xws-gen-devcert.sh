#!/usr/bin/bash

echo "Generating xworkspace developer certificate ..."

PSWD=
PSWD2=

# Get valid password
while [ -z $PSWD ]; do
    while [ -z $PSWD ]; do
        read -s -p "Enter New Password: " PSWD
        echo " "
    done

    while [ -z $PSWD2 ]; do
        read -s -p "Enter Password Again: " PSWD2
        echo " "
    done

    if [ "$PSWD" != "$PSWD2" ]; then
        echo "ERROR: Password mismatch."
        PSWD=
        PSWD2=
    fi
done

# create folder
if [ ! -d "$XWSROOT/xws/certs" ]; then
    mkdir "$XWSROOT/xws/certs" || exit 1
fi

#generate private key
echo "Generating private key ..."
openssl genrsa -aes128 -passout pass:$PSWD -out $XWSROOT/xws/certs/devcert_key.pem 2048 || exit 1
echo "    - $XWSROOT/xws/certs/devcert_key.pem"

# verify
echo "Verify private key ..."
openssl rsa -check -in $XWSROOT/xws/certs/devcert_key.pem -passin pass:$PSWD || exit 1

# create 10 years selfsigned cert
USERNAME=$(whoami)
echo "Generate selfsigned certificate for user $USERNAME ..."
SUBJECT="/C=US/ST=California/L=Sunnyvale/O=xworkspace/OU=$HOSTNAME/CN=$USERNAME"
echo SUBJECT: $SUBJECT
openssl req -new -sha256 -key $XWSROOT/xws/certs/devcert_key.pem -passin pass:$PSWD -out $XWSROOT/xws/certs/devcert.csr -subj $SUBJECT || exit 1
echo "    - $XWSROOT/xws/certs/devcert.csr"

openssl x509 -req -in $XWSROOT/xws/certs/devcert.csr -signkey $XWSROOT/xws/certs/devcert_key.pem -passin pass:$PSWD -out $XWSROOT/xws/certs/devcert.crt -days 3650 -sha256 || exit 1
echo "    - $XWSROOT/xws/certs/devcert.crt"

# create p12
echo "Generating PFX certificate ..."
openssl pkcs12 -export -out $XWSROOT/xws/certs/devcert.pfx -passout pass:$PSWD -inkey $XWSROOT/xws/certs/devcert_key.pem -in $XWSROOT/xws/certs/devcert.crt -passin pass:$PSWD || exit 1
echo "    - $XWSROOT/xws/certs/devcert.pfx"

echo "SUCCEEDED: xworkspace developer certificates are ready, please update $XWSROOT/xws/makefiles/xmake.local.settings.mak accordingly"