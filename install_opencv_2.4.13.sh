#!/bin/bash

# Written by Yahia Farghaly

if [ "$EUID" -ne 0 ]
  then echo "Please run as a sudo"
  exit
fi

wget https://github.com/Itseez/opencv/archive/2.4.13.zip
apt-get install -y unzip
unzip  2.4.13.zip
apt-get -y build-dep opencv

apt-get install -y libv4l-dev
ln -s /usr/include/libv4l1-videodev.h   /usr/include/linux/videodev.h

cd ./opencv-2.4.13
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local ..
make -j7 # runs 7 jobs in parallel
make install
ldconfig -v

echo "Creating the compile_opencv_2_4.sh script"
touch ~/.compile_opencv_2_4.sh
chmod +x ~/.compile_opencv_2_4.sh
echo "#!/bin/bash" > ~/.compile_opencv_2_4.sh
echo "echo" '"compiling $1"' >> ~/.compile_opencv_2_4.sh
echo "g++  -ggdb" '"$1"' "`pkg-config --cflags opencv` -o " '"$2"' " `pkg-config --libs opencv` " >> ~/.compile_opencv_2_4.sh
echo "echo" '"Output file => ${1%.*}"' >> ~/.compile_opencv_2_4.sh
echo "alias opencv2_4="'"~/.compile_opencv_2_4.sh"' >> ~/.bashrc

echo "OK ,every thing is done"

echo "To compile an opencv c++ file"
echo "in termianl: opencv nameOfFile.cpp nameOfOutputFile"
echo "Example: opencv2_4 feature_detect.cpp run && ./run"
echo " "
echo "It's also possible to provide as many files to compile , not just a single cpp file"
echo "you may open another shell to be able to use opencv command"

echo "Done,All opencv modules(including non free) are ready to use"