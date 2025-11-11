#!/bin/bash

: "${USERMAP_UID:=0}"
: "${USERMAP_GID:=0}"

if [ ${USERMAP_UID} -ne 1000 ] && [ ${USERMAP_UID} -ne 0 ]; then
    usermod --non-unique --uid "${USERMAP_UID}" sync
fi

if [ ${USERMAP_GID} -ne 1000 ] && [ ${USERMAP_GID} -ne 0 ]; then
    groupmod --non-unique --gid "${USERMAP_GID}" sync
fi

if [ ${USERMAP_UID} -ne 0 ]; then 
    gosu sync /usr/local/bin/mbsync -a -V -c /config/isyncrc
else
    /usr/local/bin/mbsync -a -V -c /config/isyncrc
fi


if [ ! -f "/etc/cron.d/mbsync" ]; then
    if [ "${USERMAP_UID}" -ne 0 ]; then
        echo "30 1 * * * sync /usr/local/bin/mbsync -a -V -c /config/isyncrc > /proc/1/fd/1 2> /proc/1/fd/2" > /etc/cron.d/mbsync
    else
        echo "30 1 * * * root /usr/local/bin/mbsync -a -V -c /config/isyncrc > /proc/1/fd/1 2> /proc/1/fd/2" > /etc/cron.d/mbsync
    fi
fi

exec cron -f
