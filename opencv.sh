#!bin/bash

opencv() {
	apt-get install build-essential -y
	apt-get install cmake automake pkg-config -y

	apt-get install libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev -y
	apt-get install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev -y
	apt-get install libxvidcore-dev libx264-dev libgtk2.0-dev libgtk-3-dev -y
	apt-get install libcanberra-gtk* -y
	apt-get install libatlas-base-dev gfortran -y

	apt-get install python-dev python-pip -y
	pip install --upgrade pip
	pip install numpy

	apt-get install python3-dev python3-pip -y
	pip3 install --upgrade pip
	pip3 install numpy

	cd ~
	mkdir library
	cd library
	git clone https://github.com/opencv/opencv.git
	cd opencv
	git checkout 3.4.1
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
	-D PYTHON3_LIBRARY=/usr/lib/python3.5/config-3.5m-arm-linux-gnueabihf/libpython3.5m.so ..

	make -j4
	make install

	// install curl
	apt-get install libcurl4-openssl-dev -y

	// install pigpio
	cd ~
	wget https://github.com/joan2937/pigpio/archive/master.zip
	unzip master.zip
	cd pigpio-master
	make -j4
	make install

	// install raspicam
	cd ~
	git clone https://github.com/cedricve/raspicam
	cd raspicam
	mkdir build
	cd build
	cmake ..
	make
	make install
	ldconfig
}
