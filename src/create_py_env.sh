# author: Reza Hosseini
# functions to create python virtual env of given version

echo "file .../create_py_env.sh is sourced."

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

