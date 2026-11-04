param(
    [string]$VivadoBat = 'E:\Vivado\vitis\Vivado\2020.2\bin\vivado.bat'
)
$ErrorActionPreference = 'Stop'
$expRoot = Split-Path -Parent $PSScriptRoot
$ipDir = Join-Path $expRoot 'build\yolov5n_hls_r6_4_axi64_noila\solution1\impl\ip'
$pack = Join-Path $ipDir 'run_ippack.tcl'
if (-not (Test-Path -LiteralPath $pack)) { throw "HLS IP packager script not found: $pack" }
if (-not (Test-Path -LiteralPath $VivadoBat)) { throw "Vivado launcher not found: $VivadoBat" }
$text = Get-Content -LiteralPath $pack -Raw
if ($text -notmatch '(?m)^set Revision\s+"\d+"') { throw 'Could not find the generated IP revision field.' }
$text = [regex]::Replace($text, '(?m)^set Revision\s+"\d+"', 'set Revision "1"')
Set-Content -LiteralPath $pack -Value $text -NoNewline
Push-Location $ipDir
try {
    & $VivadoBat -mode batch -source 'run_ippack.tcl'
    if ($LASTEXITCODE -ne 0) { throw "Vivado IP packaging failed with exit code $LASTEXITCODE" }
} finally { Pop-Location }
Write-Output "Packaged HLS IP at $ipDir"
