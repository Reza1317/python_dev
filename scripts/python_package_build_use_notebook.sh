# original author: Reza Hosseini
# guide on: using python via notebook from custom builds in virtual env
# it also install a package locally if needed

github_path="https://raw.githubusercontent.com/Reza1317/python_dev/main/src/"
f1=$github_path/build_python_package.sh
f2=$github_path/install_python_specific_version.sh
f3=$github_path/start_python_notebook.sh

source <(curl -s $f1)
source <(curl -s $f2)
source <(curl -s $f3)

# might need: brew install openblas.
OPENBLAS="$(brew --prefix openblas)"
py_version="3.7.7"


repo_path="$HOME/codes/getfred"
build_and_install_py_package_locally  $py_version $repo_path

py_env_path="$HOME/temp_py_env/"
checkpacks $py_version $py_env_path

which python
start_python_notebook


# END
