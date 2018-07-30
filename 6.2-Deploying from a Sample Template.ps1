Clear-Host

New-AzureRMResourceGroup -Name "ARMTemplateDemo" -Location "East US"
New-AzureRmResourceGroupDeployment -Name "VMFromTemplate" -ResourceGroupName ARMTemplateDemo `
 -TemplateParameterFile .\6.2-azuredeploy.parameters.json -TemplateFile .\6.2-azuredeploy.json `
 -Verbose 

#Now that the template is completed, the VM is ready!
Get-AzureRMVM -ResourceGroupName ARMTemplateDemo -Status




