# shamelessly taken from https://github.com/mwrock/packer-templates

Write-Host "defragging..."
if (Get-Command -Name 'Optimize-Volume' -ErrorAction SilentlyContinue){
    Optimize-Volume -DriveLetter C
} else {
    Defrag.exe c: /H
}