Set-Location C:\

Get-Command -Module AzureRM.Network | Measure-Object 


Get-Command -Module AzureRM.Network | Group-Object -Property Noun `
  | Sort-Object -Property Name | Select-Object -Property Count, Name



Get-Command -Module AzureRM.Network -Noun AzureRmVirtualNetwork
Get-Command -Module AzureRM.Network -Noun AzureRmVirtualNetworkSubnetConfig
Get-Command -Module AzureRM.Network -Noun AzureRmNetworkSecurityGroup
Get-Command -Module AzureRM.Network -Noun AzureRmNetworkSecurityRuleConfig