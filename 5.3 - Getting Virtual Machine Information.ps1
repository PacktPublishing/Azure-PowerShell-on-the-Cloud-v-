Set-Location C:\
Clear-Host

# Finding a Virtual Machine by name
Get-AzureRMVM -Name SimpleVM
Clear-Host
Get-AzureRMVM -Name SimpleVM -ResourceGroupName SimpleVM
# OR
$VMList = Get-AzureRMVM 
$VMFromList = $VMList | Where-Object {$_.Name -eq "SimpleVM"}

# The Difference between VM Instance Object and List Object

$VM = Get-AzureRMVM -Name SimpleVM -ResourceGroupName SimpleVM

$VMList.Count
$VM.Count
$VMFromList.Count

$VM
$VMFromList

$VM | Format-Table

$VM.GetType()
$VMFromList.GetType()


# Getting all VMs from a Resource Group
$VMRG_VMs = Get-AzureRMVM -ResourceGroupName VMRG -Status 
$VMRG_VMs
$VMRG_VMs[0].GetType()

$VMRG_VMs | Where-Object {$_.PowerState -eq "running"} 
$VMRG_VMs | Get-Member -Name *power*
$VMRG_VMs | Select-Object Name, PowerState
$VMRG_VMs
$VMRG_VMs | Where-Object {$_.PowerState -eq "VM running"}


$VM
$VM.NetworkProfile
$VM.NetworkProfile.NetworkInterfaces
$VM.NetworkProfile.NetworkInterfaces[0].Id
$NicID = $VM.NetworkProfile.NetworkInterfaces[0].Id

$Nic = Get-AzureRMResource -ResourceId $NicId | Get-AzureRmNetworkInterface
$Nic.IpConfigurations[0].PrivateIpAddress
$Nic.IpConfigurations[0].PublicIpAddress


$VM.StorageProfile
$VM.StorageProfile.OsDisk

$VM.OSProfile



Function Get-MyAzureResourceGroupNetworkInfo {
  Param ($ResourceGroupName)

  if (Get-AzureRMResourceGroup | Where-Object ResourceGroupName -eq $ResourceGroupName) {
    $VMList = Get-AzureRMVM -ResourceGroupName $ResourceGroupName
    Foreach ($VM in $VMList) {
      $VMNicID = $VM.NetworkProfile.NetworkInterfaces[0].Id
      $VMNic = Get-AzureRMResource -ResourceId $VMNicId | Get-AzureRmNetworkInterface
      $OutObject = [PSCustomObject]@{
        Name = $VM.Name
        PublicIP = $VMNic.IpConfigurations[0].PublicIpAddress.IpAddress
        PrivateIP = $VMNic.IpConfigurations[0].PrivateIpAddress
      }
      $OutObject
    } #End Foreach
  } #End If
} #End Function

Clear-Host
Get-MyAzureResourceGroupNetworkInfo -ResourceGroupName VMRG
