#!/bin/bash

function check_previous {
        RESULT=$?
        if [ $RESULT -eq 0 ]; then
        echo "$1: success"
        else
        echo "$1: failed"
        fi
}

echo "wwe"
check_previous "echo"

ls - l
check_previous "ls"
