# This script is used to setup the environment for the project.
Write-Host "Setting up the environment for the project..."

# Unity repository URL variable
$UNITY_REPO_URL = "https://github.com/ThrowTheSwitch/Unity.git"

# Remove .git and initialize the git repository
if (Test-Path -Path .git) {
    Remove-Item -Path .git -Recurse -Force
}
git init

# Add submodules Unity
git submodule add $UNITY_REPO_URL tests/unity

# Create Python virtual environment
python3 -m venv .venv
. .venv\Scripts\Activate
pip install -r requirements.txt

Write-Host "Environment setup is done."
