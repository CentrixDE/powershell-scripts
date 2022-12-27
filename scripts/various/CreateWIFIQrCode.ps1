# Import the required modules
Import-Module -Name QRCodeGenerator

# Read the CSV file
$csvFile = Get-ChildItem -Filter "batch_dpsk*.csv" | Select-Object -First 1
$csv = Import-Csv -Path $csvFile.FullName

# Iterate through each row in the CSV file
foreach ($row in $csv) {
  # Generate the QR code image
  New-QRCodeWifiAccess -SSID $row.UserName -Password $row.Passphrase -OutPath "C:\Users\Admin\Desktop\Powershell Scripts\CreateQRCode\$($row.UserName).png"
}