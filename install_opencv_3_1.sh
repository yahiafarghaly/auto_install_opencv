#!/bin/bash

#This Script will download,install the latest opencv 3.1 and configure a bashfile for easy compile the opencv c++ files
#This builds the support of CUDA inside the opencv if the CUDA-toolkit exists in the machine
#make sure you have at least 6GB before downloading the repos and building ...

if [ $# = 0 ]
then
    echo "Provide an existing opencv repo directory path"
    echo "Example:"
    echo "./setopenCV path_to_opencv_directory"
    echo "OR provide git option to download the repos and start building."
    echo "Example:"
    echo "./setopenCV git"

    exit
fi

echo "In This Place,Make sure you have enough space for opencv downloads and building (6Gb)"
echo "And Keep This Folder after downloading, Don't delete it"

echo " Donwloading the neccessary dev stuff..."
sudo apt-get install -y build-essential
sudo apt-get install -y cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install -y python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev python-scipy

if [ "$1" = "git" ]; then

	echo "Creating opencv_latest directory ..."
	mkdir opencv_latest
	echo "Go inside opencv_latest directory "
	cd ./opencv_latest

	echo "Downloading The main opencv repo .."
	git clone https://github.com/Itseez/opencv.git
	echo "Downloading the extre opencv modules repo .."
	git clone https://github.com/Itseez/opencv_contrib.git

	echo "Go inside opencv/build directory "
	cd ./opencv
	mkdir build
	cd build

else
	echo "Go inside $1"
	cd "$1"
		if [ ! -d "build" ]
	        then
	            echo "build directory is not exist ,create a one ..."
	            echo "Go inside opencv/build directory "
	            mkdir build
	            cd build
	    else
	    		echo "build directory exists"
	    		cd build
	    fi
fi


cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules -D WITH_OPENGL=ON \
	  -D WITH_CUDA=ON -D ENABLE_FAST_MATH=1 -D CUDA_FAST_MATH=1 -D WITH_CUBLAS=1 \
	  -D INSTALL_C_EXAMPLES=ON \
	  -D INSTALL_PYTHON_EXAMPLES=ON \
	  -D BUILD_EXAMPLES=ON \
	  -D BUILD_NEW_PYTHON_SUPPORT=ON \
	  ..

make -j7 # runs 7 jobs in parallel
sudo make install
sudo ldconfig -v


echo "Creating the compile_opencv.sh script"
touch ~/.compile_opencv.sh
chmod +x ~/.compile_opencv.sh
echo "#!/bin/bash" > ~/.compile_opencv.sh
echo "echo" '"compiling $1"' >> ~/.compile_opencv.sh
echo "g++  -ggdb" '"$1"' "`pkg-config --cflags opencv` -o " '"$2"' " `pkg-config --libs opencv` " >> ~/.compile_opencv.sh
echo "echo" '"Output file => ${1%.*}"' >> ~/.compile_opencv.sh
echo "alias opencv="'"~/.compile_opencv.sh"' >> ~/.bashrc


echo "To compile an opencv c++ file"
echo "in termianl: opencv nameOfFile.cpp nameOfOutputFile"
echo "Example: opencv feature_detect.cpp run && ./run"
echo " "
echo "It's also possible to provide as many files to compile , not just a single cpp file"
echo "you may open another shell to be able to use opencv command"





