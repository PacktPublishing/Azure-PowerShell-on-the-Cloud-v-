Set-Location C:\
Clear-Host

# Stop and Start a Virtual Machine
$JumpBox = Get-AzureRMVM -ResourceGroupName VMRG -Name JumpBox -Status

$JumpBox.Statuses | Where-Object {$_.Code -match "PowerState"} | Select-Object -ExpandProperty DisplayStatus
$JumpBox | Stop-AzureRMVM -StayProvisioned -Force -WhatIf
$JumpBox | Start-AzureRMVM -AsJob -WhatIf
$JumpBox | Restart-AzureRMVM -PerformMaintenance

# Snapshot an OS disk, create a new VM from snapshot
# Get the OS Disk to snapshot...
$SqlBox = Get-AzureRMVM -ResourceGroupName VMRG -Name SQL2017
$SqlDisk = $SqlBox.StorageProfile.OsDisk.ManagedDisk.Id
# Take the snapshot...
$QuickSnapConfig =  New-AzureRmSnapshotConfig -SourceUri $SqlDisk -Location 'eastus' -CreateOption copy
$QuickSnap = New-AzureRmSnapshot -ResourceGroupName VMRG -Snapshot $QuickSnapConfig -SnapshotName "SqlOSDiskSnapshot"
# Create a new disk from the snapshot...
$NewDiskConfig = New-AzureRmDiskConfig -Location "eastus" -SourceResourceId $QuickSnap.Id -CreateOption Copy 
$NewDisk = New-AzureRmDisk -Disk $NewDiskConfig -ResourceGroupName VMRG -DiskName "SQL2017-FromSnapshot"
# Create a new VM that uses the disk!
$NewVMConfig = New-AzureRmVMConfig -VMName "NewSql" -VMSize $SqlBox.HardwareProfile.VmSize
Set-AzureRmVMOSDisk -VM $NewVMConfig -ManagedDiskId $NewDisk.Id -CreateOption "Attach" -Windows

# Finish the OS Config (Local Admin), Add data disks (if required) and a networking profile to the $NewVMConfig. 
New-AzureRMVM -VM $NewVMConfig -AsJob


# Moving a Virtual Machine to a different resource group.
$MgmtRG = New-AzureRMResourceGroup -Name "ManagementServers" -Location "East US" 
$JumpBox = Get-AzureRMVM -ResourceGroupName "VMRG" | Where-Object Name -eq "JumpBox"
Move-AzureRmResource -DestinationResourceGroupName $MgmtRG.ResourceGroupName -ResourceId $JumpBox.Id

