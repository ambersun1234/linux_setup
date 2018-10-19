#!bin/bash

__config_opencv() {
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
		echo -e "\tquit install opencv${NC}"
		return
	else
		echo -e "\t${GREEN}git found${NC}"
	fi

	# check cmake installed or not
	check=$(apt-cache policy cmake | grep Installed | cut -c14-)
	if [[ ${check} == "(none)" ]]; then
		echo -e "\t${RED}cmake not found . In config.sh , change package=\"NO\" to package=\"YES\" to install"
		echo -e "\tquit install opencv${NC}"
		return
	else
		echo -e "\t${GREEN}cmake found${NC}"
	fi

	# check python3 installed or not
	check=$(apt-cache policy python3 | grep Installed | cut -c14-)
	if [[ ${check} == "(none)" ]]; then
		echo -e "\t${RED}python3 not found . In config.sh , change package=\"NO\" to package=\"YES\" to install"
		echo -e "\tquit install opencv${NC}"
		return
	else
		echo -e "\t${GREEN}python3 found${NC}"
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
				chown -R ${USER} ${HOME}/library
			else
				echo -e "\t${RED}opencv clone failed${NC}"
				return
			fi
		else
			echo -e "\topencv found in ${HOME}/library"
		fi
		cd opencv
		git checkout ${opencv_version} &>> ${WORKING_DIR}/log.txt

		version_check=$(git describe)
		if [[ ${version_check} != ${opencv_version} ]]; then
			echo -e "\t${RED}version not found in opencv${NC}"
			return
		else
			echo -e "\t${GREEN}switch to version ${opencv_version} successfully${NC}"
		fi

		# do while
		while ! ${okay};
			do
			# install opencv
			cd ${HOME}/library/opencv
			mkdir build
			chown ${USER} build
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

			chown -R ${USER} .

			echo -e "\tcompile ing..."

			gnome-terminal --disable-factory --tab -e "bash -c \"make -j`nproc` | tee -a ${WORKING_DIR}/log.txt; make install -j`nproc` | tee -a ${WORKING_DIR}/log.txt;\""

			# check installation successful or not
			output=$(python3 ${WORKING_DIR}/opencvConfirm.py 2>&1)
			if [[ -z ${output} ]]; then
				okay=true
			else
				# check five times
				if [ ${count} -eq 5 ]; then
					echo -e "\t${RED}opencv install failed( 5 times exceeded )${NC}"
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
			fi
		done
	fi
}
