. ./functions.sh




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
function check() {
   # start_time2=$(date +%s%3N)
    start_loading "Carregando..."
  
    local command=("$@")
    if "${command[@]}"; then
        echo_success
    else
        echo_failure
    fi
     
    stop_loading $?
    #    end_time2=$(date +%s%3N)
    #    duration_ms2=$((end_time2 - start_time2))
    #    echo "Execution: $duration_ms2"
        
        #return 0

}



function esperar(){
    start_time2=$(date +%s%3N)
CINZA="$(tput setaf 8)"
  CHECK_MARK="\033[0;32m\xE2\x9C\x94\033[0m"
  CHECK_SYMBOL='\u2713'
  X_SYMBOL='\u2A2F'
 # local __resultvar=$3
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

#echo -e ""
#  printf " \b\n"
  # Wait the command to be finished, this is needed to capture its exit status
  wait $!
  exitCode=$?
  if [ "$exitCode" -eq "0" ]; then
    echo_success
    #printf "${CHECK_SYMBOL} ${2}                                                                \b\n"
  else
    echo_failure
   # printf "${X_SYMBOL} ${2}                                                                \b\n"
  fi

    end_time2=$(date +%s%3N)
    duration_ms2=$((end_time2 - start_time2))
    echo -e "Execution: $duration_ms2"
  # Restore the cursor
#  tput cnorm
#  eval $__resultvar=$exitCode
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
function setup() {
arg1=$1
arg2=$2
arg3=$3
esperar "$arg1" "$arg2" " ${WHITE} $arg3"
if [ $? -eq 0 ]; then
	echo "Atualizado"
       #return 0
    else
        echo "failed"
        sleep 3
		#exit 1
    fi	
	
	}
function run(){
echo "ok" &
 setup "sudo mv oi oi" "1" "1x" &
 setup "sudo apt update -y" "2" "2x" &
 wait -n
echo "First job completed."
wait
echo "All jobs completed." 
}
function instalar(){
	
    check sudo apt update -y
	read -n 1 -r -s -p "Press X..."
	sleep 5
	check sudo cp oi.txt oi2.txt
	sleep 5
	return 0
}

 esperar instalar "Instalando..." " ${WHITE} Instalado!"

read -n 1 -r -s -p "Press 0..."
clear

setup "sudo mv oi oi" "kkkk" "xxxxxxx"

#run

#iniciar
read -n 1 -r -s -p "Press any key to continue1..."
clear
check sudo apt update -y
check sudo mv oi oi
#esperar iniciar "Instalando..." " ${WHITE} Instalado!"
#read -n 1 -r -s -p "Press any key to continue2..."
#clear
