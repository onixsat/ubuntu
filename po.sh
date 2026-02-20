#!/bin/bash
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
        
        echo "$1 Execution: $duration_ms2"
        echo_success
        else
        echo "$1: failed"
        echo_failure
        fi

}

echo "wwe"
check_previous "echo"

check_previous "sudo apt update"
ls - l
check_previous "ls"
