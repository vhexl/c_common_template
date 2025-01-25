# This script is used to setup the environment for the project.
Write-Host "Setting up the environment for the project..."

# Unity repository URL variable
$UNITY_REPO_URL = "https://github.com/ThrowTheSwitch/Unity.git"

# Remove .git and tests/Unity
if (Test-Path -Path .git) {
    Remove-Item -Path .git -Recurse -Force
}
if (Test-Path -Path tests/Unity) {
    Remove-Item -Path tests/Unity -Recurse -Force
}

# Initial the git repository
git init
# Add submodules Unity
git submodule add $UNITY_REPO_URL tests/Unity

# Create Python virtual environment
python -m venv .venv
. .venv\Scripts\Activate
pip install -r requirements.txt

Write-Host "Environment setup is done."
