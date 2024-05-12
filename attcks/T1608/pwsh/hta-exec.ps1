
# NOTE: The following example should only be used in an authorized environment and for legitimate purposes, such as running test HTAs.

$htaFilePath = "C:\path\to\your_script.hta" # Replace with the actual path to your HTML Help Authoring Tool (.hta) file

# Execute the HTML Help Script using Windows Script Host 'wscript'
Start-Process -FilePath "cscript.exe" -ArgumentList $htaFilePath -NoNewWindow -Wait