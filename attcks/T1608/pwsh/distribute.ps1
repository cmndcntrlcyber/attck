$machines = Get-Content -Path "list.txt" 


foreach ($machine in $machines1)
    { 
        Write-Host "Currently the script is copying files on" $machine 
        Copy-Item -Path "\hta.js" -Destination "\\$machine\c$\temp\hta.js" 
        $s = New-PSSession -ComputerName $machine
        Invoke-Command -Session $s -ScriptBlock { wscript.exe "\\$machine\c$\temp\hta.js"} 
    }