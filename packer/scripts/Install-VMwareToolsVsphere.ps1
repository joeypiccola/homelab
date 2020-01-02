#if (Test-Path -Path E:\) {
#    e:\setup64 /s /v "/qb REBOOT=R" /l c:\windows\temp\vmware_tools_install.log
#


#Set the current working directory to whichever drive corresponds to the mounted VMWare Tools installation ISO
Set-Location e:

#Install VMWare Tools
Start-Process "setup64.exe" -ArgumentList '/s /v "/qb REBOOT=R"' -Wait

#After the installation is finished, check to see if the 'VMTools' service enters the 'Running' state every 2 seconds for 10 seconds
$Running = $false
$iRepeat = 0
while (!$Running -and $iRepeat -lt 5) {
  Start-Sleep -s 2
  $Service = Get-Service "VMTools" -ErrorAction SilentlyContinue
  $Servicestatus = $Service.Status
  if ($ServiceStatus -notlike "Running") {
    $iRepeat++
  }
  else {
    $Running = $true
  }
}

#If the service never enters the 'Running' state, re-install VMWare Tools
if (!$Running) {
  #Uninstall VMWare Tools
  Start-Process "setup64.exe" -ArgumentList '/s /c' -Wait
  #Install VMWare Tools
  Start-Process "setup64.exe" -ArgumentList '/s /v "/qb REBOOT=R"' -Wait
  #Wait again for the VMTools service to start
  $iRepeat = 0
  while (!$Running -and $iRepeat -lt 5) {
    Start-Sleep -s 2
    $Service = Get-Service "VMTools" -ErrorAction SilentlyContinue
    $ServiceStatus = $Service.Status

    if ($ServiceStatus -notlike "Running") {
      $iRepeat++
    }
    else {
      $Running = $true
    }
  }

  #If after the reinstall, the service is still not running, this is a failed deployment.
  if (!$Running) {
    Write-Host -ForegroundColor Red "VMWare Tools are still not installed correctly. This is a failed deployment."
    Pause
  }
}