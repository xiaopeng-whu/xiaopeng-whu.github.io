$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)

$previewExisting = Get-NetTCPConnection -LocalPort 4000 -State Listen -ErrorAction SilentlyContinue
if ($previewExisting) {
    $previewResponse = Invoke-WebRequest 'http://127.0.0.1:4000/' -UseBasicParsing -TimeoutSec 5
    if ($previewResponse.Content.Contains('Zepeng Wang')) {
        Start-Process 'http://127.0.0.1:4000/'
        exit 0
    }
    throw 'Port 4000 is already in use by another application.'
}

# Refresh PATH for terminals opened before Ruby was installed.
$env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
    [Environment]::GetEnvironmentVariable('Path', 'User') + ';' + $env:Path
if (-not (Get-Command ruby.exe -ErrorAction SilentlyContinue)) {
    foreach ($rubyBin in @('C:\Ruby33-x64\bin', "$env:LOCALAPPDATA\Programs\Ruby33-x64\bin")) {
        if (Test-Path (Join-Path $rubyBin 'ruby.exe')) {
            $env:Path = $rubyBin + ';' + $env:Path
            break
        }
    }
}
if (-not (Get-Command ruby.exe -ErrorAction SilentlyContinue)) {
    throw 'Ruby was not found. Install Ruby+Devkit and try again.'
}
$env:LANG = 'en_US.UTF-8'
$env:JEKYLL_ENV = 'development'
# Keep native gem extraction outside the project's Chinese directory names.
& bundle.bat config set --local path "$env:LOCALAPPDATA/Jekyll/xiaopeng-whu/bundle"
if ($LASTEXITCODE -ne 0) { throw 'Could not configure the dependency directory.' }
& bundle.bat check
if ($LASTEXITCODE -ne 0) {
    & bundle.bat install
    if ($LASTEXITCODE -ne 0) { throw 'Dependency installation failed.' }
}
Write-Host 'Local preview: http://127.0.0.1:4000'
Write-Host 'Keep this window open. Press Ctrl+C to stop.'
& bundle.bat exec jekyll serve --host 127.0.0.1 --port 4000 --livereload --open-url --force_polling
exit $LASTEXITCODE
