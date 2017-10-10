#!/usr/bin/env bash

set -eu

if [ $# -ne 2 ]; then
    echo "Usage: $0 <extension> <URL>"
    exit 1
fi

EXTENSION="$1"
TARGET="$2"
SAVEPATH="$PWD"

HTML=$(curl $TARGET 2>/dev/null)
URLS=$(echo $HTML | grep -Eo "[^\"]+${EXTENSION}")
for URL in $URLS; do
    if [[ "$URL" =~ ^(http|https).+ ]]; then
        wget -nc -P ${SAVEPATH} ${URL}
    else
        wget -nc -P ${SAVEPATH} ${TARGET}/${URL}
    fi
done
