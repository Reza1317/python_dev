# original author: Reza Hosseini
# This is a bash file for testing and building python packages
# It includes useful functions to:
# (1) install python of various versions on Mac and Centos
# (2) create python virtual environments of desired versions
# (3) build/test python packages locally with python version of your choice

echo "file .../build_python_package_src.sh was sourced"

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
    mkdir $HOME/temp
    cd $HOME/temp
    wget https://www.python.org/ftp/python/$1/Python-$ver.tgz
    tar xzf Python-$ver.tgz
    cd Python-$ver
    ./configure --with-libs='bzip'
    ./configure --enable-optimizations
    sudo make altinstall
}

# install_python_ver_centos $py_ver_full

# install and use a specific python version on MacOS
# Usage: install_python_ver_mac 3.7.7
function install_python_ver_mac() {
    # step 1:
    # open Xcode-beta.app
    # go to Preference > Locations
    # select the right version of command-line tools
    # step 2:
    ver=$1
    LDFLAGS="-L/opt/homebrew/opt/zlib/lib -L/opt/homebrew/opt/bzip2/lib"

    CPPFLAGS="-I/opt/homebrew/opt/zlib/include -I/opt/homebrew/opt/bzip2/include"

    CFLAGS="-I$(brew --prefix openssl)/include -I$(brew --prefix bzip2)/include -I$(brew --prefix readline)/include -I$(xcrun --show-sdk-path)/usr/include"

    LDFLAGS="-L$(brew --prefix openssl)/lib -L$(brew --prefix readline)/lib -L$(brew --prefix zlib)/lib -L$(brew --prefix bzip2)/lib"

    pyenv install --patch $ver < <(curl -sSL https://github.com/python/cpython/commit/8ea6353.patch\?full_index\=1)
    # set the version
    # this is needed because
    # pyenv seems to require explicit .python-version file to be set
    # in the current directory for any other version than the default in
    pyenv global $1
}


# this function creates virtual python environment
# $1: full python version eg 3.7.7
# $2: the directory where the python env will be placed in
# example usage: create_py_env 3.7.7 test_dir
function create_py_env() {
    cd $2
    # on Mac we need to do this to activate desired python version e.g. python3.7
    if [[ "$OSTYPE" == "darwin"* ]]; then
        pyenv global $1
    fi
    py_ver_short=$(echo $1 | cut -c1-3)
    python$py_ver_short -m venv env
    which python
    ls
    ls env
    ls env/bin
    source  env/bin/activate
    printf "Upgrading pip"
    pip install --upgrade pip
    printf "\n\n * This is the python virtual env path: "
    which python
    printf "\n\n * This is the python version in the virtual env: "
    python --version
    printf "\n\n * Install some key packages in the virtual env: wheel, tox, twine. \n\n"
    # python3 -m pip install --user --upgrade setuptools wheel
    # python3 -m pip install --upgrade setuptools wheel
    # pip install wheel
    # pip install setuptools
    printf "Updating setup tools"
    pip install --upgrade setuptools wheel
    pip install wheel
    pip install twine
    pip install tox
}


# short-hand to clean up python build
function pyclean () {
    find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete
}


# short-hand for pytest
function pyt () {
    python -m pytest -rf $1
}


# create a new python environment in a temp folder
# $1: full python version
function create_temp_py_env() {
    printf "Creating temporary python env in $HOME/temp_py_env/"
    py_env_path="$HOME/temp_py_env/"
    rm -rf $py_env_path
    mkdir $py_env_path
    create_py_env $1 $py_env_path
    which python
};


# builds dist files and
# installs python package using setup file
# $1: full python version
# $2: the path to the python package / repo
# example usage: build_and_install_py_package_locally 3.7.7 $repo_path
function build_and_install_py_package_locally() {
    create_temp_py_env $1;
    # test your virtual environment install
    # you need to get: $HOME/temp_py_env/env/bin/python
    which python
    # you might need to get: Python 3.7.7
    python --version

    # run setup
    cd $2
    printf "setup.py file contents:"
    cat setup.py
    python setup.py clean --all
    printf "Creating wheels:"
    python setup.py sdist bdist_wheel
    # pip -V
    # which pip
    printf "Installing python package $2 manually via setup.py:"
    pip install -e .
}


# checking what packages are installed
# $1: python full version
# $2: python env path
# example usage: checkpacks 3.7.7 $py_env_path
function checkpacks() {
    py_env_path=$2
    py_ver_short=$(echo $1 | cut -c1-3)
    # python$py_ver_short -m venv env
    ls $py_env_path/env/lib/python$py_ver_short/site-packages/
}


# install python package locally and check dist files
# $1: full python version
# $2: the path to the python package / repo
# $3: python env path
# example usage:
# build_and_install_py_package_check_dist 3.7.7 $repo_path $py_env_path
function build_and_install_py_package_check_dist() {
    build_and_install_py_package_locally $1 $2
    # checking what packages are installed
    checkpacks $1 $3
    pip install --upgrade twine
    twine check dist/*
}


function test_local_setup_install_from_dist_files() {
    package=$1
    package_ver=$2
    # create a local temp directory to check that install
    rm -rf $HOME/test_package_dist
    mkdir $HOME/test_package_dist
    cp -rf dist $HOME/test_package_dist


    cd $HOME/test_package_dist/dist
    ls

    tar -xzf $package-$package_ver.tar.gz
    cd $package-$package_ver/
    python setup.py install
}


# This function uses pip to install from tar file
function test_local_pip_install_from_dist_files() {
    package=$1
    package_ver=$2
    # create a local test directory to check that install
    rm -rf $HOME/test_package_dist
    mkdir $HOME/test_package_dist
    cp -rf dist $HOME/test_package_dist


    cd $HOME/test_package_dist/dist
    ls

    pip install $package-$package_ver.tar.gz
}
