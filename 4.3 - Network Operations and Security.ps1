Set-Location C:\
Clear-Host

$NetRG = Get-AzureRMResourceGroup | Where-Object {$_.ResourceGroupName -eq "NetRG"}
if (-not $NetRG) {
  $NetRG = New-AzureRmResourceGroup -Location 'West US' -Name "NetRG"
}
$NetRG
  
# Define some application security groups. Great for categorizing network roles
Get-Command New-AzureRMApplicationSecurityGroup -Syntax
$WebGroup = $NetRG | New-AzureRmApplicationSecurityGroup -Name "WebRole"
$SQLGroup = $NetRG | New-AzureRMApplicationSecurityGroup -Name "SQLRole"

# Don't worry about how to get computers added to those groups. I'll show that when we're working
# with Virtual Machines in the next section

# Now let's set the ground rules...
## Webs can receive traffic on 80 and 443 from the Internet.
## SQL can receive traffic on port 1433, but only from the Webs.
## We'll add in a rule to allow remote PowerShell from a jumpbox...
### It will allow Remote Desktop in (3389) and allow 5985 (or 5986 for encrypted, which is recommended) out

$webRule = New-AzureRmNetworkSecurityRuleConfig -Name "Allow-Web" -Description "Normal web traffic" `
-Direction Inbound -Access Allow  `
-Protocol Tcp `
-SourceAddressPrefix Internet -SourcePortRange * `
-DestinationApplicationSecurityGroup $WebGroup -DestinationPortRange 80,443 `
-Priority 200

$sqlRule = New-AzureRmNetworkSecurityRuleConfig -Name "Allow-Sql" -Description "Webs to Sql traffic" `
-Direction Inbound -Access Allow  `
-Protocol Tcp `
-SourceApplicationSecurityGroup $WebGroup -SourcePortRange * `
-DestinationApplicationSecurityGroup $SQLGroup -DestinationPortRange 1433 `
-Priority 300

$jumpBoxRDPRule = New-AzureRMNetworkSecurityRuleConfig -Name "Allow-Jumpbox-RDP" -Description "RDP to jump server only" `
-Direction Inbound -Access Allow `
-Protocol Tcp `
-SourceAddressPrefix Internet -SourcePortRange * `
-DestinationAddressPrefix 10.0.0.100 -DestinationPortRange 3389 `
-Priority 400

$winRMRule = New-AzureRmNetworkSecurityRuleConfig -Name "Allow-WinRM" -Description "PowerShell Remoting" `
-Direction Inbound -Access Allow `
-Protocol Tcp `
-SourceAddressPrefix 10.0.0.100 -SourcePortRange * `
-DestinationAddressPrefix VirtualNetwork -DestinationPortRange 5985-5986 `
-Priority 410

Get-Command Get-AzureRmNetworkSecurityRuleConfig -Syntax

Get-Command New-AzureRmNetworkSecurityGroup -Syntax

$NetRG | New-AzureRmNetworkSecurityGroup -Name "AppEnvironment" -SecurityRules $webRule, $sqlRule

$AppNSG = $NetRG | Get-AzureRmNetworkSecurityGroup -Name "AppEnvironment"

$AppNSG.SecurityRules | Select-Object Name, Description, ProvisioningState
$AppNSG.SecurityRules += $winRMRule, $jumpBoxRDPRule

$AppNSG = $AppNsg | Set-AzureRmNetworkSecurityGroup 

$AppNSG.SecurityRules | Select-Object Name, Description, ProvisioningState



# We have a really great network security group now. I'm so excited!! Let's apply it to the network!

# Let's get the virtual network:
$NetRG | Get-AzureRmVirtualNetwork -Name "demoNet" | Tee-Object -Variable vNet
$vnet = $null
Remove-Variable -Name vNet
Set-Variable -Name vNet -Value ""
$vnet

$vNet.Subnets | Select-Object Name, AddressPrefix, NetworkSecurityGroup

# And apply the network security group to the subnets
$vNet.Subnets | Foreach-Object {
  $vNet | Set-AzureRMVirtualNetworkSubnetConfig -Name $_.name -AddressPrefix $_.AddressPrefix -NetworkSecurityGroup $AppNSG
}

$vNet.Subnets | Select-Object Name, AddressPrefix, NetworkSecurityGroup | Format-Table -AutoSize

$vNet = $vNet | Set-AzureRmVirtualNetwork

$vNet.Subnets[0]


$NetRG | Remove-AzureRMResourceGroup 
