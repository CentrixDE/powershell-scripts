$PCs = Get-Content [PATH TO .TXT FILE]

Foreach ($PC in $PCs)
{
	$Groups = Get-WmiObject Win32_GroupUser –Computer $PC
	
	$RDPUsers = $Groups | Where GroupComponent –like '*"Remotedesktopbenutzer"'
 
	Write-Host "PC: $PC"
	Write-Host " "	
	Write-Host "ReDeUser:"
	$RDPUsers |% {  
	$_.partcomponent –match ".+Domain\=(.+)\,Name\=(.+)$" > $nul  
	$matches[1].trim('"') + "\" + $matches[2].trim('"')
	}
	Write-Host " " 
}
