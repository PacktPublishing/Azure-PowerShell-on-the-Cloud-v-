#Reading simple and complex object properties
Set-Location C:\
Clear-Host


#Reviewing - working with simple and complex properties in PowerShell

Get-AzureRMVM -Status 

# Display only one property value
Get-AzureRMVM -Status | Select-Object -Property PowerState

# Select multiple object properties
Get-AzureRMVM -Status | Select-Object Name, PowerState

#Works great for simple properties, but what about complex?

Get-AzureRMVM -Status | Select-Object Name, VMSize, PowerState 
Get-AzureRMVM -Status | Select-Object Size -First 1

Get-AzureRMVM -Status | Get-Member

Get-AzureRMVM | Select-Object -ExpandProperty HardwareProfile -First 1

Get-AzureRMVM | Select-Object -Property * -First 1

$VM = Get-AzureRMVM -Status | Select-Object -First 1 

$VM 

#Mix of simple and complex object properties
$VM | Select-Object -Property *

#Expanding a complex object property
$VM | Select-Object -ExpandProperty HardwareProfile

#Or... use the '.' for an object reference. Intellisense also helps (CTRL + Enter)
$VM.HardwareProfile.VmSize 

#
$VM | Select-Object -Property *
Clear-Host
$VM.StorageProfile | ConvertTo-Json -Depth 1
$VM.StorageProfile | ConvertTo-Json -Depth 2
$VM.StorageProfile.OsDisk.ManagedDisk.Id








