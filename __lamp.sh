#!bin/bash

__config_lamp() {
    __network_check
    retval=$?

    if [ $retval -eq 1 ]; then
        echo -e "\t${RED}network not available${NC}"
        echo -e "\t${RED}abort install lamp_server${NC}"
        return
    fi
    
    # install lamp-server
    { echo ${mysql_password}; echo ${mysql_password_confirm}; } | apt install lamp-server^ -y &>> ${WORKING_DIR}/log.txt

    # check server properly installed
    check=$(service --status-all | grep apache)
    if [[ -z $check ]]; then
        echo -e "\t${RED}apache server install failed${NC}"
    else
        echo -e "\t${GREEN}apache server install successfully${NC}"
    fi
    check=$(service --status-all | grep mysql)
    if [[ -z $check ]]; then
        echo -e "\t${RED}mysql server install failed${NC}"
    else
        echo -e "\t${GREEN}mysql server install successfully${NC}"
    fi
    check=$(php -v)
    if [[ -z $check ]]; then
        echo -e "\t${RED}php install failed${NC}"
    else
        echo -e "\t${GREEN}php install successfully${NC}"
    fi

    # block on start up
    echo -e "disable apache & mysql start up"
    systemctl disable mysql &>> ${WORKING_DIR}/log.txt
    systemctl disable apache &>> ${WORKING_DIR}/log.txt
}
