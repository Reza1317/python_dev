#!/bin/bash
# original author: Reza Hosseini
# This is a bash file for testing and building python packages
# It includes useful functions to:
# build/test python packages locally with python version of your choice

echo "file .../build_python_package.sh is sourced."


# builds dist files and
# installs python package using setup file
# $1: full python version
# $2: the path to the python package / repo
# example usage: build_and_install_py_package_locally 3.7.7 $repo_path
function build_and_install_py_package_locally() {
    create_temp_py_env $1;
    # test your virtual environment install
    # you need to get: $HOME/temp_py_env/env/bin/python
    which python;
    # you might need to get: Python 3.7.7
    python --version;

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


# short-hand to clean up python build
function pyclean () {
    find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete
}


# short-hand for pytest
function pyt () {
    python -m pytest -rf $1
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
