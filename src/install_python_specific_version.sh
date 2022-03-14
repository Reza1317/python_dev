
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
    echo "Step 1: download Python of the version specified using wget"
    wget https://www.python.org/ftp/python/$1/Python-$ver.tgz
    echo "Step 2: unzip Python"
    tar xzf Python-$ver.tgz
    cd Python-$ver
    echo "Step 3: configure bzip"
    ./configure --with-libs='bzip'
    ./configure --enable-optimizations
    echo "Step 4: Install python using `make`"
    sudo make altinstall
    echo "Step 5: update pip"
    pip install --upgrade pip
    echo "python version:"
    echo python --version
}


# run this if you like to un-install python version first
function delete_python_ver_mac() {
    ls $HOME/.pyenv/versions
    rm -rf ls $HOME/.pyenv/versions/$ver
}

# install and use a specific python version on MacOS
# Usage: install_python_ver_mac 3.7.7
function install_python_ver_mac() {
    echo "Eventhough you are installing python for virtual env, it might be good to update base Pythons on you mac"
    echo "The base Pythons are typically located at: `/usr/local/bin`"
    echo "This can be done with: `brew install python`"
    echo "For example it seems like envoking notebooks under Python virtual env still somehow infers to base Pythons"
    echo "This command will  install Python in this path: ``$HOME/.pyenv/shims/python``"
    echo "You might need to do this first: (if not done before)"
    echo "Step 1:"
    echo "1.a Open Xcode-beta.app"
    echo "1.b Go to Preference > Locations"
    echo "1.c Select the right version of command-line tools"
    echo "Step 2 started:"
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
    echo "Step 3: update pip"
    pip install --upgrade pip
    echo "Step 4: setting up the global python env to be the new version"
    echo "Note that if conda/ anaconda settings in bash file are run after, this pyenv global will be over-ruled by conda"
    echo "Remove anoconda blurb from bash profile or convert the commands to a function to run as per need."
    pyenv global $1
    echo "python version:"
    echo python --version
    echo "Step 4: install some useful libraries: ipython, notebook, pandas"
    pip install ipython
    pip install notebook
    pip install pandas

    echo "make sure your jupyter kernel specs are good. If not delete them"
    jupyter kernelspec list
}



# END
