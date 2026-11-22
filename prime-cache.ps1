# Put the Lightweight Charts packages into this machine's npm cache, so `npm ci` in any project
# that locks these versions installs them from the cache instead of the registry.
# Run once per machine (and again after npm's cache is cleared). Usage: .\prime-cache.ps1
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Get-ChildItem (Join-Path $here 'vendor\node-packages') -Filter *.tgz | ForEach-Object {
    npm cache add $_.FullName
    if ($LASTEXITCODE -ne 0) { throw "npm cache add failed for $($_.Name)" }
    Write-Host "cached $($_.Name)"
}
