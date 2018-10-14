#!bin/bash

__config_vimrc() {
    # check vim installed or not
    check=$(apt-cache policy vim | grep Installed | cut -c14-)
    if [[ ${check} == "(none)" ]]; then
        echo -e "\t${RED}couldn't find vim${NC}"
        return
    fi
	echo -e "\tchecking .vimrc status"
    if [ ! -s .vimrc ]; then
        cd ~
        # if .vimrc is empty
		touch .vimrc
        echo -e ":set nu\n:set ai\n:set cursorline\n:set tabstop=4\n:set shiftwidth=4" >> ${HOME}/.vimrc
		echo -e "\t${GREEN}.vimrc set up successfully${NC}"

        chown ${USER} .vimrc
	else
		echo -e "\t${GREEN}.vimrc already set up${NC}"
    fi
}
