#!/usr/bin/env bash

set -eu

if [ $# -ne 2 ]; then
    echo "Usage: $0 <extension> <URL>"
    exit 1
fi

NPROC=8
EXTENSION="$1"
TARGET_SITE="$2"
SAVEPATH="$PWD"

HTML=$(curl $TARGET_SITE 2>/dev/null)
URLS=$(echo $HTML | grep -Eo "[^\"\' ]+${EXTENSION}")
TARGET_FILES=""
for URL in $URLS; do
    if [[ "$URL" =~ ^(http|https).+ ]]; then
        TARGET_FILES="${TARGET_FILES} ${URL}"
    else
        TARGET_FILES="${TARGET_FILES} ${TARGET_SITE}/${URL}"
    fi
done
echo ${TARGET_FILES} | xargs -n 1 -P $NPROC wget -nc -P $SAVEPATH
