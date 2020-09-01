# load config data
$configDataFile = Join-Path -Path $PSScriptRoot -ChildPath 'configData.json'
$configData = Get-Content -Path $configDataFile | ConvertFrom-Json
# try and get external IP
try {
    $currentIP = (Invoke-RestMethod -Uri $configData.icanhazipUri -ErrorAction Stop).TrimEnd()
    if ([string]::IsNullOrEmpty($currentIP)) {
        Write-Error "Failed to get external ip via $($configData.icanhazipUri)."
    }
} catch {
    Write-Error $_.Exception.Message
}
# compare last ip to current ip
if ($configData.lastIP -ne $currentIP) {
    # try and update dns
    try {
        if ($host.version.major -lt 6) {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}
        # this is using FreeDNS's automatic IP detection
        $result = Invoke-RestMethod -Uri $configData.freednsUri
    } catch {
        Write-Error $_.Exception.Message
    }
    # try and notify
    try {
        $irmPushoverSplat = @{
            Method = 'Post'
            Uri    = $configData.pushoverUri
            Body = @{
                token   = $configData.pushoverToken
                user    = $configData.pushoverUser
                message = "Home IP Changed.`nCurrent: $currentIP`nPrevious: $($configData.lastIP)`n`nFreeDNS: $result"
            }
        }
        Invoke-RestMethod @irmPushoverSplat
    } catch {
        Write-Error $_.Exception.Message
    }
    # update ip in config data and write to config file
    $configData.lastIP = $currentIP
    $configData | ConvertTo-Json | Out-File -FilePath $configDataFile
}
