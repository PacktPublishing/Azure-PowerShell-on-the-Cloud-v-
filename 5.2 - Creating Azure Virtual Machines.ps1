Set-Location C:\
Clear-Host


# Choosing a resource group and location
If (-not (Get-AzureRMResourceGroup | Where-Object {$_.ResourceGroupName -eq "VMRG"})) {
  $VMRG = New-AzureRMResourceGroup -Name "VMRG" -Location 'East US'
} else {
  $VMRG = Get-AzureRMResourceGroup -Name "VMRG"
}

# Creating an Azure Virtual Machine
# Choose your OS:  Windows or Linux
# Choose your Publisher:  Microsoft, Centos, Redhat, Ubuntu, 
Get-AzureRmVMImagePublisher -Location 'East US'  | Select-Object -First 10
Get-AzureRmVMImageOffer -Location "East US" -PublisherName "MicrosoftSQLServer"
Get-AzureRMVMImageSku -Location "East US" -PublisherName "MicrosoftSQLServer" -Offer "SQL2017-WS2016"
Get-AzureRmVMImage -Location "East US" -PublisherName "MicrosoftSQLServer" -Offer "SQL2017-WS2016" -Skus "SQLDEV"


# Choose a size for the VM

Get-AzureRMVMSize -Location 'East US'
Get-AzureRMVMSize -Location 'East US' | Where-Object {$_.MemoryInMB -eq 8GB/1MB -and $_.NumberOfCores -eq 2}
$VMSize = Get-AzureRMVMSize -Location "eastus" | Out-GridView -Title "Choose a VM Size" -PassThru 
$VMSize

# Choose other options
# - Username / password for admin account
$AdminLogin = Get-Credential "LocalAdmin" 

# - Network settings
$NetRG = Get-AzureRMResourceGroup "NetRG"
$DemoNet = $NetRG | Get-AzureRMVirtualNetwork  -Name "DemoNet"
$Sub0 = $DemoNet.Subnets[0]
$SQLGroup = $NetRG | Get-AzureRMApplicationSecurityGroup -Name "SQLRole"
$SQLGroup.Id

$NIC = $VMRG | New-AzureRmNetworkInterface -ApplicationSecurityGroupId $SQLGroup.Id -Name "SQLVM-Nic" -SubnetId $Sub0.Id
$NIC


# Building a VM with the fewest possible inputs
New-AzureRmVM -Name "SimpleVM" -Credential $AdminLogin



# Building a VM with a full selection of options
# Start with a VM Configuration
$VMSet = New-AzureRmVMConfig -VMName "SQL2017" -VMSize $VMSize.Name

# Configure the operating system
Set-AzureRmVMOperatingSystem -VM $VMSet -Windows -ComputerName "SQL2017" -Credential $AdminLogin


# Configure the network 
Add-AzureRmVMNetworkInterface -VM $VMSet -Id $NIC.Id

# Choose the image
Set-AzureRmVMSourceImage -VM $VMSet -PublisherName "MicrosoftSQLServer" -Offer "SQL2017-WS2016" -Skus "Express" -Version "latest"

# 
$diskSet = New-AzureRmDiskConfig -Location "eastus" -DiskSizeGB 1024 -CreateOption Empty 
$sqlDisk = $VMRG | New-AzureRMDisk -DiskName "SqlDataDisk" -Disk $diskSet


Add-AzureRmVMDataDisk -VM $VMSet -Name "sqlDataDisk" -CreateOption Attach -ManagedDiskId $sqlDisk.Id -Lun 1

#Use the resource group variable to set the resource group and location... VM Configuration holds the rest
$VMRG | New-AzureRMVM -VM $VMSet 


New-AzureRMVM -ResourceGroupName "VMRG" -Location "eastus" -Name "JumpBox" `
 -VirtualNetworkName "demoNet" -SubnetName "sub1" -AllocationMethod Static -DomainNameLabel "demojumpbox2018" `
 -OpenPorts 3389 -ImageName "MicrosoftWindowsServer:WindowsServer:2016-Datacenter:latest" `
 -Credential $AdminLogin -Size $VMSize.Name -DataDiskSizeInGb 200 `
 -AsJob


$VMRG | Remove-AzureRMResourceGroup -Whatif




Get-Help Get-AzureRmVMImagePublisher -Online
Get-Help New-AzureRmVMConfig
Get-Help New-AzureRMVM -Online 
Get-Help Get-AzureRMVMSize -Online

