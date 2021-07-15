# original author: Reza Hosseini
# guide on: using python via notebook from custom builds in virtual env
# you can also use pip to install desired packages

github_path="https://raw.githubusercontent.com/Reza1317/python_dev/main/src"
f1=$github_path/build_python_package.sh
f2=$github_path/install_python_specific_version.sh
f3=$github_path/start_python_notebook.sh

bash <(curl -s $f1)
bash <(curl -s $f2)
bash <(curl -s $f3)

source <(curl -s $f2)


# this is the desired python version
py_version=3.7.7

# run this command only if you need to install that version
# this is required if that version is not available locally
install_python_ver_mac $py_version

# this will create a python virtual env in "$HOME/temp_py_env/"
py_env_path="$HOME/temp_py_env/"
create_py_env $py_env

checkpacks $py_version $py_env_path
