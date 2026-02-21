# Source - https://stackoverflow.com/a/5196220
# Posted by John Kugelman, modified by community. See post 'Timeline' for change history
# Retrieved 2026-02-21, License - CC BY-SA 2.5
# Source - https://stackoverflow.com/a/5196220
# Posted by John Kugelman, modified by community. See post 'Timeline' for change history
# Retrieved 2026-02-21, License - CC BY-SA 2.5

#!/bin/bash
# Source - https://stackoverflow.com/a/54190627
# Posted by Mark Thomson
# Retrieved 2026-02-21, License - CC BY-SA 4.0


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

echo_passed() {
    [ "$BOOTUP" = "color" ] && $MOVE_TO_COL
    echo -n "["
    [ "$BOOTUP" = "color" ] && $SETCOLOR_WARNING
    echo -n $"PASSED"
    [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
    echo -n "]"
    echo -ne "\r"
    return 1
}

echo_warning() {
    [ "$BOOTUP" = "color" ] && $MOVE_TO_COL
    echo -n "["
    [ "$BOOTUP" = "color" ] && $SETCOLOR_WARNING
    echo -n $"WARNING"
    [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
    echo -n "]"
    echo -ne "\r"
    return 1
} 


. /etc/init.d/functions

# Use step(), try(), and next() to perform a series of commands and print
# [  OK  ] or [FAILED] at the end. The step as a whole fails if any individual
# command fails.
#
# Example:
#     step "Remounting / and /boot as read-write:"
#     try mount -o remount,rw /
#     try mount -o remount,rw /boot
#     next
step() {
    echo -n "$@"

    STEP_OK=0
    [[ -w /tmp ]] && echo $STEP_OK > /tmp/step.$$
}

try() {
    # Check for `-b' argument to run command in the background.
    local BG=

    [[ $1 == -b ]] && { BG=1; shift; }
    [[ $1 == -- ]] && {       shift; }

    # Run the command.
    if [[ -z $BG ]]; then
        "$@"
    else
        "$@" &
    fi

    # Check if command failed and update $STEP_OK if so.
    local EXIT_CODE=$?

    if [[ $EXIT_CODE -ne 0 ]]; then
        STEP_OK=$EXIT_CODE
        [[ -w /tmp ]] && echo $STEP_OK > /tmp/step.$$

        if [[ -n $LOG_STEPS ]]; then
            local FILE=$(readlink -m "${BASH_SOURCE[1]}")
            local LINE=${BASH_LINENO[0]}

            echo "$FILE: line $LINE: Command \`$*' failed with exit code $EXIT_CODE." >> "$LOG_STEPS"
        fi
    fi

    return $EXIT_CODE
}

next() {
    [[ -f /tmp/step.$$ ]] && { STEP_OK=$(< /tmp/step.$$); rm -f /tmp/step.$$; }
    [[ $STEP_OK -eq 0 ]]  && echo_success || echo_failure
    echo

    return $STEP_OK
}



step "Installing XFS filesystem tools:"
try rpm -i xfsprogs-*.rpm
next

step "Configuring udev:"
try cp *.rules /etc/udev/rules.d
try udevtrigger
next

step "Adding rc.postsysinit hook:"
try cp rc.postsysinit /etc/rc.d/
try ln -s rc.d/rc.postsysinit /etc/rc.postsysinit
try echo $'\nexec /etc/rc.postsysinit' >> /etc/rc.sysinit
next

# Source - https://stackoverflow.com/a/5195736
# Posted by Erik, modified by community. See post 'Timeline' for change history
# Retrieved 2026-02-21, License - CC BY-SA 2.5

run() {
  $*
  if [ $? -ne 0 ]
  then
    echo "$* failed with exit code $?"
    return 1
  else
    return 0
  fi
}

run ls && run apt update && run command3




# Source - https://stackoverflow.com/a/5195741
# Posted by krtek, modified by community. See post 'Timeline' for change history
# Retrieved 2026-02-21, License - CC BY-SA 4.0

function mytest {
    "$@"
    local status=$?
    if (( status != 0 )); then
        echo "error with $1" >&2
    fi
    return $status
}

mytest "ls"
mytest "cp oi.txt ojj.txt"
