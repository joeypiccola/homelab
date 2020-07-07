#!/bin/bash
# via: https://gist.github.com/daks/a7834169fc1a483b85bc

CRYPTSETUP=/sbin/cryptsetup

shopt -s nullglob
for dev in /dev/mapper/*_autocrypt
do
    match=`mount|grep $dev`
    if [ -z "$match" ]; then
        # fs is not mounted, LUKS fs can be closed
        dm_file=${dev##*/}
        $CRYPTSETUP luksClose $dm_file
    fi
done