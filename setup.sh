#!/bin/bash

# A script to auto setup linux( ubuntu ) develop environment
# Please run the script with sudo mode

# Load config file
source ./config.sh

# Setup output color
RED='\033[31m'
GREEN='\033[32m'
NC='\033[0m'

# Function part
config_vimrc() {
    cd ~
	echo -e "checking .vimrc status"
    if [ ! -s .vimrc ]; then
        # if .vimrc is empty
		touch .vimrc
        echo ":set nu\n:set ai\n:set cursorline\n:set tabstop=4\n:set shiftwidth=4" >> .vimrc
		echo -e "${GREEN}.vimrc set up successfully${NC}"
	else
		echo -e "${GREEN}.vimrc already set up${NC}"
    fi
}
 
config_git() {
	declare -a arr=( "git config --global user.email \"${git_email}\""
			"git config --global user.name \"${git_username}\""
			"git config --global color.ui true"
			"git config --global core.editor vim"
			"git config --global alias.co commit"
			"git config --global alias.su status"
			"git config --global alias.lg \"log --color --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --\"" )

	okay=0
	for (( i=0 ; i < ${#arr[@]} ; i++ )); do
		# check input empty or not
		if [[ ( ${i} -eq 0 && ${git_email} == "" ) || ( ${i} -eq 1 && ${git_username} == "" ) ]]; then
			echo -en "${RED}config.sh - "
			
			if [ ${i} -eq 0 ]; then
				echo -n "email "
			else
				echo -n "username "
			fi

			echo -e "empty${NC}"
			continue

		# execute failed
		elif ! eval "${arr[$i]}"; then
			okay=1
			echo -e "${RED}error: ${arr[$i]}${NC}"

		# output execute command
		else
			echo ${arr[$i]}	
		fi
	done

	# check whether execute successfully or not
	if [ ${okay} -eq 0 ]; then
		echo -e "${GREEN}git config execute successfully${NC}"
	else
		echo -e "${RED}git config execute failed${NC}"
	fi
}


# Main body of scripts starts here
# apt update
if apt update; then
    echo -e "${GREEN}apt update successfully${NC}"
else
    echo -e "${RED}$output${NC}"
    echo -e "${RED}apt update failed: $output${NC}"
fi

# apt-get update
if apt-get update; then
    echo -e "${GREEN}apt-get update successfully${NC}"
else
    echo -e "${RED}apt-get update failed${NC}"
fi

# install essential package
if apt install vim git htop curl -y; then
    echo -e "${GREEN}package( vim , git , htop , curl ) install successfully${NC}"
else
    echo -e "${RED}package( vim , git , htop , curl ) install failed${NC}"
fi

# config .vimrc file
config_vimrc

# config git
config_git
