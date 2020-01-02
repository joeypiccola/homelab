$VerbosePreference = "Continue"

$wmi_operatingsystem = Get-WmiObject -Class win32_operatingsystem

Write-Verbose "Windows Version found: $($wmi_operatingsystem.version)"

if($wmi_operatingsystem.version -lt 6.3) { # Server is older than 2012R2
    Write-Verbose "Removing packer scheduled tasks for 2008R2 using COM Object."
    ($TaskScheduler = New-Object -ComObject Schedule.Service).Connect("localhost")
    $TFolder = $TaskScheduler.GetFolder('\')
    $PackerTasks = $TFolder.GetTasks(1) | Where-Object {$_.Name -match "packer"}

    Foreach($ptask in $PackerTasks){
        $TFolder.DeleteTask($ptask.Path, 0)
    }
} else {
    Write-Verbose "Removing packer scheduled tasks."
    Get-ScheduledTask | Where-Object {$_.TaskName -match "packer"} | Unregister-ScheduledTask -Confirm:$false
}