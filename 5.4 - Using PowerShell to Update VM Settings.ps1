Set-Location C:\
Clear-Host

# Adding resources to a virtual machine
$SimpleVM = Get-AzureRMVM -ResourceGroupName SimpleVM -Name SimpleVM

# Same basic code as from the video on creating a virtual machine
$NetRG = Get-AzureRMResourceGroup "NetRG"
$DemoNet = $NetRG | Get-AzureRMVirtualNetwork  -Name "DemoNet"
$Sub1 = $DemoNet.Subnets[1]
$NIC2 = $VMRG | New-AzureRmNetworkInterface -Name "Nic2" -SubnetId $Sub1.Id
$NIC2

Add-AzureRmVMNetworkInterface -VM $SimpleVM -NetworkInterface $NIC2

$SimpleVM.NetworkProfile.NetworkInterfaces

$SimpleVMInAzure = Get-AzureRMVM -ResourceGroupName SimpleVM -Name SimpleVM
$SimpleVMInAzure.NetworkProfile.NetworkInterfaces

# Resizing a virtual machine

$SimpleVM.HardwareProfile.VmSize
$NewSize = "Standard_DS2_v2"
$SimpleVM.HardwareProfile.VmSize = $NewSize
$SimpleVM.HardwareProfile.VmSize

$SimpleVMInAzure = Get-AzureRMVM -ResourceGroupName SimpleVM -Name SimpleVM
$SimpleVMInAzure.HardwareProfile.VmSize

# Increasing the capacity of a data disk
$diskOptions = New-AzureRmDiskConfig -SkuName Premium_LRS -DiskSizeGB 100 -Location "eastus" -CreateOption "Empty"
$disk = New-AzureRmDisk -Disk $diskOptions -ResourceGroupName VMRG -DiskName "DataDisk1"
Add-AzureRmVMDataDisk -VM $SimpleVM -Name "DataDisk1" -CreateOption Attach -ManagedDiskId $disk.Id -Lun 1

$SimpleVMInAzure = Get-AzureRMVM -ResourceGroupName SimpleVM -Name SimpleVM
$SimpleVMInAzure.StorageProfile.DataDisks

$SimpleVM.StorageProfile.DataDisks

$ExistingDisk = Get-AzureRMDisk -ResourceGroupName VMRG -DiskName DataDisk1
$ExistingDisk.DiskSizeGB = 200
$ExistingDisk | Update-AzureRmDisk 

# Expanding the OS Disk
$SimpleVM.StorageProfile.OsDisk
Set-AzureRmVMOSDisk -VM $SimpleVM -DiskSizeInGB 100

$SimpleVMInAzure = Get-AzureRMVM -ResourceGroupName SimpleVM -Name SimpleVM
$SimpleVMInAzure.StorageProfile.OsDisk.DiskSizeGB
$SimpleVM.StorageProfile.OsDisk.DiskSizeGB

Clear-Host
$SimpleVM | Update-AzureRmVM -AsJob
