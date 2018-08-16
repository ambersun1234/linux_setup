__config_git() {
	# check git is installed or not
	check=$(apt-cache policy git | grep Installed | cut -c14-)
	if [[ -z ${check} ]]; then
		echo -e "\t${RED}couldn't find git${NC}"
		return
	fi
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
			echo -en "\t${YELLOW}config.sh - "

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
			echo -e "\t${RED}error: ${arr[$i]}${NC}"
		fi
	done

	# check whether execute successfully or not
	if [ ${okay} -eq 0 ]; then
		echo -e "\t${GREEN}git config execute successfully${NC}"
	else
		echo -e "\t${RED}git config execute failed${NC}"
	fi
}
