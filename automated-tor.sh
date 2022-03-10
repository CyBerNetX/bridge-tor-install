#!/bin/bash 
# inspired of Parrot On-Debian Installer Script
author="CyBerNetX <cybernetx@cybermazout.net>"
version="0.1"
license="GPL v3"
#curl -s https://raw.githubusercontent.com/CyBerNetX/bridge-tor-install/main/automated-tor.sh |sudo bash -s --  -d
# 
# cat automated-tor.sh | bash -s -- -h
#
Tor="yes"
TorBridge=""
TorPort=""
BridgePort=""
ContactInfo=""
InstaneName=""
RunInstall=""
choice=""


function help(){
  echo "Welcome to Tor Bridge On-Debian Based Installer Script"
  echo "Simply deploy a tor Bridge"
  echo ""
  echo "Author : $author "
  echo "Version : $version "
  echo "License : $license "
  echo ""
  usage 
}

function usage(){
echo "Usage: $0 [-d|-h|-v|-m]"
echo -e "\t-d :Debug"
echo -e "\t-c :Contact Mail"
echo -e "\t-i :Instance Name"
echo -e "\t-h :Help"
echo -e "\t-v :Version"
echo -e "\t-m :Version with menu"

exit 1
}

function withdebug(){
if [[ ${Debug} -gt 0 ]]
then
  option_picked "Debug:  $1"
fi
}

function cls(){
if [[ ${Debug} -gt 0 ]] 
then
  option_picked "Clear unloaded"
else
  clear
fi
}

function show_menu(){
    NORMAL=`echo "\033[m"`
    MENU=`echo "\033[36m"` #Blue
    NUMBER=`echo "\033[33m"` #yellow
    FGRED=`echo "\033[41m"`
    RED_TEXT=`echo "\033[31m"`
    ENTER_LINE=`echo "\033[33m"`
    Red=`echo "\033[0;31m"`
    Green=`echo "\033[32m"`
    echo -e "${MENU}*********************************************${NORMAL}"
    echo -e "Welcome to Tor Bridge On-Debian Based Installer Script"
    echo -e "\t\trev 0.1 - 2021-12-16"
    echo -en "${MENU}** ${NORMAL}"; checked_option "$Tor" ;echo -e "${NUMBER} 1)${MENU} choice Tor Only Installation ${NORMAL}"; withdebug "tor = $Tor"
    echo -en "${MENU}** ${NORMAL}"; checked_option "$TorBridge" ;echo -e "${NUMBER} 2)${MENU} choice Tor Bridge Installation ${NORMAL}"; withdebug " TorBridge = $TorBridge"
    echo -en "${MENU}** ${NORMAL}"; checked_option "$TorPort" ;echo -e "${NUMBER} 3)${MENU} Set Port Tor ${NORMAL}"; withdebug " TorPort = $TorPort"
    echo -en "${MENU}** ${NORMAL}"; checked_option "$BridgePort" ;echo -e "${NUMBER} 4)${MENU} Set Bridge Port ${NORMAL}"; withdebug " BridgePort = $BridgePort"
    echo -en "${MENU}** ${NORMAL}"; checked_option "$ContactInfo" ;echo -e "${NUMBER} 5)${MENU} Set ContactInfo ${NORMAL}"; withdebug " ContactInfo = $ContactInfo"
    echo -en "${MENU}** ${NORMAL}"; checked_option "$InstaneName" ;echo -e "${NUMBER} 6)${MENU} Set Instance Name ${NORMAL}"; withdebug " InstaneName = $InstaneName"
    echo -en "${MENU}** ${NORMAL}"; checked_option "$RunInstall" ;echo -e "${NUMBER} 7)${MENU} Run the Install process. ${NORMAL}"; withdebug " RunInstall = $RunInstall"
    echo -e "${MENU}*********************************************${NORMAL}"
    echo -e "${NORMAL}Please enter a menu option and enter ${NUMBER}q${NORMAL} or ${NUMBER}x${NORMAL} ${RED_TEXT}to exit. ${NORMAL}"
    read opt
}

function checked_option(){
  if [ -z $1 ] || [ $1 == "no" ]
  then 
    echo -en "[${Red}✗${NORMAL}]"
  else
    echo -en "[${Green}✔${NORMAL}]"
  fi
}

show_choice(){
NORMAL=`echo "\033[m"`
MENU=`echo "\033[36m"` #Blue
NUMBER=`echo "\033[33m"` #yellow
FGRED=`echo "\033[41m"`
RED_TEXT=`echo "\033[31m"`
ENTER_LINE=`echo "\033[33m"`
Red=`echo "\033[0;31m"`
Green=`echo "\033[32m"`
choice=""

  echo -e "${MENU}*********************************************${NORMAL}"
  echo -e "${NUMBER} 1)${MENU} set to Yes ?"
  echo -e "${NUMBER} 2)${MENU} set to No ?"
  echo -e "${MENU}*********************************************${NORMAL}"
  echo -e "${ENTER_LINE}Please enter a menu option and enter ${RED_TEXT}l to leave this menu. ${NORMAL}"
  read choice
}

function setchoice(){

while [[ $choice != "l" ]]; do
cls 
show_choice
    case $choice in
      1) retval="yes"
      withdebug "you have selected YES"
      ;; 
      2) retval="no"
      withdebug "you have selected NO"
      ;;
     
      l)
      break 2
      ;;

      *)
      option_picked "Pick an option from the menu";
      ;;
    esac
  # fi
done
choice=""
eval $1=$retval
 
}

show_question(){
NORMAL=`echo "\033[m"`
MENU=`echo "\033[36m"` #Blue
NUMBER=`echo "\033[33m"` #yellow
FGRED=`echo "\033[41m"`
RED_TEXT=`echo "\033[31m"`
ENTER_LINE=`echo "\033[33m"`
Red=`echo "\033[0;31m"`
Green=`echo "\033[32m"`
unset answer

  echo -e "${MENU}*********************************************${NORMAL}"
  echo -e "${MENU} $2"
  echo -e "${MENU}*********************************************${NORMAL}"
  #echo -e "${ENTER_LINE}Please enter a menu option and enter ${RED_TEXT}l to leave this menu. ${NORMAL}"
  read answer
  withdebug "answer = $answer "
  if [[ $answer = "" ]]
  then
    answer=$3
    withdebug "answer = $answer "
  else
    answer=$answer
  fi
  eval $1=$answer
  withdebug "nom variable: $1 "
}

function check_port(){
  change="no"
  varname=$1
  withdebug "varname=$varname "
  eval port_selected=$2
  #randomize=$(shuf -i 2000-65000 -n 1)
  withdebug "Port selected : $port_selected"
  checkportsactif=$(netstat -n -a|grep -e tcp -e udp|awk '{print $4}'|cut -d: -f2|sort -nu)
  for portlisted in $checkportsactif;
  do
    withdebug "port = $port_selected : check port en cour : $portlisted "
    if [[ $portlisted == $port_selected ]]
    then
      withdebug "port = $port_selected : check port en cour : $portlisted "

      #randomize=$(shuf.exe -i 2000-65000 -n 1)
      change="yes"
      withdebug "change random port = $change"
    fi
  done
  withdebug "Port selected : $port_selected : change=$change"
  if [[ $change = "yes" ]]
  then
    eval $1=$change
    withdebug "$1 = $shange"
  fi
}


function option_picked() {
    COLOR='\033[01;31m' # bold red
    RESET='\033[00;00m' # normal white
    MESSAGE=${@:-"${RESET}Error: No message passed"}
    echo -e "${COLOR}${MESSAGE}${RESET}"
}

function install_required_packages() {
apt-get install -y unattended-upgrades apt-listchanges net-tools coreutils


unattendedupgrades="/etc/apt/apt.conf.d/50unattended-upgrades"
cat  << FILEUNOEF >$unattendedupgrades

Unattended-Upgrade::Origins-Pattern {
    "origin=Debian,codename=${distro_codename},label=Debian-Security";
    "origin=TorProject";
};
Unattended-Upgrade::Package-Blacklist {
};
FILEUNOEF

}

function Automatically-reboot(){

unattendedupgradesdeux="/etc/apt/apt.conf.d/50unattended-upgrades"

echo 'Unattended-Upgrade::Automatic-Reboot "true";' |tee -a $unattendedupgradesdeux


autoupgrades="/etc/apt/apt.conf.d/20auto-upgrades"
cat  << FILETROISOEF >$autoupgrades
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::AutocleanInterval "5";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::Verbose "1";
FILETROISOEF

}

function install-tor(){
  apt update
  apt install -y tor
}

function install-bridge(){
  apt install -y obfs4proxy 
}


function set-tor-config(){

torconfigfile="/etc/tor/torrc"

cat  << FILETOROEF >$torconfigfile
BridgeRelay 1

# Remplacez "TODO1" par un port Tor de votre choix.
# Ce port doit être accessible de l'extérieur.
# Evitez le port 9001 car il est communément associé à Tor et les censeurs peuvent scanner l'Internet pour ce port.
ORPort $TorPort

ServerTransportPlugin obfs4 exec /usr/bin/obfs4proxy

# Remplacez "TODO2" par un port obfs4 de votre choix.
# Ce port doit être accessible de l'extérieur et doit être différent de celui spécifié pour ORPort.
# Evitez le port 9001 car il est communément associé à Tor et les censeurs peuvent scanner l'Internet pour ce port.
ServerTransportListenAddr obfs4 0.0.0.0:$BridgePort

# Port de communication local entre Tor et obfs4.  Toujours régler cela sur "auto".
# "Ext" signifie "étendu", pas "externe".  N'essayez pas de définir un numéro de port spécifique, ni d'écouter sur 0.0.0.0.
ExtORPort auto

# Remplacez "<address@email.com>" par votre adresse électronique afin que nous puissions vous contacter en cas de problème avec votre pont.
# Ceci est facultatif mais encouragé.
ContactInfo <$ContactInfo>

# Choisissez un surnom que vous aimez pour votre pont.  Ceci est facultatif.
Nickname $InstaneName
FILETOROEF
}

run_install (){
echo "Run Install"

if [ $Tor == "no" ]
then
  exit 0
fi

if [ -z $Tor ] ||  [ $Tor == "yes" ]
then 
  TorPort=$(shuf -i 2000-65000 -n 1)
  check_port TorPort $TorPort
  withdebug " TorPort :$TorPort "
  install_required_packages
  Automatically-reboot
  install-tor
  set-tor-config
fi

if [ $TorPort == "no" ]
then
  break 0
elif  [ -z $TorPort ] || [ $TorPort -gt "1999" ]
then
  check_port TorPort $TorPort
  withdebug " TorPort :$TorPort "
fi

if [ $TorBridge == "no" ]
then
  break 0
elif  [ -z $TorBridge ] ||  [ $TorBridge == "yes" ] && [ -z $BridgePort ] || [ $BridgePort -gt "1999" ]
then	
  BridgePort=$(shuf -i 2000-65000 -n 1)
  if  [ $BridgePort -gt "1999" ]
  then
    check_port BridgePort $BridgePort
    withdebug " BridgePort :$BridgePort "
    install-bridge
  else
    install-bridge
    break 0
  fi
fi
if [ ! -z $ContactInfo ]
then
  option_picked "Set ContactInfo";
  #show_question ContactInfo "Set ContactInfo, please enter your mail :"	
  ContactInfo=$ContactInfo
  withdebug " ContactInfo: $ContactInfo"
fi
if [ -z $InstaneName ]
then
  option_picked "Set Instance Name";
  InstaneName=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 15 ; echo '')
  #show_question InstaneName "Set Instance Name, choose a nome for this instance :"
  withdebug " Instance Name: $InstaneName "
else
  InstaneName=$InstaneName
  withdebug " Instance Name: $InstaneName "
fi
set-tor-config

withdebug " FIN CONFIG "
withdebug " Restart tor default service"
service tor@default restart
	

}



function init_menu() {


# while [ opt != '' ]
#   do
#     if [[ $opt = "" ]]; then 
#             exit;
#     else
while [[ $opt != "q"  ||  $opt != "x" ]]; do
cls 
show_menu
        case $opt in
        1) cls ;
          #retval=""
        	option_picked "choice Tor Only Installation ";
		      setchoice Tor;
          withdebug "Tor = $Tor"          
        ;;

        2) cls ;
          #retval=""
		      option_picked "choice Tor Bridge Installation";
		      setchoice TorBridge;
          withdebug "TorBridge = $TorBridge"
          ;;

        3) cls ;
          option_picked "Set Port Tor";
          #random_port torrandom
          torrandom=$(shuf -i 2000-65000 -n 1)
          show_question TorPort "Set tor port ? or keep random $torrandom !" $torrandom ;
          check_port TorPort $TorPort
          while [[ $TorPort = "yes" ]]; do
          if [[ $TorPort = "yes" ]]
          then
            torrandom=$(shuf -i 2000-65000 -n 1)
            show_question TorPort "Set tor port ? or keep random $torrandom !" $torrandom ;
            check_port TorPort $TorPort 
          fi
          option_picked "Operation Done!";
          done
        ;;

        4) cls ;
          option_picked "Set Bridge Port";
          bridgerandom=$(shuf -i 2000-65000 -n 1)
          show_question BridgePort "Set Bridge Port ? or keep random $bridgerandom !" $bridgerandom ;
          check_port BridgePort $BridgePort
          option_picked "Operation Done!";
          while [[ $BridgePort = "yes" ]]; do
          if [[ $BridgePort = "yes" ]]
          then
            torrandom=$(shuf -i 2000-65000 -n 1)
            show_question BridgePort "Set Bridge Port ? or keep random $bridgerandom !" $bridgerandom ;
            check_port BridgePort $BridgePort
          fi
          option_picked "Operation Done!";
          done
        ;;
        5) cls ;
          option_picked "Set ContactInfo";
          show_question ContactInfo "Set ContactInfo, please enter your mail :"

          option_picked "Operation Done!";
  
        ;;
        6) cls ;
          option_picked "Set Instance Name";
          show_question InstaneName "Set Instance Name, choose a nome for this instance :"
          option_picked "Operation Done!";
        ;;

        7) run_install 
        RunInstall="yes"
        ;;
        x)
        return
        ;;

        q)
        return
        ;;

        *) cls ;
        option_picked "Pick an option from the menu";
        show_menu;
        #retval=""
        ;;
      esac
    # fi
  done
}


## Main ##

if [ `whoami` == "root" ]; then
#
while getopts "c:di:hvm" arg
do
  case ${arg} in
    # a)  app=${OPTARG} ;;
    c)  ContactInfo=${OPTARG} ;;
    # d)  domain=${OPTARG} ;;
    d)  Debug=1 ;;
    i)  InstaneName=${OPTARG} ;;
    # r)  Doit=1 ;;
    # s)  subapp=${OPTARG} ;;
    m) init_menu ; m=1 ;;
    h)  help ;h=1;exit 0 ;;
    v) echo "Version : $version" ;v=1;exit 0;;
    *)  usage ;h=1;;
  esac
done
#shift $((OPTIND-1))
if [[ -z "${m}" ]] || [ -z "${h}" ] || [ -z "${v}" ]; then
  run_install
  exit 1
fi
# if [ `whoami` == "root" ]; then
# 	init_menu;
# run_install
else
	echo "R U Drunk? This script needs to be run as root!"
  #init_menu;
  #run_install;
fi
withdebug "Debug Mode"
