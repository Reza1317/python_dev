# original author: Reza Hosseini
# guide on: using python via notebook from custom builds in virtual env
# it also install a package locally if needed

# you git clone the python_dev github repo into a temp dir
rm -rf $HOME/temp_code_dir
mkdir $HOME/temp_code_dir
git -C $HOME/temp_code_dir clone https://github.com/Reza1317/python_dev.git
# we source the files which contain python dev bash commands
. $HOME/temp_code_dir/python_dev/src/install_python_specific_version.sh
. $HOME/temp_code_dir/python_dev/src/create_py_env.sh
. $HOME/temp_code_dir/python_dev/src/build_python_package.sh
. $HOME/temp_code_dir/python_dev/src/start_python_notebook.sh


# might need: brew install openblas.

py_version="3.8.0"


repo_path="$HOME/codes/greykite"
build_and_install_py_package_locally  $py_version $repo_path

py_env_path="$HOME/temp_py_env/"
checkpacks $py_version $py_env_path


# install other packages using pip if needed
pip install fbprophet

which python
start_python_notebook


# END
