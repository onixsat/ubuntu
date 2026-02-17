#!/system/bin/sh
check() {
local command=("$@")
 if "${command[@]}"; then
 echo "6"
    else
 echo "88"
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
carregar
esperar carregar "${WHITE}Carregando..." "Carregado!"
