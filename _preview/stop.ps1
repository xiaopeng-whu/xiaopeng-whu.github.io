$ErrorActionPreference = 'Stop'
$previewListener = Get-NetTCPConnection -LocalPort 4000 -State Listen -ErrorAction SilentlyContinue
foreach ($previewConnection in $previewListener) {
    $previewProcess = Get-CimInstance Win32_Process -Filter "ProcessId = $($previewConnection.OwningProcess)"
    if ($previewProcess.Name -eq 'ruby.exe' -and
        $previewProcess.CommandLine -match 'jekyll.*serve.*--host 127\.0\.0\.1.*--port 4000') {
        Stop-Process -Id $previewProcess.ProcessId
        Write-Host 'Local preview stopped.'
    } else {
        throw 'Port 4000 belongs to another application; it was not stopped.'
    }
}
