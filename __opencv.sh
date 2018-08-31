#!bin/bash

__config_opencv() {
	if [ ! -d "${HOME}/library" ]; then
		cd ${HOME}
		mkdir library
		chown ${USER} ${HOME}/library
		echo -e "\t${HOME}/library not found , create directory \"library\""
	fi

	# check opencv is already installed or not
	output=$(python3 ${WORKING_DIR}/opencvConfirm.py 2>&1)
	if [[ -z ${output} ]]; then
		echo -e "\t${YELLOW}opencv has already been installed${NC}"
		return
	else
		apt-get install build-essential -y &>> ${WORKING_DIR}/log.txt
		apt-get install pkg-config -y &>> ${WORKING_DIR}/log.txt

		apt-get install libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev -y &>> ${WORKING_DIR}/log.txt
		apt-get install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev -y &>> ${WORKING_DIR}/log.txt
		apt-get install libxvidcore-dev libx264-dev libgtk2.0-dev libgtk-3-dev -y &>> ${WORKING_DIR}/log.txt
		apt-get install libcanberra-gtk* -y &>> ${WORKING_DIR}/log.txt
		apt-get install libatlas-base-dev gfortran -y &>> ${WORKING_DIR}/log.txt

		apt-get install python-dev python-pip -y &>> ${WORKING_DIR}/log.txt
		pip install --upgrade pip &>> ${WORKING_DIR}/log.txt
		pip install numpy &>> ${WORKING_DIR}/log.txt

		apt-get install python3-dev python3-pip -y &>> ${WORKING_DIR}/log.txt
		pip3 install --upgrade pip &>> ${WORKING_DIR}/log.txt
		pip3 install numpy &>> ${WORKING_DIR}/log.txt

		okay=false
		count=1

		# clone opencv source code to local
		cd ${HOME}/library
		if [ ! -d "opencv" ]; then
			echo -e "\t${YELLOW}opencv not found in ${HOME}/library, cloning into opencv...${NC}"
			git clone https://github.com/opencv/opencv.git &>> ${WORKING_DIR}/log.txt
			if [ -d "opencv" ]; then
				echo -e "\t${GREEN}opencv clone done${NC}"
			else
				echo -e "\t${RED}opencv clone failed${NC}"
				return
			fi
		else
			echo -e "\topencv found in ${HOME}/library"
		fi
		cd opencv
		git checkout 3.4.1 &>> ${WORKING_DIR}/log.txt

		# do while
		while ! ${okay};
			do
			# install opencv
			cd ${HOME}/library/opencv
			mkdir build
			cd build

			cmake -D CMAKE_BUILD_TYPE=Release \
			-D CMAKE_INSTALL_PREFIX=/usr/local \
			-D ENABLE_NEON=ON \
			-D BUILD_EXAMPLES=ON \
			-D BUILD_TESTS=OFF \
			-D INSTALL_C_EXAMPLES=OFF \
			-D INSTALL_PYTHON_EXAMPLES=OFF \
			-D BUILD_opencv_python2=ON \
			-D PYTHON2_INCLUDE_DIR=/usr/include/python2.7 \
			-D PYTHON2_LIBRARY=/usr/lib/python2.7/config-arm-linux-gnueabihf/libpython2.7.so \
			-D BUILD_opencv_python3=ON \
			-D PYTHON3_INCLUDE_DIR=/usr/include/python3.5m \
			-D PYTHON3_LIBRARY=/usr/lib/python3.5/config-3.5m-arm-linux-gnueabihf/libpython3.5m.so .. &>> ${WORKING_DIR}/log.txt

			echo -e "\t${GREEN}generate done${NC}"
			echo -e "\tcompile ing..."
			make -j`nproc` &>> ${WORKING_DIR}/log.txt
			echo -e "\tmake install ing..."
			make install -j`nproc` &>> ${WORKING_DIR}/log.txt

			# check installation successful or not
			output=$(python3 ${WORKING_DIR}/opencvConfirm.py 2>&1)
			if [[ -z ${output} ]]; then
				okay=true
			else
				# check five times
				if [ ${count} -eq 1 ]; then
					break
				fi

				okay=false
				# remove build directory and rebuild
				cd ${HOME}/library/opencv
				rm -rf build
				echo -e "\t${RED}opencv install failed( ${count} time(s) )${NC}"
				count=$((count+1))
			fi

			# check five time install
			if [[ -z ${output} ]]; then
				echo -e "\t${GREEN}opencv install successfully${NC}"
				break
			else
				echo -e "\t${RED}opencv install failed( 5 times exceeded )${NC}"
			fi
		done
	fi
: '
	# install curl
	echo -e "\tcurl: "
	check=$(apt-cache policy curl | grep Installed | cut -c14-)
	if [[ ! -z ${check} ]]; then
		echo -e "\t\t${YELLOW}curl has already been installed${NC}"
	else
		apt-get install libcurl4-openssl-dev -y &>> ${WORKING_DIR}/log.txt
		check=$(apt-cache policy curl | grep Installed | cut -c14-)
		if [[ -z ${check} ]]; then
			echo -e "\t\t${RED}curl installed failed${NC}";
		else
			echo -e "\t\t${GREEN}curl installed successfully${NC}";
		fi
	fi

 	# install pigpio
	cd ${HOME}/library
	wget https://github.com/joan2937/pigpio/archive/master.zip &>> ${WORKING_DIR}/log.txt
	unzip master.zip &>> ${WORKING_DIR}/log.txt
	cd pigpio-master
	make -j`nproc` &>> ${WORKING_DIR}/log.txt
	make install &>> ${WORKING_DIR}/log.txt
	echo -e "\t\t${GREEN}gpio install done${NC}"

	# install raspicam
	cd ${HOME}/library
	git clone https://github.com/cedricve/raspicam &>> ${WORKING_DIR}/log.txt
	cd raspicam
	mkdir build
	cd build
	cmake .. &>> ${WORKING_DIR}/log.txt
	make &>> ${WORKING_DIR}/log.txt
	make install &>> ${WORKING_DIR}/log.txt
	ldconfig &>> ${WORKING_DIR}/log.txt
'
}
