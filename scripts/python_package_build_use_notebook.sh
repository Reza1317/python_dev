# original author: Reza Hosseini
# guide on: using python via notebook from custom builds in virtual env
# it also install a package locally if needed

# you git clone the python_dev github repo into a temp dir
cd $HOME
rm -rf $HOME/temp_code_dir
mkdir $HOME/temp_code_dir
git -C $HOME/temp_code_dir clone https://github.com/Reza1317/python_dev.git
# we source the files which contain python dev bash commands
for f in $HOME/temp_code_dir/python_dev/src/*; do source $f; done

# might need: brew install openblas.

# this specifies your desired python version
py_version=3.8.1

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


package_name="getfred"
repo_path="$HOME/codes/$package_name"
build_and_install_py_package_locally  $py_version $repo_path

py_env_path="$HOME/temp_py_env/"
checkpacks $py_version $py_env_path


# install other packages using pip if needed
pip install fbprophet

which python
start_python_notebook


# END
