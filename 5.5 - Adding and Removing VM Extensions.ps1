Set-Location C:\
Clear-Host

# Adding a VM extension
# Two variations... Some extensions have their own cmdlets.

Set-AzureRMVMBGInfoExtension -ResourceGroupName "VMRG" -VMName "JumpBox" -Location "eastus" `
  -Name "BGInfo" -TypeHandlerVersion "2.1"

# Some extensions don't have their own cmdlets.
# Here, for example is the Octopus Deploy tentacle extension installation

# Configure the settings that the extension requires
$Extensions = Get-AzureRmVmImagePublisher -Location "eastus" | Get-AzureRmVMExtensionImageType 
$Extensions | Select-Object PublisherName, Type
$Extensions | Where-Object {$_.type -match "Octopus"}

Get-AzureRMVMExtensionImage -Location "eastus" -PublisherName "OctopusDeploy.Tentacle" -Type "OctopusDeployWindowsTentacle" | Select-Object -Last 1

# Where to find exactly what each extension requires? Start with the vendor for support.
#   Octopus Deploy Tentacle specifics were published at: 
#   https://octopus.com/docs/infrastructure/windows-targets/azure-virtual-machines/via-powershell

$Settings = @{
  OctopusServerUrl = "https://octopus.example.com";
  Environments = @("Demo");
  Roles = @("Db");
  CommunicationMode = "Listen";
  Port = 10933
}

$Secrets = @{"ApiKey" = "Enter a valid API Key from the Octopus Server..."}

Set-AzureRmVMExtension -ResourceGroupName "VMRG" -Location "eastus" -VMName "SQL2017" `
    -Name "OctopusDeployWindowsTentacle" -Publisher "OctopusDeploy.Tentacle" -ExtensionType "OctopusDeployWindowsTentacle" `
    -TypeHandlerVersion "2.0.164" `
    -Settings $Settings `
    -ProtectedSettings $Secrets `
    -AsJob

# What about if you don't know the name?
Get-AzureRmVMExtension -ResourceGroupName VMRG -VMName JumpBox

# Don't forget our already established tools for finding extensions on Virtual Machines:
Get-AzureRMVM -ResourceGroupName VMRG -Name JumpBox | Select-Object -ExpandProperty extensions | Select-Object -Property name


Get-AzureRmVMExtension -ResourceGroupName VMRG -VMName JumpBox -Name BGInfo | Remove-AzureRmVMExtension -WhatIf
