#!bin/bash

__config_openpose() {
    if [ ! -d "${HOME}/library" ]; then
        cd ${HOME}
        mkdir library
        echo -e "\t${HOME}/library not found , create directory \"library\""
    fi

    # check git installed or not
    check=$(apt-cache policy git | grep Installed | cut -c14-)
    if [[ ${check} == "(none)" ]]; then
        echo -e "\t${RED}git not found . In config.sh , change package=\"NO\" to package=\"YES\" to install"
        echo -e "\tquit install caffe${NC}"
        return
    else
        echo -e "\t${GREEN}git found${NC}"
    fi

    # check cmake installed or not
    check=$(apt-cache policy cmake | grep Installed | cut -c14-)
    if [[ ${check} == "(none)" ]]; then
        echo -e "\t${RED}cmake not found . In config.sh , change package=\"NO\" to package=\"YES\" to install"
        echo -e "\tquit install caffe${NC}"
        return
    else
        echo -e "\t${GREEN}cmake found${NC}"
    fi

    # check opencv installed or not
    output=$(python3 ${WORKING_DIR}/opencvConfirm.py 2>&1)
    if [[ -z ${output} ]]; then
        echo -e "\t${GREEN}opencv installed properly${NC}"
    else
        echo -e "\t${RED}opencv not found . In config.sh , change opencv=\"NO\" to opencv=\"YES\" to install"
        echo -e "\tquit install caffe"
        return
    fi

    # check caffe installed or not
    echo -e "\t${YELLOW}make sure that caffe exists in ${HOME}/library/caffe${NC}"

    __network_check
    retval=$?

    if [ $retval -eq 1 ]; then
        echo -e "\t${RED}network not available${NC}"
        echo -e "\t${RED}abort configure openpose${NC}"
        return
    fi

    cd ${HOME}/library
    if [[ -d "openpose" ]]; then
        echo -e "\t${GREEN}git clone openpose successfully${NC}"
    else
        git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose &>> ${WORKING_DIR}/log.txt
        if [[ -d "caffe" ]]; then
            echo -e "\t${GREEN}git clone openpose successfully${NC}"
        else
            echo -e "\t${RED}git clone openpose failed${NC}"
            return
        fi
    fi

    # copy caffe to openpose
    cp -R caffe/ openpose/3rdparty

    cd openpose
    rm -rf build
    mkdir build && cd build

    cp -R ${HOME}/library/openpose/3rdparty/caffe/include/caffe/* ${HOME}/library/openpose/3rdparty/caffe/build/include/caffe/

    echo -e "\t${YELLOW}cmake openpose takes quite a long time , with downloading some of the packages${NC}"
    cmake -D Caffe_INCLUDE_DIRS:PATH="${HOME}/library/openpose/3rdparty/caffe/build/include" \
          -D BUILD_PYTHON:BOOL="1" \
          -D BUILD_CAFFE:BOOL="0" \
          -D Caffe_LIBS:FILEPATH="${HOME}/library/openpose/3rdparty/caffe/build/lib/libcaffe.so" .. &>> ${WORKING_DIR}/log.txt

    echo -e "\t${GREEN}generate done${NC}"

    echo -e "\tcompile ing..."

    gnome-terminal --disable-factory --tab -e "bash -c \"make -j`nproc` | tee -a ${WORKING_DIR}/log.txt; sudo make install -j`nproc` | tee -a ${WORKING_DIR}/log.txt;\""

    cd ${HOME}/library/openpose
    echo -e "\t${GREEN}compile done${NC}";
}
