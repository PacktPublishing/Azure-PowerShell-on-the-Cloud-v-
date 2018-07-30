

# Viewing the deployments made in a resource group

Get-AzureRmResourceGroupDeployment -ResourceGroupName "ARMTemplateDemo"

Get-AzureRmResourceGroupDeployment -ResourceGroupName "ARMTemplateDemo" -Name "VMFromTemplate"


# Saving one of the deployments for a resource group as a template

Save-AzureRmResourceGroupDeploymentTemplate -ResourceGroupName "ARMTemplateDemo" -DeploymentName "VMFromTemplate" -Path .\6.3-SavedTemplate
