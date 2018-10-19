#!bin/bash

__config_caffe() {
    if [ ! -d "${HOME}/library" ]; then
		cd ${HOME}
		mkdir library
		chown ${USER} ${HOME}/library
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

    echo -e "\t${YELLOW}make sure you have cuda & cudnn installed properly${NC}"

    __network_check
    retval=$?
    if [ $retval -eq 1 ]; then
        echo -e "\t${RED}network not available${NC}"
        echo -e "\t${RED}abort configure caffe${NC}"
        return
    fi

    apt-get install -y libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler &>> ${WORKING_DIR}/log.txt
    apt-get install -y libatlas-base-dev &>> ${WORKING_DIR}/log.txt
    apt-get install -y --no-install-recommends libboost-all-dev &>> ${WORKING_DIR}/log.txt
    apt-get install -y libgflags-dev libgoogle-glog-dev liblmdb-dev &>> ${WORKING_DIR}/log.txt
    apt-get install -y python-pip &>> ${WORKING_DIR}/log.txt
    apt-get install -y python-dev &>> ${WORKING_DIR}/log.txt
    apt-get install -y python-numpy python-scipy &>> ${WORKING_DIR}/log.txt

    cd ${HOME}/library
    if [[ -d "caffe" ]]; then
        echo -e "\t${GREEN}git clone caffe successfully${NC}"
    else
        git clone https://github.com/CMU-Perceptual-Computing-Lab/caffe
        if [[ -d "caffe" ]]; then
            echo -e "\t${GREEN}git clone caffe successfully${NC}"
        else
            echo -e "\t${RED}git clone caffe failed${NC}"
            return
        fi
    fi

    cd ${HOME}/library/caffe
    cp Makefile.config.Ubuntu16_cuda8.example Makefile.config
    sed -i 's/# USE_CUDNN := 1/USE_CUDNN := 1/' Makefile.config
    sed -i 's/# OPENCV_VERSION := 3/OPENCV_VERSION := 3/' Makefile.config
    sed -i 's/# WITH_PYTHON_LAYER := 1/WITH_PYTHON_LAYER := 1/' Makefile.config
    sed -i 's#INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include#INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include /usr/include/hdf5/serial#' Makefile.config
    sed -i 's#LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib /usr/lib#LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib /usr/lib /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu/hdf5/serial#' Makefile.config

    sed -i 's#NVCCFLAGS +=-ccbin=$(CXX) -Xcompiler-fPIC $(COMMON_FLAGS)#NVCCFLAGS += -D_FORCE_INLINES -ccbin=$(CXX) -Xcompiler -fPIC $(COMMON_FLAGS)#' Makefile

    sed -i 's$#error-- unsupported GNU version! gcc versions later than 4.9 are not supported!$//#error-- unsupported GNU version! gcc versions later than 4.9 are not supported!$' /usr/local/cuda/include/host_config.h

    gnome-terminal --disable-factory --tab -e "bash -c \"make all -j`nproc` | tee -a ${WORKING_DIR}/log.txt; make runtest -j`nproc` | tee -a ${WORKING_DIR}/log.txt;\""

    echo -e "\t${GREEN}caffe installed successfully${NC}"

    cd ${HOME}/library/
    chown -R ${USER} caffe/
}
