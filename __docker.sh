#!bin/bash

__config_docker() {

    __network_check
    retval=$?

    if [ $retval -eq 1 ]; then
        echo -e "\t${RED}network not available${NC}"
        echo -e "\t${RED}abort install docker${NC}"
        return
    fi

    sudo apt install docker.io -y &>> ${WORKING_DIR}/log.txt

	status=$(service --status-all | grep docker | cut -c4-5)
	if [[ ${status} == '-' ]]; then
		echo -e "\t${YELLOW}docker not activated , starting docker...${NC}"
	else
		echo -e "\t${GREEN}docker activated${NC}"
	fi

  sudo docker pull hello-world &>> ${WORKING_DIR}/log.txt

  check=$(sudo docker run hello-world | grep 'This message shows that your installation appears to be working correctly')
  if [[ -z ${check} ]]; then
      echo -e "\t${RED}docker installation failed${NC}"
      return
  else
      echo -e "\t${GREEN}docker installation successfully${NC}"
  fi

	echo -e "\tdisable docker start up"
	sudo systemctl disable docker &>> ${WORKING_DIR}/log.txt

	echo -e "\tsetting up docker without sudo mode"
	sudo groupadd docker &>> ${WORKING_DIR}/log.txt
	sudo usermod -aG docker ${USER} &>> ${WORKING_DIR}/log.txt
	echo -e "\t${GREEN}log out and log back in so that your group membership is re-evaluated${NC}"
}
