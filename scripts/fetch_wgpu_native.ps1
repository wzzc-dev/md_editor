# Fetch the official wgpu-native MSVC build used by wgpu_mbt's dynamic link
# mode (the win32 static artifact is GNU-ABI and cannot link through MSVC).
# Materializes the runtime into .cache/wgpu-native-msvc (gitignored); both
# scripts/build_moui_windows.sh and moui/ui_benchmark.py point
# MBT_WGPU_NATIVE_ROOT at that directory. Idempotent.
param(
  [string]$Repo = 'gfx-rs/wgpu-native',
  # Must match SUPPORTED_RELEASE in Milky2018/wgpu_mbt@0.14.8 scripts.
  [string]$Tag = 'v29.0.1.1',
  [string]$Asset = 'wgpu-windows-x86_64-msvc-release.zip'
)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
$dest = Join-Path $root '.cache/wgpu-native-msvc'
if (Test-Path (Join-Path $dest 'lib\wgpu_native.dll')) {
  Write-Output "wgpu-native runtime already present: $dest"
  exit 0
}
$url = "https://github.com/$Repo/releases/download/$Tag/$Asset"
$zip = Join-Path $env:TEMP $Asset
$staging = Join-Path $env:TEMP ('wgpu-native-' + [guid]::NewGuid().ToString('N'))
Write-Output "fetching $url"
Invoke-WebRequest -Uri $url -OutFile $zip
Expand-Archive -Path $zip -DestinationPath $staging
$dll = Get-ChildItem -Path $staging -Recurse -Filter wgpu_native.dll | Select-Object -First 1
$implib = Get-ChildItem -Path $staging -Recurse -Filter wgpu_native.dll.lib | Select-Object -First 1
$meta = Get-ChildItem -Path $staging -Recurse -Directory -Filter wgpu-native-meta | Select-Object -First 1
if (-not $dll -or -not $implib -or -not $meta) {
  throw "zip layout unexpected: dll=$dll implib=$implib meta=$meta"
}
New-Item -ItemType Directory -Force -Path (Join-Path $dest 'lib') | Out-Null
Copy-Item $dll.FullName (Join-Path $dest 'lib')
Copy-Item $implib.FullName (Join-Path $dest 'lib')
Copy-Item $meta.FullName $dest -Recurse
Remove-Item $staging -Recurse -Force
Remove-Item $zip
Write-Output "wgpu-native $Tag runtime ready: $dest"
