#!/bin/sh

#version 1.2
#2017/02/27
#
REMOVEDEPENDENCIES="not";
REDOIMAGES="not";
ONECHECK="false";
TWOCHECKS="false";
VERBOSE="false";
ARG1="false";
ARG2="false";
ARG1="false"
NOT="not";
TRUE="true";
NONE='\033[00m';
BLINK='\033[5m';
BLACK='\033[01;30m';
RED='\033[01;31m';
GREEN='\033[01;32m';
YELLOW='\033[01;33m';
BLUE='\033[01;34m';
PURPLE='\033[01;35m';
CYAN='\033[01;36m';
WHITE='\033[01;37m';
BOLD='\033[1m';
UNDERLINE='\033[4m';

if [ -z $1 ]
then
  ARG1="false"
elif [ -n $1 ]
then
# otherwise make first arg as a rental
  ARG1=$1
fi

if [ -z $2 ]
then
  ARG2="false"
  ONECHECK="true"
elif [ -n $2 ]
then
# otherwise make first arg as a rental
  ARG2=$2
fi

if [ -z $3 ]
then
  ARG3="false"
  TWOCHECKS="true"
elif [ -n $3 ]
then
# otherwise make first arg as a rental
  ARG3=$3
fi
#///////////////////////////////////////////////////////////////////////////////////////////////////////////
#//// Docker start doesnt need any other file now //////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////

chmod -R 755 public_html
chmod -R 755 storage/framework


# make .env if not already created
 if [ ! -f ".env" ]; then
    cp .env.example .env
    echo ".env was created from example file"
 fi

# cleanup wordpress install
if [ -d "public_html/wp/wp-content" ];then
    rm -rf public_html/wp/wp-content
fi

if [ -f "public_html/wp/wp-config-sample.php" ];then
    rm -f public_html/wp/wp-config-sample.php
fi

if [ -f "public_html/wp/.htaccess" ];then
    rm -f public_html/wp/.htaccess
fi

case $ARG1 in
    [-][hH]|[-][-][hH][eE][lL][pP])

    echo "${CYAN}########################################################################################${NONE}"
    echo "${CYAN}##############################${NONE} ${RED}parameters available${NONE} ${CYAN}####################################${NONE}"
    echo "${CYAN}########################################################################################${NONE}"
    echo " "
    echo "${GREEN}   *${NONE} ${YELLOW}-h or --help${NONE}\n      ${RED} ->${NONE} to show this menu..... \n"
    echo "${GREEN}   *${NONE} ${YELLOW}open or -open or --open${NONE}\n      ${RED} ->${NONE} to do a normal docker-compose exec code bash..... just if you couldn't remember the command :P \n"
    echo "${GREEN}   *${NONE} ${YELLOW}down or -down or --down${NONE}\n      ${RED} ->${NONE} to do a normal docker-compose down..... just if you couldn't remember the command :P \n"
    echo "${GREEN}   *${NONE} ${YELLOW}-i or --images${NONE}\n      ${RED} ->${NONE} to tell the script that you want to build the images\n"
    echo "${GREEN}   *${NONE} ${YELLOW}-ni or --notimages${NONE}\n      ${RED} ->${NONE} to tell the script that you don't want to build the images\n"
    echo "${GREEN}   *${NONE} ${YELLOW}-d or --dependencies${NONE}\n      ${RED} ->${NONE} to tell the script that you want to install dependencies\n"
    echo "${GREEN}   *${NONE} ${YELLOW}-nd or --notdependencies${NONE}\n      ${RED} ->${NONE} to tell the script that you don't want to install dependencies\n"
    echo "${GREEN}   *${NONE} ${YELLOW}-a or --all${NONE}\n      ${RED} ->${NONE} to tell the script that you want to rebuild the images and to install dependencies\n"
    echo "${GREEN}   *${NONE} ${YELLOW}-n or --none${NONE}\n      ${RED} ->${NONE} to tell the script that you don't want to rebuild the images or to install dependencies\n"
    echo " "
    echo "########################################################################################"
            exit;
    ;;
    [dD][oO][wW][nN]|[-][dD][oO][wW][nN]|[-][-][dD][oO][wW][nN])

            docker-compose down;
            exit;
    ;;
    [oO][pP][eE][nN]|[-][oO][pP][eE][nN]|[-][-][oO][pP][eE][nN])
            CONT=code
            CODERUNNING="true"
            CODERUNNING=$(docker inspect --format="{{ .State.Running }}" $CONTAINER 2> /dev/null)
            if [ $? -eq 1 ]; then
              echo "Warning - $CONT is not running."
              CODERUNNING="false"
            fi
            if  [ "$CODERUNNING" != "false" ]; then

                docker-compose exec code bash
                exit;
            else
                REDOIMAGES="false"
                REMOVEDEPENDENCIES="false"
                ONECHECK="true"
            fi

    ;;
    [-][vV]|[-][-][vV][eE][rR][bB][oO][sS][eE])
          VERBOSE="true"
            echo "VERBOSE is true"
          ;;
    [-][iI]|[-][-][iI][mM][aA][gG][eE][sS])
          REDOIMAGES="true"
            echo "REDOIMAGES is true"
    ;;
    [-][nN][iI]|[-][-][nN][oO][tT][iI][mM][aA][gG][eE][sS])
          REDOIMAGES="false"
            echo "REDOIMAGES is false"
    ;;
    [-][dD]|[-][-][dD][eE][pP][eE][nN][dD][eE][nN][cC][iI][eE][sS])
          REMOVEDEPENDENCIES="true"
            echo "REMOVEDEPENDENCIES is true"
    ;;
    [-][nN][dD]|[-][-][nN][oO][tT][dD][eE][pP][eE][nN][dD][eE][nN][cC][iI][eE][sS])
          REMOVEDEPENDENCIES="false"
            echo "REMOVEDEPENDENCIES is false"
    ;;
    [-][aA]|[-][-][aA][lL][lL])
          REMOVEDEPENDENCIES="true"
          REDOIMAGES="true"
          ONECHECK="true"
            echo "REDOIMAGES is true"
            echo "REMOVEDEPENDENCIES is true"
    ;;
    [-][nN]|[-][-][nN][oO][nN][eE])
          REMOVEDEPENDENCIES="false"
          REDOIMAGES="false"
          ONECHECK="true"
            echo "REDOIMAGES is false"
            echo "REMOVEDEPENDENCIES is false"
    ;;
    *)
    ;;
esac
if [ "$ONECHECK" == "false" ]; then
    case $ARG2 in
    [-][vV]|[-][-][vV][eE][rR][bB][oO][sS][eE])
          VERBOSE="true"
            echo "VERBOSE is true"
          ;;
    [-][iI]|[-][-][iI][mM][aA][gG][eE][sS])
          REDOIMAGES="true"
            echo "REDOIMAGES is true"
          ;;
    [-][nN][iI]|[-][-][nN][oO][tT][iI][mM][aA][gG][eE][sS])
          REDOIMAGES="false"
            echo "REDOIMAGES is false"
    ;;
    [-][dD]|[-][-][dD][eE][pP][eE][nN][dD][eE][nN][cC][iI][eE][sS])
          REMOVEDEPENDENCIES="true"
            echo "REMOVEDEPENDENCIES is true"
          ;;
    [-][nN][dD]|[-][-][nN][oO][tT][dD][eE][pP][eE][nN][dD][eE][nN][cC][iI][eE][sS])
          REMOVEDEPENDENCIES="false"
            echo "REMOVEDEPENDENCIES is false"
    ;;
    *)
    ;;
    esac
else
    if [ "$ARG2" != "false" ]; then
        case $ARG2 in
        [-][vV]|[-][-][vV][eE][rR][bB][oO][sS][eE])
              VERBOSE="true"
                echo "VERBOSE is true"
              ;;
        esac
    fi
fi
if [ "$TWOCHECKS" == "false" ]; then
    case $ARG3 in
    [-][vV]|[-][-][vV][eE][rR][bB][oO][sS][eE])
          VERBOSE="true"
            echo "VERBOSE is true"
          ;;
    [-][iI]|[-][-][iI][mM][aA][gG][eE][sS])
          REDOIMAGES="true"
            echo "REDOIMAGES is true"
          ;;
    [-][nN][iI]|[-][-][nN][oO][tT][iI][mM][aA][gG][eE][sS])
          REDOIMAGES="false"
            echo "REDOIMAGES is false"
    ;;
    [-][dD]|[-][-][dD][eE][pP][eE][nN][dD][eE][nN][cC][iI][eE][sS])
          REMOVEDEPENDENCIES="true"
            echo "REMOVEDEPENDENCIES is true"
          ;;
    [-][nN][dD]|[-][-][nN][oO][tT][dD][eE][pP][eE][nN][dD][eE][nN][cC][iI][eE][sS])
          REMOVEDEPENDENCIES="false"
            echo "REMOVEDEPENDENCIES is false"
    ;;
    *)
    ;;
    esac
fi
##############################################################
##############################################################
#load variables of env file
##############################################################
function loadenv() {
  env=${1:-.env}
  echo Loading $env
  file=`mktemp -t tmp `
  if [ -f $env ]; then
    cat $env | while read line; do
      echo export $line >> $file
    done
    source $file
  else
    echo No file $env
  fi
}
##############################################################
#load the variables!! -->
loadenv
#variables loaded <--
##############################################################
##############################################################


echo "$REMOVEDEPENDENCIES" == "not"
##############################################################
##############################################################
#if you have problems loading the docker machine, remove the # symbol from the beginning of the next two lines
#docker-machine rm default
#docker-machine create default --driver virtualbox
CONTAINER=frontend
FRONTENDRUNNING="true"
#important this will set the default vb machine so is found every time
##set docker default image to default used one
#eval "$(docker-machine env default)"
#check if the front end is running. if not run it from scratch
RUNNING=$(docker inspect --format="{{ .State.Running }}" $CONTAINER 2> /dev/null)

if [ $? -eq 1 ]; then
  echo "UNKNOWN - $CONTAINER does not exist."
  FRONTENDRUNNING="false"

elif [ "$RUNNING" == "false" ]; then
  echo "CRITICAL - $CONTAINER is not running."
  FRONTENDRUNNING="false"

fi

if  [ "$FRONTENDRUNNING" == "false" ]; then



    mkdir traefik-temp

    cd traefik-temp

    git clone https://github.com/castillo-n/traefik-image

    cd traefik-image

    sh init.sh

    cd ..

    cd ..

    rm -rf traefik-temp
fi
##############################################################
###############################################################
trim() {
  local s2 s="$*"
  # note: the brackets in each of the following two lines contain one space
  # and one tab
  until s2="${s#[ ]}"; [ "$s2" = "$s" ]; do s="$s2"; done
  until s2="${s#[\r]}"; [ "$s2" = "$s" ]; do s="$s2"; done
  until s2="${s%[ ]}"; [ "$s2" = "$s" ]; do s="$s2"; done
  until s2="${s%[\r]}"; [ "$s2" = "$s" ]; do s="$s2"; done
  echo "$s"
}
FILE="php.ini"
chmod 777 "$FILE"
# make sure php.ini has this line before going and executing it
 if [ -f "$FILE" ]; then
    STRING="xdebug"
    ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d\  -f2 >> machineIp;
    ##################    ##################    ##################    ##################
    ##################    ##################    ##################    ##################
    ### I am working on it #################    ##################    ##################
    ##################    ##################    ##################    ##################
    ##################    ##################    ##################    ##################
    exist="true"
    ##################    ##################    ##################    ##################
    ##################    ##################    ##################    ##################
#    if [ -z $(grep xdebug php.ini) ]; then exist="false"; else exist="true"; fi
    echo "$exist";
     if [ "$exist" = "true" ]; then
        echo "xdebug was configured already."
        echo "if you run into problems, please remove all xdebug extensions from your php.ini before dockering up"
     else
        machineIp= cat machineIp
        echo "$machineIp"
        line=1914
        STR1="\r[xdebug]\rxdebug.remote_host="
        STR2="\rxdebug.remote_autostart=1\rxdebug.idekey=PHPSTORM\rxdebug.default_enable=0\rxdebug.remote_enable=1\rxdebug.remote_connect_back=0\rxdebug.profiler_enable=1\r"
        FULLSTRING=$STR1$machineIp$STR2

        echo $FULLSTRING >> php.ini
#        awk -v insert="$insert" "{print} NR==1914{print insert}" FILE

     fi
#     sed -i "/aaa=/c\aaa=xxx" php.ini
#     sed 's/^xdebug.remote_host=.*/\xdebug.remote_host=xxx/' php.ini
#     sed -i "/^xdebug.remote_host=.*/xdebug.remote_host=111" php.ini
#    sed 's/^xdebug.remote_host=/c\xdebug.remote_host=111' php.ini
#    sed -i "s/^aaa=/c\aaa=xxx" your_file_here
fi
exit
##############################################################
##############################################################
#now added this to the host file if it doesnt exist
## this will only work on macs (I havent tested on windows --sorry Garrett)
##############################################################
echo "#################"
echo "check host"
echo "#################"
STARTED=$(docker inspect --format="{{ .State.StartedAt }}" $CONTAINER)
#NETWORK=$(docker-machine ip default)
# Fallback to localhost if docker-machine not found or error occurs
#if [ -z "$NETWORK" ]; then
    NETWORK=127.0.0.1
#fi

matches_in_hosts="$(grep -n ${SERVER_NAME} /etc/hosts | cut -f1 -d:)"
host_entry="${NETWORK} ${SERVER_NAME}"

if [ "$REDOIMAGES" == "$NOT" ]; then
    echo "${CYAN}#########################################################################"
    echo "#########################################################################"
    echo "#########################################################################"
    echo "Would you like to build the docker images?"
    echo "Intro y and press enter to accept, anything else to skip this option"
    echo "-------------------------------------------------------------------------${RED}"
    read -e -p "##### (y??)>>: " build;
    echo "${NONE} "
    case $build in
        [yY][eE][sS]|[yY])
          REDOIMAGES="true";;
          *)
          REDOIMAGES="false";;
    esac
fi

if [ "$REDOIMAGES" == "$TRUE" ]; then


    docker-compose build;
fi

docker-compose up -d;
echo "${RED}##########################################################################################################"
echo "##########################################################################################################"
echo "if you encounter errors, please check that the machines are not running before running this script";
echo "##########################################################################################################"
echo "##########################################################################################################${NONE}"
ImageName="$(docker-compose ps -q code)"

if [ "$REMOVEDEPENDENCIES" == "$NOT" ]; then
echo "${CYAN}#########################################################################"
echo "#########################################################################"
echo "Would you like to install dependencies?"
echo "Intro y and press enter to accept, anything else to skip this option"
echo "-------------------------------------------------------------------------${RED}"
read -e -p "##### (y??)>>: " answer;
echo "${NONE} ";
case $answer in
    [yY][eE][sS]|[yY])
      REMOVEDEPENDENCIES="true"
        ;;
        *)
      REMOVEDEPENDENCIES="false"
      ;;
esac
fi


if [ "$REMOVEDEPENDENCIES" == "$TRUE" ]; then
    echo "${YELLOW}#########################################################################"
    echo "removing dependencies folders"
    echo "#########################################################################"
    docker-compose exec -T code rm -rf vendor;
    docker-compose exec -T code rm -rf node_modules;
    docker-compose exec -T code rm -rf /usr/local/share/.cache;
    docker-compose exec -T code rm -rf ~/.npm;
    echo "${CYAN}#########################################################################"
    echo "Now installing dependencies"
    echo "#########################################################################"
    echo "Opening code container --> container ID: $ImageName"
    echo "#########################################################################${YELLOW}"
    echo "#########################################################################"
    echo " npm cache clean"
    echo "#########################################################################"
    docker-compose exec -T code npm cache clean

    if [ "$doc_yarn" == "true" ]; then
        echo "#########################################################################${BLUE}"
        echo "#########################################################################"
        echo "yarn upgrade"
        if [ "$VERBOSE" == "false" ]; then
            docker-compose exec -T code yarn upgrade --silent
        else
            docker-compose exec -T code yarn upgrade
        fi
        echo "#########################################################################"
    fi
    if [ "$doc_npm" == "true" ]; then
        echo "#########################################################################${RED}"
        echo "#########################################################################"
        echo "npm -g update"
        if [ "$VERBOSE" == "false" ]; then
            docker-compose exec -T code npm -g update --silent
        else
            docker-compose exec -T code npm -g update
        fi
    fi
    if [ "$doc_bower" == "true" ]; then
        echo "#########################################################################${GREEN}"
        echo "#########################################################################"
        echo "bower update --force"
        if [ "$VERBOSE" == "false" ]; then
            docker-compose exec -T code bower update --force  --allow-root --silent
        else
            docker-compose exec -T code bower update --force  --allow-root --quiet
        fi
    fi
    if [ "$doc_composer" == "true" ]; then
        echo "#########################################################################${PURPLE}"
        echo "#########################################################################"
        echo "composer update"
        if [ "$VERBOSE" == "false" ]; then
            docker-compose exec -T code composer update --quiet
        else
            docker-compose exec -T code composer update
        fi
    fi
    if [ "$doc_artisan_key" == "true" ]; then
        echo "#########################################################################${CYAN}"
        echo "#########################################################################"
        echo "php artisan key:generate"
        docker-compose exec -T code php artisan key:generate
    fi
    if [ "$doc_artisan_migrate" == "true" ]; then
        echo "#########################################################################${NONE}"
        echo "${CYAN}#########################################################################"
        echo "Opening code container --> container ID: $ImageName ${NONE}" ;
        echo "#########################################################################"
        echo "php artisan migrate"
        docker-compose exec -T code php artisan migrate
    fi
    if [ "$doc_gulp" == "true" ]; then
        echo "#########################################################################"
        echo "gulp"
        docker-compose exec -T code gulp
        echo "#########################################################################"
    fi
    echo "${YELLOW}Going into command line -type ${RED}exit ${YELLOW}and press enter to leave the container-${NONE}"
else
    echo "You chose to not build the assets so they were skip"
fi
docker-compose exec code bash
echo "#########################################################################"
echo "#################/-----------------------------------------------\#################"
echo "################|     Paul Bunyan Communications Rocks!!!     |################"
echo "#################\-----------------------------------------------/#################"
echo "#########################################################################"
echo "── ── ── ── ── ── ── ██ ██ ██ ██ ── ██ ██ ██ ── "
echo "── ── ── ── ── ██ ██ ▓▓ ▓▓ ▓▓ ██ ██ ░░ ░░ ░░ ██ "
echo "── ── ── ── ██ ▓▓ ▓▓ ▓▓ ▓▓ ▓▓ ▓▓ ██ ░░ ░░ ░░ ██ "
echo "── ── ── ██ ▓▓ ▓▓ ▓▓ ██ ██ ██ ██ ██ ██ ░░ ░░ ██ "
echo "── ── ██ ▓▓ ▓▓ ▓▓ ██ ██ ██ ██ ██ ██ ██ ██ ░░ ██ "
echo "── ── ██ ▓▓ ██ ██ ░░ ░░ ░░ ░░ ░░ ░░ ██ ██ ██ ── "
echo "── ██ ██ ██ ██ ░░ ░░ ░░ ██ ░░ ██ ░░ ██ ▓▓ ▓▓ ██ "
echo "── ██ ░░ ░░ ░░ ░░ ░░ ░░ ██ ░░ ██ ░░ ██ ▓▓ ▓▓ ██ "
echo "██ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ░░ ██ ▓▓ ██ "
echo "██ ░░ ░░ ░░ ░░ ░░ ░░ ██ ░░ ░░ ░░ ░░ ░░ ██ ▓▓ ██ "
echo "── ██ ░░ ░░ ░░ ░░ ██ ██ ██ ██ ░░ ░░ ██ ██ ██ ── "
echo "── ── ██ ██ ░░ ░░ ░░ ░░ ██ ██ ██ ██ ██ ▓▓ ██ ── "
echo "── ── ── ██ ██ ██ ░░ ░░ ░░ ░░ ░░ ██ ▓▓ ▓▓ ██ ── "
echo "── ░░ ██ ▓▓ ▓▓ ██ ██ ██ ██ ██ ██ ██ ▓▓ ██ ── ── "
echo "── ██ ▓▓ ▓▓ ▓▓ ▓▓ ██ ██ ░░ ░░ ░░ ██ ██ ── ── ── "
echo "██ ██ ▓▓ ▓▓ ▓▓ ▓▓ ██ ░░ ░░ ░░ ░░ ░░ ██ ── ── ── "
echo "██ ██ ▓▓ ▓▓ ▓▓ ▓▓ ██ ░░ ░░ ░░ ░░ ░░ ██ ── ── ── "
echo "██ ██ ██ ▓▓ ▓▓ ▓▓ ▓▓ ██ ░░ ░░ ░░ ██ ██ ██ ██ ── "
echo "── ██ ██ ██ ▓▓ ▓▓ ▓▓ ██ ██ ██ ██ ██ ██ ██ ██ ── "
echo "── ── ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ▓▓ ▓▓ ██ "
echo "── ██ ▓▓ ▓▓ ██ ██ ██ ██ ██ ██ ██ ██ ▓▓ ▓▓ ▓▓ ██ "
echo "██ ██ ▓▓ ██ ██ ██ ██ ██ ██ ██ ██ ██ ▓▓ ▓▓ ▓▓ ██ "
echo "██ ▓▓ ▓▓ ██ ██ ██ ██ ██ ██ ██ ██ ██ ▓▓ ▓▓ ▓▓ ██ "
echo "██ ▓▓ ▓▓ ██ ██ ██ ██ ██ ── ── ── ██ ▓▓ ▓▓ ██ ██ "
echo "██ ▓▓ ▓▓ ██ ██ ── ── ── ── ── ── ── ██ ██ ██ ── "
echo "── ██ ██ ── ── ── ── ── ── ── ── ── ── ── ── ── "
echo "#########################################################################"
echo "#################/-------------------------------------\#################"
echo "################|  Paul Bunyan Communications Rocks!!!  |################"
echo "#################\-------------------------------------/#################"
echo "#########################################################################"
