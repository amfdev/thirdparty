#!/bin/bash

set -x

TIME_DIR=$( dirname "${BASH_SOURCE[0]}")
[ -z "$LOG_FILE" ] && LOG_FILE=$TIME_DIR/log.txt

SECONDS=0
echo ---- starting : "$@" >> $LOG_FILE
"$@"

echo ---- end: "$@" >> $LOG_FILE
echo ---- time: $SECONDS seconds >> $LOG_FILE
