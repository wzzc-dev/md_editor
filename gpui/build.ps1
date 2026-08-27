$ErrorActionPreference = "Stop"
python "$PSScriptRoot\build.py"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
