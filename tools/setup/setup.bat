@echo off
setlocal

:: This script is used to setup the environment for the project.
echo Setting up the environment for the project...

:: Unity repository URL variable
set UNITY_REPO_URL=https://github.com/ThrowTheSwitch/Unity.git

:: Remove .git and tests/Unity
if exist .git (
    rmdir /s /q .git
)
if exist tests/Unity (
    rmdir /s /q tests/Unity
)

:: Initial the git repository
git init
:: Add submodules Unity
git submodule add %UNITY_REPO_URL% tests/Unity

:: Create Python virtual environment
python -m venv .venv
call .venv\Scripts\activate
pip install -r requirements.txt

echo Environment setup is done.

endlocal
