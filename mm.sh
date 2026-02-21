#!/bin/bash
#./etc/init.d/functions
BOOTUP=color
RES_COL=60
MOVE_TO_COL="echo -en \\033[${RES_COL}G"
SETCOLOR_SUCCESS="echo -en \\033[1;32m"
SETCOLOR_FAILURE="echo -en \\033[1;31m"
SETCOLOR_WARNING="echo -en \\033[1;33m"
SETCOLOR_NORMAL="echo -en \\033[0;39m"


echo_success() {
    [ "$BOOTUP" = "color" ] && $MOVE_TO_COL
    echo -n "["
    [ "$BOOTUP" = "color" ] && $SETCOLOR_SUCCESS
    echo -n $"  OK  "
    [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
    echo -n "]"
    echo -ne "\r"
    return 0
}
echo_failure() {
    [ "$BOOTUP" = "color" ] && $MOVE_TO_COL
    echo -n "["
    [ "$BOOTUP" = "color" ] && $SETCOLOR_FAILURE
    echo -n $"FAILED"
    [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
    echo -n "]"
    echo -ne "\r"
    return 1
}
function check_previous {
        start_time2=$(date +%s%3N)
        RESULT=$?
        if [ $RESULT -eq 0 ]; then

        end_time2=$(date +%s%3N)
        duration_ms2=$((end_time2 - start_time2))
        
        echo -e "Execution $duration_ms2: $1"
        echo_success
        else
        echo "$1: failed"
        echo_failure
        fi
}


check_previous "sudo apt update"
check_previous "sudo apt install curl"
check_previous "ls"
check_previous "ls - l"
