#!bin/bash

__config_docker() {

    apt install docker.io -y &>> ${WORKING_DIR}/log.txt

    check=$(docker run hello-world | grep 'This message shows that your installation appears to be working correctly')
    if [[ -z ${check} ]]; then
        echo -e "\t${RED}docker installation failed${NC}"
    else
        echo -e "\t${GREEN}docker installation successfully${NC}"
    fi

	echo -e "\tdisable docker start up"
	systemctl disable docker &>> ${WORKING_DIR}/log.txt

	echo -e "\tsetting up docker without sudo mode"
	groupadd docker
	usermod -aG docker ${USER}
	echo -e "\t${GREEN}log out and log back in so that your group membership is re-evaluated${NC}"
}
