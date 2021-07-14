# author: Reza Hosseini

# these are packages you often need for python dev
function install_dev_packages_os() {
    install_func=yum
    sudo $install_func install gcc openssl-devel bzip2-devel libffi-devel zlib-devel
    sudo $install_func install glpk
    sudo $install_func install atlas-devel atlas lapack blas lapack-devel
    sudo $install_func install openblas-devel hdf5-devel
    sudo $install_func install bzip2-devel
    sudo $install_func install libjpeg-devel
    sudo $install_func install gcc-c++
    sudo $install_func install qdldl
    # these are also often needed especially for installing/using Cairo
    sudo $install_func install cmake gcc-gfortran libpng-devel libjpeg-devel
    sudo $install_func install libxml2-devel libxslt-devel sqlite sqlite-devel
    sudo $install_func install bzip2-devel gdbm-devel openssl-devel tcl-devel
    sudo $install_func install tk-devel db4-devel expat-devel libffi-devel gcc-c++
    sudo $install_func install mesa-libGL-devel mesa-libGLU-devel libXt-devel automake
}


# centos does not make it easy to install newer versions of python
# e.g. "yum install" does not work for python 3.7 and later
# Usage: install_python_ver_centos 3.7.7
function install_python_ver_centos() {
    ver=$1
    wget https://www.python.org/ftp/python/$1/Python-$ver.tgz
    tar xzf Python-$ver.tgz
    cd Python-$ver
    ./configure --with-libs='bzip'
    ./configure --enable-optimizations
    sudo make altinstall
}


# install and use a specific python version on MacOS
# Usage: install_python_ver_mac 3.7.7
function install_python_ver_mac() {
    # step 1:
    # Open Xcode-beta.app
    # Go to Preference > Locations
    # Select the right version of command-line tools
    # step 2:
    ver=$1
    CFLAGS="-I$(brew --prefix openssl)/include -I$(brew --prefix bzip2)/include -I$(brew --prefix readline)/include -I$(xcrun --show-sdk-path)/usr/include" LDFLAGS="-L$(brew --prefix openssl)/lib -L$(brew --prefix readline)/lib -L$(brew --prefix zlib)/lib -L$(brew --prefix bzip2)/lib" pyenv install --patch $ver < <(curl -sSL https://github.com/python/cpython/commit/8ea6353.patch\?full_index\=1)
    # set the version
    # this is needed because
    # pyenv seems to require explicit .python-version file to be set
    # in the current directory for any other version than the default in
    pyenv global $1
}
