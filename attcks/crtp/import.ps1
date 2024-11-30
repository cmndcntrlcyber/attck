# URL of the PowerShell module
$moduleUrl = "https://example.com/path/to/module.ps1"

# Download and import the module
Invoke-Expression (New-Object Net.WebClient).DownloadString($moduleUrl)
