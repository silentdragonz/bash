#!/usr/bin/env bash

#version 1.2
#2017/02/27
#

################################################################################
################################################################################
# Load in Helper file
################################################################################


################################################################################
################################################################################
# Global Variables
################################################################################
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
NL="\n"
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
DOCKSTART=$(date +%s);
DOCKEND=0;
GULPSTART=0;
GULPEND=0;
COMPOSERSTART=0;
COMPOSEREND=0;
GRUNTSTART=0;
GRUNTEND=0;
MIGRATIONSTART=0;
MIGRATIONEND=0;
BOWERSTART=0;
BOWEREND=0;
YARNSTART=0;
YARNEND=0;
NPMSTART=0;
NPMEND=0;
POSTDOCKERSTART=0;
POSTDOCKEREND=0;
RUBYSTART=0;
RUBYEND=0;
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
#//// Docker start doesn't need any other file now //////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////////////////////////////////

#chmod -R 755 public_html
chmod -fR 755 storage


## make .env if not already created
latest=$(git ls-remote https://github.com/paulbunyannet/bash.git | grep HEAD | awk '{ print $1}');
curl --silent https://raw.githubusercontent.com/paulbunyannet/bash/${latest}/docker/update_docker_assets_file.sh > update_docker_assets_file.sh;
chmod +x update_docker_assets_file.sh;
sh update_docker_assets_file.sh;
rm update_docker_assets_file.sh;
sh get_docker_assets.sh;
#

# make .env if not already created
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo ".env was created from example file"
fi
source dock-helpers.sh;
if [ "$(uname)" == "Linux" ]; then
    export XDEBUG_CONFIG="$(hostname -I | cut -d ' ' -f 1)";
else
    export XDEBUG_CONFIG="remote_host=$(ipconfig getifaddr en0)";
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

    divider "#" ${CYAN}
    echo "${CYAN}##############################${NONE} ${RED}parameters available${NONE} ${CYAN}####################################${NONE}"
    divider "#" ${CYAN}
    echo " "
    echo "${GREEN}   *${NONE} ${YELLOW}-h or --help${NONE}\n      ${RED} ->${NONE} to show this menu..... \n"
    echo "${GREEN}   *${NONE} ${YELLOW}up ${NONE}\n      ${RED} ->${NONE} to tell the script that you dont want to rebuild the images and to reinstall dependencies\n"
    echo "${GREEN}   *${NONE} ${YELLOW}fup ${NONE}\n      ${RED} ->${NONE} to tell the script that you want to rebuild the images and to install dependencies\n"
    echo "${GREEN}   *${NONE} ${YELLOW}down${NONE}\n      ${RED} ->${NONE} to do a normal docker-compose down..... just if you couldn't remember the command :P \n"
    echo "${GREEN}   *${NONE} ${YELLOW}fdown${NONE}\n      ${RED} ->${NONE} to do a normal docker-compose down with a -v to remove volumes..... just if you couldn't remember the command :P \n"
    echo "${GREEN}   *${NONE} ${YELLOW}-i or --images${NONE}\n      ${RED} ->${NONE} to tell the script that you want to build the images\n"
    echo "${GREEN}   *${NONE} ${YELLOW}-ni or --notimages${NONE}\n      ${RED} ->${NONE} to tell the script that you don't want to build the images\n"
    echo "${GREEN}   *${NONE} ${YELLOW}-d or --dependencies${NONE}\n      ${RED} ->${NONE} to tell the script that you want to install dependencies\n"
    echo "${GREEN}   *${NONE} ${YELLOW}-nd or --notdependencies${NONE}\n      ${RED} ->${NONE} to tell the script that you don't want to install dependencies\n"
    echo " "
    echo "########################################################################################"
            exit;
    ;;
    [dD][oO][wW][nN])

            docker-compose down;
            exit;
    ;;
    [fF][dD][oO][wW][nN])

            echo "$RED This command is going to remove every volume for this project"
            echo "(that means you will lose all database changes made until now) $BLUE"
            echo "Do you wish to continue? type y or yes to continue"
            read -e -p "##### >>: " buildme;
            echo "${NONE} "
            case $buildme in
                [yY][eE][sS]|[yY])
                echo "Removing project volumes"
                docker-compose down -v;;
                  *)
                echo "Well then, executing a simple docker-compose down"
                docker-compose down;;
            esac
            exit;
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
    [uU][pP])
          REMOVEDEPENDENCIES="false"
          REDOIMAGES="false"
          ONECHECK="false"
          TWOCHECKS="true"
#            sh get_docker_assets.sh
            echo "REDOIMAGES is true"
            echo "REMOVEDEPENDENCIES is true"
    ;;
    [fF][uU][pP])
          REMOVEDEPENDENCIES="true"
          REDOIMAGES="true"
          ONECHECK="false"
          TWOCHECKS="true"
#            sh get_docker_assets.sh
            echo "REDOIMAGES is true"
            echo "REMOVEDEPENDENCIES is true"
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


#echo "$REMOVEDEPENDENCIES" == "not"
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
RUNNING=$(docker inspect --format="{{ .State.Running }}" $CONTAINER 2> /dev/null);

if [ $? -eq 1 ]; then
  echo "UNKNOWN - $CONTAINER does not exist."
  FRONTENDRUNNING="false"

elif [ "$RUNNING" == "false" ]; then
  echo "CRITICAL - $CONTAINER is not running."
  FRONTENDRUNNING="false"

fi

if  [ "$FRONTENDRUNNING" == "false" ]; then

    docker run -d -p 8080:8080 -p 80:80 -p 443:443 --name=frontend  --restart=always -v /var/run/docker.sock:/var/run/docker.sock jenkins.paulbunyan.net:5000/traefik:latest

    docker network create frontend

    docker network connect frontend frontend

fi
#exit
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
#    NETWORK=127.0.0.1
#fi

#matches_in_hosts="$(grep -n ${SERVER_NAME} /etc/hosts | cut -f1 -d:)"
#host_entry="${NETWORK} ${SERVER_NAME}"

if [ "$REDOIMAGES" == "$NOT" ]; then
    divider "#" ${CYAN}
    divider "#" ${CYAN}
    divider "#" ${CYAN}
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
divider "#" ${RED}
divider "#" ${RED}
echo "if you encounter errors, please check that the machines are not running before running this script";
divider "#" ${RED}
divider "#" ${RED}
ImageName="$(docker-compose ps -q code)"

if [ "$REMOVEDEPENDENCIES" == "$NOT" ]; then
    divider "#" ${CYAN}
    divider "#" ${CYAN}
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

# Install Ruby and Bundler in the code container if there's a Gemfile in this project
if [ -f Gemfile ];
    then
        RUBYSTART=$(date +%s);
        divider "#" ${PURPLE}
        printf "${PURPLE}Installing Ruby Gem dependencies${NL}"
        divider "-" ${PURPLE}
        docker-compose exec -T code apt-get install ruby-full -y;
        docker-compose exec -T code gem install bundler;
        docker-compose exec -T code bundler install;
        printf "${PURPLE}Installing Ruby Gem dependencies complete!${NL}"
        divider "#" ${PURPLE}
        RUBYEND=$(date +%s);
fi;


if [ "$REMOVEDEPENDENCIES" == "$TRUE" ]; then
    divider "#" ${YELLOW}
    echo "removing dependencies folders"
    divider "#" ${YELLOW}
    if [ "$doc_composer" == "true" ]; then
        docker-compose exec -T code rm -rf vendor;
    fi
    if [ "$doc_npm" == "true" ]; then
        docker-compose exec -T code rm -rf node_modules;
        docker-compose exec -T code rm -rf /usr/local/share/.cache;
        docker-compose exec -T code rm -rf ~/.npm;
    fi
    divider "#" ${CYAN}
    echo "Now installing dependencies"
    divider "#" ${CYAN}
    echo "Opening code container --> container ID: $ImageName"
    divider "#" ${YELLOW}
    divider "#" ${YELLOW}
    echo " npm cache clean"
    divider "#" ${YELLOW}
    docker-compose exec -T code npm cache clean

    if [ "$doc_yarn" == "true" ]; then
        YARNSTART=$(date +%s);
        divider "#" ${BLUE}
        divider "#" ${BLUE}
        echo "yarn install"
        if [ "$VERBOSE" == "false" ]; then
            docker-compose exec -T code yarn install --force >/dev/null 2>&1;
        else
            docker-compose exec -T code yarn install --force
        fi
        YARNEND=$(date +%s);
        divider "#" ${BLUE}
    fi
    if [ "$doc_npm" == "true" ] && [ "$doc_yarn" != "true" ]; then
        NPMSTART=$(date +%s);
        divider "#" ${RED}
        divider "#" ${RED}
        echo "npm -g update"
        if [ "$VERBOSE" == "false" ]; then
            docker-compose exec -T code npm -g update --silent  >/dev/null 2>&1;
        else
            docker-compose exec -T code npm -g update
        fi
        NPMEND=$(date +%s);
    fi
    if [ "$doc_artisan_key" == "true" ]; then
        divider "#" ${CYAN}
        divider "#" ${CYAN}
        echo "php artisan key:generate"
        docker-compose exec -T code php artisan key:generate
    fi
else
    echo "You chose to not build the assets so they were skipped";
fi

if [ "$doc_bower" == "true" ]; then
    BOWERSTART=$(date +%s);
    divider "#" ${GREEN}
    divider "#" ${GREEN}
    echo "bower update --force"
    if [ "$VERBOSE" == "false" ]; then
        docker-compose exec -T code bower update --force  --allow-root --silent  >/dev/null 2>&1;
    else
        docker-compose exec -T code bower update --force  --allow-root --quiet
    fi
    BOWEREND=$(date +%s);
fi
if [ "$doc_composer" == "true" ]; then
    COMPOSERSTART=$(date +%s);
    divider "#" ${PURPLE}
    divider "#" ${PURPLE}
    echo "composer update"
    if [ "$VERBOSE" == "false" ]; then
        docker-compose exec -T code composer update --quiet
    else
        docker-compose exec -T code composer update
    fi
    COMPOSEREND=$(date +%s);
fi
if [ "$doc_artisan_migrate" == "true" ]; then
    MIGRATIONSTART=$(date +%s);
    divider "#" ${CYAN}
    echo "Opening code container --> container ID: $ImageName ${NONE}" ;
    divider "#" ${CYAN}
    echo "php artisan migrate"
    docker-compose exec -T code php artisan migrate
    MIGRATIONEND=$(date +%s);
fi
if [ "$doc_gulp" == "true" ]; then
    GULPSTART=$(date +%s);
    divider "#" ${YELLOW}
    divider "#" ${YELLOW}
    echo "gulp"
    if [ "$VERBOSE" == "false" ]; then
        docker-compose exec -T code gulp >/dev/null 2>&1;
    else
        docker-compose exec -T code gulp
    fi
    divider "#" ${YELLOW}
    GULPEND=$(date +%s);
fi
# start install and run of grunt if
# - set $doc_grunt exists
# - $doc_grunt is set to "true"
# - that there's a Gruntfile.js in the code container
gruntFile="grunt_exists_file"
grFile="Gruntfile.js"
if [ -e "$grFile" ]; then echo 1 > ${gruntFile}; else echo 0 > ${gruntFile}; fi;
gruntExists=$(cat grunt_exists_file);
if [ -n ${doc_grunt} ] && [ "${doc_grunt}" = "true" ] && [ ${gruntExists} -eq 1 ]; then
    GRUNTSTART=$(date +%s);
    divider "#" ${CYAN}
    divider "#" ${CYAN}
    echo "Opening code container --> container ID: $ImageName ${NONE}" ;
    divider "#" ${CYAN}
    echo "grunt"
    # Install grunt-cli globally then run grunt
    docker-compose exec -T code yarn global add grunt-cli && yarn add grunt --dev && grunt
    GRUNTEND=$(date +%s);
fi;
rm -f ${gruntFile} || true

# Run post docker script from composer if there is one
postDocker=$(grep -c "post-docker" composer.json)
if [[ ${doc_composer} == "true" && ${postDocker} > 0 ]]; then
    POSTDOCKERSTART=$(date +%s);
    divider "#" ${YELLOW};
    printf "${YELLOW}Running composer post-docker scripts${NL}";
    divider "-" ${YELLOW};
    docker-compose exec -T code composer run-script post-docker || true;
    printf "${YELLOW}Running composer post-docker scripts complete${NL}";
    divider "#" ${YELLOW};
    POSTDOCKEREND=$(date +%s);
fi;


DOCKEND=$(date +%s);
SIXTY=60;
DOCKTOTAL=$(($DOCKEND - $DOCKSTART));
DOCKTOTALMIN=$(($DOCKTOTAL / $SIXTY));
DOCKTOTALREST=$(($DOCKTOTALMIN * $SIXTY));
DOCKTOTALSEC=$(($DOCKTOTAL - $DOCKTOTALREST));
GRUNTTOTAL=$(($GRUNTEND - $GRUNTSTART));
GRUNTTOTALMIN=$(($GRUNTTOTAL / $SIXTY));
GRUNTTOTALREST=$(($GRUNTTOTALMIN * $SIXTY));
GRUNTTOTALSEC=$(($GRUNTTOTAL - $GRUNTTOTALREST));
GULPTOTAL=$(($GULPEND - $GULPSTART));
GULPTOTALMIN=$(($GULPTOTAL / $SIXTY));
GULPTOTALREST=$(($GULPTOTALMIN * $SIXTY));
GULPTOTALSEC=$(($GULPTOTAL - $GULPTOTALREST));
COMPOSERTOTAL=$(($COMPOSEREND - $COMPOSERSTART));
COMPOSERTOTALMIN=$(($COMPOSERTOTAL / $SIXTY));
COMPOSERTOTALREST=$(($COMPOSERTOTALMIN * $SIXTY));
COMPOSERTOTALSEC=$(($COMPOSERTOTAL - $COMPOSERTOTALREST));
MIGRATIONTOTAL=$(($MIGRATIONEND - $MIGRATIONSTART));
MIGRATIONTOTALMIN=$(($MIGRATIONTOTAL / $SIXTY));
MIGRATIONTOTALREST=$(($MIGRATIONTOTALMIN * $SIXTY));
MIGRATIONTOTALSEC=$(($MIGRATIONTOTAL - $MIGRATIONTOTALREST));
YARNTOTAL=$(($YARNEND - $YARNSTART));
YARNTOTALMIN=$(($YARNTOTAL / $SIXTY));
YARNTOTALREST=$(($YARNTOTALMIN * $SIXTY));
YARNTOTALSEC=$(($YARNTOTAL - $YARNTOTALREST));
NPMTOTAL=$(($NPMEND - $NPMSTART));
NPMTOTALMIN=$(($NPMTOTAL / $SIXTY));
NPMTOTALREST=$(($NPMTOTALMIN * $SIXTY));
NPMTOTALSEC=$(($NPMTOTAL - $NPMTOTALREST));

POSTDOCKERTOTAL=$(($POSTDOCKERSTART - $POSTDOCKEREND));
POSTDOCKERTOTALMIN=$(($POSTDOCKERTOTAL / $SIXTY));
POSTDOCKERTOTALREST=$(($POSTDOCKERTOTALMIN * $SIXTY));
POSTDOCKERTOTALSEC=$(($POSTDOCKERTOTAL - $POSTDOCKERTOTALREST));

POSTDOCKERTOTAL=$(($POSTDOCKERSTART - $POSTDOCKEREND));
POSTDOCKERTOTALMIN=$(($POSTDOCKERTOTAL / $SIXTY));
POSTDOCKERTOTALREST=$(($POSTDOCKERTOTALMIN * $SIXTY));
POSTDOCKERTOTALSEC=$(($POSTDOCKERTOTAL - $POSTDOCKERTOTALREST));

echo "${BLUE}The whole dock.sh command took: $DOCKTOTALMIN minutes $DOCKTOTALSEC seconds";
echo "Ruby Gem Dependencies: $RUBYTOTALMIN minutes $RUBYTOTALSEC seconds";
echo "Grunt: $GRUNTTOTALMIN minutes $GRUNTTOTALSEC seconds";
echo "Gulp: $GULPTOTALMIN minutes $GULPTOTALSEC seconds";
echo "Composer: $COMPOSERTOTALMIN minutes $COMPOSERTOTALSEC seconds";
echo "Migrations: $MIGRATIONTOTALMIN minutes $MIGRATIONTOTALSEC seconds";
echo "Yarn: $YARNTOTALMIN minutes $YARNTOTALSEC seconds";
echo "NPM $NPMTOTALMIN minutes $NPMTOTALSEC seconds";
echo "Post Docker scripts: ${POSTDOCKERTOTALMIN} minutes ${POSTDOCKERTOTALSEC} seconds";
echo "${YELLOW}Going into command line -type ${RED}exit ${YELLOW}and press enter to leave the container-${NONE}";
docker-compose exec code bash
sh stacks.sh
divider "#" ${BLUE}
echo "#################/-------------------------------------\#################"
echo "################|  Paul Bunyan Communications Rocks!!!  |################"
echo "#################\-------------------------------------/#################"
divider "#" ${BLUE}
