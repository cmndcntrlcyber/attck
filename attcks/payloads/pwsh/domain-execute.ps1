# Ensure that you have administrative privileges before running this script

function Execute-CommandAcrossDomain {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [scriptblock]$CommandToRun,
        
        [Parameter(Mandatory=$true)]
        [string]$DomainName
    )
    
    # Connect to the domain controller using credentials
    $domainController = "DC-$DomainName"
    try {
        $credential = Get-Credential -Message "Enter credentials for the Domain Controller."
        $connection = New-PSSession -ComputerName $domainController -Credential $credential
        
        # Run the command on each user account in the domain
        Invoke-Command -Session $connection -ScriptBlock {
            param($command)
            
            foreach ($user in (Get-WmiObject Win32_UserAccount -Filter "Name='*'" | Select-Object -ExpandProperty Name)) {
                try {
                    # Execute the command and capture output or errors
                    $result = Invoke-Command -ComputerName "\"$env:COMPUTERNAME\"" -ScriptBlock $command -Credential (Get-Credential -UserName $user)
                    
                    Write-Output "Executed '$command' for user account: $user"
                } catch {
                    Write-Error "Failed to execute command for user account: $user. Error: $_"
                }
            }
        } -ArgumentList ($CommandToRun) -Credential (New-Object System.Management.Automation.PSCredential ("",($credential | Select-Object -ExpandProperty GetNetworkCredential($credential).Password)))
        
        # Close the session
        Remove-PSSession $connection
    } catch {
        Write-Error "Failed to establish a connection with domain controller: $DomainName"
    }
}

# Example usage: Execute-CommandAcrossDomain -CommandToRun {Get-Process} -DomainName 'YOURDOMAIN'