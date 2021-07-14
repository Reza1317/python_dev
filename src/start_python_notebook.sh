#!/bin/bash
# author: Reza Hosseini
# this is to start a python notebook using arbitrary python environments
# this could as an example a virtual env which includes manual installs

echo "file .../start_python_notebook.sh was sourced"


function start_python_notebook() {
    printf "you are starting a notebook based on this python:"
    which python

    printf "pip install ipython and notebook"
    # start ipython
    pip install ipython
    pip install notebook

    printf "Warning: you might need to delete existing notebook kernel.json file"
    # You might need to delete existing kernels
    # This is for Mac
    printf "Use following commands on Mac or similar commands on Linux"
    printf "ls $HOME/Library/Jupyter/kernels/python3/"
    printf "cat $HOME/Library/Jupyter/kernels/python3/kernel.json"
    printf "rm $HOME/Library/Jupyter/kernels/python3/kernel.json"
    # cat $HOME/Library/Jupyter/kernels/python3/kernel.json
    # rm $HOME/Library/Jupyter/kernels/python3/kernel.json

    # create a temporary path for your notebook
    printf "creates a temporary path for your notebook"
    mkdir $HOME/ipython_temp_path
    cd $HOME/ipython_temp_path
    printf "creates an empty notebook template via shell"
    # creates an empty notebook template via shell
    cat Untitled.ipynb
    {
     "cells": [],
     "metadata": {},
     "nbformat": 4,
     "nbformat_minor": 2
    }

    # starts notebook
    printf "starts notebook"
    jupyter notebook $(cat Untitled.ipynb >test_notebook.ipynb && echo test_notebook.ipynb)
}
