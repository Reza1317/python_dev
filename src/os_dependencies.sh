# author: Reza Hosseini
# this file include commands to install some typical dependencies
# you might need for python dev on mac/linux


echo "file .../install_python_specific_version.sh is sourced."

# these are packages you often need for python dev on linux
# note that this list might be an over-kill for most projects
# usage on centos/fedora: install_dev_packages_linux yum
# usage on ubunto: install_dev_packages_linux apt-get
function install_dev_packages_linux() {
    # update the installer function eg "yum"
    $1 update
    sudo $1 install gcc
    sudo $1 install openssl-devel
    sudo $1 install bzip2-devel
    sudo $1 install libffi-devel
    sudo $1 install zlib-devel
    sudo $1 install glpk
    sudo $1 install atlas-devel
    sudo $1 install atlas
    sudo $1 install lapack
    sudo $1 install blas
    sudo $1 install lapack-devel
    sudo $1 install hdf5-devel
    sudo $1 install libjpeg-devel
    sudo $1 install gcc-c++
    sudo $1 install qdldl
    # these are also often needed especially for installing/using Cairo
    sudo $1 install cmake
    sudo $1 install gcc-gfortran
    sudo $1 install libpng-devel
    sudo $1 install libxml2-devel
    sudo $1 install libxslt-devel
    sudo $1 install sqlite
    sudo $1 install sqlite-devel
    sudo $1 install gdbm-devel
    sudo $1 install openssl-devel
    sudo $1 install tcl-devel
    sudo $1 install db4-devel
    sudo $1 install expat-devel
    sudo $1 install mesa-libGL-devel
    sudo $1 install mesa-libGLU-devel
    sudo $1 install libXt-devel
    sudo $1 install automake
}


# these are packages you often need for python dev on linux
# usage: install_dev_packages_os yum
function install_dev_packages_mac() {
    # update brew
    brew update
    brew upgrade
    # installs dev tools for mac
    sudo xcode-select --install
    # installs pip
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py
    rm -rf get-pip.py
}

# END
