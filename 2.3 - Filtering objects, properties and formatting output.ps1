#Filtering and Formatting Output of Object
Set-Location C:\
Clear-Host

# Pick a VM... any VM will do...
$AllVMs = Get-AzureRMVM 
$FirstVM = $AllVMs | Select-Object -First 1
$FirstVM
$EastUSVMs = $AllVMs  | Where-Object Location -eq "eastus"
$EastUSVMs

#Why doesn't this work?
$D_SeriesVMs = $AllVMs | Where-Object VMSize -like "Standard_D*"
if (-not $D_SeriesVMs) {Write-Host -ForegroundColor Cyan "That didn't work"} else {$D_SeriesVMs} 

#We do have AllVMS variable populated, and we have the VMSize showing in this table...
$AllVMs

$D_SeriesVMs = $AllVMs | Where-Object HardwareProfile.VMSize -like "Standard_D*"
if ($D_SeriesVMs -eq $Null) {Write-Host -ForegroundColor Cyan "Not yet..."}

$AorD_SeriesVMs_withPremiumStorage = $AllVMs | Where-Object {$_.HardwareProfile.VMSize -match "_(D|A).*s.*_"}

$RandomVM = Get-AzureRMVM -Status | Get-Random

Get-AzureRMVM -Status | Get-Random -Count 3 | Select-Object Name

$RandomVM

#Remember this from our last video
$RandomVM | Select-Object Name, VMSize, PowerState

$RandomVM | Select-Object  Name, @{Name="Size of the VM";Expression={$_.HardwareProfile.VMSize}}, PowerState


#Formatting that output
$RandomVM | Format-Custom
$RandomVM | Format-Custom -Property diagnosticsprofile

$RandomVM | Select-Object Name, Location, resourcegroupname, vmid 
$RandomVM | Select-Object Name, Location, resourcegroupname, vmid | Format-List

$RandomVM | Select-Object Name, location, resourcegroupname, vmid, powerstate
$RandomVM | Select-Object Name, location, resourcegroupname, vmid, powerstate | Format-Table 

