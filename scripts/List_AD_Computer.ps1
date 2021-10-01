Get-ADComputer -Filter {Name -like "*NAME_SCHEME*" -and Enabled -eq $True } | select Name | Sort-Object Name | ft
$Shell = New-Object -ComObject "WScript.Shell"
$Button = $Shell.Popup("Click OK to continue.", 0, "Waiting to exit...", 0){\rtf1}