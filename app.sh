. ./functions.sh
#sudo rm /var/lib/dpkg/lock
#sudo rm /var/lib/apt/lists/lock
#sudo rm /var/lib/dpkg/lock-frontend
#sudo rm /var/cache/apt/archives/lock
#sudo dpkg --configure -a

step() {
    echo -n "$@"

    STEP_OK=0
    [[ -w /tmp ]] && echo $STEP_OK > /tmp/step.$$
}
try() {

    start_time2=$(date +%s%3N)
    start_loading "Carregando..."
    
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

    stop_loading $?
    end_time2=$(date +%s%3N)
    duration_ms2=$((end_time2 - start_time2))
    echo "Execution: $duration_ms2"
    
    return $EXIT_CODE
}
next() {
    [[ -f /tmp/step.$$ ]] && { STEP_OK=$(< /tmp/step.$$); rm -f /tmp/step.$$; }
    [[ $STEP_OK -eq 0 ]]  && echo_success || echo_failure
    echo
    
    return $STEP_OK
}
function instalar(){
	echo "ok"
    step "Carregar1:"
    try sudo apt update -y
    next
    
    read -n 1 -r -s -p "Press any key to continue function instalar 1..."

    
    step "Carregar2:"
    try sudo apt install dos2unix -y
    next
    
    read -n 1 -r -s -p "Press any key to continue function instalar 2..."

    #read -n 1 -r -s -p "Press any key to continue..."
    
    #apt install nginx nginx-full -y >/dev/null 2>&1 &
    #sudo apt install ufw -y >/dev/null 2>&1 &
    #sudo apt install iptables-persistent -y >/dev/null 2>&1 &
    #sudo apt install certbot python3-certbot-nginx -y >/dev/null 2>&1 &
    #sudo apt install net-tools -y >/dev/null 2>&1 &
    #sudo apt install apache2 -y >/dev/null 2>&1 &
    #sudo apt update >/dev/null 2>&1 &

    
   # https://docs.vultr.com/how-to-upgrade-php-8-2-to-8-3-on-ubuntu
    
    #sudo apt install apt-transport-https ca-certificates software-properties-common -y
    #sudo add-apt-repository -y ppa:ondrej/php
    #sudo apt update
    #sudo apt install -y php8.3
    #sudo apt install -y php8.3-{common,cgi,gd,mysql,pgsql,curl,bz2,mbstring,intl}
    #sudo apt install -y php8.3-fpm
    #sudo systemctl enable php8.3-fpm
    #sudo systemctl start php8.3-fpm
    #sudo a2enconf php8.3-fpm
    #sudo apachectl configtest
    #sudo systemctl reload apache2
    
    
    
    
    
    
#sudo apt update && sudo apt upgrade 
#sudo apt install software-properties-common ca-certificates lsb-release apt-transport-https 
#LC_ALL=C.UTF-8 sudo add-apt-repository ppa:ondrej/php 
#sudo apt update 
 #   sudo apt install php8.2
    
    
  #  sudo update-alternatives --set php /usr/bin/php8.2
   # sudo systemctl start php8.2-fpm.service >/dev/null 2>&1 &
    #sudo systemctl enable php8.4-fpm.service >/dev/null 2>&1 &
    #sudo systemctl status php8.4-fpm.service >/dev/null 2>&1 &
    #sudo apt install software-properties-common ca-certificates lsb-release apt-transport-https -y >/dev/null 2>&1 &
    #LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php


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
  local __resultvar=$3
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
  printf " \b\n"
  # Wait the command to be finished, this is needed to capture its exit status
  wait $!
  exitCode=$?
  if [ "$exitCode" -eq "0" ]; then
    printf "${CHECK_SYMBOL} ${2}                                                                \b\n"
  else
    printf "${X_SYMBOL} ${2}                                                                \b\n"
  fi

  # Restore the cursor
  tput cnorm
  eval $__resultvar=$exitCode
}
function iniciar(){
    echo Starting sleep
    (sleep 1; exit 3) &
    # get the pid of the last process run
    pid=$!

    echo Processing...
    sleep 1
    echo "sleep must be done by now"
    sudo apt update
    # wait for the process to finish
    echo Waiting for sleep to finish
    wait $pid
    echo "Sleep finished with exit code $?"
    echo done
}

esperar "sudo apt update -y" "${WHITE}Instalando..." " ${WHITE} Instalado!"
read -n 1 -r -s -p "Press any key to continue..."
esperar instalar "${WHITE}Instalando..." " ${WHITE} Instalado!"

read -n 1 -r -s -p "Press any key to continue..."

step "Update:"
    try sudo apt update -y
next

read -n 1 -r -s -p "Press any key to continue..."

step "Update:"
esperar "try sudo apt update -y" "Esperar" " Atualizado!"
next
