#!/bin/bash

/usr/local/bin/mbsync -a -V -c /config/isyncrc

exec cron -f
