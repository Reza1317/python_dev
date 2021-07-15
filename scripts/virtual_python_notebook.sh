# original author: Reza Hosseini
# guide on: using python via notebook from custom builds in virtual env
# you can also use pip to install desired packages

# you git clone the python_dev github repo into a temp dir
rm -rf $HOME/temp_code_dir
mkdir $HOME/temp_code_dir
git -C $HOME/temp_code_dir clone https://github.com/Reza1317/python_dev.git
# we source the files which contain python dev bash commands
. $HOME/temp_code_dir/python_dev/src/build_python_package.sh
. $HOME/temp_code_dir/python_dev/src/install_python_specific_version.sh
. $HOME/temp_code_dir/python_dev/src/start_python_notebook.sh



# this is the desired python version
py_version=3.8.0

# run this command only if you need to install that version
# this is required if that version is not available locally
# this is for Mac
install_python_ver_mac $py_version

# this should work for centos
install_python_ver_centos $py_version

# this will create a python virtual env in "$HOME/temp_py_env/"
py_env_path="$HOME/temp_py_env/"
rm -rf $py_env_path
mkdir $py_env_path
create_py_env $py_version $py_env_path

# check if python is pointing to the right location
which python

# check the python packages inside the py env you just created
checkpacks $py_version $py_env_path


# install other python packages you might need via pip
pip install greykite
pip install kats

# check if the new packages are installed
checkpacks $py_version $py_env_path

# now you can start a notebook with this python
start_python_notebook
