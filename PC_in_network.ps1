Import-Module activedirectory

$DaysInactive = 10 
$ExcludeFilter = "COMPUTERNAME TO EXCLUDE"
$time = (Get-Date).Adddays(-($DaysInactive))
$SerchOU = "OU=SBSComputers,OU=Computers,OU=MyBusiness,DC=local"
$PSComputerName = "PSComputerName"

$proc = Get-ADComputer -Filter {Name -notlike $ExcludeFilter -and LastLogon -gt $time -and enabled -eq $true} -SearchBase $SerchOU | select Name |Sort-Object Name

Sleep 5

foreach ($p in $proc)

{

# Is the PC in the Network? If not go ahead
If (!(Test-Connection -ComputerName $p.Name -Count 1 -Quiet)) { 
     Continue # Move to next computer
}

# Is in use with RDP?

try {

    Get-CimInstance win32_networkadapterconfiguration –Computer $p.Name | select description, macaddress, IPAddress | where {$_.MACAddress -ne $null } | where {$_.IPAddress -ne $null }

	$Groups = Get-WmiObject Win32_GroupUser –Computer $p.Name
    $RDPUsers = $Groups | Where GroupComponent –like '*"Remotedesktopbenutzer"'
 
	Write-Host "PC:" $p.Name
	Write-Host " "
	Write-Host "Remote Desktop Users:"
	$RDPUsers |% {  
	$_.partcomponent –match ".+Domain\=(.+)\,Name\=(.+)$" > $nul  
	$matches[1].trim('"') + "\" + $matches[2].trim('"')
	}
	Write-Host " " 



} catch {

     Write-Warning $p.Name "RPC Nicht verfügbar, konto prüfen nicht möglich"
     Continue # Move to next computer

} #end try
}