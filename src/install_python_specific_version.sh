
# author: Reza Hosseini

echo "file .../install_python_specific_version.sh is sourced."

# these are packages you often need for python dev
# usage: install_dev_packages_os yum
function install_dev_packages_linux() {
    $1 gcc openssl-devel bzip2-devel libffi-devel zlib-devel
    $1 install glpk
    $1 install atlas-devel atlas lapack blas lapack-devel
    $1 install openblas-devel hdf5-devel
    $1 install bzip2-devel
    $1 install libjpeg-devel
    $1 install gcc-c++
    $1 install qdldl
    # these are also often needed especially for installing/using Cairo
    $1 install cmake gcc-gfortran libpng-devel libjpeg-devel
    $1 install libxml2-devel libxslt-devel sqlite sqlite-devel
    $1 install bzip2-devel gdbm-devel openssl-devel tcl-devel
    $1 install tk-devel db4-devel expat-devel libffi-devel gcc-c++
    $1 install mesa-libGL-devel mesa-libGLU-devel libXt-devel automake
}


# centos does not make it easy to install newer versions of python
# e.g. "yum install" does not work for python 3.7 and later
# Usage: install_python_ver_centos 3.7.7
function install_python_ver_centos() {
    cd
    ver=$1
    wget https://www.python.org/ftp/python/$1/Python-$ver.tgz
    tar xzf Python-$ver.tgz
    cd Python-$ver
    ./configure --with-libs='bzip'
    ./configure --enable-optimizations
    sudo make altinstall
}


# run this if you like to un-install python version first
function delete_python_ver_mac() {
    ls $HOME/.pyenv/versions
    rm -rf ls $HOME/.pyenv/versions/$ver
}

# install and use a specific python version on MacOS
# Usage: install_python_ver_mac 3.7.7
function install_python_ver_mac() {
    echo "You might need to do this first: (if not done before)"
    echo "step 1:"
    echo "1.a Open Xcode-beta.app"
    echo "1.b Go to Preference > Locations"
    echo "1.c Select the right version of command-line tools"
    echo "step 2 started:"
    export LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib"
    export CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include"
    export OPENBLAS="$(brew --prefix openblas)"
    cd
    py_version=$1
    CFLAGS="-I$(brew --prefix openssl)/include -I$(brew --prefix bzip2)/include -I$(brew --prefix readline)/include -I$(xcrun --show-sdk-path)/usr/include" LDFLAGS="-L$(brew --prefix openssl)/lib -L$(brew --prefix readline)/lib -L$(brew --prefix zlib)/lib -L$(brew --prefix bzip2)/lib" pyenv install --patch $py_version < <(curl -sSL https://github.com/python/cpython/commit/8ea6353.patch\?full_index\=1)
    # set the version
    # this is needed because
    # pyenv seems to require explicit .python-version file to be set
    # in the current directory for any other version than the default in
    pyenv global $1
}
