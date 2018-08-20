__config_vimrc() {
    # check vim installed or not
    check=$(apt-cache policy vim | grep Installed | cut -c14-)
    if [[ -z ${check} ]]; then
        echo -e "\t${RED}couldn't find vim${NC}"
        return
    fi
	echo -e "\tchecking .vimrc status"
    if [ ! -s .vimrc ]; then
        # if .vimrc is empty
		touch .vimrc
        echo -e ":set nu\n:set ai\n:set cursorline\n:set tabstop=4\n:set shiftwidth=4" >> ${HOME}/.vimrc
		echo -e "\t${GREEN}.vimrc set up successfully${NC}"
	else
		echo -e "\t${GREEN}.vimrc already set up${NC}"
    fi
}
