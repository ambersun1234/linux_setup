#!/bin/bash

# A script to auto setup linux( ubuntu ) develop environment
# Please run the script with sudo mode

# Load config file
source ./config.sh
source ./__opencv.sh
source ./__lamp.sh
source ./__vimrc.sh
source ./__git.sh

# Main body of scripts starts here

# write current datetime to log.txt
currentTime=$(date +'%Y-%m-%d %H:%M:%S')
echo -e "\n\n---------------setup.sh start: ${currentTime}" &>> ${WORKING_DIR}/log.txt

# apt update
cd ${WORKING_DIR}
echo -e "apt: config.sh = ${PURPLE}${apt}${NC}"
if [ ${apt} == "YES" ]; then
    if apt update &>> ${WORKING_DIR}/log.txt; then
        echo -e "\t${GREEN}apt update successfully${NC}"
    else
        echo -e "\t${RED}apt update failed${NC}"
    fi
else
    echo -e "\t${YELLOW}disable apt update${NC}"
fi

# apt-get update
cd ${WORKING_DIR}
echo -e "\napt-get: config.sh = ${PURPLE}${apt-get}${NC}"
if [ ${apt_get} == "YES" ]; then
    if apt-get update &>> ${WORKING_DIR}/log.txt; then
        echo -e "\t${GREEN}apt-get update successfully${NC}"
    else
        echo -e "\t${RED}apt-get update failed${NC}"
    fi
else
    echo -e "\t${YELLOW}disable apt-get update${NC}"
fi

# install essential package
cd ${WORKING_DIR}
echo -e "\nessential package( vim , git , htop , build-essential , cmake , automake ): config.sh = ${PURPLE}${package}${NC}"
if [ ${package} == "YES" ]; then
    if apt install vim git htop build-essential cmake automake -y &>> ${WORKING_DIR}/log.txt; then
        declare -a checkingList=( [0]="vim" [1]="git" [2]="htop" [3]="build-essential" [4]="cmake" [5]="automake" )
        okay=true

        for i in ${!checkingList[@]}; do
            check=$(apt-cache policy ${checkingList[$i]} | grep Installed | cut -c14- )

            if [[ -z ${check} ]]; then
                echo -e "\t${RED}${checkingList[$i]} install failed${NC}";
                okay=false
            else
                echo -e "\t${GREEN}${checkingList[$i]} installed successfully${NC}"
            fi
        done

        if [ ${okay} == true ]; then
            echo -e "\n\t${GREEN}package install successfully${NC}"
        else
            echo -e "\n\t${RED}package install failed${NC}"
        fi
    else
        echo -e "\t${RED}package install failed${NC}"
    fi
else
    echo -e "\t${YELLOW}disable package install${NC}"
fi

# config .vimrc file
cd ${WORKING_DIR}
echo -e "\n.vimrc: config.sh = ${PURPLE}${vimrc}${NC}"
if [ ${vimrc} == "YES" ]; then
    __config_vimrc
else
    echo -e "\t${YELLOW}disable .vimrc config${NC}"
fi

# config git
cd ${WORKING_DIR}
echo -e "\ngit: config.sh = ${PURPLE}${git}${NC}"
if [ ${git} == "YES" ]; then
    __config_git
else
    echo -e "\t${YELLOW}disable git config${NC}"
fi

# opencv
cd ${WORKING_DIR}
echo -e "\nopencv: config.sh = ${PURPLE}${opencv}${NC}"
if [ ${opencv} == "YES" ]; then
    __config_opencv
else
    echo -e "\t${YELLOW}disable opencv install${NC}"
fi

# lamp-server
cd ${WORKING_DIR}
echo -e "\nlamp-server: config.sh = ${PURPLE}${lamp_server}${NC}"
if [ ${lamp_server} == "YES" ]; then
    __config_lamp
else
    echo -e "\t${YELLOW}disable lamp-server install${NC}"
fi
