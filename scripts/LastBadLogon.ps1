$dcs = Get-ADDomainController -Filter * | Select-Object name
$samAccountName = "ACCOUNT_NAME"
$badpwdcount = 0 
$badpwdtime = New-Object System.DateTime
 
foreach($dc in $dcs) { 
   $user = Get-ADUser $samAccountName -Server $dc.name -properties badPwdCount,badPasswordTime
   $badpwdcount += $user.badPwdCount
 
   $userBadPwdTime = [datetime]::fromFileTime($user.badPasswordTime)
 
   if($badpwdtime -lt $userBadPwdTime) { 
      $badpwdtime = $userBadPwdTime 
   } 
}
 
if($badpwdtime -ne (New-Object System.DateTime)) { 
   $bptString = $badpwdtime.ToString("dd.MM.yyyy HH:mm:ss") 
} else { 
   $bptString = "-" 
}
 
Write-Host("User: " + $samAccountName + "- Failed logons: " + $badpwdcount + " - Last failed attempt: " + $bptString)