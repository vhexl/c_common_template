#!/usr/bin/env bash

set -e
set -u

# This script is used to setup the environment for the project.

echo "Setting up the environment for the project..."

# Unity repository URL variable
UNITY_REPO_URL="https://github.com/ThrowTheSwitch/Unity.git"

# remove .git and initial the git repository
if [ -d .git ]; then
    rm -rf .git
fi
git init

# Add submodules Unity
git submodule add ${UNITY_REPO_URL} tests/unity

# create python virtual environment
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

echo "Environment setup is done."
