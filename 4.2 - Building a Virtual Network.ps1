Set-Location c:\
Clear-Host


#Building a Virtual Network with 2 subnets

#Start with a resource group for the virtual network

$NetRG = Get-AzureRMResourceGroup | Where-Object {$_.ResourceGroupName -eq "NetRG"}
if (-not $NetRG) {
  $NetRG = New-AzureRmResourceGroup -Location 'West US' -Name "NetRG"
}
$NetRG

# Now to create a virtual network called "demoNet"
$vNet = $NetRG | New-AzureRMVirtualNetwork -Name "demoNet" -AddressPrefix "10.100.0.0/16"

$vNet
$vNet.Tag = @{Reason="Demo"}
$vNet | Set-AzureRMVirtualNetwork 

$vNet = $NetRG | Get-AzureRMVirtualNetwork
$vNet | Remove-AzureRmVirtualNetwork -WhatIf

# Next up, adding two subnets to the network.
$vNet | Add-AzureRmVirtualNetworkSubnetConfig -Name "sub0" -AddressPrefix "10.100.0.0/24"
$vNet | Add-AzureRmVirtualNetworkSubnetConfig -Name "sub1" -AddressPrefix "10.100.1.0/24"

$vNetInAzure = $NetRG | Get-AzureRmVirtualNetwork
$vNet.Subnets | Select-Object  Name, AddressPrefix
$vNetInAzure.Subnets | Select-Object  Name, AddressPrefix
$vNet | Set-AzureRmVirtualNetwork 


$vNet | Set-AzureRmVirtualNetworkSubnetConfig -Name "sub1" -AddressPrefix "10.100.100.0/24"


$Sub1 = Get-AzureRmVirtualNetworkSubnetConfig -Name "sub1" -VirtualNetwork $vNet

$vNet | Remove-AzureRmVirtualNetworkSubnetConfig -Name "sub1" 

$vNet | Foreach-Object {
  $_ | Add-AzureRmVirtualNetworkSubnetConfig -Name $sub1.Name -AddressPrefix $sub1.AddressPrefix
  $_ | Set-AzureRMVirtualNetwork 
}


$NetRG | Remove-AzureRmResourceGroup -Whatif
