#!/bin/bash

set -x
COMMAND=($@)

TIME_DIR=$( dirname "${BASH_SOURCE[0]}")
[ -z "$LOG_FILE" ] && LOG_FILE=$TIME_DIR/log.txt

SECONDS=0
echo "exec : ${COMMAND[0]}" >> $LOG_FILE
"$@"

echo "time: ${SECONDS}s. (${COMMAND[0]})" >> $LOG_FILE
