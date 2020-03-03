# move to mounted iso
Set-Location E:

# install tools
Start-Process "setup64.exe" -ArgumentList '/s /v "/qb REBOOT=R"' -Wait

# check the service
$i = 1
while ((Get-Service -Name 'vmtools' -ErrorAction SilentlyContinue).Status -ne 'Running') {
  Write-Host "VMware Tools service check. Loop #1 interval #$i."
  if ($i -gt 10) {
    $neverStarted = $true
    break
  }
  Start-Sleep -Seconds 2
  $i++
}

# if tools never started then uninstall and reinstall
if ($neverStarted) {
  # get vmware tools guid
  $uninstallKeys = Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
  $toolskey = $uninstallKeys | Get-ItemProperty | Where-Object {$_.DisplayName -eq 'VMware Tools'}
  # define msiexec args
  $spArgs = @(
    "/x"
    "$($toolskey.PSChildName)"
    "/qn"
    "/norestart"
  )
  # uninstall tools
  Start-Process msiexec.exe -ArgumentList $spArgs -Wait
  # wait a bit
  Start-Sleep -Seconds 10
  # install tools
  Start-Process "setup64.exe" -ArgumentList '/s /v "/qb REBOOT=R"' -Wait
} else  {
  # if started exit
  exit 0
}

# check the service
$i = 1
while ((Get-Service -Name 'vmtools' -ErrorAction SilentlyContinue).Status -ne 'Running') {
  Write-Host "VMware Tools service check. Loop #2 interval #$i."
  if ($i -gt 10) {
    Write-Error "vmtools failed to install."
    break
  }
  Start-Sleep -Seconds 2
  $i++
}
