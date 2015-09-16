README for OpenCV/Camera unit code

Software:
- OpenCV 3.0
- Python 2.7

Setup:
- Get OpenCV 3.0 and Python 2.7 (varies based on your OS)
- Install virtualenv and virtualenvwrapper 
- mkvirtualenv cv (now you're in the cv virtual env)
- pip install numpy
- install libraries: cmake pkg-config jpeg libpng libtiff openexr eigen tbb
- cd ~
  git clone https://github.com/Itseez/opencv.git
  git clone https://github.com/Itseez/opencv_contrib
  cd ~/opencv
  mkdir build
  cd build
  cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local \
                           -D PYTHON2_PACKAGES_PATH=~/.virtualenvs/cv/lib/python2.7/site-packages \
                           -D PYTHON2_LIBRARY=/usr/local/Cellar/python/2.7.10/Frameworks/Python.framework/Versions/2.7/bin \
                           -D PYTHON2_INCLUDE_DIR=/usr/local/Frameworks/Python.framework/Headers \
                           -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON \
                           -D BUILD_EXAMPLES=ON \
                           -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules ..
  (Except you have to modify PYTHON2_PACKAGES_PATH, PYTHON2_LIBRARY, and
  PYTHON_INCLUDE_DIR for your computer...)
  make -j4
  sudo make install

Source for setup: http://www.pyimagesearch.com/2015/06/15/install-opencv-3-0-and-python-2-7-on-osx/
