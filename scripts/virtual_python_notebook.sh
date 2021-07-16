# original author: Reza Hosseini
# guide on: using python via notebook from custom builds in virtual env
# the virtual env will be of desired python version
# you can also use pip to install desired packages

# this git clones the python_dev github repo into a temp dir
rm -rf $HOME/temp_code_dir
mkdir $HOME/temp_code_dir
git -C $HOME/temp_code_dir clone https://github.com/Reza1317/python_dev.git
# this sources the files which contain python dev bash commands
. $HOME/temp_code_dir/python_dev/src/install_python_specific_version.sh;
. $HOME/temp_code_dir/python_dev/src/create_py_env.sh;
. $HOME/temp_code_dir/python_dev/src/build_python_package.sh;
. $HOME/temp_code_dir/python_dev/src/start_python_notebook.sh;



# this specifies your desired python version
py_version=3.8.0

# run this command only if you need to install that version
# this is required if that version is not available locally
# the virtual environment can be only created if
# python with that version is already installed locally on the OS
# this should work for Mac or linux (tried on centos):
if [[ "$OSTYPE" == "darwin"* ]]; then
    # this is for mac
    install_python_ver_mac $py_version
else
    # this is for centos
    install_python_ver_centos $py_version;
fi


# this creates a python virtual env in "$HOME/temp_py_env/"
py_env_path="$HOME/temp_py_env/"
rm -rf $py_env_path
mkdir $py_env_path
create_py_env $py_version $py_env_path

# checks if python is pointing to the right location
which python

# checks the python packages inside the py env you just created
checkpacks $py_version $py_env_path


# installs other python packages you might need via pip
pip install greykite
pip install kats

# checks if the new packages are installed
checkpacks $py_version $py_env_path

# now you can start a notebook with this python
# you can use the standard commands, if "ipython" and "notebook" are already installed:
# standard command: jupter notebook
# or you can use this short-hand command (from this repo) which puts a notebook in a temp folder:
start_python_notebook
