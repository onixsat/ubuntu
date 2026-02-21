#!/bin/bash
. ./globais.sh
step() {
    echo -n "$@"
    STEP_OK=0
    [[ -w /tmp ]] && echo $STEP_OK > /tmp/step.$$
}
try() { # Check for `-b' argument to run command in the background.
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
    echo -e ""
    return $STEP_OK
}

function add(){
    start_time2=$(date +%s%3N)
    
    arg1=$1
    arg2=$2
    step "${arg1}"
        if [[ $3 != '' ]]; then
            try ${arg2} >/dev/null 2>&1 &
        else         
           try ${arg2}
        fi
    next
    
    end_time2=$(date +%s%3N)
    duration_ms2=$((end_time2 - start_time2))
    echo -e "Execution: $duration_ms2"
}
add "Atualizar" "sudo apt update" "1"
#read -n 1 -s -p "Press any key to continue 1"

#add "Atualizar" "sudo apt update"
#read -n 1 -s -p "Press any key to continue 2"

add "Instalar dnf" "sudo apt install dnf" "1"
#read -n 1 -s -p "Press any key to continue 3"

add "Instalar dos2unix" "sudo apt install dos2unix -y" "1"
#read -n 1 -s -p "Press any key to continue 4 "

add "Instalar nginx" "sudo apt install nginx nginx-full -y" "1"

add "Instalar ufw" "sudo apt install ufw -y" "1"
add "Instalar iptables" "sudo apt install iptables-persistent -y" "1"

step "Ficheiro data.txt"
    try echo 'This is a test' > data.txt
    #try mv file.txt data.txt
    try echo 'yet another line' >> data.txt
next
