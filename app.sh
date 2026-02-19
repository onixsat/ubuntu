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
check() {
local command=("$@")
 if "${command[@]}"; then
 echo "6"
    else
 echo "88"
fi
}


function instalar(){
	
    sudo apt update >/dev/null 2>&1 &
    sudo apt install dos2unix -y
    echo "dos2ubix"
    sleep 3
    clear
    sudo apt install nginx nginx-full -y >/dev/null 2>&1 &
    echo "dos2ubix"
    sleep 3
    clear
    sudo apt install ufw -y >/dev/null 2>&1 &
    echo "dos2ubix"
    sleep 3
    clear
    sudo apt install iptables-persistent -y >/dev/null 2>&1 &
    echo "dos2ubix"
    sleep 3
    clear
    sudo apt install certbot python3-certbot-nginx -y >/dev/null 2>&1 &
    echo "dos2ubix"
    sleep 3
    clear
    sudo apt install net-tools -y >/dev/null 2>&1 &
    echo "dos2ubix"
    sleep 3
    clear
    sudo apt install apache2 -y >/dev/null 2>&1 &
    echo "dos2ubix"
    sleep 3
    clear
    sudo apt update >/dev/null 2>&1 &
    echo "dos2ubix"
    sleep 3
    clear
    
   # https://docs.vultr.com/how-to-upgrade-php-8-2-to-8-3-on-ubuntu
    
    sudo apt install apt-transport-https ca-certificates software-properties-common -y
    sudo add-apt-repository -y ppa:ondrej/php
    sudo apt update
    sudo apt install -y php8.3
    sudo apt install -y php8.3-{common,cgi,gd,mysql,pgsql,curl,bz2,mbstring,intl}
    sudo apt install -y php8.3-fpm
    sudo systemctl enable php8.3-fpm
    sudo systemctl start php8.3-fpm
    sudo a2enconf php8.3-fpm
    sudo apachectl configtest
    sudo systemctl reload apache2
    
    
    
    
    
    
sudo apt update && sudo apt upgrade 
sudo apt install software-properties-common ca-certificates lsb-release apt-transport-https 
LC_ALL=C.UTF-8 sudo add-apt-repository ppa:ondrej/php 
sudo apt update 
    sudo apt install php8.2
    
    
    echo "dos2ubix"
    sleep 3
    clear
    sudo update-alternatives --set php /usr/bin/php8.2
    sudo systemctl start php8.2-fpm.service >/dev/null 2>&1 &
    sudo systemctl enable php8.4-fpm.service >/dev/null 2>&1 &
    sudo systemctl status php8.4-fpm.service >/dev/null 2>&1 &
    echo "dos2ubix"
    sleep 3
    clear
    sudo apt install software-properties-common ca-certificates lsb-release apt-transport-https -y >/dev/null 2>&1 &
    echo "dos2ubix"
    sleep 3
    clear
    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

    if [ $? -eq 0 ]; then
	echo "Atualizado"
       return 0
    else
        echo "failed"
        sleep 3
		exit 1
    fi
}
function draw_spinner(){
    # shellcheck disable=SC1003
    local -a marks=( '/' '-' '\ ' '|' )
    local i=0
    delay=${SPINNER_DELAY:-0.25}
    message=${1:-}
    while :; do
        printf '%s\r' "${marks[i++ % ${#marks[@]}]} ${message}"
        sleep "${delay}"
    done
}
function start_loading(){
    message=${1:-}                                # Set optional message
    draw_spinner "${message}" &                   # Start the Spinner:
    SPIN_PID=$!                                   # Make a note of its Process ID (PID):
    declare -g SPIN_PID
    # shellcheck disable=SC2312
    trap stop_loading $(seq 0 15)
}
function stop_loading(){
    if [[ "${SPIN_PID}" -gt 0 ]]; then
        kill -9 "${SPIN_PID}" > /dev/null 2>&1;
    fi
    SPIN_PID=0
    printf '\033[2K'
}
function esperar(){
		
  # Executar e esperar
  # Run the command passed as 1st argument and shows the spinner until this is done
  # @param String $1 the command to run
  # @param String $2 the title to show next the spinner
  # @param var $3 the variable containing the return code
  CINZA="$(tput setaf 8)"
  CHECK_MARK="\033[0;32m\xE2\x9C\x94\033[0m"
  CHECK_SYMBOL='\u2713'
  X_SYMBOL='\u2A2F'
  #local __resultvar=$3
  local done=${3:-'Atualizado'}
  local msg=$2

  eval $1 >/tmp/execute-and-wait.log 2>&1 &
  pid=$!
  delay=0.05

  frames=('\u280B' '\u2819' '\u2839' '\u2838' '\u283C' '\u2834' '\u2826' '\u2827' '\u2807' '\u280F')

  echo "$pid" >"/tmp/.spinner.pid"

  tput civis # Hide the cursor, it looks ugly :D
  index=0
  framesCount=${#frames[@]}
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    printf "${YELLOW}${frames[$index]}${NC} ${GREEN}${msg}${NC}"

    let index=index+1
    if [ "$index" -ge "$framesCount" ]; then
      index=0
    fi

    printf "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
    sleep $delay
  done

  echo -e "\b\\r${CHECK_MARK}${CINZA} ${done}!   "
echo -e ""
  #printf " \b\n"
  # Wait the command to be finished, this is needed to capture its exit status
  #wait $!
  #exitCode=$?
  #if [ "$exitCode" -eq "0" ]; then
  #  printf "${CHECK_SYMBOL} ${2}                                                                \b\n"
  #else
  #  printf "${X_SYMBOL} ${2}                                                                \b\n"
  #fi

  # Restore the cursor
  #tput cnorm
  #eval $__resultvar=$exitCode
}
function carregar(){
  start_time2=$(date +%s%3N)
  start_loading "Carregando..."
  check sudo apt update
  esperar carregar "${WHITE}Carregandoxxxx..." "Cxxxxarregado!"
check  php -v
  stop_loading $?
  end_time2=$(date +%s%3N)
  duration_ms2=$((end_time2 - start_time2))
  echo "Execution: $duration_ms2"
}


step "Carregar1:"
    try carregar
    esperar "sleep 5" "${WHITE}Atualizando..." " ${WHITE} Atualizado!"
next

step "Carregar2:"
    try instalar
    esperar carregar "${WHITE}Atualizando..." " ${WHITE} Atualizado!"
next


pause


step "Ligar localhost:"
    try instalar
    esperar "sleep 5" "${WHITE}Atualizando..." " ${WHITE} Atualizado!"
next

step "Ligar localhost:"
    try sudo iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT
    try sudo iptables -I INPUT 1 -p tcp --dport 8080 -j ACCEPT
    #try sudo iptables -A PREROUTING -t nat -p tcp --dport 8080 -j REDIRECT --to-port 80
    #try sudo iptables -A PREROUTING -t nat -p tcp --dport 80 -j REDIRECT --to-port 8080
    esperar "sleep 5" "${WHITE}Atualizando..." " ${WHITE} Atualizado!"
next


step "Ligar localhost:"
    try sudo ufw enable
    try sudo ufw status
    try sudo systemctl reload nginx
    
    try sudo ufw allow 'Nginx Full'
    try sudo ufw allow 'Nginx HTTP'
    try sudo ufw allow 'Nginx HTTPS'
    try sudo ufw allow OpenSSH
    try sudo ufw allow ssh
    #sudo ufw status numbered
    #sudo nginx -s reload
    try sudo systemctl restart nginx
    esperar "sleep 5" "${WHITE}Atualizando..." " ${WHITE} Atualizado!"
next

pause
